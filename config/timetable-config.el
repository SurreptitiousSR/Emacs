;;; timetable-config.el --- Week A/B detection and timetable agenda -*- lexical-binding: t -*-

;; ============================================================
;; WEEK A/B DETECTION
;; ============================================================
;; Anchor: 2026-03-09 is a Week A Monday.
;; Any date an even number of weeks from this anchor is Week A.
(defvar my/week-a-anchor (encode-time 0 0 0 9 3 2026)
  "A known Week A Monday, used as reference for A/B calculation.")

(defun my/current-week ()
  "Return \"A\" or \"B\" for the current school week."
  (let* ((today (current-time))
         (days (/ (float-time (time-subtract today my/week-a-anchor)) 86400))
         (weeks (floor (/ days 7))))
    (if (= (mod weeks 2) 0) "A" "B")))

(defun my/week-for-date (date)
  "Return \"A\" or \"B\" for a given DATE (a time value)."
  (let* ((days (/ (float-time (time-subtract date my/week-a-anchor)) 86400))
         (weeks (floor (/ days 7))))
    (if (= (mod weeks 2) 0) "A" "B")))

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

;; Timetable agenda views ("t" and "w") are defined in init.el
;; alongside the other org-agenda-custom-commands.

(provide 'timetable-config)
