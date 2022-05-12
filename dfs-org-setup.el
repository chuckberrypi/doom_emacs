;;; dfs-org-setup.el -*- lexical-binding: t; -*-
(require 'org-id)
(require 'org-expiry)

(defun dfs-insert-created-timestamp (_)
  "Insert a 'Created' property for every todo that is created"
  ;; (require 'org-expiry)
  (org-expiry-insert-created)
  (org-back-to-heading)
  (org-end-of-line)
  (evil-insert 1))

(defun dfs/insert-id (_)
  "Insert an 'ID' property for every todo that is created"
  ;; (require 'org-id)
  (org-id-get-create)
  (org-back-to-heading)
  (org-end-of-line)
  (evil-insert 1))

(defun dfs/org-setup ()
  (require 'org-id)
  (require 'org-expiry)
  (advice-add 'org-insert-todo-heading :after #'dfs/insert-created-timestamp)
  (advice-add 'org-insert-todo-heading :after #'dfs/insert-id)
  (setq org-agenda-files '("~/work_org" "~/org"))
  (setq org-treat-insert-todo-heading-as-state-change t)
  (setq org-todo-keywords
        '((sequence "TODO(t!)" "PROJ(p)" "LOOP(r)" "STRT(s)" "DGATE(g@/!)" "WAIT(w@/!)" "HOLD(h@)" "IDEA(i)" "|" "DONE(d!)" "KILL(k!)")
          (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
          (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))
  (setq org-log-into-drawer t)
  (setq org-agenda-follow-mode t)
  (org-bullets-mode 1)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (sqlite . t)))
  )

(after! org
  (setq org-capture-templates
        (append
         '(("w" "Chuck Walk" table-line
            (id  "b42729b6-1cc1-460c-a7b5-6b0eb8a3970f")
            "| %u | %^{Time|morning|afternoon|evening} | %^{Slowdown} | %^{Notes} |"))
         org-capture-templates)))

(add-hook 'org-agenda-mode-hook #'dfs/org-setup)
(add-hook 'org-mode-hook #'dfs/org-setup)

(use-package! org
  :init (progn
          (setq org-roam-directory "~/org-roam")
          (setq org-directory "~/org")))
