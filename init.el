;; Addd the .emacs.d/config directory to the load path
(add-to-list 'load-path "~/.emacs.d/config")
(load "org-config")
(load "key-bindings")

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
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "gray23" :foreground "ghost white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 102 :width normal :foundry "outline" :family "MartianMono NFM")))))

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; (EVIL MODE START
;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)
;; EVIL MODE FINISH)


;; Add vterm a terminal emulator
(unless (package-installed-p 'vterm)
  (package-install 'vterm))


;; (UI / MINIBUFFER IMPROVEMENTS START
;; Download ivy (consel pulls in ivy and swiper as well)
(unless (package-installed-p 'counsel)
  (package-install 'counsel))

;; Enable ivy
(require 'ivy)
(ivy-mode)
(setopt ivy-use-virtual-buffers t)
(setopt enable-recursive-minibuffers t)

;; Enable counsel - replaces a bunch of standard keybinding
(counsel-mode)

;; Download ivy-rich (better minibuffer formatting)
(unless (package-installed-p 'ivy-rich)
  (package-install 'ivy-rich))

;; Enable ivy-rich
(require 'ivy-rich)
(ivy-rich-mode 1)

;; Download all-the-icons
(unless (package-installed-p 'all-the-icons)
  (package-install 'all-the-icons))

(unless (package-installed-p 'all-the-icons-dired)
  (package-install 'all-the-icons-dired))

(unless (package-installed-p 'all-the-icons-ivy-rich)
  (package-install 'all-the-icons-ivy-rich))

;; Run all-the-icons
(when (display-graphic-p)
  (require 'all-the-icons))
;; Don't forget to install the resource fonts with M-x all-the-icons-install-fonts
 
;; Enable all the icons at startup
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(all-the-icons-ivy-rich-mode 1)

;; Download orgmode bullets - nicer than asterisks
(unless (package-installed-p 'org-bullets)
  (package-install 'org-bullets))

;; Enable orgmode bullets

;; (UI / MINIBUFFER IMPROVEMENTS FINISH)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))


;; (DISABLE ANNOYING THINGS START
;; Disable annoying bell
(setq visible-bell 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; DISABLE ANNOYING THINGS FINISH)


;; Enable recentf mode that maintains a list of recently opened files
(recentf-mode 1)

;; Start EMACS in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . fullboth))

