;;; org-config.el --- Org capture templates and tags -*- lexical-binding: t -*-

;; Helper to build org file paths from my/org-directory
(defun my/org-file (filename)
  "Return full path to FILENAME within `my/org-directory'."
  (expand-file-name filename my/org-directory))

;; ============================================================
;; ORG AGENDA FILES
;; ============================================================
(with-eval-after-load 'org
  (setq org-agenda-files (list my/org-directory)))

;; ============================================================
;; ORG CAPTURE TEMPLATES
;; ============================================================
(with-eval-after-load 'org
  (setq org-capture-templates
        `(("i" "Inbox" entry (file+headline ,(my/org-file "inbox.org") "Inbox")
           "* TODO %?\n%U" :empty-lines 1)
          ("a" "Appointment" entry (file+headline ,(my/org-file "diary.org") "Appointments")
           "* %?\n%^T" :empty-lines 1)
          ("t" "Teaching task" entry (file+headline ,(my/org-file "teaching.org") "Teaching")
           "* TODO %?" :empty-lines 1)
          ("d" "Departmental task" entry (file+headline ,(my/org-file "departmental.org") "Departmental")
           "* TODO %?" :empty-lines 1)
          ("h" "Homework task" entry (file+headline ,(my/org-file "homework.org") "Homework")
           "* TODO %?" :empty-lines 1)
          ;; Per-class logbooks (newest first) — keys unchanged (ca–cd)
          ("ca" "7L/Sc2 log" entry (file+headline ,(my/org-file "7l2.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cb" "7S/Sc2 log" entry (file+headline ,(my/org-file "7s2.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cc" "9S/Sc1 log" entry (file+headline ,(my/org-file "9s1.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cd" "10LS/Sc6 log" entry (file+headline ,(my/org-file "10s6.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t))))

;; ============================================================
;; ORG CAPTURE KEYBINDINGS
;; ============================================================
(define-prefix-command 'my-org-capture-map)
(global-set-key (kbd "C-c c") 'my-org-capture-map)
(define-key my-org-capture-map (kbd "c") 'org-capture)

;; Direct keys for new GTD captures
(define-key my-org-capture-map (kbd "i")
  (lambda () (interactive) (org-capture nil "i")))
(define-key my-org-capture-map (kbd "a")
  (lambda () (interactive) (org-capture nil "a")))
(define-key my-org-capture-map (kbd "t")
  (lambda () (interactive) (org-capture nil "t")))
(define-key my-org-capture-map (kbd "d")
  (lambda () (interactive) (org-capture nil "d")))
(define-key my-org-capture-map (kbd "h")
  (lambda () (interactive) (org-capture nil "h")))

;;7l2
(define-prefix-command 'my-org-capture-7-map)
(define-key my-org-capture-map (kbd "7") 'my-org-capture-7-map)
(define-prefix-command 'my-org-capture-7l-map)
(define-key my-org-capture-7-map (kbd "l") 'my-org-capture-7l-map)
(define-key my-org-capture-7l-map (kbd "2")
  (lambda () (interactive) (org-capture nil "ca")))

;;7s2
(define-prefix-command 'my-org-capture-7s-map)
(define-key my-org-capture-7-map (kbd "s") 'my-org-capture-7s-map)
(define-key my-org-capture-7s-map (kbd "2")
  (lambda () (interactive) (org-capture nil "cb")))

;;9s1
(define-prefix-command 'my-org-capture-9-map)
(define-key my-org-capture-map (kbd "9") 'my-org-capture-9-map)
(define-prefix-command 'my-org-capture-9s-map)
(define-key my-org-capture-9-map (kbd "s") 'my-org-capture-9s-map)
(define-key my-org-capture-9s-map (kbd "1")
   (lambda () (interactive) (org-capture nil "cc")))

;;10s6
(define-prefix-command 'my-org-capture-0-map)
(define-key my-org-capture-map (kbd "0") 'my-org-capture-0-map)
(define-prefix-command 'my-org-capture-0s-map)
(define-key my-org-capture-0-map (kbd "s") 'my-org-capture-0s-map)
(define-key my-org-capture-0s-map (kbd "6")
    (lambda () (interactive) (org-capture nil "cd")))

;; ============================================================
;; TAGS
;; ============================================================
(setq org-tag-alist '(("departmental" . ?d) ("teaching" . ?t) ("marking" . ?m) ("topics" . ?p) ("reprographics" . ?r)))
