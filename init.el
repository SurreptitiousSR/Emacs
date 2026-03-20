;; Addd the .emacs.d/config directory to the load path
(add-to-list 'load-path "~/.emacs.d/config")
(load "org-config")

(with-eval-after-load 'org
    (setq org-directory "C:/Users/SAttwell/Documents/org/"))

;; Set the default directory
(setq default-directory "C:/Users/SAttwell/Documents/org")
(setq dired-default-directory "C:/Users/SAttwell/Documents/org/")
;; Set the initial buffer's default directory on startup
(setq initial-buffer-choice default-directory)


;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("c:/Users/SAttwell/Documents/org/10s6.logbook.org"
     "c:/Users/SAttwell/Documents/org/9s1.logbook.org"
     "c:/Users/SAttwell/Documents/org/11s8.logbook.org"
     "c:/Users/SAttwell/Documents/org/7s2.logbook.org"
     "c:/Users/SAttwell/Documents/org/7l2.logbook.org"))
 '(org-capture-templates
   '(("c" "LOG ENTRY" entry
      (file+headline "C:/Users/SAttwell/Documents/logbook.org" "LOG")
      "* LOG ENTRY %? %t\12 %i\12 %a")) t)
 '(package-selected-packages
   '(all-the-icons-dired all-the-icons-ivy all-the-icons-ivy-rich
			 all-the-icons-nerd-fonts counsel evil
			 ivy-rich nerd-icons-dired org-bullets
			 org-modern)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "gray23" :foreground "ghost white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 130 :width normal :foundry "outline" :family "Px437 IBM VGA 9x16")))))


;; (EVIL MODE START
;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Only refresh package contents when a package needs installing
(defun my-package-install (pkg)
  "Install PKG, refreshing contents first if needed."
  (unless (package-installed-p pkg)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install pkg)))

;; Download Evil
(my-package-install 'evil)

;; Enable Evil
(require 'evil)
(evil-mode 1)
;; EVIL MODE FINISH)


;; (UI / MINIBUFFER IMPROVEMENTS START
;; Download ivy (consel pulls in ivy and swiper as well)
(my-package-install 'counsel)

;; Enable ivy
(require 'ivy)
(ivy-mode)
(setopt ivy-use-virtual-buffers t)
(setopt enable-recursive-minibuffers t)

;; Enable counsel - replaces a bunch of standard keybinding
(counsel-mode)

;; Download ivy-rich (better minibuffer formatting)
(my-package-install 'ivy-rich)

;; Enable ivy-rich
(require 'ivy-rich)
(ivy-rich-mode 1)

;; Download all-the-icons
(my-package-install 'all-the-icons)
(my-package-install 'all-the-icons-dired)

;; Run all-the-icons
(when (display-graphic-p)
  (require 'all-the-icons))
;; Don't forget to install the resource fonts with M-x all-the-icons-install-fonts
 
;; Enable all the icons at startup
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(all-the-icons-ivy-rich-mode 1)

;; Download orgmode bullets - nicer than asterisks
(my-package-install 'org-bullets)

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

;; Hide temporary files (ending in ~) in dired
(require 'dired-x)
(setq dired-omit-files "\\`[.]\\|~$\\|\\`#.*#\\'")
(add-hook 'dired-mode-hook 'dired-omit-mode)

;; Use built-in ls-lisp for consistent column alignment on Windows
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)
(setq ls-lisp-verbosity nil)

;; Hide file details by default, toggle with (
(add-hook 'dired-mode-hook 'dired-hide-details-mode)

;; Start EMACS in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Org agenda opens in full window
(setq org-agenda-window-setup 'only-window)
(setq org-agenda-restore-windows-after-quit t)
;; Force the dispatcher menu into the current window instead of splitting
(add-to-list 'display-buffer-alist
             '(" \\*Agenda Commands\\*" (display-buffer-same-window)))
;; Hide matcher regex from agenda dispatcher
(setq org-agenda-menu-show-matcher nil)
;; Sort agenda items by priority (high to low) then category
(setq org-agenda-sorting-strategy
      '((agenda habit-down time-up priority-down category-keep)
        (todo priority-down category-keep)
        (tags priority-down category-keep)
        (search category-keep)))
;; Start agenda from today, not Monday
(setq org-agenda-start-on-weekday nil)
;; Use leading zeros for time alignment (08:00 not 8:00)
(setq org-agenda-time-leading-zero t)
;; Prefix format: category left-padded, then time aligned
(setq org-agenda-prefix-format
      '((agenda . " %-16:c%?-12t% s")
        (todo . " %-16:c")
        (tags . " %-16:c")
        (search . " %-16:c")))
;; Custom agenda: 3-day view + upcoming items
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs"
         ((agenda "" ((org-agenda-span 3)))
          (alltodo "" ((org-agenda-overriding-header "Upcoming")))))
        ("m" "Marking"
         ((tags-todo "marking"
                     ((org-agenda-overriding-header "TODO")))
          (tags "marking/DONE"
                ((org-agenda-overriding-header "────────────────────────────────────────\nCompleted")))))))

;; Modify orgmode TODO states
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "BLOCKED" "|" "DONE" "DELEGATED" "MEET")))

;; Make org indent things properly
(add-hook 'org-mode-hook (lambda () (org-indent-mode)))

;; Enable visual line wrapping (word wrap)
(global-visual-line-mode 1)

;; Keybinds
(global-set-key (kbd "C-S-x") 'recentf-open-files)
(defun my-org-agenda-fullscreen ()
  "Open org-agenda dispatcher in the full window."
  (interactive)
  (delete-other-windows)
  (org-agenda))
(global-set-key (kbd "C-c a") 'my-org-agenda-fullscreen) 

