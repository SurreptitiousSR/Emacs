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
          ;; Own classes
          ("ca" "7S/ScSAL log" entry (file+headline ,(my/org-file "7s.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cb" "8S/ScSAL log" entry (file+headline ,(my/org-file "8s.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cc" "9L/ScSAL log" entry (file+headline ,(my/org-file "9l.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cd" "10LS/ScSAL log" entry (file+headline ,(my/org-file "10ls.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("ce" "11LS/ScSAL log" entry (file+headline ,(my/org-file "11ls.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ;; Reading lessons - one group each, once a fortnight
          ("cf" "7L/ScMBN log" entry (file+headline ,(my/org-file "7l-mbn.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cg" "7L/ScRDS log" entry (file+headline ,(my/org-file "7l-rds.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("ch" "8L/ScAES log" entry (file+headline ,(my/org-file "8l.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("ci" "9S/ScRDS log" entry (file+headline ,(my/org-file "9s-rds.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t)
          ("cj" "9S/ScHUR log" entry (file+headline ,(my/org-file "9s-hur.logbook.org") "LOG")
           "* LOG ENTRY %T\n %?" :unnarrowed t :prepend t))))

;; ============================================================
;; ORG CAPTURE KEYBINDINGS
;; ============================================================
(define-prefix-command 'my-org-capture-map)
(global-set-key (kbd "C-c c") 'my-org-capture-map)
(define-key my-org-capture-map (kbd "c") 'org-capture)

;; Direct keys for the GTD captures
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

;; ------------------------------------------------------------
;; Class logbooks: C-c c <year> <class>
;;
;; Classes no longer carry a set number, so the old third keypress
;; (C-c c 7 l 2) is gone. Where a year has one of your own classes it
;; keeps its stream letter; the once-a-fortnight reading groups use the
;; TEACHER's initial, because 7L and 9S are each two different groups and
;; a single "l"/"s" key could not tell them apart.
;;
;;   Own classes                  Reading lessons (1 per fortnight)
;;   C-c c 7 s   7S/ScSAL         C-c c 7 m   7L/ScMBN
;;   C-c c 8 s   8S/ScSAL         C-c c 7 r   7L/ScRDS
;;   C-c c 9 l   9L/ScSAL         C-c c 8 a   8L/ScAES
;;   C-c c 0     10LS/ScSAL       C-c c 9 r   9S/ScRDS
;;   C-c c 1     11LS/ScSAL       C-c c 9 h   9S/ScHUR
;; ------------------------------------------------------------

;; Year 7 - own class 7S, plus two separate 7L reading groups
(define-prefix-command 'my-org-capture-7-map)
(define-key my-org-capture-map (kbd "7") 'my-org-capture-7-map)
(define-key my-org-capture-7-map (kbd "s")
  (lambda () (interactive) (org-capture nil "ca")))
(define-key my-org-capture-7-map (kbd "m")
  (lambda () (interactive) (org-capture nil "cf")))
(define-key my-org-capture-7-map (kbd "r")
  (lambda () (interactive) (org-capture nil "cg")))

;; Year 8 - own class 8S, plus 8L reading group
(define-prefix-command 'my-org-capture-8-map)
(define-key my-org-capture-map (kbd "8") 'my-org-capture-8-map)
(define-key my-org-capture-8-map (kbd "s")
  (lambda () (interactive) (org-capture nil "cb")))
(define-key my-org-capture-8-map (kbd "a")
  (lambda () (interactive) (org-capture nil "ch")))

;; Year 9 - own class 9L, plus two separate 9S reading groups
(define-prefix-command 'my-org-capture-9-map)
(define-key my-org-capture-map (kbd "9") 'my-org-capture-9-map)
(define-key my-org-capture-9-map (kbd "l")
  (lambda () (interactive) (org-capture nil "cc")))
(define-key my-org-capture-9-map (kbd "r")
  (lambda () (interactive) (org-capture nil "ci")))
(define-key my-org-capture-9-map (kbd "h")
  (lambda () (interactive) (org-capture nil "cj")))

;; Year 10 / 11 - one class each, bound directly
(define-key my-org-capture-map (kbd "0")
  (lambda () (interactive) (org-capture nil "cd")))
(define-key my-org-capture-map (kbd "1")
  (lambda () (interactive) (org-capture nil "ce")))

;; ============================================================
;; TAGS
;; ============================================================
(setq org-tag-alist '(("departmental" . ?d) ("teaching" . ?t) ("marking" . ?m) ("topics" . ?p) ("reprographics" . ?r)))
