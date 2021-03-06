;; My init.el
;;
;; ‘Installation’
;; - Make sure use-package is installed
;; - Then all packages will be downloaded and installed automatically

(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(width  . 110))
(add-to-list 'default-frame-alist '(height . 50))

(setq inhibit-startup-message t)

;; Confirm with simply ‘y’ or ‘n’ (instead of ‘yes’ or ‘no’).
(defalias 'yes-or-no-p 'y-or-n-p)

(setq history-length 1000)
(savehist-mode)

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

(setq sentence-end-double-space nil)
(setq-default fill-column 80)

(setq require-final-newline t)

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)

;; Sensible word-wrapping, like :set linebreak! in Vim.
;; (visual-line-mode)

(line-number-mode t)
(column-number-mode t)

;; (global-linum-mode)

(define-minor-mode sensitive-mode
  "Sensitive mode to prevent backups and auto-save in sensitive files.

See:
- ‘Disabling Backup and Auto-save in Emacs’, http://anirudhsasikumar.net/blog/2005.01.21.html
- http://stackoverflow.com/a/18330742"
  nil
  " Sensitive"
  nil
  (if (symbol-value sensitive-mode)
      (progn
        (set (make-local-variable 'backup-inhibited) t)
        (if auto-save-default
            (auto-save-mode -1)))
    (kill-local-variable 'backup-inhibited)
    (if auto-save-default
        (auto-save-mode 1))))

(setq auto-mode-alist
      (append '(("\\.gpg$" . sensitive-mode))
              auto-mode-alist))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'blackboard t)

(setq woman-fill-column 80)


;; Core plugins

(require 'saveplace)
(setq-default save-place t)

(require 'recentf)
(setq recentf-max-saved-items 100)
(recentf-mode t)

(require 'org)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-directory "~/org")
(setq org-agenda-files '("~/org"))
(setq org-default-notes-file (concat org-directory "/notes.org"))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; or instead, (define-key global-map "\C-ca" 'org-agenda), etc.?

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)


;; Packages

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; TODO May also auto-install it; now you have to package-install this:
(require 'use-package)
(setq use-package-always-ensure t)

;; TODO When to use :config, when :init?
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package clojure-mode
  :init
  (setq clojure-indent-style :align-arguments)
  :config
  (define-clojure-indent
    (s/fdef 1)
    (for-all 1)
    (dom/div 1)))

(use-package cider
  :init
  (setq cider-connection-message-fn nil)
  (setq cider-repl-pop-to-buffer-on-connect 'display-only)
  (setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))"))

(use-package clj-refactor
  :config
  (defun my-clojure-mode-hook ()
    (paredit-mode 1)
    (clj-refactor-mode 1)
    (yas-minor-mode 1))
  (add-hook 'clojure-mode-hook 'my-clojure-mode-hook))

(use-package markdown-mode)

(use-package ess)

(use-package adoc-mode
  :mode "\\.adoc\\'")

(use-package yaml-mode)

(use-package which-key
  :config
  (which-key-mode))

(use-package emojify
  :init
  (setq emojify-emoji-styles '(unicode))
  (add-hook 'after-init-hook 'global-emojify-mode))

;; (use-package org)

;; Suggestions:
;; (use-package company)  ; company-mode for auto-completion
;; Frequently used typographical marks.
;; TODO Perhaps use typo-mode in the future?
(global-set-key (kbd "<f5>") (kbd "‚"))
(global-set-key (kbd "S-<f5>") (kbd "„"))
(global-set-key (kbd "<f6>") (kbd "‘"))
(global-set-key (kbd "S-<f6>") (kbd "“"))
(global-set-key (kbd "<f7>") (kbd "’"))
(global-set-key (kbd "S-<f7>") (kbd "”"))
(global-set-key (kbd "<f8>") (kbd "…"))
(global-set-key (kbd "<f9>") (kbd "–"))
;; ... more generally, C-x 8 RET, then type Unicode name.

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(setq epg-gpg-program "gpg2")
