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
    projectile))

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
(global-display-line-numbers-mode 1) ;; enable line numbers globally
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
  (setq-default indent-tabs-mode nil)
  :config
  (setq python-indent-offset 4)
  (add-hook 'python-mode-hook 'smartparens-mode)
  (add-hook 'python-mode-hook 'color-identifiers-mode))

(elpy-enable)
(setq elpy-rpc-python-command "python3")
(setq elpy-rpc-backend "jedi")

(when (executable-find "ipython")
  (setq python-shell-interpreter "ipython"))

(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "--simple-prompt --pprint")

(require 'conda)
;; if you want interactive shell support, include:
(conda-env-initialize-interactive-shells)
;; if you want eshell support, include:
(conda-env-initialize-eshell)
;; if you want auto-activation (see below for details), include:
(conda-env-autoactivate-mode t)

(custom-set-variables
'(conda-anaconda-home "/Users/akumar67/miniconda3/"))




(use-package jedi
  :ensure t
  :init
  (add-to-list 'company-backends 'company-jedi)
  :config
  (use-package company-jedi
    :ensure t
    :init
    (add-hook 'python-mode-hook (lambda () (add-to-list 'company-backends 'company-jedi)))
    (setq company-jedi-python-bin "python")))


(use-package anaconda-mode
  :ensure t
  :init (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
  :config (use-package company-anaconda
            :ensure t
            :init (add-hook 'python-mode-hook 'anaconda-mode)
            (eval-after-load "company"
              '(add-to-list 'company-backends '(company-anaconda :with company-capf)))))




;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; NEOTREE
;; ------------------------------------------------------
(global-set-key (kbd "C-d") 'neotree)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))


;; RST
;; ------------------------------------------------------
(require 'rst)

;; LaTeX configuration
;; ------------------------------------------------------
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)

(setq TeX-output-view-style
    (quote
     (("^pdf$" "." "evince -f %o")
      ("^html?$" "." "iceweasel %o"))))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)


;; MISC STUFF
;; ------------------------------------------------------

(use-package all-the-icons
  :config
  (use-package all-the-icons-dired
    :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
    )
  )

(use-package pretty-mode
  :ensure t
  :config
  (global-pretty-mode t)

  (pretty-deactivate-groups
   '(:equality :ordering :ordering-double :ordering-triple
               :arrows :arrows-twoheaded :punctuation
               :logic :sets))

  (pretty-activate-groups
   '(:sub-and-superscripts :greek :arithmetic-nary :parentheses
                           :types :arrows-tails  :arrows-tails-double
                           :logic :sets :equality :ordering
                           :arrows :arrows-twoheaded ))
    )


(add-hook
 'prog-mode-hook
 (lambda ()
   (setq prettify-symbols-alist
         '(;; Syntax
           ("in" .       #x2208)
           ("not in" .   #x2209)
           ("not" .      #x2757)
           ("return" .   #x27fc)
           ("yield" .    #x27fb)
           ("for" .      #x2200)
           ("function" . ?λ)
           ("<>" . ?≠)
           ("!=" . ?≠)
           ("exists" . ?Ǝ)
           ("in" . ?∈)
           ("sum" . ?Ʃ)
           ("complex numbers" . ?ℂ)
           ("integer numbers" . ?ℤ)
           ("natural numbers" . ?ℕ)
           ;; Base Types
           ("int" .      #x2124)
           ("float" .    #x211d)
           ("str" .      #x1d54a)
           ("True" .     #x1d54b)
           ("False" .    #x1d53d)
           ;; python
           ("Dict" .     #x1d507)
           ("List" .     #x2112)
           ("Tuple" .    #x2a02)
           ("Set" .      #x2126)
           ("Iterable" . #x1d50a)
           ("Any" .      #x2754)
           ("Union" .    #x22c3)))))
(global-prettify-symbols-mode t)

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



;; SQL
;; ---------------------------------------------------------
(add-to-list 'same-window-buffer-names "*SQL*")
(setq sql-postgres-login-params
      '((user :default "postgres")
        (database :default "postgres")
        (server :default "localhost")
        (port :default 5432)))

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (setq sql-prompt-regexp "^[_[:alpha:]]*[=][#>] ")
            (setq sql-prompt-cont-regexp "^[_[:alpha:]]*[-][#>] ")
            (toggle-truncate-lines t)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-anaconda company-jedi jedi yaml-mode use-package unicode-fonts try soothe-theme py-autopep8 pretty-mode origami neotree multiple-cursors material-theme magit json-mode ivy-hydra format-sql flycheck elpy ein doom-modeline dired-icon counsel-projectile centaur-tabs bicycle better-defaults bash-completion badwolf-theme avy anaconda-mode all-the-icons-ivy all-the-icons-dired aggressive-indent)))
 '(python-shell-interpreter "ipython"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; projectile for managing projects
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
