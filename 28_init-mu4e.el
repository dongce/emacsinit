
;;;_ emacs 버그 - TZ 환경 변수를 정상적으로 처리하지 못한다. 
;;(setenv "TZ" "ROK")                     ;mingw 프로그램 영향 

;;http://emacswiki.org/emacs/LoadPath

(use-package mu4e

  :init
  (cond ((eq window-system 'w32)
         (let ((default-directory (fullpath "../../mumailindexer/share/emacs/site-lisp")))
           (normal-top-level-add-subdirs-to-load-path))
         (append-path (fullpath "../../mumailindexer/bin/")))
        (t
         (let ((default-directory  "/opt/emacs/mumail/default/share/emacs/site-lisp"))
           (normal-top-level-add-subdirs-to-load-path))
         (append-path  "/opt/emacs/mumail/default/bin/")))
  :config
  (setq mu4e-bookmarks
        '( ("flag:unread AND NOT flag:trashed" "Unread messages"      ?u)
           ("date:1d..now"                  "오늘의 메일"     ?t)
           ("flag:attach"       "첨부파일있음"     ?a)
           ("date:8d..now"                     "Last 7 days"          ?w)
           ("mime:image/*"                     "Messages with images" ?p)))

  (defun bmkp-mu4e-helper ( subject docid)
    (let* ((bookmark-name (format "%d-%s" docid subject ))
           (bookmark-record (bookmark-get-bookmark bookmark-name t )))
      
      (if bookmark-record
          (message "북마크가 이미 존재합니다.")
        
        (progn
          (bmkp-make-function-bookmark
           bookmark-name
           (format "(lambda () (mu4e~proc-view %d nil nil))" docid))
          (message (format "\"%s\" 메일에 대하여 북마크를 완료하였습니다." subject))
          (bookmark-edit-annotation bookmark-name )))))
  
  (defun bmkp-mu4e-view ()
    (interactive)
    (let* ((subject (mu4e-message-field mu4e~view-msg :subject))
           (docid (mu4e-message-field mu4e~view-msg :docid)))
      (bmkp-mu4e-helper subject docid)))

  (defun bmkp-mu4e-header ()
    (interactive)
    (let* ((msg (mu4e-message-at-point))
           (subject (mu4e-message-field msg :subject))
           (docid (mu4e-message-field msg :docid)))
      (bmkp-mu4e-helper subject docid)))


  (defun mu4e-filename (msg)
    (decode-coding-string (string-as-unibyte (mu4e-message-field msg :path)) 'utf-8))

  (defun copy-mu4e-header ()
    (interactive)
    (let* ((msg (mu4e-message-at-point))
           (subject (mu4e-message-field msg :subject))
           (path    (mu4e-message-field msg :path))
           (docid (mu4e-message-field msg :docid)))
      (kill-new (format "%s %s : (lambda ()  (mu4e~proc-view %d nil nil))" subject path docid))))

  (defun open-mu4e-header ()
    (interactive)
    (w32-shell-execute
     nil
     (mu4e-message-field (mu4e-message-at-point) :path )
     nil
     1)
    )
  

  (defun copy-mu4e-view ()
    (interactive)
    (let* ((subject (mu4e-message-field mu4e~view-msg :subject))
           (path    (mu4e-filename mu4e~view-msg ))
           (docid (mu4e-message-field mu4e~view-msg :docid)))
      (kill-new (format "%s %s (lambda () (mu4e~proc-view %d nil nil))" subject path docid))))

  (defun open-mu4e-view ()
    (interactive)
    (w32-shell-execute nil (mu4e-message-field mu4e~view-msg :path) nil 1))

  (setf mu4e-field-list '(:path :docid :from :to :cc :subject :date :size :message-id  :maildir :priority :flags :attachments :references )) ;:parts


  (defun mu4e-field-header ()
    (interactive)
    (mu4e-field-helper (mu4e-message-at-point) mu4e-field-list))

  (defun mu4e-field-view ()
    (interactive)
    (mu4e-field-helper mu4e~view-msg (cons ':parts mu4e-field-list)))

  (defun find-file-mu4e()
    (interactive)
    (let* ((msg (mu4e-message-at-point))
           (path    (mu4e-message-field msg :path))
           )
      (find-file path)))

  (defun copy-file-mu4e()
    (interactive "r")
    (let* ((msg (mu4e-message-at-point))
           (filename (buffer-substring-no-properties (region-beginning) (region-end)))
           (path    (mu4e-message-field msg :path)))

      (find-file path)))


  

  (defun mu4e-field-helper (msg fieldlist )
    "Retrieve FIELD from message plist MSG.
FIELD is one of :from, :to, :cc, :bcc, :subject, :data,
:message-id, :path, :maildir, :priority, :attachments,
:references, :in-reply-to, :body-txt, :body-html

Returns `nil' if the field does not exist.

A message plist looks something like:
\(:docid 32461
 :from ((\"Nikola Tesla\" . \"niko@example.com\"))
 :to ((\"Thomas Edison\" . \"tom@example.com\"))
 :cc ((\"Rupert The Monkey\" . \"rupert@example.com\"))
 :subject \"RE: what about the 50K?\"
 :date (20369 17624 0)
 :size 4337
 :message-id \"6BDC23465F79238C8233AB82D81EE81AF0114E4E74@123213.mail.example.com\"
 :path  \"/home/tom/Maildir/INBOX/cur/133443243973_1.10027.atlas:2,S\"
 :maildir \"/INBOX\"
 :priority normal
 :flags (seen)
 :attachments
     ((:index 2 :name \"photo.jpg\" :mime-type \"image/jpeg\" :size 147331)
      (:index 3 :name \"book.pdf\" :mime-type \"application/pdf\" :size 192220))
 :references  (\"6BDC23465F79238C8384574032D81EE81AF0114E4E74@123213.mail.example.com\"
 \"6BDC23465F79238203498230942D81EE81AF0114E4E74@123213.mail.example.com\")
 :in-reply-to \"6BDC23465F79238203498230942D81EE81AF0114E4E74@123213.mail.example.com\"
 :body-txt \"Hi Tom, ...\"
\)).
Some notes on the format:
- The address fields are lists of pairs (NAME . EMAIL), where NAME can be nil.
- The date is in format emacs uses in `current-time'
- Attachments are a list of elements with fields :index (the number of
  the MIME-part), :name (the file name, if any), :mime-type (the
  MIME-type, if any) and :size (the size in bytes, if any).
- Messages in the Headers view come from the database and do not have
  :attachments, :body-txt or :body-html fields. Message in the
  Message view use the actual message file, and do include these fields."
    ;; after all this documentation, the spectacular implementation

    (interactive)
    (let* ((field (ido-completing-read 
                   "속정을 입력하세요: "
                   (mapcar (lambda (x) (symbol-name  x)) fieldlist )))
           (value (format "%s" (mu4e-message-field msg (intern field)))))
      (kill-append value nil )
      (message value)
      ))

  (define-key mu4e-headers-mode-map (kbd "!")             'open-mu4e-header)
  (define-key mu4e-headers-mode-map (kbd "@")             'copy-mu4e-header)
  (define-key mu4e-headers-mode-map (kbd "*")             'bmkp-mu4e-header)
  (define-key mu4e-headers-mode-map (kbd "<kp-multiply>") 'bmkp-mu4e-header)
  (define-key mu4e-headers-mode-map (kbd "F")             'find-file-mu4e)
  (define-key mu4e-headers-mode-map (kbd "f")             'mu4e-field-header)


  (define-key mu4e-view-mode-map (kbd "!")             'open-mu4e-view)
  (define-key mu4e-view-mode-map (kbd "@")             'copy-mu4e-view)
  (define-key mu4e-view-mode-map (kbd "*")             'bmkp-mu4e-view)
  (define-key mu4e-view-mode-map (kbd "<kp-multiply>") 'bmkp-mu4e-view)
  (define-key mu4e-view-mode-map (kbd "F") 'find-file-mu4e)
  (define-key mu4e-view-mode-map (kbd "f") 'mu4e-field-view)

  ;; 메일을 볼 때 HTML 을 rendering 한다. 
  (require 'htmlr)                        

  ;; (add-hook 
  ;;  'mu4e-view-mode-hook
  ;;  #'htmlr-render)


  (defun shr-render ()
    "Display the HTML rendering of the current buffer."
    (interactive )
    (or (fboundp 'libxml-parse-html-region)
        (error "This function requires Emacs to be compiled with libxml2"))
    (save-excursion 
      (save-restriction 
        (narrow-to-region (point) (point-max))
        (shr-insert-document
         (libxml-parse-html-region (point-min) (point-max)))
        (delete-region (point) (point-max))
        )))      


  (defun shr-insert-document-temp (dom)
    "Render the parsed document DOM into the current buffer.
DOM should be a parse tree as generated by
`libxml-parse-html-region' or similar."
    (setq shr-content-cache nil)
    (let ((start (point))
          (shr-state nil)
          (shr-start nil)
          (shr-base nil)
          (shr-preliminary-table-render 0)
          (shr-width (or shr-width (1- (window-width)))))
      (shr-descend (shr-transform-dom dom))))
  ;; (shr-remove-trailing-whitespace start (point))))

  (defun shr-render-temp ()
    "Display the HTML rendering of the current buffer."
    (interactive )
    (or (fboundp 'libxml-parse-html-region)
        (error "This function requires Emacs to be compiled with libxml2"))
    (save-excursion 
      (save-restriction

        (let ((dom (libxml-parse-html-region (point-min) (point-max))))
          (with-temp-file "c:/temp.txt"
            (shr-insert-document-temp dom)))
        (delete-region (point) (point-max)))))


  (define-key 
    mu4e-view-mode-map "l" 
    (lambda () 
      (interactive)
      (toggle-read-only 0 )
      (htmlr-render)
      (mu4e-view-mode)))


  ;;http://stackoverflow.com/questions/9942675/in-elisp-how-do-i-put-a-function-in-a-variable
  (fset 'mu4e-view-origin #'mu4e-view)       ;원본버젼 
  ;;(funcall 'mu4e-view-origin)              호출방법 
  ;;oldversion;;(defun mu4e-view (msg headersbuf &optional refresh)
  ;;oldversion;;  "Display the message MSG in a new buffer, and keep in sync with HDRSBUF.
  ;;oldversion;;'In sync' here means that moving to the next/previous message in
  ;;oldversion;;the the message view affects HDRSBUF, as does marking etc.
  ;;oldversion;;
  ;;oldversion;;REFRESH is for re-showing an already existing message.
  ;;oldversion;;
  ;;oldversion;;As a side-effect, a message that is being viewed loses its 'unread'
  ;;oldversion;;marking if it still had that."
  ;;oldversion;;  (let* ((embedded ;; is it registered as an embedded msg (ie. message/rfc822
  ;;oldversion;;          ;; att)?
  ;;oldversion;;          (when (gethash (mu4e-message-field msg :path)
  ;;oldversion;;                         mu4e~path-parent-docid-map) t))
  ;;oldversion;;         (buf
  ;;oldversion;;          (if embedded
  ;;oldversion;;              (mu4e~view-embedded-winbuf)
  ;;oldversion;;            (get-buffer-create mu4e~view-buffer-name))))
  ;;oldversion;;    (with-current-buffer buf
  ;;oldversion;;      (let ((inhibit-read-only t))
  ;;oldversion;;        (setq ;; buffer local
  ;;oldversion;;         mu4e~view-msg msg
  ;;oldversion;;         mu4e~view-headers-buffer headersbuf)
  ;;oldversion;;        (erase-buffer)
  ;;oldversion;;        (insert (mu4e-view-message-text msg))
  ;;oldversion;;        (switch-to-buffer buf)
  ;;oldversion;;        (goto-char (point-min))
  ;;oldversion;;        (mu4e~view-fontify-cited)
  ;;oldversion;;        (mu4e~view-fontify-footer)
  ;;oldversion;;        (mu4e~view-make-urls-clickable)
  ;;oldversion;;        (mu4e~view-show-images-maybe msg)
  ;;oldversion;;        
  ;;oldversion;;        (save-excursion          ;;!!!ticket:XXXX 20121130 김동일 | HTML RENDERING
  ;;oldversion;;          (goto-char (point-min));;!!!ticket:XXXX 20121130 김동일 | HTML RENDERING
  ;;oldversion;;          (forward-paragraph)    ;;!!!ticket:XXXX 20121130 김동일 | HTML RENDERING
  ;;oldversion;;          (htmlr-render)
  ;;oldversion;;          ;; (shr-render)
  ;;oldversion;;          )        ;;!!!ticket:XXXX 20121130 김동일 | HTML RENDERING
  ;;oldversion;;
  ;;oldversion;;        (if embedded
  ;;oldversion;;            (local-set-key "q" 'kill-buffer-and-window)
  ;;oldversion;;          (setq mu4e~view-buffer buf))
  ;;oldversion;;
  ;;oldversion;;        (unless (or refresh embedded)
  ;;oldversion;;          ;; no use in trying to set flags again, or when it's an embedded
  ;;oldversion;;          ;; message
  ;;oldversion;;          (mu4e~view-mark-as-read-maybe))
  ;;oldversion;;
  ;;oldversion;;        (mu4e-view-mode)))))
  ;;oldversion;;(defun mu4e~view-mark-as-read-maybe () "not implemented mu.  do nothing ")

  ;;TEST;;(setq mu4e-mu-binary "c:/usr/local/mingwdevkit/local/bin/mu.exe")
  ;;TEST;;(setq mu4e-debug t)
  ;;TEST;;(mu4e~proc-find
  ;;TEST;; "from:bluewindie@gmail.com"
  ;;TEST;; mu4e-headers-show-threads
  ;;TEST;; mu4e-headers-sortfield
  ;;TEST;; mu4e-headers-sort-revert
  ;;TEST;; (unless mu4e-headers-full-search mu4e-search-results-limit))
  ;;TEST;;
  ;;TEST;;(setq mu4e~proc-buf "")
  ;;TEST;;(setq mu4e~proc-buf (string-replace-match "" mu4e~proc-buf "" t t ))
  ;;TEST;;(setq x (mu4e~proc-eat-sexp-from-buf))
  ;;TEST;;(mu4e~view-make-urls-clickable)
  ;;TEST;;
  ;;TEST;;
  ;;TEST;;(mu4e~proc-view docid nil nil)
  ;;TEST;;
  ;;TEST;;move docid:27047  flags:+S-u-N 
  ;;TEST;;
  ;;TEST;;extract action:open docid:26759 index:2

  (fset 'mu4e-mark-execute-all-origin #'mu4e-mark-execute-all)       ;원본버젼 

  (defun mu4e-mark-execute-all (&optional no-confirmation)
    "Execute the actions for all marked messages in this
buffer. After the actions have been executed succesfully, the
affected messages are *hidden* from the current header list. Since
the headers are the result of a search, we cannot be certain that
the messages no longer matches the current one - to get that
certainty, we need to rerun the search, but we don't want to do
that automatically, as it may be too slow and/or break the users
flow. Therefore, we hide the message, which in practice seems to
work well.

If NO-CONFIRMATION is non-nil, don't ask user for confirmation."
    (interactive)
    (let ((markmap mu4e~mark-map)
          (marknum (hash-table-count mu4e~mark-map)))
      (if (zerop marknum)
          (message "Nothing is marked")
        (mu4e-mark-resolve-deferred-marks)
        (when (or no-confirmation
                  (y-or-n-p
                   (format "Are you sure you want to execute %d mark%s?"
                           marknum (if (> marknum 1) "s" ""))))

          (kill-new "")
          (maphash
           (lambda (docid val)
             (let ((mark (car val)) (target (cdr val)))
               ;; note: whenever you do something with the message,
               ;; it looses its N (new) flag
               (mu4e~headers-goto-docid docid)
               (case mark
                 (refile  (mu4e~proc-move docid (mu4e~mark-check-target target) "-N"))
                 (delete  (mu4e~proc-remove docid))
                 (flag    (kill-append 
                           (format "(mu4e~proc-view %d nil nil) : %s %s %s \n"
                                   docid
                                   (format-time-string mu4e-headers-date-format (mu4e~headers-field-for-docid docid :date))
                                   (mu4e~headers-field-for-docid docid :from)
                                   (mu4e~headers-field-for-docid docid :subject)
                                   ) nil));;(mu4e~proc-move docid nil    "+F-u-N"))
                 (move    (mu4e~proc-move docid (mu4e~mark-check-target target) "-N"))
                 (read    (mu4e~proc-move docid nil    "+S-u-N"))
                 (trash   (mu4e~proc-move docid (mu4e~mark-check-target target) "+T-N"))
                 (unflag  (mu4e~proc-move docid nil    "-F-N"))
                 (unread  (mu4e~proc-move docid nil    "-S+u-N"))
                 (otherwise (mu4e-error "Unrecognized mark %S" mark)))))
           markmap)
          )
        (mu4e-mark-unmark-all)
        (message nil))))



  (fset 'mu4e~proc-start-origin #'mu4e~proc-start)       ;원본버젼 
  ;;(funcall 'mu4e-view-origin)              호출방법 

  (defun mu4e~proc-start ()
    "Start the mu server process."
    (unless (file-executable-p mu4e-mu-binary)
      (mu4e-error (format "`mu4e-mu-binary' (%S) not found" mu4e-mu-binary)))
    (let* ((process-connection-type nil) ;; use a pipe
           (args '("server"))
           (args (append args (when mu4e-mu-home
                                (list (concat "--muhome=" mu4e-mu-home))))))
      (setq mu4e~proc-buf "")
      (setq mu4e~proc-process (apply 'start-process
                                     mu4e~proc-name mu4e~proc-name
                                     mu4e-mu-binary args))
      ;; register a function for (:info ...) sexps
      (unless mu4e~proc-process
        (mu4e-error "Failed to start the mu4e backend"))
      (set-process-query-on-exit-flag mu4e~proc-process nil)
      (set-process-coding-system mu4e~proc-process 'binary 'utf-8)
      (set-process-filter mu4e~proc-process 'mu4e~proc-filter)
      (set-process-sentinel mu4e~proc-process 'mu4e~proc-sentinel)))



  (fset 'mu4e~view-mark-as-read-maybe-origin #'mu4e~view-mark-as-read-maybe)       ;원본버젼 


  ;; (defun mu4e~proc-view (docid-or-msgid &optional images decrypt)
  ;;   "Get one particular message based on its DOCID-OR-MSGID.
  ;; Optionally, if IMAGES is non-nil, backend will any images
  ;; attached to the message, and return them as temp files.
  ;; The result will be delivered to the function registered as
  ;; `mu4e-message-func'."
  ;;   (mu4e~proc-send-command
  ;;     "view %s extract-images:%s extract-encrypted:%s use-agent:true"
  ;;     (mu4e--docid-msgid-param docid-or-msgid)
  ;;     (if images "true" "false")
  ;;     (if decrypt "true" "false")))
  
  )


(use-package helm-mu
  :config 
  (defvar mucontacts-source
    (helm-build-in-buffer-source "mu를 이용하여 메일주소를 검색합니다."
      :data #'helm-mu-contacts-init
      :filtered-candidate-transformer #'helm-mu-contacts-transformer
      :fuzzy-match nil
      :action '(("메일주소를 가져옵니다. " .
                 (lambda (_candidate)
                   (insert
                    (s-join "," (mapcar #'first (mapcar #'split-string (helm-marked-candidates)))))))
                )))

  (defun mucontacts ()
    "Search for contacts."
    (interactive)
    (helm :sources 'mucontacts-source
          :buffer "*helm mu contacts*")))



;;; mu db 위치
;;; %HOME%/.mu
  
;;; index 순서 
;;mu index -m f:/single-repo
;;mu index -m f:/MYSINGLE
;;mu index -m g:/MYSINGLE
;;mu index -m F:/MYSINGLE201211

;;mu index -m g:/MYSINGLE2013
;;mu index -m f:/MYSINGLE20130318
;;mu index -m f:/MYSINGLE20130416

;;mu index -m f:/single-repo & mu index -m f:/MYSINGLE & mu index -m g:/MYSINGLE & mu index -m g:/MYSINGLE2013 & mu index -m f:/MYSINGLE20130318 & mu index -m f:/MYSINGLE20130416
