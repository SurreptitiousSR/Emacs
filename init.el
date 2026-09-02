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

(load "performance-config")
(load "org-config")
(load "gtd-config")
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
(my-package-install 'all-the-icons-ivy-rich)

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
(setq org-agenda-window-setup 'current-window)
;; Restore windows when quitting agenda
(setq org-agenda-restore-windows-after-quit t)
;; Force the dispatcher menu into the current window instead of splitting
(add-to-list 'display-buffer-alist
             '(" \\*Agenda Commands\\*" (display-buffer-same-window)))
;; Hide matcher regex from agenda dispatcher
(setq org-agenda-menu-show-matcher nil)
;; Capture buffer opens in current window
(setq org-capture-use-agenda-date-prompt nil)
(add-to-list 'display-buffer-alist
             '("\\*Org Select\\*" (display-buffer-same-window)))
(add-to-list 'display-buffer-alist
             '("^CAPTURE-" (display-buffer-same-window)))
;; Performance: skip startup options when scanning agenda files
(setq org-agenda-inhibit-startup t)
;; Performance: don't check blocked tasks
(setq org-agenda-dim-blocked-tasks nil)
;; Sort agenda items by priority (high to low) then category
(setq org-agenda-sorting-strategy
      '((agenda habit-down time-up priority-down category-keep)
        (todo priority-down category-keep)
        (tags priority-down category-keep)
        (search category-keep)))
;; Start agenda from today, not Monday
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-format-date "%A %d %B %Y")
;; Hide the misaligned A/B timetable set in every agenda view.
;; my/timetable-skip (timetable-config.el) is a no-op outside timetable.org.
(setq org-agenda-skip-function-global '(my/timetable-skip))
;; Hide topics-tagged items from all agenda views by default
(setq org-agenda-tag-filter-preset '("-topics"))
;; Hide empty time grid lines, keep the "now" indicator
(setq org-agenda-use-time-grid t)
(setq org-agenda-time-grid
      '((daily today require-timed)
        ()
        "......" "────────────────"))
;; Use leading zeros for time alignment (08:00 not 8:00)
(setq org-agenda-time-leading-zero t)
;; Prefix format: category left-padded, then time aligned
(setq org-agenda-prefix-format
      '((agenda . " %?-12t% s")
        (todo . " ")
        (tags . " ")
        (search . " ")))
;; Add spacing before timetable entries to group time blocks
(defvar my/agenda-separator " ─────────────────────────────────────\n")
(defun my/org-agenda-add-timetable-spacing ()
  "Insert dashed separators between time blocks in the agenda."
  (let ((inhibit-read-only t))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (let ((line-text (buffer-substring (line-beginning-position) (line-end-position))))
          ;; Rule 1: separator before timetable entries unless prev line starts with same time
          (when (and (looking-at "^\\s-*\\([0-9][0-9]:[0-9][0-9]\\)-[0-9][0-9]:[0-9][0-9]")
                     (not (looking-back (regexp-quote my/agenda-separator) (line-beginning-position 0)))
                     (save-excursion
                       (forward-line -1)
                       (not (looking-at "^$\\|^[A-Z]\\|^ ─")))
                     (let ((start-time (match-string 1)))
                       (save-excursion
                         (forward-line -1)
                         (not (looking-at (concat "^\\s-*" (regexp-quote start-time)))))))
            (beginning-of-line)
            (insert my/agenda-separator))
          ;; Rule 3: blank before date headers
          (when (and (looking-at "^[A-Z]")
                     (not (looking-back "\n\n" (line-beginning-position 0)))
                     (save-excursion
                       (forward-line -1)
                       (not (looking-at "^$\\|^[A-Z]\\|^ ─"))))
            (beginning-of-line)
            (insert "\n"))
          ;; Rule 2: separator before scheduled items when prev line starts with a different time
          (when (and (looking-at "^\\s-*\\([0-9][0-9]:[0-9][0-9]\\)")
                     (not (string-match-p "LOG ENTRY" line-text))
                     (not (looking-at "^\\s-*[0-9][0-9]:[0-9][0-9]-"))
                     (not (looking-back (regexp-quote my/agenda-separator) (line-beginning-position 0)))
                     (save-excursion
                       (forward-line -1)
                       (not (looking-at "^$\\|^[A-Z]\\|^ ─")))
                     (let ((this-time (match-string 1)))
                       (save-excursion
                         (forward-line -1)
                         (not (looking-at (concat "^\\s-*" (regexp-quote this-time)))))))
            (beginning-of-line)
            (insert my/agenda-separator))
          ;; Rule 4: separator before deadline/overdue items (e.g. "40 d. ago:", "In 9 d.:", "Sched.")
          (when (and (looking-at "^\\s-*\\(In \\|[0-9]+ d\\. ago:\\|Sched\\.\\)")
                     (not (looking-back (regexp-quote my/agenda-separator) (line-beginning-position 0)))
                     (save-excursion
                       (forward-line -1)
                       (not (looking-at "^$\\|^[A-Z]\\|^ ─\\|^\\s-*\\(In \\|[0-9]+ d\\. ago:\\|Sched\\.\\)"))))
            (beginning-of-line)
            (insert my/agenda-separator)))
        (forward-line 1)))))
(add-hook 'org-agenda-finalize-hook #'my/org-agenda-add-timetable-spacing)

;; Custom agenda: 3-day view + upcoming items
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs"
         ((agenda "" ((org-agenda-span 3) (org-agenda-tag-filter-preset (quote ("-topics")))))
          (alltodo "-topics" ((org-agenda-overriding-header "Upcoming")))))
        ("m" "Marking"
         ((tags-todo "marking"
                     ((org-agenda-overriding-header "TODO")
                      (org-agenda-prefix-format " %-16c ")))
          (tags "marking/DONE"
                ((org-agenda-overriding-header "────────────────────────────────────────\nCompleted")
                 (org-agenda-prefix-format " %-16c ")))))
        ("d" "Today's timetable"
         ((agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-time-grid '((daily today)
                                           (800 900 1000 1100 1200 1300 1400 1500)
                                           "......" "----------------"))
                   (org-agenda-tag-filter-preset '("-free" "-topics"))
                   (org-agenda-overriding-header
                    (format "Today's Timetable — Week %s" (my/current-week)))))))
        ("w" "This week's timetable"
         ((agenda ""
                  ((org-agenda-span 5)
                   (org-agenda-start-on-weekday 1)
                   (org-agenda-files (list (expand-file-name "timetable.org" my/org-directory)
                                           (expand-file-name "school-calendar.org" my/org-directory)))
                   (org-agenda-tag-filter-preset '("-free"))
                   (org-agenda-overriding-header
                    (format "Week %s Timetable" (my/current-week)))))))
        ("p" "Topic Progress"
         ((tags-todo "topics"
                     ((org-agenda-overriding-header "Topics — TODO")
                      (org-agenda-prefix-format " %-16c ")
                      (org-agenda-tag-filter-preset nil)))
          (tags "topics/DONE"
                ((org-agenda-overriding-header "────────────────────────────────────────\nTopics — Completed")
                 (org-agenda-prefix-format " %-16c ")
                 (org-agenda-tag-filter-preset nil)))))
        ("t" "TODOs by Tag"
         ((tags-todo "marking"
                     ((org-agenda-overriding-header "Marking")
                      (org-agenda-prefix-format " %-16c ")))
          (tags-todo "teaching"
                     ((org-agenda-overriding-header "────────────────────────────────────────\nTeaching")
                      (org-agenda-prefix-format " %-16c ")))
          (tags-todo "departmental"
                     ((org-agenda-overriding-header "────────────────────────────────────────\nDepartmental")
                      (org-agenda-prefix-format " %-16c ")))
          (tags-todo "reprographics"
                     ((org-agenda-overriding-header "────────────────────────────────────────\nReprographics")
                      (org-agenda-prefix-format " %-16c ")))
          (tags-todo "-marking-teaching-departmental-reprographics-topics"
                     ((org-agenda-overriding-header "────────────────────────────────────────\nGeneral")
                      (org-agenda-prefix-format " %-16c ")))))
        ("g" "GTD Review"
         ((todo "TODO"
                ((org-agenda-files (list (my/org-file "inbox.org")))
                 (org-agenda-overriding-header "Inbox — process & refile")))
          (agenda "" ((org-agenda-span 1)
                      (org-agenda-overriding-header "Today")))
          (todo "TODO"
                ((org-agenda-files (list (my/org-file "teaching.org")
                                         (my/org-file "departmental.org")
                                         (my/org-file "homework.org")))
                 (org-agenda-todo-ignore-scheduled 'all)
                 (org-agenda-todo-ignore-deadlines 'all)
                 (org-agenda-overriding-header "Next actions (unscheduled)")))
          (todo "DELEGATED|BLOCKED"
                ((org-agenda-overriding-header "Waiting / Blocked")))))
        ("r" "Weekly Review"
         ((agenda "" ((org-agenda-span 7) (org-agenda-start-on-weekday 1)))
          (stuck "")
          (todo "TODO" ((org-agenda-overriding-header "All open actions")))))))


;; Modify orgmode TODO states
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "BLOCKED" "|" "DONE" "DELEGATED" "MEET")))

;; Make org indent things properly
(add-hook 'org-mode-hook (lambda () (org-indent-mode)))

;; Enable visual line wrapping (word wrap)
(global-visual-line-mode 1)

;; ============================================================
;; AGENDA: RET opens logbook for lessons
;; ============================================================
(defvar my/class-logbook-map
  '(("10LS/"    . "10ls.logbook.org")
    ("11LS/"    . "11ls.logbook.org")
    ("7S/"      . "7s.logbook.org")
    ("8S/"      . "8s.logbook.org")
    ("8L/"      . "8l.logbook.org")
    ("9L/"      . "9l.logbook.org")
    ;; 7L and 9S are each split across two teaching groups, so these must
    ;; match on the full code including the teacher. A bare "7L/" or "9S/"
    ;; here would send both groups to the same logbook.
    ("7L/ScMBN" . "7l-mbn.logbook.org")
    ("7L/ScRDS" . "7l-rds.logbook.org")
    ("9S/ScRDS" . "9s-rds.logbook.org")
    ("9S/ScHUR" . "9s-hur.logbook.org"))
  "Maps class code patterns to logbook filenames for agenda RET.")

(defun my/agenda-goto-or-logbook ()
  "On a timetable lesson, open its logbook. Otherwise, default agenda-goto."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (logbook
          (catch 'found
            (dolist (pair my/class-logbook-map)
              (when (string-match-p (regexp-quote (car pair)) line)
                (throw 'found (cdr pair)))))))
    (if logbook
        (let ((path (expand-file-name logbook my/org-directory)))
          (find-file path)
          (goto-char (point-min))
          (when (re-search-forward "^\\* LOG" nil t)
            (beginning-of-line)
            (org-show-subtree)
            (recenter 0)))
      (org-agenda-goto))))

(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "RET") #'my/agenda-goto-or-logbook))

;; ============================================================
;; KEYBINDINGS
;; ============================================================
(global-unset-key (kbd "<f3>"))
(global-unset-key (kbd "<f4>"))
(global-unset-key (kbd "C-x ("))
(global-unset-key (kbd "C-x )"))
(global-unset-key (kbd "C-x e"))
(global-set-key (kbd "C-S-x") 'recentf-open-files)
(defun my-org-agenda-fullscreen ()
  "Open org-agenda dispatcher in the full window."
  (interactive)
  (delete-other-windows)
  (org-agenda))
(defun my-org-agenda-tiled ()
  "Open org-agenda dispatcher in the current window (respects splits)."
  (interactive)
  (org-agenda))
(global-set-key (kbd "C-c a") 'my-org-agenda-fullscreen)
(global-set-key (kbd "C-c A") 'my-org-agenda-tiled)
