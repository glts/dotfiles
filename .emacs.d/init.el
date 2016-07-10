(global-linum-mode 1)
(global-hl-line-mode 1)

(tool-bar-mode -1)

(setq inhibit-startup-message t)

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)
