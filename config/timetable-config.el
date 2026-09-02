;;; timetable-config.el --- Week A/B detection and timetable agenda -*- lexical-binding: t -*-

(require 'calendar)

;; ============================================================
;; SCHOOL CALENDAR 2026-27
;; ============================================================
;; The A/B rotation advances per TEACHING week, not per calendar week: a
;; holiday pauses it. Last year this was patched after the fact with a
;; one-off `shift-cutoff' once the May half-term knocked the rotation out of
;; phase. Instead of that, `my/week-for-abs' now counts teaching weeks
;; directly and skips holiday weeks, so an odd-length break corrects itself
;; and no cutoff is ever needed.
;;
;; To roll this forward a year: update the anchor, the holiday weeks, and the
;; closed/partial days. Nothing else needs touching.

(defvar my/week-a-anchor '(2026 9 7)
  "A known Week A Monday as (YEAR MONTH DAY).
Mon 2026-09-07 is Week A; Mon 2026-08-31 and Mon 2026-09-14 are Week B.")

(defvar my/school-holiday-weeks
  '((2026 10 19) (2026 10 26)   ; Autumn half term (2 weeks)
    (2026 12 21) (2026 12 28)   ; Christmas (2 weeks)
    (2027  2 15)                ; Spring half term (1 week - flips parity)
    (2027  3 29) (2027  4  5)   ; Easter (2 weeks)
    (2027  5 31))               ; Summer half term (1 week - flips parity)
  "Mondays of whole weeks with no timetable. Each pauses the A/B rotation.")

(defvar my/school-closed-days
  '((2026 9 1)     ; Training day - no learners
    (2026 9 2)     ; Training day - no learners
    (2026 9 3)     ; Autumn term begins, Year 7 only
    (2026 10 2)    ; Training day - no learners
    (2027 5 3))    ; Bank holiday
  "Individual (YEAR MONTH DAY) days with no timetabled lessons.")

(defvar my/school-partial-days
  '(((2026 9 4) . "11:30"))
  "Alist of (YEAR MONTH DAY) . EARLIEST-START.
Lessons starting before EARLIEST-START are hidden on that day.
Fri 2026-09-04 is the first day with all year groups in; teaching starts P3.")

;; ============================================================
;; DATE HELPERS
;; ============================================================

(defun my/ymd-to-abs (ymd)
  "Absolute day number for YMD, a (YEAR MONTH DAY) list."
  (calendar-absolute-from-gregorian
   (list (nth 1 ymd) (nth 2 ymd) (nth 0 ymd))))

(defun my/monday-abs (abs)
  "Absolute day number of the Monday of ABS's week."
  (- abs (mod (- abs 1) 7)))

(defvar my/--holiday-abs nil "Cached holiday Mondays as absolute days.")
(defvar my/--closed-abs nil "Cached closed days as absolute days.")

(defun my/holiday-abs ()
  (or my/--holiday-abs
      (setq my/--holiday-abs (mapcar #'my/ymd-to-abs my/school-holiday-weeks))))

(defun my/closed-abs ()
  (or my/--closed-abs
      (setq my/--closed-abs (mapcar #'my/ymd-to-abs my/school-closed-days))))

(defun my/timetable-refresh-caches ()
  "Clear cached date lookups after editing the school calendar variables."
  (interactive)
  (setq my/--holiday-abs nil my/--closed-abs nil)
  (message "timetable: caches cleared"))

;; ============================================================
;; WEEK A/B CALCULATION
;; ============================================================

(defun my/week-for-abs (abs)
  "Return \"A\" or \"B\" for absolute day ABS.
Counts teaching weeks from `my/week-a-anchor', ignoring whole holiday
weeks in between, so a break of any length keeps the rotation correct."
  (let* ((mon (my/monday-abs abs))
         (anchor (my/monday-abs (my/ymd-to-abs my/week-a-anchor)))
         (weeks (/ (- mon anchor) 7))
         (lo (min anchor mon))
         (hi (max anchor mon))
         (hol 0))
    (dolist (h (my/holiday-abs))
      (when (and (>= h lo) (< h hi)) (setq hol (1+ hol))))
    ;; Going forward a holiday removes a teaching week; going back it adds one.
    (let ((n (if (>= mon anchor) (- weeks hol) (+ weeks hol))))
      (if (= 0 (mod n 2)) "A" "B"))))

(defun my/week-for-date (date)
  "Return \"A\" or \"B\" for DATE, a time value."
  (let ((d (decode-time date)))
    (my/week-for-abs (my/ymd-to-abs (list (nth 5 d) (nth 4 d) (nth 3 d))))))

(defun my/current-week ()
  "Return \"A\" or \"B\" for the current school week."
  (my/week-for-date (current-time)))

(defun my/holiday-week-p (abs)
  "Non-nil if ABS falls in a whole holiday week."
  (memq (my/monday-abs abs) (my/holiday-abs)))

(defun my/closed-day-p (abs)
  "Non-nil if ABS is a single closed day."
  (memq abs (my/closed-abs)))

;; ============================================================
;; MODELINE WEEK INDICATOR
;; ============================================================
(defvar my/week-indicator "")

(defun my/update-week-indicator ()
  "Update the modeline week indicator."
  (setq my/week-indicator
        (let ((abs (my/ymd-to-abs
                    (let ((d (decode-time)))
                      (list (nth 5 d) (nth 4 d) (nth 3 d))))))
          (cond ((my/holiday-week-p abs) " [Holiday]")
                ((my/closed-day-p abs) " [Closed]")
                (t (format " [Wk %s]" (my/current-week)))))))

(my/update-week-indicator)
(run-at-time "00:00" 3600 #'my/update-week-indicator)

(unless (member '(:eval my/week-indicator) mode-line-misc-info)
  (push '(:eval my/week-indicator) mode-line-misc-info))

;; ============================================================
;; AGENDA SKIP
;; ============================================================
;; timetable.org holds both fortnightly sets, tagged :weekA: and :weekB: on
;; their top-level headings (inherited by every lesson). Both sets repeat
;; WEEKLY (+1w), so both have an occurrence on any given day and exactly one
;; of them is wrong; this keeps only the set matching the computed teaching
;; week, and hides holidays, closed days, and the pre-cutoff part of a
;; partial day.
;;
;; The repeaters are deliberately +1w and not +2w. A fortnightly repeater
;; advances on CALENDAR weeks, so after an odd-length holiday it falls
;; permanently out of step with the teaching-week rotation and days render
;; empty (Mon 2027-02-22 was the first casualty). Keep the rotation in this
;; function, not in the repeaters.

(defvar date)  ; dynamically bound by org-agenda while scanning a day

(defun my/entry-start-minutes ()
  "Minutes past midnight of this entry's timestamp start time, or nil."
  (save-excursion
    (org-back-to-heading t)
    (let ((end (save-excursion
                 (if (outline-next-heading) (point) (point-max)))))
      (when (re-search-forward "\\([0-9][0-9]\\):\\([0-9][0-9]\\)" end t)
        (+ (* 60 (string-to-number (match-string 1)))
           (string-to-number (match-string 2)))))))

(defun my/partial-day-cutoff-minutes (abs)
  "Earliest allowed start time in minutes for ABS, or nil if not partial."
  (let (result)
    (dolist (pair my/school-partial-days result)
      (when (= abs (my/ymd-to-abs (car pair)))
        (let ((s (cdr pair)))
          (when (string-match "\\([0-9][0-9]\\):\\([0-9][0-9]\\)" s)
            (setq result (+ (* 60 (string-to-number (match-string 1 s)))
                            (string-to-number (match-string 2 s))))))))))

(defun my/timetable-skip ()
  "Agenda skip function for timetable.org entries.
Relies on `date' (a (MONTH DAY YEAR) list) bound by org-agenda while
scanning a day. Returns the next-heading position to skip an entry, or
nil to keep it. No-op outside timetable.org or when `date' is unbound."
  (when (and (buffer-file-name)
             (string-equal (file-name-nondirectory (buffer-file-name))
                           "timetable.org")
             (boundp 'date) date)
    (let* ((abs (calendar-absolute-from-gregorian
                 (list (nth 0 date) (nth 1 date) (nth 2 date))))
           (next (save-excursion
                   (if (outline-next-heading) (point) (point-max))))
           (tags (org-get-tags))
           (letter (my/week-for-abs abs))
           (cutoff (my/partial-day-cutoff-minutes abs)))
      (cond
       ((my/holiday-week-p abs) next)
       ((my/closed-day-p abs) next)
       ((and (member "weekA" tags) (not (string-equal letter "A"))) next)
       ((and (member "weekB" tags) (not (string-equal letter "B"))) next)
       ((and cutoff
             (let ((start (my/entry-start-minutes)))
               (and start (< start cutoff))))
        next)
       (t nil)))))

(provide 'timetable-config)
