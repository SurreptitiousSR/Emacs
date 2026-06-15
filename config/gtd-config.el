;;; gtd-config.el --- Refile, archive, and GTD review config -*- lexical-binding: t -*-

(with-eval-after-load 'org
  ;; Archive DONE into archive/<file>_archive.org, outside agenda scope.
  (setq org-archive-location
        (concat my/org-directory "archive/%s_archive.org::"))

  ;; Refile from inbox into any active agenda file, or someday.org.
  (setq org-refile-targets
        `((org-agenda-files :maxlevel . 3)
          ((,(my/org-file "someday.org")) :maxlevel . 2)))
  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

  ;; Weekly-review "stuck" detection is opt-in: tag a multi-step item :project:.
  (setq org-stuck-projects
        '("+project/-DONE" ("TODO" "IN-PROGRESS") nil "")))

(provide 'gtd-config)
