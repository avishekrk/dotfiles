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
    yaml-mode))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)


;; PYTHON CONFIGURATION
;; --------------------------------------

(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 4 120 4))


(add-hook 'python-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 4)
                    (setq-default python-indent 4)))

;;(add-hook 'python-mode-hook 'guess-style-guess-tabs-mode)
;;(add-hook 'python-mode-hook (lambda ()
;;                                 (guess-style-guess-tab-width)))

(elpy-enable)
(elpy-use-ipython)

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


;; init.el ends here
