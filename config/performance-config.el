;;; performance-config.el --- Performance tuning, esp. Windows thin clients -*- lexical-binding: t -*-

;; Loaded early (before package init and the org modules) so the GC setting
;; covers startup as well as agenda builds.

;; ============================================================
;; GARBAGE COLLECTION
;; ============================================================
;; The default threshold (~800 KB) triggers frequent GC pauses while building
;; the agenda, which allocates a lot of short-lived data. Raise it so the scan
;; doesn't stall on a weak CPU.
(setq gc-cons-threshold (* 64 1024 1024))   ; 64 MB

;; ============================================================
;; VERSION CONTROL
;; ============================================================
;; Org files are a git repo synced by org-sync.el. Emacs's built-in VC would
;; otherwise spawn a `git' subprocess on every file visit (slow on Windows
;; thin clients) just to refresh modeline state we don't use.
(setq vc-handled-backends nil)

;; ============================================================
;; WINDOWS FONT CACHES
;; ============================================================
;; On Windows, GC compacts font caches, which is very slow with icon fonts
;; (all-the-icons / ivy-rich). Skip the compaction.
(when (eq system-type 'windows-nt)
  (setq inhibit-compacting-font-caches t))

(provide 'performance-config)
