;; include other file

;; Red Hat Linux default .emacs initialization file  ; -*- mode: emacs-lisp -*-

(defvar autosave-dir
  (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; turn on font-lock mode
;;(global-font-lock-mode t)
;; enable visual feedback on selections
;;(setq-default transient-mark-mode t)

;; always end a file with a newline
;;(setq require-final-newline t)

;; stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; use extended compound-text coding for X clipboard
  (set-selection-coding-system 'compound-text-with-extensions))

;; display time
;;(display-time)

(global-font-lock-mode t)
;(setq indent-tabs-mode nil)
(setq indent-tabs-mode t)

;; No beeping
(setq visible-bell t)

;; No cursor blink
(setq visible-cursor nil)

;; Put column number into modeline
;; (column-number-mode 1)

;; tab = 4 spaces
;;(setq-default tab-width 8)
;;(setq c-basic-indent 2)
;;(setq tab-width 8)

;;(defun my-c-indent-setup ()
;;  (c-set-style "bsd")
;;  (define-key c-mode-map "\C-m" 'newline-and-indent)
;;  (setq indent-tabs-mode nil)
;;  (setq c-basic-offset 2)
;;  (setq c-basic-indent 2))

;;(defun my-c++-indent-setup ()
;;  (c-set-style "bsd")
;;  (define-key c++-mode-map "\C-m" 'newline-and-indent)
;;  (setq indent-tabs-mode nil)
;;  (setq c-basic-offset 2)
;;  (setq c-basic-indent 2)
;;  (c-set-offset 'innamespace 0))

;;(add-hook 'c++-mode-hook 'my-c++-indent-setup)
;;(add-hook 'c-mode-hook 'my-c-indent-setup)

(global-set-key "\C-xg" 'goto-line)
(global-set-key "\C-x8" 'compile)

;; fix backspace problems
(global-set-key "\C-h" 'delete-backward-char)

(blink-cursor-mode 0)

;; no more startup message (splash screen)
(setq inhibit-startup-message t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(adwaita-white))
 '(custom-safe-themes
   '("7c6e42ea2b275325cf7f01c4c80cdc5913e43ff8a84c9a8cc28844862f73e68c" "ff95aefa5809f7206152912009321c8697e71600964dcd6f0191bae221f98a08" default)))

;; bar cursor

(setq initial-frame-alist
 (cons '(cursor-type . bar) 
           (copy-alist initial-frame-alist)
  )
)
(setq default-frame-alist 
  (cons '(cursor-type . bar)
            (copy-alist default-frame-alist)
   )
)

(load-file "~/dotfiles/elisp/google-c-style.el")

(add-to-list 'load-path
              "~/.emacs.d/plugins/dtrt-indent")
(require 'dtrt-indent)
(dtrt-indent-mode 1)

(global-set-key "\C-j" 'dabbrev-expand)
;; don't let python-mode take over C-j:
(add-hook 'python-mode-hook (lambda () (local-unset-key (kbd "C-j"))))

(global-set-key "\C-z" 'undo)
(global-set-key (kbd "C-_") 'comment-or-uncomment-region)

(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 1)))

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(yas-global-mode 1)

;; Auto indent pasted code

(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
	   (and (not current-prefix-arg)
		(member major-mode '(emacs-lisp-mode lisp-mode
						     clojure-mode    scheme-mode
						     haskell-mode    ruby-mode
						     rspec-mode      python-mode
						     c-mode          c++-mode
						     objc-mode       latex-mode
						     plain-tex-mode))
		(let ((mark-even-if-inactive transient-mark-mode))
		  (indent-region (region-beginning) (region-end) nil))))))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(setq-default indent-tabs-mode nil)  ;; Only indent with spaces
(setq sentence-end-double-space nil)  ;; one space after periods
