(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     '("org" . "https://orgmode.org/elpa/") ;; This repo assures the latest version of org-mode
	     )
(package-initialize)

; MELPA packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

(unless (package-installed-p 'doom-themes)
  (package-refresh-contents)
  (package-install 'doom-themes))

; Actual configuration in org mode
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   '(pdf-tools magit evil-nerd-commenter gdscript-mode dap-mode pyvenv lsp-python-ms lsp-ui lsp-mode haskell-mode yasnippet-snippets auctex yasnippet evil-collection evil popup-kill-ring doom-modeline company-box company counsel-projectile projectile dashboard sudo-edit rainbow-delimiters rainbow-mode avy helpful ivy-rich counsel ivy org-bullets beacon which-key undo-tree dired-single doom-themes use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
