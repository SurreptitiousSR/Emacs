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
(package-refresh-contents)

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

(use-package vterm)

(use-package recentf
  :ensure nil
  :config
  (recentf-mode 1)
  (setq recentf-max-saved-items 100
	recentf-save-file (expand-file-name "recentf" user-emacs-directory)))

>>>>>>> home
(use-package ivy
  :ensure t
  :config
  (ivy-mode)
  (setopt ivy-use-virtual-buffers t)
  (setopt enable-recursive-minibuffers t))

<<<<<<< HEAD
;; UI adjustments
(use-package exotica-theme
   :ensure t
   :load-path "themes"
   :init
   (setq exotica-theme t)
   :config
   (load-theme 'exotica t))

;; Remove menu-bar / scroll-bar / tool-bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Start Emacs fullscreen
(add-to-list 'default-frame-alist '(fullscreen . fullboth))




=======
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
  (setq org-roam-vb2-ack t)
  :custom
  (org-roam-directory "~/Nextcloud/Documents/roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))  

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
;;******************************************************
;; UI TWEAKS
(setq visible-bell 1)

(menu-bar-mode -1)

(tool-bar-mode -1)

(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(fullscreen . fullboth))

;;******************************************************
;; LOAD ADDITIONAL FILES / SET DIRECTORIES
(add-to-list 'load-path "~/.emacs.d/config")
(load "key-bindings")
(load "org-config")


(setq default-directory "~/Nextcloud/Documents/")
(setq dired-default-directory "~/Nextcloud/Documents/")
(setq initial-buffer-choice default-directory)
