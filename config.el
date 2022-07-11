;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(setq user-full-name "David Stearns"
      user-mail-address "d.f.stearns@gmail.com")

;; Load Org File. Source: https://github.com/angrybacon/dotemacs/blob/master/init.el
;; (let ((default-directory doom-private-dir)
;;       (file-name-handler-alist nil)
;;       (gc-cons-percentage .6)
;;       (gc-cons-threshold most-positive-fixnum)
;;       (read-process-output-max (* 1024 1024)))
;;   (org-babel-load-file "doom-config.org"))
(org-babel-load-file "~/.doom.d/doom-config.org")
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
