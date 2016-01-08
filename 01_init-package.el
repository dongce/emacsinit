
;;moveto-dotemacs;;(if (>= emacs-major-version 24 )
;;moveto-dotemacs;;    (progn 
;;moveto-dotemacs;;      (require 'package)
;;moveto-dotemacs;;      (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;moveto-dotemacs;;      (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
;;moveto-dotemacs;;      (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;;moveto-dotemacs;;      (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;;moveto-dotemacs;;      (add-to-list 'package-archives '("org"       . "http://orgmode.org/elpa/")) 
;;moveto-dotemacs;;      (add-to-list 'package-archives '("tromey"    . "http://tromey.com/elpa/"))
;;moveto-dotemacs;;      (package-initialize)
;;moveto-dotemacs;;      ))



  ;;(unless (require 'el-get nil 'noerror)
  ;;  (with-current-buffer
  ;;      (url-retrieve-synchronously
  ;;       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
  ;;    (let (el-get-master-branch)
  ;;      (goto-char (point-max))
  ;;      (eval-print-last-sexp))))
  ;;
  ;;(el-get 'sync)



(require 'use-package)
