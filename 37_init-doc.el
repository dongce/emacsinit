

;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Building-Emacs.html#Building-Emacs
(if (> 10 (length build-files))
    (progn
      (require 'f)
      (require 's)
      (setf build-files (mapcar (lambda (x) (f-filename x)) (s-split " " (car  build-files) )))))



(require 'info+)
(require 'info-look)

(info-lookup-add-help
 :mode 'python-mode
 :regexp "[[:alnum:]_]+"
 :doc-spec
 '(("(python)Index" nil "")))

(global-set-key "\C-h\t" 'info-lookup-symbol)

;;(global-set-key (kbd "<kp-home> <kp-0>") (lambda () (interactive) (find-file "~/git/xah_emacs_init/xah_emacs_keybinding.el")))
;;(global-set-key (kbd "<kp-home> <kp-1>") (lambda () (interactive) (find-file "~/web/xahlee_info/js/blog.html")))
;;(global-set-key (kbd "<kp-home> <kp-2>") (lambda () (interactive) (find-file "~/web/xahlee_info/comp/blog.html")))
;;(global-set-key (kbd "<kp-home> <kp-3>") (lambda () (interactive) (find-file "~/web/ergoemacs_org/emacs/blog.html")))
;;(global-set-key (kbd "<kp-home> <kp-4>") (lambda () (interactive) (find-file "~/web/xahlee_info/math/blog.html")))


(setq common-lisp-hyperspec-root
      "file:F:/usr/local/clisp-2.37/hyperspec/HyperSpec/" )


(setq 
 woman-manpath
 (mapcar 
  (lambda (x)
    (symbol-name x))
  `(
    c:/usr/local/editor/EmacsW32/gnuwin32/man  
    c:/usr/local/editor/mumailindexer/share/man
    c:/usr/local/activePERL/man
    c:/usr/local/cmake/man
    c:/usr/local/coreutil/man
    c:/usr/local/ecl/share/man
    c:/usr/local/guile/share/man
    c:/usr/local/mingwdevkit/mingw/man
    c:/usr/local/mingwdevkit/mingw/share/man
    c:/usr/local/python27/share/man
    c:/usr/local/ruby/man
    c:/usr/local/swipl/xpce/man
    c:/usr/local/swipl/xpce/prolog/lib/man
    ,(intern ( fullpath "../../global/share/man/"))
    ,(intern ( fullpath "../../man-pages/"))
/usr/local/misctools/default/share/man
/usr/local/emacs/default/share/man
/usr/local/guile/default/share/man
/usr/local/git/default/share/man
/usr/local/git/mandoc
/usr/local/python27/default/share/man
/usr/local/subversion/default/share/man
/usr/local/tcpreplay/default/share/man
  )))


(setq 
 Info-additional-directory-list
 (list
  (fullpath "../../share/info")
  (fullpath "../../doc/info")
  (fullpath "../../mumailindexer/share/info")
  (fullpath "../../global/share/info")
  (format "%s/%s" (getenv "GUILE_HOME") "/share/info" )
  "/usr/local/misctools/default/share/info"
"/usr/local/emacs/default/share/info"
"/usr/local/guile/default/share/info"
"/usr/local/git/default/share/info"
"/usr/local/python27/default/share/info"
"/usr/local/subversion/default/share/info"
"/usr/local/tcpreplay/default/share/info"
))




(use-package irfc
  :init
  (setq irfc-directory (fullpath "../rfcdoc")) 
  (setq irfc-assoc-mode t)
  :config
  (defun rfcsearch () 
    (interactive)
    (browse-url "http://www.ietf.org/rfc.html"))

  (defun rfcindex ()
    (interactive)
    (let ((url-request-method "GET")
          ;; (arg-stuff (concat "?query=" (url-hexify-string str) "&filter=" (url-hexify-string type)))
          )
      (url-retrieve  "http://www.ietf.org/download/rfc-index.txt" (lambda (status) (switch-to-buffer (current-buffer))))))
  )


;; know-your-http-well package 
;; https://github.com/for-GET/know-your-http-well
