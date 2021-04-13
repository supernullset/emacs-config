(require 'package)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(gnutls-algorithm-priority "normal:-vers-tls1.3")
 '(package-selected-packages
   '(lsp-mode rustic julia-mode go helm-descbinds dockerfile-mode yaml-mode wgrep-ag wrap-region use-package typescript-mode terraform-mode smartparens smart-mode-line rainbow-mode rainbow-delimiters racket-mode org-journal markdown-mode magit helm-projectile haskell-mode erlang elm-mode elixir-mode company column-enforce-mode ag)))

(setq package-enable-at-startup t)

(setq package-archives '( ;; ("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(if (not (file-exists-p "./elpa/"))
    ;; assume that this is the first run
    (progn
      (package-refresh-contents)))

(package-install 'use-package)
(eval-when-compile
  (add-to-list 'load-path "~/.emacs.d/elpa/")
  (require 'use-package))

(use-package tangotango-theme
  :ensure t)

(define-minor-mode supernullset-mode
  "A simple mode consisting of all Sean's defaults"
  :init-value nil
  :lighter " SNS "
  (progn
    (enable-theme 'tangotango)
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
    (setq inhibit-startup-screen t)

    (add-hook 'before-save-hook 'delete-trailing-whitespace)
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;;    (sml/setup)
    (column-number-mode 1)
    (ido-mode 0)
    (menu-bar-mode -1)

    (setq x-wait-for-event-timeout nil)

    (put 'narrow-to-region 'disabled nil)
    (setq-default indent-tabs-mode nil)
    (setq-default current-fill-column 80)
    (setq org-agenda-file-regexp "\\`[^.].*\\.org\\'\\|\\`[0-9]+\\'")
    ;; figure out how to get this in org mode
    (add-to-list 'auto-mode-alist '("\\`[0-9]+\\'" . org-mode))

    ;; Custom keybindings
    (global-set-key (kbd "C-x C-m") 'execute-extended-command)
    (global-set-key (kbd "C-x m") 'execute-extended-command)
    (global-set-key (kbd "C-x g") 'magit)

    (setq org-journal-prefix-key "C-c j ")
    (setq icomplete-mode t)


    ))

(define-globalized-minor-mode global-supernullset-mode supernullset-mode (lambda () (supernullset-mode)))


;; TODO: Learn more: https://projectile.mx/
(use-package projectile
  :ensure t
  :bind (("C-c p" . 'projectile-command-map)
         ("s-p" . 'projectile-command-map))
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  )

(use-package company
  :ensure t
  :bind (("C-c C-i"    . 'company-complete))
  :config (progn
            (add-hook 'after-init-hook 'global-company-mode)))

(use-package magit
  :ensure t)

(use-package rainbow-delimiters
  :ensure t

  :config (progn
            ;; enable rainbow delimiters
            (set-face-attribute 'rainbow-delimiters-depth-1-face nil :foreground "#976008")
            (set-face-attribute 'rainbow-delimiters-depth-2-face nil :foreground "#7F9208")
            (set-face-attribute 'rainbow-delimiters-depth-3-face nil :foreground "#FFE800")
            (set-face-attribute 'rainbow-delimiters-depth-4-face nil :foreground "#055E54")
            (set-face-attribute 'rainbow-delimiters-depth-5-face nil :foreground "#EB9202")
            (set-face-attribute 'rainbow-delimiters-depth-6-face nil :foreground "#C4E401")
            (set-face-attribute 'rainbow-delimiters-depth-7-face nil :foreground "#B1017C")
            (set-face-attribute 'rainbow-delimiters-depth-8-face nil :foreground "#019282")
            (set-face-attribute 'rainbow-delimiters-depth-9-face nil :foreground "#BA770B")
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
  :ensure t
  :bind (("C-c l" . 'org-store-link)
         ("C-c a" . 'org-agenda)
         ("C-c c" . 'org-capture)
         ("C-c b" . 'org-iswitchb)
         ("C-c t" . 'org-todo)
         )
  :config (progn
            (setq org-log-done 'time)))

(use-package org-journal
  :ensure t
  :defer t
;;  :bind (("C-c j" . 'org-journal-prefix-key))
;;  :init (setq org-journal-prefix-key "C-c j")
  :config (setq org-journal-dir "~/HeartOfGold/SynologyDrive/org-journal"
                org-journal-date-format "%A, %d %B %Y"))

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
            ;; Disable single quote, I basically only use it in emacs
            (sp-pair "'" nil :actions :rem)
            (add-hook 'prog-mode-hook 'smartparens-mode)
            (add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
            (add-hook 'racket-mode-hook 'smartparens-mode)
            (add-hook 'elisp-mode-hook 'smartparens-mode)
            (smartparens-global-mode)))

(use-package dired
  :config (progn
            (when (string= system-type "darwin")
              (setq dired-use-ls-dired nil))

            )
  )


(use-package ag :ensure t)
(use-package lua-mode :ensure t)
(use-package elixir-mode :ensure t)
(use-package wrap-region :ensure t)
(use-package rainbow-mode :ensure t)
(use-package elm-mode :ensure t)
(use-package haskell-mode :ensure t)
(use-package racket-mode :ensure t)
(use-package erlang :ensure t)
(use-package typescript-mode :ensure t)
(use-package column-enforce-mode :ensure t)
(use-package wgrep-ag :ensure t)
(use-package yaml-mode :ensure t)
(use-package dockerfile-mode :ensure t)

(global-supernullset-mode)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
