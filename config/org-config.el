;; Modify orgmode TODO states
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "BLOCKED" "|" "DONE")))

;; Make org indent things properly
(add-hook 'org-mode-hook (lambda () (org-indent-mode)))

;; Org capture prefix setup
(define-prefix-command 'my-org-capture-map)
(global-set-key (kbd "C-c c") 'my-org-capture-map)
(define-key my-org-capture-map (kbd "c") 'org-capture)

;;Org Roam setup
(setq find-file-visit-truename t)
(setq org-roam-directory (file-truename "~/Documents/roam"))
(org-roam-db-autosync-mode)
