(global-linum-mode 1)
(global-hl-line-mode 1)

(tool-bar-mode -1)

(setq inhibit-startup-message t)

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

(setq sentence-end-double-space nil)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(require 'org)
(setq org-log-done t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
; or instead, (define-key global-map "\C-ca" 'org-agenda), etc.?

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)
