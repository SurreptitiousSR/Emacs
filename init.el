(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#0D1117" :foreground "ghost white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 105 :width normal :foundry "UKWN" :family "MartianMono Nerd Font Mono")))))

;;******************************************************
;; SET UP PACKAGE.EL TO WORK WITH MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Refresh contents if packages aren't available
(unless package-archive-contents
  (package-refresh-contents))

;;******************************************************
;; SETUP USE-PACKAGE
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;******************************************************
;; Packages
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package vterm
  :ensure t)

(use-package recentf
  :ensure nil
  :config
  (recentf-mode 1)
  (setq recentf-max-saved-items 100
	recentf-save-file (expand-file-name "recentf" user-emacs-directory)))

(use-package flyspell
  :ensure nil
  :hook
  ((text-mode . flyspell-mode)))

(use-package org
  :ensure nil
  :hook
  ((org-mode . org-indent-mode)
   (org-mode . visual-line-mode)))

(use-package ivy
  :ensure t
  :config
  (ivy-mode)
  (setopt ivy-use-virtual-buffers t)
  (setopt enable-recursive-minibuffers t))

(use-package counsel
  :ensure t
  :after ivy
  :bind* ; load when pressed
  (("M-x"     . counsel-M-x)
   ("C-s"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)  ; search for recently edited
   ("C-c g"   . counsel-git)      ; search for files in git repo
   ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
   ("C-c /"   . counsel-ag)       ; Use ag for regexp
   ("C-x l"   . counsel-locate)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))     ; Resume last Ivy-based completion

(use-package ivy-rich
  :ensure t
  :config
  (ivy-rich-mode 1))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-ivy-rich
  :ensure t
  :config
  (all-the-icons-ivy-rich-mode 1))

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Nextcloud/Documents/roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup)
  (org-roam-db-autosync-mode))

(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package magit
  :ensure t)

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package citar
  :ensure t
  :demand t
  :custom
  (citar-bibliography '("~/Documents/bibliography/biblio.bib"))
  (citar-notes-paths '("~/Documents/roam/"))
  (citar-file-note-extensions '("org"))
  :hook
  (org-mode . citar-capf-setup))

(use-package citar-embark
  :ensure t
  :after citar embark
  :no-require
  :config (citar-embark-mode))

(use-package citar-org-roam
  :ensure t
  :after (citar org-roam)
  :config
  (citar-org-roam-mode)
  (setq citar-org-roam-subdir "reference"))
;;******************************************************
;; UI TWEAKS
(setq visible-bell 1)

(menu-bar-mode -1)

(tool-bar-mode -1)

(scroll-bar-mode -1)

(display-line-numbers-mode 1)

(add-to-list 'default-frame-alist '(fullscreen . fullboth))

;;******************************************************
;; LOAD ADDITIONAL FILES / SET DIRECTORIES
(add-to-list 'load-path "~/.emacs.d/config")

(condition-case err
    (load "key-bindings")
  (error (message "Failed to load key-bindings: %s" err)))

(condition-case err
    (load "org-config")
  (error (message "Failed to load org-config: %s" err)))

(condition-case err  
    (load "roam-custom")
  (error (message "Failed to load org-roam config: %s" err)))

(setq default-directory "~/Nextcloud/Documents/")
(setq dired-default-directory "~/Nextcloud/Documents/")
(setq initial-buffer-choice default-directory)
