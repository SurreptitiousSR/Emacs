(defun chronicler/org-roam-node-from-cite (citekey)
  (interactive (list (citar-select-ref)))
  ;;(message "Selected citekey: %s" citekey)
  (let* ((entry (citar-get-entry citekey))
         (title (concat (format "@%s - " citekey) (citar-get-value 'title entry)))
         (author (citar-get-value 'author entry))
         (type (or (citar-get-value '=type= entry) "reference"))
         (filepath (format "reference/@%s.org" citekey))
         (head (format ":PROPERTIES:
:ROAM_REFS: [cite:@%s]
:END:
#+title: %s
#+author: %s
#+type: %s\n" citekey title author type)))
    (org-roam-capture- :templates
       `(("r" "reference" plain "%?"
          :if-new
          (file+head ,filepath ,head)
          :immediate-finish t
          :unnarrowed t))
       :node (org-roam-node-create :title title)
       :props '(:finalize find-file))))
