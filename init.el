;;; -*- lexical-binding: t -*-

;; ============================================================
;; OS-AWARE PATH CONFIGURATION
;; ============================================================
(defvar my/org-directory
  (pcase system-type
    ('windows-nt "C:/Users/SAttwell/Documents/org/")
    ('darwin "~/org-files/"))
  "Root directory for org files, OS-dependent.")

(defvar my/default-directory
  (pcase system-type
    ('windows-nt "C:/Users/SAttwell/Documents/org/")
    ('darwin "~/org-files/"))
  "Default directory for file operations, OS-dependent.")

;; ============================================================
;; LOAD CONFIG MODULES
;; ============================================================
(add-to-list 'load-path "~/.emacs.d/config")

;; Pre-declare org-agenda-custom-commands so config modules can append to it
(defvar org-agenda-custom-commands nil)

(load "org-config")
(load "org-sync")
(load "timetable-config")

;; Org directory
(with-eval-after-load 'org
  (setq org-directory my/org-directory))

;; Set the default directory
(setq default-directory my/default-directory)
(setq dired-default-directory my/default-directory)
;; Set the initial buffer's default directory on startup
(setq initial-buffer-choice default-directory)

;; ============================================================
;; CUSTOM-SET (managed by Emacs — do not edit by hand)
;; ============================================================
(custom-set-variables
 '(package-selected-packages
   '(all-the-icons-dired all-the-icons-ivy all-the-icons-ivy-rich all-the-icons-nerd-fonts counsel evil ivy-rich nerd-icons-dired org-bullets org-modern)))
(custom-set-faces
 (pcase system-type
   ('windows-nt
    '(default ((t (:inherit nil :extend nil :stipple nil :background "gray23" :foreground "ghost white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 130 :width normal :foundry "outline" :family "Px437 IBM VGA 9x16")))))
   ('darwin
    '(default ((t (:inherit nil :extend nil :stipple nil :background "black" :foreground "ghost white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 130 :width normal :foundry "outline" :family "MartianMono NFM")))))))

;; ============================================================
;; PACKAGE MANAGEMENT
;; ============================================================
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

;; ============================================================
;; EVIL MODE
;; ============================================================
(my-package-install 'evil)

;; Enable Evil
(require 'evil)
(evil-mode 1)

;; ============================================================
;; UI / MINIBUFFER IMPROVEMENTS
;; ============================================================
;; Download ivy (counsel pulls in ivy and swiper as well)
(my-package-install 'counsel)

;; Enable ivy
(require 'ivy)
(ivy-mode)
(setopt ivy-use-virtual-buffers t)
(setopt enable-recursive-minibuffers t)

;; Enable counsel - replaces a bunch of standard keybindings
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
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; ============================================================
;; DISABLE ANNOYING THINGS
;; ============================================================
(setq visible-bell 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

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

;; ============================================================
;; KEYBINDINGS
;; ============================================================
(global-set-key (kbd "C-S-x") 'recentf-open-files)
(defun my-org-agenda-fullscreen ()
  "Open org-agenda dispatcher in the full window."
  (interactive)
  (delete-other-windows)
  (org-agenda))
(global-set-key (kbd "C-c a") 'my-org-agenda-fullscreen)
