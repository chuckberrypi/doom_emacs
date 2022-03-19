;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "David Stearns"
      user-mail-address "d.f.stearns@gmail.com")

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

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;;(load! "dfs-org-setup.el")

(require 'org-id)
(require 'org-expiry)

(defun dfs-insert-created-timestamp (_)
  "Insert a 'Created' property for every todo that is created"
  (org-expiry-insert-created)
  (org-back-to-heading)
  (org-end-of-line)
  (evil-insert 1))

(defun dfs-insert-id (_)
  "Insert a 'Created' property for every todo that is created"
  (org-id-get-create)
  (org-back-to-heading)
  (org-end-of-line)
  (evil-insert 1))

(defun dfs-org-setup ()
  (require 'org-id)
  (require 'org-expiry)
  (advice-add 'org-insert-todo-heading :after #'dfs-insert-created-timestamp)
  (advice-add 'org-insert-todo-heading :after #'dfs-insert-id)
  (setq org-agenda-files '("~/work_org" "~/org"))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROJ(p)" "LOOP(r)" "STRT(s)" "DGATE(g@/!)" "WAIT(w@/!)" "HOLD(h@)" "IDEA(i)" "|" "DONE(d!)" "KILL(k!)")
          (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
          (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))
  (setq org-log-into-drawer t)
  (setq org-agenda-follow-mode t)
  (org-bullets-mode 1))

(add-hook 'org-agenda-mode-hook #'dfs-org-setup)
(add-hook 'org-mode-hook #'dfs-org-setup)

(use-package! org
  :init (progn
          (setq org-roam-directory "~/org-roam")
          (setq org-directory "~/org")))

(map! :leader
      (:prefix ("k" . "parens conveniens")
       :desc "kill sexp" "k" #'kill-sexp
       :desc "wrap sexp" "w" #'sp-wrap-round
       :desc "barf" "b" #'sp-forward-barf-sexp
       :desc "slurp" "s" #'sp-forward-slurp-sexp
       :desc "raise" "r" #'sp-raise-sexp))

(use-package! org-transclusion
	      :after org
	      :init
	      (map!
		:map global-map "<f12>" #'org-transclusion-add
		:leader 
		:prefix "n"
		:desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

(after! evil
  (setq evil-respect-visual-line-mode t))

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
