;;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;; Loaded before init.el and before the package system and GUI are initialized.
;; Changes here have the most impact on startup time.

;;------------------------------------------------------
;; GARBAGE COLLECTION - defer GC during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Restore sensible GC values after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)  ; 16 MB
                  gc-cons-percentage 0.1)))

;;------------------------------------------------------
;; SUPPRESS FILE HANDLER LOOKUPS during startup
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist my/file-name-handler-alist)))

;;------------------------------------------------------
;; PACKAGE SYSTEM - tell package.el not to auto-initialize
;; (we do it explicitly in init.el after configuring archives)
(setq package-enable-at-startup nil)

;;------------------------------------------------------
;; WINDOW / FRAME - set before the frame is drawn so there is no flicker
(setq frame-inhibit-implied-resize t)

;; Maximized, but NOT fullscreen (keeps the title bar / taskbar visible)
(push '(fullscreen . maximized) default-frame-alist)

;; Suppress default startup visuals immediately (avoids drawing them at all)
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Prevent the scratch buffer flash with a dark background
(push '(background-color . "#0D1117") default-frame-alist)
(push '(foreground-color . "ghost white") default-frame-alist)

;;------------------------------------------------------
;; SILENCE STARTUP MESSAGES
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      initial-scratch-message nil)

;;; early-init.el ends here
