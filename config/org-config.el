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
	`(("ca" "LOG ENTRY" entry (file+headline ,(my/org-file "7l2.logbook.org") "LOG")
	   "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)

	  ("cb" "LOG ENTRY" entry (file+headline ,(my/org-file "7s2.logbook.org") "LOG")
	   "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)

	  ("cc" "LOG ENTRY" entry (file+headline ,(my/org-file "9s1.logbook.org") "LOG")
	   "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)

	  ("cd" "LOG ENTRY" entry (file+headline ,(my/org-file "10s6.logbook.org") "LOG")
	   "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)

	  ("ce" "LOG ENTRY" entry (file+headline ,(my/org-file "11s8.logbook.org") "LOG")
	   "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)

	  ("ck" "TODO" entry (file+headline ,(my/org-file "ks3.org") "TODO")
	   "* TODO\s %?\s :ks3:")

	  ("cl" "TODO" entry (file+headline ,(my/org-file "departmental.org") "DEPARTMENTAL TASKS")
	   "* TODO\s %?\s :departmental:")

	  ("ct" "TODO" entry (file+headline ,(my/org-file "teaching.org") "TEACHING")
	   "* TODO\s %?\s :teaching:")

	  ("cg" "GENERAL" entry (file+headline ,(my/org-file "general.org") "GENERAL")
	   "* TODO %? "))))

;; ============================================================
;; ORG CAPTURE KEYBINDINGS
;; ============================================================
(define-prefix-command 'my-org-capture-map)
(global-set-key (kbd "C-c c") 'my-org-capture-map)
(define-key my-org-capture-map (kbd "c") 'org-capture)

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

;;11s8
(define-prefix-command 'my-org-capture-1-map)
(define-key my-org-capture-map (kbd "1") 'my-org-capture-1-map)
(define-prefix-command 'my-org-capture-1s-map)
(define-key my-org-capture-1-map (kbd "s") 'my-org-capture-1s-map)
(define-key my-org-capture-1s-map (kbd "8")
    (lambda () (interactive) (org-capture nil "ce")))

;;ks3
(define-prefix-command 'my-org-capture-k-map)
(define-key my-org-capture-map (kbd "k") 'my-org-capture-k-map)
(define-prefix-command 'my-org-capture-ks-map)
(define-key my-org-capture-k-map (kbd "s") 'my-org-capture-ks-map)
(define-key my-org-capture-ks-map (kbd "3")
    (lambda () (interactive) (org-capture nil "ck")))

;;teaching
(define-key my-org-capture-map (kbd "t")
    (lambda () (interactive) (org-capture nil "ct")))

;;departmental
(define-prefix-command 'my-org-capture-d-map)
(define-key my-org-capture-map (kbd "d") 'my-org-capture-d-map)
(define-prefix-command 'my-org-capture-dp-map)
(define-key my-org-capture-d-map (kbd "p") 'my-org-capture-dp-map)
(define-key my-org-capture-dp-map (kbd "t")
    (lambda () (interactive) (org-capture nil "cl")))

;;general
(global-set-key (kbd "C-c g")
    (lambda () (interactive) (org-capture nil "cg")))

;; ============================================================
;; TAGS
;; ============================================================
(setq org-tag-alist '(("departmental" . ?d) ("teaching" . ?t) ("marking" . ?m) ("topics" . ?p) ("reprographics" . ?r)))
