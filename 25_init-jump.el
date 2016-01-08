;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-
;; ace jump mode 를 사용할 수 있다. 
(require 'ace-jump-mode)
(global-set-key (kbd "s-j")  'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(global-set-key (kbd "s-;")  (lambda () (interactive) (push-mark (point) t)))
(global-set-key (kbd "s-'")  (lambda () (interactive) (pop-global-mark)))


;; FUNCTION DEFINITION

;;VERY LITTILE USED;;(global-set-key [f10] '(aif (w32-shell-execute "open" (buffer-file-name) nil )))
(global-set-key [f10]  #'hl-symbol-and-jump)
(global-set-key [f11]  #'hl-symbol-cleanup)

(require 'quick-jump)
;;(quick-jump-default-keybinding)

(global-set-key (kbd "C-,") 'quick-jump-go-back)
(global-set-key (kbd "C-.") 'quick-jump-push-marker)
;;(global-set-key (kbd "C-<") 'quick-jump-go-forward)
;;(global-set-key (kbd "C->") 'quick-jump-clear-all-marker)


;;TOY;;(autoload 'ewb "ewb")
;;TOY;;(autoload 'vc-jump "vc-jump" "버젼제어 버퍼로 점프" t)


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

(defun hl-symbol-and-jump ()
  (interactive)
  (let ((symbol (highlight-symbol-get-symbol)))
    (unless symbol (error "No symbol at point"))
    (unless hi-lock-mode (hi-lock-mode 1))
    (if (member symbol highlight-symbol-list)
        (highlight-symbol-next)
      (highlight-symbol-at-point)
      (highlight-symbol-next))))

(defun hl-symbol-cleanup ()
  (interactive)
  (mapc 'hi-lock-unface-buffer highlight-symbol-list)
  (setq highlight-symbol-list ()))



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

;;deprecated;;(fset 'bmkp-bmenu-list-1-origin #'bmkp-bmenu-list-1)       ;원본버젼 
;;deprecated;;
;;deprecated;;
;;deprecated;;(defun bmkp-bmenu-list-1 (filteredp reset-marked-p interactivep)
;;deprecated;;  "Helper for `bookmark-bmenu-list'.
;;deprecated;;See `bookmark-bmenu-list' for the description of FILTEREDP.
;;deprecated;;Non-nil RESET-MARKED-P resets `bmkp-bmenu-marked-bookmarks'.
;;deprecated;;Non-nil INTERACTIVEP means `bookmark-bmenu-list' was called
;;deprecated;; interactively, so pop to the bookmark list and communicate the sort
;;deprecated;; order."
;;deprecated;;  (when reset-marked-p (setq bmkp-bmenu-marked-bookmarks  ()))
;;deprecated;;  (unless filteredp (setq bmkp-latest-bookmark-alist  bookmark-alist))
;;deprecated;;  (if interactivep
;;deprecated;;      (let ((one-win-p  (one-window-p)))
;;deprecated;;        (pop-to-buffer (get-buffer-create "*Bookmark List*"))
;;deprecated;;        (when one-win-p (delete-other-windows)))
;;deprecated;;    (set-buffer (get-buffer-create "*Bookmark List*")))
;;deprecated;;  (let* ((inhibit-read-only       t)
;;deprecated;;         (title                   (if (and filteredp bmkp-bmenu-title (not (equal "" bmkp-bmenu-title)))
;;deprecated;;                                      bmkp-bmenu-title
;;deprecated;;                                    "All Bookmarks"))
;;deprecated;;         (show-image-file-icon-p  (and (fboundp 'display-images-p) (display-images-p)
;;deprecated;;                                       bmkp-bmenu-image-bookmark-icon-file
;;deprecated;;                                       (file-readable-p bmkp-bmenu-image-bookmark-icon-file))))
;;deprecated;;    (erase-buffer)
;;deprecated;;    (when (fboundp 'remove-images) (remove-images (point-min) (point-max)))
;;deprecated;;    (insert (format "%s\n%s\n" title (make-string (length title) ?-)))
;;deprecated;;    (add-text-properties (point-min) (point) (bmkp-face-prop 'bmkp-heading))
;;deprecated;;    (goto-char (point-min))
;;deprecated;;    (insert (format "Bookmark file:\n%s\n\n" bmkp-current-bookmark-file))
;;deprecated;;    (forward-line bmkp-bmenu-header-lines)
;;deprecated;;    (let ((max-width  0)
;;deprecated;;          name markedp tags annotation temporaryp start)
;;deprecated;;      (setq bmkp-sorted-alist  (bmkp-sort-omit bookmark-alist
;;deprecated;;                                               (and (not (eq bmkp-bmenu-filter-function
;;deprecated;;                                                             'bmkp-omitted-alist-only))
;;deprecated;;                                                    bmkp-bmenu-omitted-bookmarks)))
;;deprecated;;      (dolist (bmk  bmkp-sorted-alist)
;;deprecated;;        (setq max-width  (max max-width 
;;deprecated;;                              (+ 10 (length (bookmark-name-from-full-record bmk)))))) ;한글전시관련오류발생 
;;deprecated;;      (setq max-width  (+ max-width bmkp-bmenu-marks-width))
;;deprecated;;      (dolist (bmk  bmkp-sorted-alist)
;;deprecated;;        (setq name        (bookmark-name-from-full-record bmk)
;;deprecated;;              markedp     (bmkp-marked-bookmark-p bmk)
;;deprecated;;              tags        (bmkp-get-tags bmk)
;;deprecated;;              annotation  (bookmark-get-annotation bmk)
;;deprecated;;              start       (+ bmkp-bmenu-marks-width (point)))
;;deprecated;;        (if (not markedp)
;;deprecated;;            (insert " ")
;;deprecated;;          (insert ">") (put-text-property (1- (point)) (point) 'face 'bmkp->-mark))
;;deprecated;;        (if (null tags)
;;deprecated;;            (insert " ")
;;deprecated;;          (insert "t") (put-text-property (1- (point)) (point) 'face 'bmkp-t-mark))
;;deprecated;;        (cond ((bmkp-temporary-bookmark-p bmk)
;;deprecated;;               (insert "X") (put-text-property (1- (point)) (point) 'face 'bmkp-X-mark))
;;deprecated;;              ((and annotation (not (string-equal annotation "")))
;;deprecated;;               (insert "a") (put-text-property (1- (point)) (point) 'face 'bmkp-a-mark))
;;deprecated;;              (t (insert " ")))
;;deprecated;;        (insert " ")
;;deprecated;;        (when (and (featurep 'bookmark+-lit) (bmkp-get-lighting bmk)) ; Highlight highlight overrides.
;;deprecated;;          (put-text-property (1- (point)) (point) 'face 'bmkp-light-mark))
;;deprecated;;        (when (and (bmkp-image-bookmark-p bmk)  show-image-file-icon-p)
;;deprecated;;          (let ((image  (create-image bmkp-bmenu-image-bookmark-icon-file nil nil :ascent 95)))
;;deprecated;;            (put-image image (point))))
;;deprecated;;        (insert name)
;;deprecated;;        (move-to-column max-width t)
;;deprecated;;        (bmkp-bmenu-propertize-item bmk start (point))
;;deprecated;;        (insert "\n")))
;;deprecated;;    (goto-char (point-min)) (forward-line bmkp-bmenu-header-lines)
;;deprecated;;    (bookmark-bmenu-mode)
;;deprecated;;    (when bookmark-bmenu-toggle-filenames (bookmark-bmenu-toggle-filenames t))
;;deprecated;;    (when (and (fboundp 'fit-frame-if-one-window)
;;deprecated;;               (eq (selected-window) (get-buffer-window (get-buffer-create "*Bookmark List*") 0)))
;;deprecated;;      (fit-frame-if-one-window)))
;;deprecated;;  (when (and interactivep bmkp-sort-comparer)
;;deprecated;;    (bmkp-msg-about-sort-order (bmkp-current-sort-order))))

(require 'point-stack)
(require 'evil-visual-mark-mode)

(evil-visual-mark-mode t)
