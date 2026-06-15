;;; timetable-config.el --- Week A/B detection and timetable agenda -*- lexical-binding: t -*-

;; ============================================================
;; WEEK A/B DETECTION
;; ============================================================
;; Anchor: 2026-03-09 is a Week A Monday.
;; Any date an even number of weeks from this anchor is Week A.
(defvar my/week-a-anchor (encode-time 0 0 0 9 3 2026)
  "A known Week A Monday, used as reference for A/B calculation.")

;; The May 2026 half-term (Mon 2026-05-25) paused the A/B rotation, shifting
;; it one week out of phase. From this cutoff onward the parity flips and the
;; `:shifted:'-tagged timetable subtrees apply instead of the originals.
(defvar my/timetable-shift-cutoff (encode-time 0 0 0 8 6 2026)
  "First day the post-half-term (`:shifted:') timetable applies (Mon 2026-06-08).")

(defvar my/school-holiday-weeks '((2026 5 25))
  "List of (YEAR MONTH DAY) Mondays whose whole week has no timetable.
Add a break's Monday here when an odd-length holiday pauses the A/B rotation.")

(defun my/date-on-or-after-cutoff-p (date)
  "Non-nil if time value DATE is on or after `my/timetable-shift-cutoff'."
  (not (time-less-p date my/timetable-shift-cutoff)))

(defun my/in-holiday-week-p (m d y)
  "Non-nil if calendar date M D Y falls within a `my/school-holiday-weeks' week."
  (let ((this (encode-time 0 0 0 d m y)))
    (seq-some
     (lambda (mon)
       (let* ((start (encode-time 0 0 0 (nth 2 mon) (nth 1 mon) (nth 0 mon)))
              (end (time-add start (days-to-time 7))))
         (and (not (time-less-p this start))
              (time-less-p this end))))
     my/school-holiday-weeks)))

(defun my/week-for-date (date)
  "Return \"A\" or \"B\" for a given DATE (a time value).
Dates on/after `my/timetable-shift-cutoff' have their parity flipped to
account for the half-term pause in the rotation."
  ;; Use whole-day counts (time-to-days), not float seconds: a DST changeover
  ;; between anchor and date otherwise shaves an hour off and flips parity.
  (let* ((days (- (time-to-days date) (time-to-days my/week-a-anchor)))
         (weeks (/ days 7))
         (parity (mod weeks 2))
         (parity (if (my/date-on-or-after-cutoff-p date) (- 1 parity) parity)))
    (if (= parity 0) "A" "B")))

(defun my/current-week ()
  "Return \"A\" or \"B\" for the current school week."
  (my/week-for-date (current-time)))

;; ============================================================
;; MODELINE WEEK INDICATOR
;; ============================================================
(defvar my/week-indicator "")

(defun my/update-week-indicator ()
  "Update the modeline week indicator."
  (setq my/week-indicator (format " [Wk %s]" (my/current-week))))

;; Update on startup and every hour
(my/update-week-indicator)
(run-at-time "00:00" 3600 #'my/update-week-indicator)

;; Add to modeline
(unless (member '(:eval my/week-indicator) mode-line-misc-info)
  (push '(:eval my/week-indicator) mode-line-misc-info))

;; ============================================================
;; AGENDA SKIP: hide the misaligned A/B timetable set
;; ============================================================
;; timetable.org keeps two overlapping fortnightly sets: the original
;; "* Week A"/"* Week B" subtrees (correct through 2026-05-18) and the
;; "* Week A/B (post-half-term)" subtrees tagged :shifted: (correct from the
;; cutoff onward). Both have endless +2w repeaters, so without this skip both
;; fire on the same day. For each agenda day we keep only the valid set:
;; originals before the cutoff, shifted entries on/after it. Whole holiday
;; weeks are hidden entirely. History stays in the file and still renders for
;; past dates.

(defvar date)  ; dynamically bound by org-agenda while scanning a day

(defun my/timetable-skip ()
  "Agenda skip function for timetable.org entries.
Relies on `date' (a (month day year) list) bound by org-agenda while
scanning a day. Returns the next-heading position to skip an entry, or
nil to keep it. No-op outside timetable.org or when `date' is unbound
\(e.g. todo/tags searches)."
  (when (and (buffer-file-name)
             (string-equal (file-name-nondirectory (buffer-file-name))
                           "timetable.org")
             (boundp 'date) date)
    (let* ((m (nth 0 date)) (d (nth 1 date)) (y (nth 2 date))
           (disp (encode-time 0 0 0 d m y))
           (shifted (member "shifted" (org-get-tags)))
           (next (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((my/in-holiday-week-p m d y) next)
       ((my/date-on-or-after-cutoff-p disp) (unless shifted next))
       (t (when shifted next))))))

;; Timetable agenda views ("t" and "w") are defined in init.el
;; alongside the other org-agenda-custom-commands.

(provide 'timetable-config)
