;;(ORG CAPTURE TEMPLATES START
(with-eval-after-load 'org
  (setq org-capture-templates
      '(("ca" "LOG ENTRY" entry (file+headline "C:/Users/SAttwell/Documents/org/7l2.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("cb" "LOG ENTRY" entry (file+headline "C:/Users/SAttwell/Documents/org/7s2.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

        ("cc" "LOG ENTRY" entry (file+headline "C:/Users/SAttwell/Documents/org/9s1.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("cd" "LOG ENTRY" entry (file+headline "C:/Users/SAttwell/Documents/org/10s6.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("ce" "LOG ENTRY" entry (file+headline "C:/Users/SAttwell/Documents/org/11s8.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("ck" "TODO" entry (file+headline "C:/Users/SAttwell/Documents/org/ks3.org" "TODO")
	 "* TODO\s %?\s :ks3:")

        ("cl" "TODO" entry (file+headline "C:/Users/SAttwell/Documents/org/departmental.org" "DEPARTMENTAL TASKS")
	 "* TODO\s %?\s :departmental:")

	("ct" "TODO" entry (file+headline "C:/Users/SAttwell/Documents/org/teaching.org" "TEACHING")
	 "* TODO\s %?\s :teaching:"))))

;; Org capture prefix setup
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

;; TAGS for tagging
(setq org-tag-alist '(("departmental" . ?d) ("teaching" . ?t) ("marking" . ?m)))
