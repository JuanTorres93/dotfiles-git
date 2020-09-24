; No splash screen
(setq inhibit-splash-screen t)

; Disable menu bar, tool bar and scroll bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

; Enable line numbers and relative numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)





; ========== MELPA-RELATED ==========
; Enable MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

; ***doom-themes***
;(use-package doom-themes
;  :config
;  ;; Global settings (defaults)
;  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-nord t)

;  ;; Enable flashing mode-line on errors
;  (doom-themes-visual-bell-config)
;  
;  ;; Enable custom neotree theme (all-the-icons must be installed!)
;  (doom-themes-neotree-config)
;  ;; or for treemacs users
;  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
;  (doom-themes-treemacs-config)
;  
;  ;; Corrects (and improves) org-mode's native fontification.
;  (doom-themes-org-config))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   '(((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "PDF Tools")
     (output-html "xdg-open")))
 '(package-selected-packages '(pdf-tools auctex rust-mode evil doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


; ***evil***
(require 'evil)
  (evil-mode 1)

; ***rust-mode***
(require 'rust-mode)

; ***auctex***
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

