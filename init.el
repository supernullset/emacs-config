(require 'package)
(setq package-enable-at-startup t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(package-refresh-contents)

(package-install 'use-package)

(eval-when-compile
  (add-to-list 'load-path "~/.emacs.d/elpa/")
  (require 'use-package))

(define-minor-mode supernullset-mode
  :doc "A simple mode consisting of all Sean's defaults"
  :init-value nil
  :lighter " SNS "
  (progn

;;    (defun ap/garbage-collect ()
;;      "Run `garbage-collect' and print stats about memory usage."
;;      (interactive)
;;      (message (cl-loop for (type size used free) in (garbage-collect)
;;                        for used = (* used size)
;;                        for free = (* (or free 0) size)
;;                        for total = (file-size-human-readable (+ used free))
;;                        for used = (file-size-human-readable used)
;;                        for free = (file-size-human-readable free)
;;                        concat (format "%s: %s + %s = %s\n" type used free total))))
;;    (ap/garbage-collect)


    ;;backup config
    (setq backup-directory-alist `(("." . "~/.saves")))
    (setq backup-by-copying t)

    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (toggle-scroll-bar -1)
    (display-line-numbers-mode -1)

    (add-hook 'before-save-hook 'delete-trailing-whitespace)
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

    (sml/setup)
    (column-number-mode 1)
    (ido-mode 0)
    (menu-bar-mode -1)

    (setq x-wait-for-event-timeout nil)

    (put 'narrow-to-region 'disabled nil)
    (setq-default indent-tabs-mode nil)
    (setq-default current-fill-column 80)
;;     (load-theme 'tangotango t)
    ))

(define-globalized-minor-mode global-supernullset-mode supernullset-mode (lambda () (supernullset-mode)))

(use-package tangotango-theme
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t))

(use-package helm-descbinds
  :config (helm-descbinds-mode))

(use-package helm-projectile
  :ensure t
  :config (helm-projectile-on))

(use-package helm
  :ensure t
  :bind (("C-x C-m"    . 'helm-M-x)
         ("C-x m"      . 'helm-M-x)
         ("C-c C-m"    . 'helm-M-x)
         ("M-y"        . 'helm-show-kill-ring)
         ("C-x C-f"    . 'helm-find-files)
         ("C-x C-g"    . 'magit-status)
         ("C-c <SPC>"  . 'helm-all-mark-rings)
         ("C-x r b"    . 'helm-filtered-bookmarks)
         ("C-h r"      . 'helm-info-emacs)
         ("C-:"        . 'helm-eval-expression-with-eldoc)
         ("C-,"        . 'helm-calcul-expression)
         ("C-h i"      . 'helm-info-at-point)
         ("C-x C-d"    . 'helm-browse-project)
         ("<f1>"       . 'helm-resume)
         ("C-h C-f"    . 'helm-apropos)
         ("C-h a"      . 'helm-apropos)
         ("<f5> s"     . 'helm-projectile)
         ("<f2>"       . 'helm-execute-kmacro)
         ("C-c i"      . 'helm-imenu-in-all-buffers)
         ("C-s"        . 'helm-occur)
         )

  :config (progn
            (setq helm-buffers-fuzzy-matching t)
            (helm-mode 1)))

(use-package company
  :ensure t
  :bind (("C-c C-i"    . 'company-complete))
  :config (progn
            (add-hook 'after-init-hook 'global-company-mode)))

(use-package magit
  :ensure t)

(use-package smart-mode-line
  :ensure t
  :config (progn
            (setq sml/no-confirm-load-theme t)))

(use-package rainbow-delimiters
  :ensure t

  :config (progn
            ;; enable rainbow delimiters
            (setq rainbow-delimiters-depth-1-face "color-196")
            (setq rainbow-delimiters-depth-2-face "color-58")
            (setq rainbow-delimiters-depth-3-face "color-70")
            (setq rainbow-delimiters-depth-4-face "color-26")
            (setq rainbow-delimiters-depth-5-face "color-211")
            (setq rainbow-delimiters-depth-6-face "color-220")
            (setq rainbow-delimiters-depth-7-face "color-225")
            (setq rainbow-delimiters-depth-8-face "color-22")
            (setq rainbow-delimiters-depth-9-face "color-130")
            ))

(use-package markdown-mode
  :ensure t
  :config (progn
            ;; markdown mode hooks
            (add-hook 'markdown-mode-hook 'orgtbl-mode)
            (add-hook 'markdown-mode-hook 'flyspell-mode)
            (add-hook 'markdown-mode-hook 'auto-fill-mode)
            ))

;;;;;;;;;;;;;;
;; Org Mode ;;
;;;;;;;;;;;;;;

(use-package org
  :bind (("C-c l" . 'org-store-link)
         ("C-c a" . 'org-agenda)
         ("C-c c" . 'org-capture)
         ("C-c b" . 'org-iswitchb)
         ("C-c t" . 'org-todo)
         )
  :config (progn (setq org-log-done 'time)))

(use-package smartparens
  :ensure t
  :bind (("C-M-a" . 'sp-beginning-of-sexp)
         ("C-M-e" . 'sp-end-of-sexp)
         ("C-M-f" . 'sp-forward-sexp)
         ("C-M-b" . 'sp-backward-sexp)
         ("C-M-d" . 'sp-down-sexp)
         ("C-M-u" . 'sp-backward-up-sexp)

         ("M-(" . 'sp-wrap-round)
         ("M-[" . 'sp-wrap-square)
         ("M-{" . 'sp-wrap-curly)

         ("C-M-]" . 'sp-forward-slurp-sexp)
         ("C-M-[" . 'sp-backward-slurp-sexp)
         ("<ESC-right>" . 'sp-forward-barf-sexp)
         ("<ESC-left>" . 'sp-backward-barf-sexp))

  :config (progn
            (add-hook 'prog-mode-hook 'smartparens-mode)
            (add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
            (add-hook 'racket-mode-hook 'smartparens-mode)
            (add-hook 'elisp-mode-hook 'smartparens-mode)
            (smartparens-global-mode)))

(use-package org-journal
  :ensure t
  :config (progn (setq org-journal-dir "~/HeartOfGold/SynologyDrive/org-journal")))

(use-package dired
  :config (progn
            (when (string= system-type "darwin")
              (setq dired-use-ls-dired nil))

            )
  )

(use-package ag :ensure t)
(use-package elixir-mode :ensure t)
(use-package terraform-mode :ensure t)
(use-package wrap-region :ensure t)
(use-package rainbow-mode :ensure t)
(use-package elm-mode :ensure t)
(use-package haskell-mode :ensure t)
(use-package markdown-mode :ensure t)
(use-package racket-mode :ensure t)
(use-package erlang :ensure t)
(use-package projectile :ensure t)
(use-package typescript-mode :ensure t)
(use-package column-enforce-mode :ensure t)
(use-package wgrep-ag :ensure t)
(use-package yaml-mode :ensure t)
(use-package dockerfile-mode :ensure t)
(use-package company :ensure t)
(use-package helm-descbinds :ensure t)


(global-supernullset-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-descbinds dockerfile-mode yaml-mode wgrep-ag wrap-region use-package typescript-mode terraform-mode smartparens smart-mode-line rainbow-mode rainbow-delimiters racket-mode org-journal markdown-mode magit helm-projectile haskell-mode erlang elm-mode elixir-mode company column-enforce-mode ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
