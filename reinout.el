;; Reinout-specific customizations to the base starter kit.

;; faster syntax highlighting
(setq jit-lock-stealth-time 0.01)

;; Get dired to consider .pyc and .pyo files to be uninteresting
(add-hook 'dired-load-hook
    (lambda ()
      (load "dired-x")
     ))
(add-hook 'dired-mode-hook
    (lambda ()
      (setq dired-omit-files-p t)
      (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
     ))
(load "dired")
(setq dired-omit-extensions (append '(".pyc" ".pyo" ".bak")
				    dired-omit-extensions))

;; Zap trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Alt-arrow navigation between emacs windows.
(windmove-default-keybindings 'meta)

;; PO mode stuff.
(autoload 'po-mode "po-mode")
(add-to-list 'auto-mode-alist '("\\.po$" . po-mode))

;; Reset js/json to use the simpler and nicer javascript-mode
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . javascript-mode))
;; And .less is really .css.
(add-to-list 'auto-mode-alist '("\\.less\\'" . css-mode))

;; PML
(add-to-list 'auto-mode-alist '("\\.pml$" . nxml-mode))

;; Python mode stuff
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))

;; Enable pyflakes and flymake
;; http://www.plope.com/Members/chrism/flymake-mode
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))

(add-hook 'find-file-hook 'flymake-find-file-hook)

;; Enable the locally-downloaded doctest-mode.el
(autoload 'doctest-mode "doctest-mode" "doctest mode" t)

;; Override starter-kit's ctrl-x TAB override back.
(global-set-key (kbd "C-x C-i") 'indent-rigidly)

(define-prefix-command 'reinout-bindings-keymap)
(define-key reinout-bindings-keymap (vector ?f) 'auto-fill-mode)
(define-key reinout-bindings-keymap (vector ?j) 'jslint-thisfile)
(define-key reinout-bindings-keymap (vector ?s) 'sort-lines)
(global-set-key [(f5)] 'reinout-bindings-keymap)

;; javascript lint
(defun jslint-thisfile ()
  (interactive)
  (compile (format "jslint %s" (buffer-file-name))))
(add-hook 'javascript-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-w") 'jslint-thisfile)))

;; http://koansys.com/tech/emacs-hangs-on-flymake-under-os-x
(setq flymake-gui-warnings-enabled nil)
;; Start emacs as a server so that clients can connect.
(server-start)
