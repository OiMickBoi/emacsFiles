;; ;; You will most likely need to adjust this font size for your system!
;; (defvar /default-font-size 180)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)          ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)
(require 'use-package)

(use-package modus-themes
  :config
  (load-theme 'modus-vivendi))

;;(require 'zen-mode)
 ;; (global-set-key (kbd "C-M-z"))

(use-package undo-fu)
(setq tramp-verbose 6)
;; ===================================================================
;; Package Manager
;; ===================================================================
;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))


(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ===================================================================
;; Comfort Configs
;; ===================================================================
(use-package evil
  :hook (after-init . evil-mode)
  :custom
  ;; use emacs bindings in insert-mode
  (evil-disable-insert-state-bindings t)
  (evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

(setq evil-insert-state-cursor 'box)
;; (evil-set-initial-state 'dired-mode 'emacs)

;; (use-package god-mode
;;   :custom
;;   (setq god-exempt-major-modes nil) 
;;   (setq god-exempt-predicates nil)
;;   :config
;;   (god-mode))

;; Line Numbers
(column-number-mode)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
		pdf-view-mode-hook
		vterm-mode-hook
		vterm-toggle-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map

         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package which-key 
 :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package ace-window
:ensure t
:init
(progn
(global-set-key [remap other-window] 'ace-window)
(custom-set-faces
'(aw-leading-char-face
((t (:inherit ace-jump-face-foreground :height 3.0)))))
))
;; ===================================================================
;; Development
;; ===================================================================
;; == irony-mode ==
(use-package irony
  :ensure t
  :defer t
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  :config
  ;; replace the `completion-at-point' and `complete-symbol' bindings in
  ;; irony-mode's buffers by irony-mode's function
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  )

;; == company-mode ==
(use-package company
  :ensure t
  :defer t
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-irony :ensure t :defer t)
  (setq company-idle-delay              nil
	company-minimum-prefix-length   2
	company-show-numbers            t
	company-tooltip-limit           20
	company-dabbrev-downcase        nil
	company-backends                '((company-irony company-gtags))
	)
  :bind ("C-;" . company-complete-common)
  )

;; == vterm  ==
;; (define-key vterm-mode-map (kbd "<C-backspace>")
;;   (lambda () (interactive) (vterm-send-key (kbd "C-w"))))

(global-set-key [f2] 'vterm-toggle)
(global-set-key [C-f2] 'vterm-toggle-cd)

;; you can cd to the directory where your previous buffer file exists
;; after you have toggle to the vterm buffer with `vterm-toggle'.
;; (define-key vterm-mode-map [(control return)]   #'vterm-toggle-insert-cd)

;; ;Switch to next vterm buffer
;; (define-key vterm-mode-map (kbd "s-n")   'vterm-toggle-forward)
;; ;Switch to previous vterm buffer
;; (define-key vterm-mode-map (kbd "s-p")   'vterm-toggle-backward)


;; ===================================================================
;; Keybinds
;; ===================================================================
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; evil and god mode
(global-set-key (kbd "C-S-c C-c") 'god-mode)
(global-set-key (kbd "C-c e") 'evil-mode)

;; eval-buffer
(global-set-key (kbd "C-c C-c") 'eval-buffer)

;; multple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

;; compile
(global-set-key [f5] 'compile)

;; God-mode Keybinds
;; (define-key god-local-mode-map (kbd "i") #'god-local-mode)
;; (define-key god-local-mode-map (kbd ".") #'repeat)
;; (global-set-key (kbd "C-x C-1") #'delete-other-windows)
;; (global-set-key (kbd "C-x C-2") #'split-window-below)
;; (global-set-key (kbd "C-x C-3") #'split-window-right)
;; (global-set-key (kbd "C-x C-0") #'delete-window)
;; (define-key god-local-mode-map (kbd "[") #'backward-paragraph)
;; (define-key god-local-mode-map (kbd "]") #'forward-paragraph)

;; Evil mode Bindings
(require 'evil-leader)
(evil-leader/set-leader "<Space>")
(global-evil-leader-mode)
(evil-leader/set-key
  "e" 'find-file
  "b" 'switch-to-buffer
  "k" 'kill-buffer)
;; ===================================================================
;; Registers
;; ===================================================================
;; To view registers use:
(set-register ?e (cons 'file "~/.emacs.d/init.el"))
;; (set-register ?n (cons 'file "/su:root@nixos:/etc/nixos/configuration.nix"))
;; (set-register ?D (cons 'file "~/.config/dwm/config.h"))
;; (set-register ?b (cons 'file "~/.local/share/snippets"))
(set-register ?c (cons 'file "~/Code"))
(set-register ?d (cons 'file "~/Documents"))
(set-register ?b (cons 'file "~/.bashrc"))
(set-register ?o (cons 'file "~/Documents/emacs.org"))
(set-register ?j (cons 'file "~/Journals/Journal.org"))
(set-register ?l (cons 'file "~/Documents/links.org"))
(set-register ?L (cons 'file "~/Documents/Latin/LatinProgress.org"))
(set-register ?x (cons 'file "~/.xmonad/xmonad.hs"))
;; ===================================================================
;; Flash Card system
;; ===================================================================

(add-to-list 'load-path "~/elisp/org-mode/contrib/lisp/")
(use-package org-drill
  :config (progn
	    (add-to-list 'org-modules 'org-drill)
	    (setq org-drill-add-random-noise-to-intervals-p t)
	    (setq org-drill-hint-separator "||")
	    (setq org-drill-left-cloze-delimiter "<[")
	    (setq org-drill-right-cloze-delimiter "]>")
	    (setq org-drill-learn-fraction 0.25)))

;; ===================================================================
;; pdfs
;; ===================================================================
 (use-package pdf-tools
   :defer t
   :config
       (pdf-tools-install)
       (setq-default pdf-view-display-size 'fit-page)
   :bind (:map pdf-view-mode-map
         ("\\" . hydra-pdftools/body)
         ("<s-spc>" .  pdf-view-scroll-down-or-next-page)
         ("g"  . pdf-view-first-page)
         ("G"  . pdf-view-last-page)
         ("l"  . image-forward-hscroll)
         ("h"  . image-backward-hscroll)
         ("j"  . pdf-view-next-page)
         ("k"  . pdf-view-previous-page)
         ("e"  . pdf-view-goto-page)
         ("u"  . pdf-view-revert-buffer)
         ("al" . pdf-annot-list-annotations)
         ("ad" . pdf-annot-delete)
         ("aa" . pdf-annot-attachment-dired)
         ("am" . pdf-annot-add-markup-annotation)
         ("at" . pdf-annot-add-text-annotation)
         ("y"  . pdf-view-kill-ring-save)
         ("i"  . pdf-misc-display-metadata)
         ("s"  . pdf-occur)
         ("b"  . pdf-view-set-slice-from-bounding-box)
         ("r"  . pdf-view-reset-slice)))

   ;; (use-package org-pdfview
   ;;     :config 
   ;;             (add-to-list 'org-file-apps
   ;;             '("\\.pdf\\'" . (lambda (file link)
   ;;             (org-pdfview-open link)))))

;; (defhydra hydra-pdftools (:color blue :hint nil)
;;         "
;;                                                                       ╭───────────┐
;;        Move  History   Scale/Fit     Annotations  Search/Link    Do   │ PDF Tools │
;;    ╭──────────────────────────────────────────────────────────────────┴───────────╯
;;          ^^_g_^^      _B_    ^↧^    _+_    ^ ^     [_al_] list    [_s_] search    [_u_] revert buffer
;;          ^^^↑^^^      ^↑^    _H_    ^↑^  ↦ _W_ ↤   [_am_] markup  [_o_] outline   [_i_] info
;;          ^^_p_^^      ^ ^    ^↥^    _0_    ^ ^     [_at_] text    [_F_] link      [_d_] dark mode
;;          ^^^↑^^^      ^↓^  ╭─^─^─┐  ^↓^  ╭─^ ^─┐   [_ad_] delete  [_f_] search link
;;     _h_ ←pag_e_→ _l_  _N_  │ _P_ │  _-_    _b_     [_aa_] dired
;;          ^^^↓^^^      ^ ^  ╰─^─^─╯  ^ ^  ╰─^ ^─╯   [_y_]  yank
;;          ^^_n_^^      ^ ^  _r_eset slice box
;;          ^^^↓^^^
;;          ^^_G_^^
;;    --------------------------------------------------------------------------------
;;         "
;;         ("\\" hydra-master/body "back")
;;         ("<ESC>" nil "quit")
;;         ("al" pdf-annot-list-annotations)
;;         ("ad" pdf-annot-delete)
;;         ("aa" pdf-annot-attachment-dired)
;;         ("am" pdf-annot-add-markup-annotation)
;;         ("at" pdf-annot-add-text-annotation)
;;         ("y"  pdf-view-kill-ring-save)
;;         ("+" pdf-view-enlarge :color red)
;;         ("-" pdf-view-shrink :color red)
;;         ("0" pdf-view-scale-reset)
;;         ("H" pdf-view-fit-height-to-window)
;;         ("W" pdf-view-fit-width-to-window)
;;         ("P" pdf-view-fit-page-to-window)
;;         ("n" pdf-view-next-page-command :color red)
;;         ("p" pdf-view-previous-page-command :color red)
;;         ("d" pdf-view-dark-minor-mode)
;;         ("b" pdf-view-set-slice-from-bounding-box)
;;         ("r" pdf-view-reset-slice)
;;         ("g" pdf-view-first-page)
;;         ("G" pdf-view-last-page)
;;         ("e" pdf-view-goto-page)
;;         ("o" pdf-outline)
;;         ("s" pdf-occur)
;;         ("i" pdf-misc-display-metadata)
;;         ("u" pdf-view-revert-buffer)
;;         ("F" pdf-links-action-perfom)
;;         ("f" pdf-links-isearch-link)
;;         ("B" pdf-history-backward :color red)
;;         ("N" pdf-history-forward :color red)
;;         ("l" image-forward-hscroll :color red)
;;         ("h" image-backward-hscroll :color red))

;; ===================================================================
;; Elfeed
;; ===================================================================
 (use-package elfeed
  :defer t
  :ensure t
  :commands (elfeed))
;; ===================================================================
;; Auto-Generated
;; ===================================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("69f7e8101867cfac410e88140f8c51b4433b93680901bb0b52014144366a08c8" "15604b083d03519b0c2ed7b32da6d7b2dc2f6630bef62608def60cdcf9216184" "21e3d55141186651571241c2ba3c665979d1e886f53b2e52411e9e96659132d4" default))
 '(elfeed-feeds
   '("https://www.youtube.com/@blearoyd" "https://earlyretirementextreme.com/feed"))
 '(package-selected-packages
   '(zen-mode org-pdfview which-key vterm-toggle use-package undo-fu rainbow-delimiters pdf-tools org-drill multiple-cursors modus-themes magit ivy-rich helpful helm-emms god-mode flycheck evil elfeed counsel company-irony command-log-mode ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))

