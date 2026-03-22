;;; init.el --- Main configuration -*- lexical-binding: t -*-

;;------------------------------------------------------
;; CUSTOM FILE - keep Custom out of this file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))

;;------------------------------------------------------
;; PACKAGE SYSTEM
(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package (built-in from Emacs 29; install on older versions)
(unless (package-installed-p 'use-package)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Default: always fetch missing packages, and defer loading unless told otherwise
(setq use-package-always-ensure t
      use-package-always-defer  t)

;;------------------------------------------------------
;; FONT & THEME  (background already set in early-init.el)
(set-face-attribute 'default nil
                    :family "Px437 IBM VGA 9x16"
                    :height 130)

;;------------------------------------------------------
;; UI TWEAKS  (menu/tool/scroll-bar already disabled in early-init.el)
(setq visible-bell 1)

;; Window is maximized via early-init.el default-frame-alist.
;; Ensure any NEW frames also open maximized.
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (set-frame-parameter frame 'fullscreen 'maximized)))

;;------------------------------------------------------
;; EDITING DEFAULTS
(setq-default indent-tabs-mode nil
              tab-width 4)
(setq auto-save-default nil
      make-backup-files nil)

;;------------------------------------------------------
;; DIRECTORIES
(defvar my/documents-dir
  (cond
   ((eq system-type 'windows-nt) "C:/Users/samat/Nextcloud/Documents/")
   (t (let ((nc (expand-file-name "~/Nextcloud/Documents/")))
        (if (file-directory-p nc) nc (expand-file-name "~/")))))
  "Base documents directory, resolved per OS.")

(setq default-directory       my/documents-dir
      dired-default-directory my/documents-dir)
(when (eq system-type 'windows-nt)
  (setq temporary-file-directory "C:/Users/samat/AppData/Local/Temp/"))

;;------------------------------------------------------
;; STARTUP BUFFER - open home directory in dired
(setq initial-buffer-choice (expand-file-name "~/"))

;;------------------------------------------------------
;; RECENT FILES
(use-package recentf
  :ensure nil
  :demand t
  :config
  (recentf-mode 1)
  (setq recentf-max-saved-items 100
        recentf-save-file (expand-file-name "recentf" user-emacs-directory)))

;;------------------------------------------------------
;; EVIL (Vi keybindings)
(use-package evil
  :demand t
  :init
  ;; Must be set before Evil loads — prevents Evil from binding C-i
  ;; (which shares the same keycode as TAB), so Org tables can use TAB
  ;; for field navigation and alignment.
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

;;------------------------------------------------------
;; VTERM (terminal emulator)
(use-package vterm
  :hook (vterm-mode . (lambda () (evil-local-mode -1))))

;;------------------------------------------------------
;; COMPLETION - Ivy / Counsel / Swiper
(use-package ivy
  :demand t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(use-package counsel
  :after ivy
  :demand t
  :bind*
  (("M-x"     . counsel-M-x)
   ("C-s"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)
   ("C-c g"   . counsel-git)
   ("C-c j"   . counsel-git-grep)
   ("C-c /"   . counsel-ag)
   ("C-x l"   . counsel-locate)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))

(use-package ivy-rich
  :after ivy
  :demand t
  :config
  (ivy-rich-mode 1))

;;------------------------------------------------------
;; ICONS (only in GUI Emacs)
(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-ivy-rich
  :after (all-the-icons ivy-rich)
  :config
  (all-the-icons-ivy-rich-mode 1))

;;------------------------------------------------------
;; ORG MODE
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; Pixel-perfect table alignment (works around Nerd Font width issues on Windows)
(use-package valign
  :hook (org-mode . valign-mode))

;;------------------------------------------------------
;; ORG-ROAM
(use-package org-roam
  :custom
  (org-roam-directory (expand-file-name "roam" my/documents-dir))
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert))
  :config
  ;; find-file-visit-truename causes symlink cycle errors on Linux
  (when (eq system-type 'windows-nt)
    (setq find-file-visit-truename t))
  (org-roam-db-autosync-mode))

;;------------------------------------------------------
;; VERTICO + ORDERLESS
(use-package vertico
  :config
  (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;------------------------------------------------------
;; PROJECTILE
(use-package projectile
  :demand t
  :config
  (projectile-mode 1))

;; FIND-FILE-IN-PROJECT (used by elpy)
(use-package find-file-in-project
  :defer t)

;;------------------------------------------------------
;; MAGIT
(use-package magit)

;;------------------------------------------------------
;; ELPY (Python)
(use-package elpy
  :hook (python-mode . elpy-enable))

;;------------------------------------------------------
;; DIRED
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind ("C-x C-j" . dired-jump)
  :hook
  (dired-mode . dired-hide-details-mode)
  (dired-mode . dired-omit-mode)
  :config
  (require 'dired-x)
  (setq dired-omit-files "^\\."))  ; hide dotfiles

;;------------------------------------------------------
;; POSTSCRIPT / PDF PRINTING (Windows only)
(when (eq system-type 'windows-nt)
  (setq ps-paper-type    'a4
        ps-landscape-mode nil
        ps-number-of-columns 1
        ps-left-margin   36
        ps-right-margin  36
        ps-top-margin    36
        ps-bottom-margin 36
        ps-font-size     9
        ps-header-font-size 10
        ps-line-number   nil
        ps-print-color-p 'black-white
        ps-multibyte-buffer 'non-latin-printer)

  (defun my/find-ghostscript ()
    "Return path to the Ghostscript console executable, or nil."
    (or (executable-find "gswin64c.exe")
        (executable-find "gswin32c.exe")
        (car (file-expand-wildcards
              "C:/Program Files/gs/gs*/bin/gswin64c.exe"))))

  (defun my/print-to-pdf (ps-print-fn)
    "Call PS-PRINT-FN to write a .ps temp file then convert to PDF."
    (let* ((ps-file  (make-temp-file "emacs-print-" nil ".ps"))
           (pdf-file (concat (file-name-sans-extension ps-file) ".pdf"))
           (gs-exe   (my/find-ghostscript)))
      (funcall ps-print-fn ps-file)
      (if gs-exe
          (progn
            (call-process gs-exe nil nil nil
                          "-dNOPAUSE" "-dBATCH" "-sDEVICE=pdfwrite"
                          "-dPDFSETTINGS=/printer"
                          (concat "-sOutputFile=" pdf-file)
                          ps-file)
            (delete-file ps-file)
            (message "Opening PDF: %s" pdf-file)
            (w32-shell-execute "open" pdf-file))
        (error "Ghostscript not found — install from https://ghostscript.com"))))

  (defun my/ps-print-region-pdf (start end)
    "Print the active region as a PDF file."
    (interactive "r")
    (my/print-to-pdf
     (lambda (f) (ps-print-region-with-faces start end f))))

  (defun my/ps-print-buffer-pdf ()
    "Print the current buffer as a PDF file."
    (interactive)
    (my/print-to-pdf #'ps-print-buffer-with-faces))

  (defalias 'ps-print-region 'my/ps-print-region-pdf)
  (defalias 'ps-print-buffer 'my/ps-print-buffer-pdf))

;;------------------------------------------------------
;; LOAD ADDITIONAL CONFIG FILES
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(load "key-bindings" 'noerror 'nomessage)
(load "org-config"   'noerror 'nomessage)

;;------------------------------------------------------
;; STARTUP BENCHMARK (visible in *Messages*)
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %.2f seconds with %d GCs."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

;;; init.el ends here
