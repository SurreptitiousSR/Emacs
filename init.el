;; Addd the .emacs.d/config directory to the load path
(add-to-list 'load-path "~/.emacs.d/config")
(load "key-bindings")
(load "org-config")

;; Set the default directory
(setq default-directory "~/Documents/org")
(setq dired-default-directory "~/Documents/org/")
;; Set the initial buffer's default directory on startup
(setq initial-buffer-choice default-directory)

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
 '(default ((t (:inherit nil :extend nil :stipple nil :background "gray23" :foreground "ghost white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 102 :width normal :foundry "outline" :family "MartianMono NFM")))))


;;******************************************************
;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)


;;******************************************************
;; Packages
(unless (package-installed-p 'evil)
  (package-install 'evil))

(unless (package-installed-p 'vterm)
  (package-install 'vterm))

(unless (package-installed-p 'counsel)
  (package-install 'counsel))

(unless (package-installed-p 'ivy-rich)
  (package-install 'ivy-rich))

(unless (package-installed-p 'all-the-icons)
  (package-install 'all-the-icons))

(unless (package-installed-p 'all-the-icons-dired)
  (package-install 'all-the-icons-dired))

(unless (package-installed-p 'all-the-icons-ivy-rich)
  (package-install 'all-the-icons-ivy-rich))

(unless (package-installed-p 'org-bullets)
  (package-install 'org-bullets))

(unless (package-installed-p 'org-roam)
  (package-install 'org-roam))

;;******************************************************
;;Load packages / set modes
(require 'evil)
(evil-mode 1)

(require 'ivy)
(ivy-mode)
(setopt ivy-use-virtual-buffers t)
(setopt enable-recursive-minibuffers t)

(counsel-mode)

(require 'ivy-rich)
(ivy-rich-mode 1)

(when (display-graphic-p)
  (require 'all-the-icons))

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(all-the-icons-ivy-rich-mode 1)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(recentf-mode 1)

;;******************************************************
;; UI TWEAKS
(setq visible-bell 1)

(menu-bar-mode -1)

(tool-bar-mode -1)

(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(fullscreen . fullboth))

