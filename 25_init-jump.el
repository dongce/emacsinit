;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-
;; ace jump mode 를 사용할 수 있다. 


;; FUNCTION DEFINITION



(require 'webjump)
(global-set-key "\C-cw" 'webjump)

(setq 
 webjump-sites
 (append
  webjump-sites
 '(("emacs"           . "http://www.gnu.org/software/emacs/manual/emacs.html")
   ("elisp-intro"     . "http://www.gnu.org/software/emacs/emacs-lisp-intro/html_mono/emacs-lisp-intro.html")
   ("elisp-reference" . "http://www.gnu.org/software/emacs/elisp-manual/html_mono/elisp.html")
   ("msdn"            . "http://msdn.microsoft.com/library/default.asp")
   ("msdn-forum"      . "http://forums.microsoft.com/msdn/")
   ("iostream"        . "http://www.cplusplus.com/ref/")
   ("stl"             . "http://www.sgi.com/tech/stl/table_of_contents.html")
   ("sgi"             . "http://www.sgi.com/tech/stl/")
   ("tr1"             . "http://www.aristeia.com/EC3E/TR1_info.html")
   ("man"             . "http://www.freebsd.org/cgi/man.cgi")
   ("wikipedia"       . "http://en.wikipedia.org/wiki/Main_Page")
   ("koders"          . "http://www.koders.com")
   ("c++faq"          . "http://www.parashift.com/c++-faq-lite/index.html")
   ("python"          . "http://www.python.org/doc/")
   ("erlang"          . "http://www.erlang.org/doc.html")
   ("sbcl"            . "http://www.sbcl.org/manual/")
   ("java"            . "http://java.sun.com/javase/6/docs/api/")
   ("haskell"         . "http://haskell.org/ghc/docs/latest/html/libraries/")

   ("FFX"             . "http://10.239.12.181/projects/ffx/")
   ("FBUILD"          . "http://10.239.12.134/buildserver")
   ("FFXCODESONAR"    . "http://10.239.12.181/projects/ffxcodesonar/")
   ("IIDS"            . "http://10.239.12.181/projects/iids/")
   ("LST"             . "http://10.239.12.181/projects/lst/")
   ("HILS"            . "http://10.239.12.181/projects/hils/")
   ("MISC"            . "http://10.239.12.181/projects/misc/")
   ("CORESW"          . "http://10.239.12.181/projects/coresw/")

   ("LPX"             . "http://10.239.12.87/projects/lpx/")
   ("bzrsync"         . "http://10.239.12.181/syncbzr/ffx")
   ("CODESONAR"       . "http://10.239.12.219:7340/")
   ("gmail   "        . "http://www.gmail.com")

   ("swankjs"         . "http://localhost:8009/swank-js/test.html")
   ("MDMS"            . "http://10.239.12.87:3000/login/login")
   )))



;;Typing the Form Feed Character
;;
;;In emacs, you can type the char by pressing 【Ctrl+q】 then 【Ctrl+l】. ( Emacs's Key Notations Explained (/r, ^M, C-m, RET, <return>, M-, meta)) 

;; keys for moving to prev/next code section (Form Feed; ^L)
(global-set-key (kbd "<C-M-prior>") 'backward-page) ; Ctrl+Alt+PageUp
(global-set-key (kbd "<C-M-next>") 'forward-page)   ; Ctrl+Alt+PageDown





(setq bm-restore-repository-on-load t)
(require 'bm)

;; bm-bookmart-annotate
;;(global-set-key (kbd "<M-f2>") 'bm-toggle)
;;(global-set-key (kbd "<f2>")   'bm-next)
;;(global-set-key (kbd "<S-f2>") 'bm-previous)
 
;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)
 
;; Loading the repository from file when on start up.
(add-hook' after-init-hook 'bm-repository-load)
 
;; Restoring bookmarks when on file find.
(add-hook 'find-file-hooks 'bm-buffer-restore)
 
;; Saving bookmark data on killing a buffer
(add-hook 'kill-buffer-hook 'bm-buffer-save)
 
;; Restore bookmarks when buffer is reverted.
(add-hook 'after-revert-hook 'bm-buffer-restore)

;; Saving the repository to file when on exit.
;; kill-buffer-hook is not called when emacs is killed, so we
;; must save all bookmarks first.
(add-hook 
 'kill-emacs-hook 
 '(lambda nil
    (bm-buffer-save-all)
    (bm-repository-save)))

;; STANDARD emacs bookmark 
;;;; C-x r m   set a bookmark at the current location (e.g. in a file)
;;;; C-x r b   jump to a bookmark
;;;; C-x r l   list all of your bookmarks
;;;; M-x bookmark-delete   delete a bookmark by name

(require 'bookmark+)
(global-set-key (kbd "C-*") 'bookmark-bmenu-list)


(fset 'bmkp-url-target-set-origin #'bmkp-url-target-set)       ;원본버젼 

(defun bmkp-url-target-set (url &optional prefix-only-p name/prefix no-update-p msg-p) ; `C-x p c u'
  "Set a bookmark for a URL.  Return the bookmark.
Interactively you are prompted for the URL.  Completion is available.
Use `M-n' to pick up the url at point as the default.

You are also prompted for the bookmark name.  But with a prefix arg,
you are prompted only for a bookmark-name prefix.  In that case, the
bookmark name is the prefix followed by the URL.

When entering a bookmark name you can use completion against existing
names.  This completion is lax, so you can easily edit an existing
name.  See `bookmark-set' for particular keys available during this
input.

Non-interactively:
* Non-nil PREFIX-ONLY-P means NAME/PREFIX is a bookmark-name prefix.
* NAME/PREFIX is the bookmark name or its prefix (the suffix = URL).
* Non-nil NO-UPDATE-P means do not refresh/rebuild the bookmark-list
  display.
* Non-nil MSG-P means display a status message."
  (interactive
   (list (if (require 'ffap nil t)
             (ffap-read-file-or-url "URL: " (or (bmkp-thing-at-point 'url)
                                                (and (fboundp 'url-get-url-at-point)
                                                     (url-get-url-at-point))))
           (let ((icicle-unpropertize-completion-result-flag  t))
             (read-file-name "URL: " nil (or (bmkp-thing-at-point 'url)
                                             (and (fboundp 'url-get-url-at-point)
                                                  (url-get-url-at-point))))))
         current-prefix-arg
         (if current-prefix-arg
             (read-string "Prefix for bookmark name: ")
           (bmkp-completing-read-lax "Bookmark name"))
         nil
         'MSG))
  (unless name/prefix (setq name/prefix  ""))
  ;;usedynamicbinding;;(lexical-let* ((ul                             url)
  (let* ((ul                             url)
         (bookmark-make-record-function  (if (eq major-mode 'w3m-mode)
                                             'bmkp-make-w3m-record
                                           (lambda () (bmkp-make-url-browse-record ul))))
         bmk failure)
    (condition-case err
        (setq bmk  (bookmark-store (if prefix-only-p (concat name/prefix url) name/prefix)
                                   (cdr (bookmark-make-record))  nil  no-update-p  (not msg-p)))
      (error (setq failure  err)))
    (when failure (error "Failed to create bookmark for `%s':\n%s\n" url failure))
    bmk))


(require 'point-stack)
