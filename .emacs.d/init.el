(global-linum-mode 1)
(global-hl-line-mode 1)

(tool-bar-mode -1)

(setq inhibit-startup-message t)

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

(setq sentence-end-double-space nil)
(setq-default fill-column 80)

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
;; TODO or: (set-default 'indent-tabs-mode nil) ?

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

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

;; Need this on OS X only
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(require 'saveplace)
(setq-default save-place t)

(require 'org)
(setq org-log-done t)
(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; or instead, (define-key global-map "\C-ca" 'org-agenda), etc.?

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(setq epg-gpg-program "gpg2")
