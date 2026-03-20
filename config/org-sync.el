;;; org-sync.el --- Auto-sync org files via git -*- lexical-binding: t -*-

;; ============================================================
;; GIT SYNC FOR ORG FILES
;; ============================================================
;; Automatically commits and pushes org files on save,
;; and pulls latest changes on Emacs startup.

(defvar org-sync--push-timer nil
  "Timer to debounce git push operations.")

(defun org-sync--run-git (args callback)
  "Run git in `my/org-directory' with ARGS, call CALLBACK with exit code when done."
  (let ((default-directory my/org-directory))
    (make-process
     :name "org-sync-git"
     :buffer nil
     :command (append '("git") args)
     :sentinel (lambda (proc event)
                 (when (and callback (string-match-p "finished" event))
                   (funcall callback (process-exit-status proc)))))))

(defun org-sync-pull ()
  "Pull latest org files from remote."
  (interactive)
  (message "org-sync: pulling latest changes...")
  (org-sync--run-git
   '("pull" "--rebase" "--autostash")
   (lambda (code)
     (if (= code 0)
         (message "org-sync: pull complete.")
       (message "org-sync: pull failed (exit %d) — check *Messages*" code)))))

(defun org-sync--commit-and-push ()
  "Stage all changes, commit with timestamp, and push."
  (let ((default-directory my/org-directory))
    (org-sync--run-git
     '("add" "-A")
     (lambda (_)
       (org-sync--run-git
        (list "commit" "-m" (format-time-string "auto: %Y-%m-%d %H:%M:%S"))
        (lambda (code)
          (when (= code 0)
            (org-sync--run-git '("push" "origin" "HEAD:main") nil)
            (message "org-sync: pushed."))))))))

(defun org-sync-after-save ()
  "Hook: debounce commit+push after saving an org file in `my/org-directory'."
  (when (and buffer-file-name
             (string-prefix-p (expand-file-name my/org-directory)
                              (expand-file-name buffer-file-name)))
    ;; Cancel any pending push timer and set a new one (2 second debounce)
    (when org-sync--push-timer
      (cancel-timer org-sync--push-timer))
    (setq org-sync--push-timer
          (run-with-idle-timer 2 nil #'org-sync--commit-and-push))))

;; Hook into after-save
(add-hook 'after-save-hook #'org-sync-after-save)

;; Sync on Emacs close
(add-hook 'kill-emacs-hook
          (lambda ()
            (let ((default-directory my/org-directory))
              (when (file-directory-p (expand-file-name ".git" my/org-directory))
                (call-process "git" nil nil nil "add" "-A")
                (call-process "git" nil nil nil "commit" "-m"
                              (format-time-string "auto: %Y-%m-%d %H:%M:%S"))
                (call-process "git" nil nil nil "push" "origin" "HEAD:main")))))

;; Periodic sync every 15 minutes
(run-with-timer 900 900 #'org-sync--commit-and-push)

;; Pull on startup (with a short delay so Emacs finishes loading first)
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (file-directory-p (expand-file-name ".git" my/org-directory))
              (run-with-timer 3 nil #'org-sync-pull))))

(provide 'org-sync)
