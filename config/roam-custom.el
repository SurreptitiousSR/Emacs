;; Ensure citar is loaded before defining the function
(defun org-roam-node-from-cite (keys-entries)
  "Create an org-roam node from a citation."
  (interactive) (list (




  ;; Use citar-select-refs (note the 's') which is the standard function
  (let* ((keys-entries (citar-select-refs :multiple nil))
	 (key (car keys-entries))
         (entry (cdr keys-entries))
         (title (citar-format--entry entry "${author editor} :: ${title}")))
    (org-roam-capture- :templates
                       '(("r" "reference" plain "%?" :if-new
                          (file+head "reference/${citekey}.org"
                                     ":PROPERTIES:
:ROAM_REFS: [cite:@${citekey}]
:END:
#+title: ${title}\n")
                          :immediate-finish t
                          :unnarrowed t))
                       :info (list :citekey key)
                       :node (org-roam-node-create :title title)
                       :props '(:finalize find-file))))

