;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(org-babel-load-file "~/.doom.d/doom-config.org")

(with-current-buffer "Hamilton_NOP.org"
  (org-element-map (org-element-parse-buffer) 'headline
    (lambda (el)
      (org-element-property :contents-begin el))))

(with-current-buffer "Hamilton_NOP.org"
  )
