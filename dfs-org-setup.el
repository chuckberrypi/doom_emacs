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
  (dfs/org-setup)
  (setq org-capture-templates
        (append
         '(("w" "Chuck Walk" table-line
            (id  "b42729b6-1cc1-460c-a7b5-6b0eb8a3970f")
            "| %u | %^{Time|morning|afternoon|evening} | %^{Slowdown} | %^{Notes} |")
           ("b" "Best" entry
            (file+headline "~/org/scratch.org" "Heading 1.1")
            "** TODO %(s-concat \"%^{\" (s-join \"|\" '(\"Pick Animal: \" \"cat\" \"bat\" \"rat\")) \"}\")"))
         org-capture-templates)))

(add-hook 'org-agenda-mode-hook #'dfs/org-setup)
(add-hook 'org-mode-hook #'dfs/org-setup)

(use-package! org
  :init (progn
          (setq org-roam-directory "~/org-roam")
          (setq org-directory "~/org")))

(defun dfs/agenda-file-names ()
  (->> org-agenda-files
       (-map #'dfs/file-or-dir-files)
       -flatten
       (-filter (lambda (x) x))
       (-remove (lambda (s) (string-match-p "/\.git" s)))
       ))

(defun dfs/file-or-dir-files (name)
  (if (file-directory-p name)
      (directory-files-recursively name ".*\.org")
    (if (and (file-exists-p name)
             (string-match-p ".*\.org" name))
        name
      nil)))

(defun dfs/org-file-to-elements (name)
  (with-temp-buffer
    (insert-file-contents name)
    (org-element-parse-buffer)))

(defun dfs/org-file-to-json (name)
  (with-temp-buffer
    (insert-file-contents name)
    (ox-json-export-to-buffer))
  (with-current-buffer "*Org JSON Export*"
    (let  ((s (buffer-string)))
      (erase-buffer)
      (kill-buffer-and-window)
      s)))

(defun dfs/org-agenda-files-json ()
  (->> (dfs/agenda-file-names)
       (mapcar #'dfs/org-file-to-json)
       vconcat
       json-serialize))

(defun dfs/org-agenda-file-names-json ()
  (->> (dfs/agenda-file-names)
       vconcat
       json-serialize))

;; (insert (dfs/org-agenda-file-names-json))

(defun dfs/apply-concat (list-of-lists)
  (-reduce-from (lambda (acc v)
                  (append acc v))
                '()
                list-of-lists))

(defun dfs/org-elements-of-type (tree type)
  (org-element-map tree type #'identity))

(defun dfs/org-get-table-by-name (name)
  (->> (dfs/org-elements-of-type (org-element-parse-buffer) 'table)
       (-filter (lambda (table) (equal name (org-element-property :name table))))
       car))

(defun dfs/vec->list (vec)
  (append vec '()))

(defun dfs/row-coords->fields (row-coord)
  "must be in the table"
  (-map (lambda (coord)
          (let ((r (elt coord 0))
               (c (elt coord 1)))
           (org-table-get r c))) row-coord))

(defun dfs/org-table-fields ()
  (->> org-table-dlines
       dfs/vec->list
       (-filter #'identity)
       (-map-indexed (lambda (index el) (+ 1 index)))
       (-map (lambda (r)
               (let ((c org-table-current-ncol)
                     (ret '()))
                 (while (< 0 c)
                   (setq ret (cons (list r c) ret))
                   (setq c (- c 1)))
                 ret)))
       (-map #'dfs/row-coords->fields)
       ) )

(defun dfs/org-table-by-name->values (name)
 (save-excursion
  (let* ((tbl (dfs/org-get-table-by-name name))
         (start (org-element-property :begin tbl)))
    (goto-char (+ 1 start))
    (org-table-analyze)
    (dfs/org-table-fields)
    )))

(quote (completing-read "Edit: " '(("a" 3) ("b" 8) ("c" 10))))
