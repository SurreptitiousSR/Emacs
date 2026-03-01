;; Keybinds
(global-set-key (kbd "C-S-x") 'recentf-open-files)
(global-set-key (kbd "C-c a") 'org-agenda)

;; Let Org-mode own Tab in Evil Normal mode
;; (needed for table alignment and heading folding)
(with-eval-after-load 'evil
  (evil-define-key 'normal org-mode-map (kbd "TAB") #'org-cycle))