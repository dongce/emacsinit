;; -*- coding: utf-8; -*-
;;; http://ergoemacs.org/emacs/elisp_syntax_coloring.html
;;; my own mode 
(define-derived-mode qac-mode compilation-mode "qac"
  "Major mode for editing Octave code.

Octave is a high-level language, primarily intended for numerical
computations.  It provides a convenient command line interface
for solving linear and nonlinear problems numerically.  Function
definitions can also be stored in files and used in batch mode."
  ;; grep-regexp-alist 
  ;; compilation-error-regexp-alist
  ;; 위의 두 변수를 수정하여 새로은 컴파일모드를 생성할 수 있다. 
  (message "qac mode")
  )
