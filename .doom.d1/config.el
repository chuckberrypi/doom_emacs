;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "David Stearns"
      user-mail-address "d.f.stearns@gmail.com")
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;(require 'mu4e)
;(setq mail-user-agent 'mu4e-user-agent)

;(setq mu4e-sent-messages-behavior 'delete)
;(setq mu4e-get-mail-command "mbsync -a")

(set-email-account! "gmail.com"
                    '())

(setq mu4e-get-mail-command "mbsync -V gmail")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(setq line-chunk 8)

(defun down-chunk ()
  (interactive)
  (forward-line line-chunk))

(defun up-chunk ()
  (interactive)
  (forward-line (- 0 line-chunk)))

(setq evil-escape-key-sequence "fd")
(setq smartparens-strict-mode t)

(map! :leader
      :prefix ("k" . "lisp funcs")
      :desc "barf last sexp" "b" #'sp-forward-barf-sexp
      :desc "kill sexp" "k" #'sp-kill-sexp
      :desc "raise sexp" "r" #'sp-raise-sexp
      :desc "slurp next sexp" "s" #'sp-forward-slurp-sexp
      :desc "wrap Sexp" "w" #'sp-wrap-round
      )

(map! :i "[" #'paredit-open-bracket)

(global-set-key [(control shift j)] 'down-chunk)
(global-set-key [(control shift k)] 'up-chunk)
(global-set-key [(control shift up)] 'move-line-up)
(global-set-key [(control shift down)] 'move-line-down)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(after! racket-mode
  (setq racket-racket-program "/Applications/Racket v8.0/bin/racket")
  (setq racket-raco-program "/Applications/Racket v8.0/bin/raco"))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
