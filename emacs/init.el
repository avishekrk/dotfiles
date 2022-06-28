;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

;; Disbale guru-mode
(setq prelude-guru nil)
(setq prelude-whitespace nil)

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8
    markdown-mode
    origami
    neotree
    yaml-mode
    bash-completion
    soothe-theme
    badwolf-theme
    format-sql
    rst
    magit
    dired-icon
    unicode-fonts
    all-the-icons-dired
    doom-modeline
    json-mode
    anaconda-mode
    company
    color-identifiers-mode
    use-package
    smartparens
    conda
    projectile
    centaur-tabs))

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


;; FONTS
;; -------------------------------------------------------------------
(require 'unicode-fonts)
(unicode-fonts-setup)


;; BASIC CUSTOMIZATION
;; -------------------------------------------------------------------
(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'badwolf t)
;;(global-display-line-numbers-mode 1) ;; enable line numbers globally
(add-hook 'after-init-hook 'global-company-mode)
(setq initial-scratch-message "")
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq-default tab-always-indent 'complete)
(require 'smartparens-config)



(when (window-system)
  (tool-bar-mode 0)               ;; Toolbars were only cool with XEmacs
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1))
  (scroll-bar-mode -1))            ;; Scrollbars are waste screen estate


;; WINDOW MANAGEMENT
;; --------------------------------------------------
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)


;; BASH COMPLETION
;; --------------------------------------------------
(autoload 'bash-completion-dynamic-complete
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)

;; PYTHON CONFIGURATION
;; --------------------------------------

(use-package python
  :mode ("\\.py\\'" . python-mode)
  ("\\.wsgi$" . python-mode)
  :interpreter ("python" . python-mode)

  :init
  (setq-default indent-tabs-mode nil
                python-shell-interpreter-args "-m IPython --simple-prompt -i")  
  :custom
  (python-indent-offset 4)
  (python-indent-guess-indent-offset nil)
  (python-indent-guess-indent-offset-verbose nil)
  :hook
  (python-mode-hook . smartparens-mode)
  )


(use-package jedi
  :disabled t
                                        ;ensure t
  :init
  (add-to-list 'company-backends 'company-jedi)
  :config
  (use-package company-jedi
    :disabled t
                                        ;ensure t
    :init
    (add-hook 'python-mode-hook (lambda () (add-to-list 'company-backends 'company-jedi)))
    (setq company-jedi-python-bin "python")))

(setq jedi:complete-on-dot t) 
(add-hook 'python-mode-hook 'jedi:setup)

(use-package pytest
  :commands (pytest-one
             pytest-pdb-one
             pytest-all
             pytest-pdb-all
             pytest-module
             pytest-pdb-module)
  :config (add-to-list 'pytest-project-root-files "setup.cfg")
  (setq pytest-cmd-flags  "-v")
  :bind (:map python-mode-map
              ("C-c a" . pytest-all)
              ("C-c m" . pytest-module)
              ("C-c ." . pytest-one)
              ("C-c d" . pytest-directory)))

(use-package blacken
  :after python
  :demand t
  :commands blacken-buffer
  :bind (:map python-mode-map
              ("C-c =" . blacken-buffer)))


(use-package anaconda-mode
  :ensure t
  :init (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
  :config (use-package company-anaconda
            :ensure t
            :init (add-hook 'python-mode-hook 'anaconda-mode)
            (eval-after-load "company"
              '(add-to-list 'company-backends '(company-anaconda :with company-capf)))))



;; NEOTREE
;; ------------------------------------------------------
(global-set-key (kbd "C-d") 'neotree)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-window-fixed-size nil)

;; RST
;; ------------------------------------------------------
(require 'rst)

;; MISC STUFF
;; ------------------------------------------------------

(use-package all-the-icons
  :config
  (use-package all-the-icons-dired
    :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
    )
  )

(use-package avy
  :ensure t
  :commands avy-goto-word-1 avy-goto-char-1 avy-goto-line avy-goto-char-timer
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char)
         ("C-l"     . avy-goto-word-1))
  )

;; Aggressive-fill
(use-package aggressive-fill-paragraph
  :ensure t
  :disabled
  :config
  (afp-setup-recommended-hooks)
  ;; to enable the minor mode in all places where it might be useful. Alternatively use
  ;;(add-hook '[major-mode-hook] #'aggressive-fill-paragraph-mode)
  )

;; Aggressive-indent
(use-package aggressive-indent
  :ensure t
  :config
  ;; (global-aggressive-indent-mode 1)
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
  (add-hook 'ruby-mode-hook #'aggressive-indent-mode)
  (add-hook 'css-mode-hook #'aggressive-indent-mode)
  )


;; Edición de múltiples líneas
(use-package multiple-cursors
  :diminish multiple-cursors-mode
  :defer t
  :init
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  )

;; it looks like counsel is a requirement for swiper
(use-package counsel
  :ensure t
  )

(use-package swiper
  :init (ivy-mode 1)
  :ensure try
  :bind (
         ("C-s" . swiper)
         ("C-r" . swiper)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)
         ("C-c h m" . woman)
         ("C-x b" . ivy-switch-buffer)
         ("C-c u" . swiper-all)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> l" . counsel-load-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate)
         ("C-S-o" . counsel-rhythmbox)
         )
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d ")
  (setq projectile-completion-system 'ivy)                   ;; Habilitamos ivy en projectile
  (setq magit-completing-read-function 'ivy-completing-read) ;; Habilitamos ivy en magit

  ;; Tomado de scimax
  (ivy-set-actions
   t
   '(("i" (lambda (x) (with-ivy-window
                   (insert x))) "insert candidate")
     (" " (lambda (x) (ivy-resume)) "resume")
     ("?" (lambda (x)
            (interactive)
            (describe-keymap ivy-minibuffer-map)) "Describe keys")))

  ;; ** Acciones para counsel-find-file
  ;; Tomado de scimax
  (ivy-add-actions
   'counsel-find-file
   '(("a" (lambda (x)
            (unless (memq major-mode '(mu4e-compose-mode message-mode))
              (compose-mail))
            (mml-attach-file x)) "Attach to email")
     ("c" (lambda (x) (kill-new (f-relative x))) "Copy relative path")
     ("4" (lambda (x) (find-file-other-window x)) "Open in new window")
     ("5" (lambda (x) (find-file-other-frame x)) "Open in new frame")
     ("C" (lambda (x) (kill-new x)) "Copy absolute path")
     ("d" (lambda (x) (dired x)) "Open in dired")
     ("D" (lambda (x) (delete-file x)) "Delete file")
     ("e" (lambda (x) (shell-command (format "open %s" x)))
      "Open in external program")
     ("f" (lambda (x)
            "Open X in another frame."
            (find-file-other-frame x))
      "Open in new frame")
     ("p" (lambda (path)
            (with-ivy-window
              (insert (f-relative path))))
      "Insert relative path")
     ("P" (lambda (path)
            (with-ivy-window
              (insert path)))
      "Insert absolute path")
     ("l" (lambda (path)
            "Insert org-link with relative path"
            (with-ivy-window
              (insert (format "[[./%s]]" (f-relative path)))))
      "Insert org-link (rel. path)")
     ("L" (lambda (path)
            "Insert org-link with absolute path"
            (with-ivy-window
              (insert (format "[[%s]]" path))))
      "Insert org-link (abs. path)")
     ("r" (lambda (path)
            (rename-file path (read-string "New name: ")))
      "Rename")))
  )

(use-package ivy-hydra
  :ensure t
  )

(use-package counsel-projectile
  :ensure t
  :after counsel
  :config
  ;;  (counsel-projectile-on)
  )


(require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-bar-width 16)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))



(use-package all-the-icons-ivy
  :ensure t
  :config
  (all-the-icons-ivy-setup))

(setq mac-shift-modifier 'meta)
;;(customize-set-variable 'mac-command-modifier 'meta)
;;(customize-set-variable 'mac-option-modifier 'alt)
;;(customize-set-variable 'mac-right-option-modifier 'super)

(use-package bicycle
  :after outline
  :bind (:map outline-minor-mode-map
              ([C-tab] . bicycle-cycle)
              ([S-tab] . bicycle-cycle-global)))

(use-package prog-mode
  :ensure nil
  :config
  (add-hook 'prog-mode-hook 'outline-minor-mode)
  (add-hook 'prog-mode-hook 'hs-minor-mode))


(use-package centaur-tabs
  :demand
  :config
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-height 30)
  (setq centaur-tabs-modified-marker "●")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-set-bar 'over)
  (setq centaur-tabs-set-modified-marker t)
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t)
  :bind
  ("M-q" . centaur-tabs-backward)
  ("M-a" . centaur-tabs-forward))

;;Custom Shortcuts
(defun connect-remote ()
  (interactive)
  (dired "/user@192.168.1.5:/"))


(eval-after-load "flyspell"
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-jedi jedi blacken yaml-mode use-package unicode-fonts try soothe-theme smartparens py-autopep8 origami neotree material-theme markdown-mode magit json-mode ivy-hydra format-sql flycheck elpy ein doom-modeline dired-icon counsel-projectile conda company-anaconda color-identifiers-mode centaur-tabs better-defaults bash-completion badwolf-theme avy all-the-icons-ivy all-the-icons-dired aggressive-indent)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
