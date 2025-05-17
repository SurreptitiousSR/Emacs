;; Elpaca Package Manager
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Setup use-package
(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))
      
;;Evil mode
(use-package evil
   :ensure t
   :init
   (setq evil-want-keybinding nil)
   (setq evil-vsplit-window-right t)
   (evil-mode))

(use-package evil-collection
   :ensure t
   :after evil
   :config
   (setq evil-collection-mode-list '(dashboard dired ibuffer))
   (evil-collection-init))

;; Ivy - Generic completion
(use-package ivy
  :ensure t
  :config
  (ivy-mode)
  (setopt ivy-use-virtual-buffers t)
  (setopt enable-recursive-minibuffers t)
  (keymap-global-set "C-s" #'swiper-isearch)
  (keymap-global-set "C-c C-r" #'ivy-resume)
  (keymap-global-set "<f6>" #'ivy-resume)
  (keymap-global-set "M-x" #'counsel-M-x)
  (keymap-global-set "C-x C-f" #'counsel-find-file)
  (keymap-global-set "<f1> f" #'counsel-describe-function)
  (keymap-global-set "<f1> v" #'counsel-describe-variable)
  (keymap-global-set "<f1> o" #'counsel-describe-symbol)
  (keymap-global-set "<f1> l" #'counsel-find-library)
  (keymap-global-set "<f2> i" #'counsel-info-lookup-symbol)
  (keymap-global-set "<f2> u" #'counsel-unicode-char)
  (keymap-global-set "C-c g" #'counsel-git)
  (keymap-global-set "C-c j" #'counsel-git-grep)
  (keymap-global-set "C-c k" #'counsel-ag)
  (keymap-global-set "C-x l" #'counsel-locate)
  (keymap-global-set "C-S-o" #'counsel-rhythmbox)
  (keymap-set minibuffer-local-map "C-r" #'counsel-minibuffer-history))

(use-package ivy-rich
  :ensure t
  :after
  ivy
  counsel
  :config
  (ivy-rich-mode 1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))
  

;; Make sure counsel is loaded after ivy
(elpaca-wait)

(use-package counsel
  :ensure t
  :after ivy
  :config
  (counsel-mode 1))


;; All the icons - prettier icons in the minibuffer
(use-package all-the-icons
  :if (display-graphic-p))

;; Add all-the-icons to Dired
(use-package all-the-icons-dired
  :hook (dired-mode . (lambda ()
  (all-the-icons-dired-mode t))))

;; Flycheck - syntax checking on the fly
(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init
  (global-flycheck-mode))

;; Turn on which-key - gives more information about keymaps
(which-key-mode 1)

;; UI adjustments
(use-package exotica-theme
  :ensure t
  :load-path "themes"
  :init
  (setq exotica-theme t)
  :config
  (load-theme 'exotica t))

;; (use-package zenburn-theme
;;   :ensure t
;;   :load-path "themes"
;;   :config
;;   (load-theme 'zenburn t))

;; (use-package solarized-theme
;;   :ensure t
;;   :load-path "themes"
;;   :config
;;   (load-theme 'solarized t)

;; Remove menu-bar / scroll-bar / tool-bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Start Emacs fullscreen
(add-to-list 'default-frame-alist '(fullscreen . fullboth))

;; Display line numbers
(global-display-line-numbers-mode 1)

;; Orgmode bullets
(use-package org-bullets
  :ensure t
  :init
  (org-bullets-mode))
