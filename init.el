;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

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
    dired-icon))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------
(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e4446")
(set-face-foreground 'highlight nil)

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'badwolf t)
;;(load-theme 'soothe t) ;; load material theme
;;(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

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

(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 4 120 4))


(add-hook 'python-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 4)
                    (setq-default python-indent 4)))


(elpy-enable)
(elpy-use-ipython)

(setq python-shell-interpreter "ipython3" python-shell-interpreter-args "--simple-prompt --pprint")
:+1: 2


;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(global-set-key (kbd "C-n") 'neotree)

;; code folding
(require 'origami)
(global-origami-mode)
(global-set-key (kbd "C-f") 'origami-recursively-toggle-node)

(require 'rst)



;; init.el ends here
