;;(ORG CAPTURE TEMPLATES START
(with-eval-after-load 'org
  (setq org-capture-templates
      '(("ca" "LOG ENTRY" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/7g3.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("cb" "LOG ENTRY" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/7f2.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

        ("cc" "LOG ENTRY" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/8f1.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("cd" "LOG ENTRY" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/9g1.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("cg" "LOG ENTRY" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/9f1.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("ce" "LOG ENTRY" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/10ats1.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("cf" "LOG ENTRY" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/10f1.logbook.org" "LOG")
	 "* LOG ENTRY %T\n %?")

	("ck" "TODO" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/ks3.org" "TODO")
	 "* TODO\s %?\s :ks3:")

        ("cl" "TODO" entry (file+headline "C:/Users/Samuel.Attwell/Documents/org/departmental.org" "DEPARTMENTAL TASKS")
	 "* TODO\s %?\s :departmental:"))))

;; Org capture prefix setup
(define-prefix-command 'my-org-capture-map)
(global-set-key (kbd "C-c c") 'my-org-capture-map)
(define-key my-org-capture-map (kbd "c") 'org-capture)

;;7g3 
(define-prefix-command 'my-org-capture-7-map)
(define-key my-org-capture-map (kbd "7") 'my-org-capture-7-map)
(define-prefix-command 'my-org-capture-7g-map)
(define-key my-org-capture-7-map (kbd "g") 'my-org-capture-7g-map)
(define-key my-org-capture-7g-map (kbd "3")
  (lambda () (interactive) (org-capture nil "ca")))

;;7f2 
(define-prefix-command 'my-org-capture-7f-map)
(define-key my-org-capture-7-map (kbd "f") 'my-org-capture-7f-map)
(define-key my-org-capture-7f-map (kbd "2")
  (lambda () (interactive) (org-capture nil "cb")))

;;8f1 
(define-prefix-command 'my-org-capture-8-map)
(define-key my-org-capture-map (kbd "8") 'my-org-capture-8-map)
(define-prefix-command 'my-org-capture-8f-map)
(define-key my-org-capture-8-map (kbd "f") 'my-org-capture-8f-map)
(define-key my-org-capture-8f-map (kbd "1")
  (lambda () (interactive) (org-capture nil "cc")))

;;9g1 
(define-prefix-command 'my-org-capture-9-map)
(define-key my-org-capture-map (kbd "9") 'my-org-capture-9-map)
(define-prefix-command 'my-org-capture-9g-map)
(define-key my-org-capture-9-map (kbd "g") 'my-org-capture-9g-map)
(define-key my-org-capture-9g-map (kbd "1")
   (lambda () (interactive) (org-capture nil "cd")))

;;9f1
(define-prefix-command 'my-org-capture-9f-map)
(define-key my-org-capture-9-map (kbd "f") 'my-org-capture-9f-map)
(define-key my-org-capture-9f-map (kbd "1")
   (lambda () (interactive) (org-capture nil "cg")))


;;10ats1 
(define-prefix-command 'my-org-capture-0-map)
(define-key my-org-capture-map (kbd "0") 'my-org-capture-0-map)
(define-prefix-command 'my-org-capture-0t-map)
(define-key my-org-capture-0-map (kbd "t") 'my-org-capture-0t-map)
(define-key my-org-capture-0t-map (kbd "1")
    (lambda () (interactive) (org-capture nil "ce")))

;;10f1 
(define-prefix-command 'my-org-capture-0f-map)
(define-key my-org-capture-0-map (kbd "f") 'my-org-capture-0f-map)
(define-key my-org-capture-0f-map (kbd "1")
    (lambda () (interactive) (org-capture nil "cf")))

;;ks3 
(define-prefix-command 'my-org-capture-k-map)
(define-key my-org-capture-map (kbd "k") 'my-org-capture-k-map)
(define-prefix-command 'my-org-capture-ks-map)
(define-key my-org-capture-k-map (kbd "s") 'my-org-capture-ks-map)
(define-key my-org-capture-ks-map (kbd "3")
    (lambda () (interactive) (org-capture nil "ck")))

;;departmental 
(define-prefix-command 'my-org-capture-d-map)
(define-key my-org-capture-map (kbd "d") 'my-org-capture-d-map)
(define-prefix-command 'my-org-capture-dp-map)
(define-key my-org-capture-d-map (kbd "p") 'my-org-capture-dp-map)
(define-key my-org-capture-dp-map (kbd "t")
    (lambda () (interactive) (org-capture nil "cl")))

;; TAGS for tagging
(setq org-tag-alist '(("form" . ?f) ("classroom" . ?c) ("ks3" . ?k) ("departmental" . ?d) ("lablogger" . ?l)))
