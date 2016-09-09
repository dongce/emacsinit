;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

;;(setq 
;; browse-url-browser
;; browse-url-new-window-flag           t
;; browse-url-firefox-new-window-is-tab t)

;; webjump 의 내용을 재정의
(setq 
 browse-url-browser-function
 (lambda (url &optional new-window)
   "Ask the Firefox WWW browser to load URL.
Default to the URL around or before point.  The strings in
variable `browse-url-firefox-arguments' are also passed to
Firefox.

When called interactively, if variable
`browse-url-new-window-flag' is non-nil, load the document in a
new Firefox window, otherwise use a random existing one.  A
non-nil interactive prefix argument reverses the effect of
`browse-url-new-window-flag'.

If `browse-url-firefox-new-window-is-tab' is non-nil, then
whenever a document would otherwise be loaded in a new window, it
is loaded in a new tab in an existing window instead.

When called non-interactively, optional second argument
NEW-WINDOW is used instead of `browse-url-new-window-flag'.

On MS-Windows systems the optional `new-window' parameter is
ignored.  Firefox for Windows does not support the \"-remote\"
command line parameter.  Therefore, the
`browse-url-new-window-flag' and `browse-url-firefox-new-window-is-tab'
are ignored as well.  Firefox on Windows will always open the requested
URL in a new window."
   (setq url (browse-url-encode-url url))
   (apply 'start-process
          (concat "firefox " url) nil
          browse-url-firefox-program
          (append
           browse-url-firefox-arguments
           (list url)
           ))))



(defun httpcall ()
  (interactive)
  (save-excursion
    (let ((url (read-from-minibuffer "url: " "http://")))
      (set-buffer (get-buffer-create "*httpcall*"))
      (erase-buffer)
      (insert-buffer (url-retrieve-synchronously url))
      (switch-to-buffer "*httpcall*"))))


(defun httpstring ( url )
  (interactive (list (read-from-minibuffer "url: " "http://")))
  (save-excursion
    (with-temp-buffer
      (insert-buffer (url-retrieve-synchronously url))
      (goto-char (point-min))
      (if (looking-at "^HTTP/1.1 200 OK$")
          (progn
            (forward-line 1)
            (while (looking-at "^.+[:].+$")
              (forward-line 1))
            (forward-line 1)
            (delete-region (point-min) (point))))
      (buffer-string))))


(defun httpeval ( url )
  (interactive (list (read-from-minibuffer "url: " "http://")))
  (save-excursion
    (with-temp-buffer
      (insert-buffer (url-retrieve-synchronously url))
      (goto-char (point-min))
      (if (looking-at "^HTTP/1.1 200 OK$")
          (progn
            (forward-line 1)
            (while (looking-at "^.+[:].+$")
              (forward-line 1))
            (forward-line 1)
            (delete-region (point-min) (point))))
      (eval-current-buffer))))


;; 다음과 같이 authentication 을 사용할 수 있다. 
;; http://stackoverflow.com/questions/1597959/how-does-emacs-url-package-handle-authentication
;; http://www.emacswiki.org/emacs/UrlPackage

;; M-x mail 을 이용하여 메일을 전송할 수 있다. 
;;(setq send-mail-function 'sendmail-send-it)
;;(setq sendmail-program "C:/usr/local/msmtp/msmtp.exe")
;;(setq message-sendmail-extra-arguments '("-a" "gmail"))
;;(setq mail-host-address "gmail.com")
;;(setq user-full-name "dongce")
;;(setq user-mail-address "dongce@gmail.com")
;;
;;http://kaisyu.springnote.com/pages/575011.xhtml


;; post 메시지를 전송할 수 있다. 
(require 'http-post-simple)
;; 다음과 같이 메일전송가능 
;;(http-post-simple 
;; "http://10.239.12.219/singlemail/send_bitten_result"
;; '((title       . "TEST EMACS MAIL")
;;   (sender      . "di7979.kim@samsung.com")
;;   (recipients  . "di7979.kim@samsung.com" )
;;   (txtcontents . "한글을 사용할 수 있다. "))
;; 'utf-8)


;;; Emacs/W3 설정
(condition-case () (require 'w3-auto "w3-auto") (error nil))
(add-hook 'w3-parse-hooks 'w3-tidy-page)
(defvar w3-fast-parse-tidy-program "tidy")
(defun w3-tidy-page (&optional buff)
  "Use html tidy to clean up the HTML in the current buffer."
  (save-excursion
    (if buff
	(set-buffer buff)
      (setq buff (current-buffer)))
    (widen)
    (call-process-region (point-min) (point-max)
			 w3-fast-parse-tidy-program
			 t (list buff nil) nil ;nil nil nil;
			 "--show-warnings" "no" "--show-errors" "0" "--force-output" "yes"
			 "-quiet" "-clean" "-bare" "-omit"
			 "--drop-proprietary-attributes" "yes" "--hide-comments" "yes"
			 )))
