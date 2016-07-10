;; -*- coding: utf-8; -*-
* folding package
#+BEGIN_SRC emacs-lisp

(use-package html-fold)
(use-package origami-mode
:commands (origami-mode)
:config
  (evil-leader/set-key-for-mode 'origami-mode
    "o" origami-mode-map
    )
)
#+END_SRC

