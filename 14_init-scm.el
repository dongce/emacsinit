;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SVN 관련
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; svn-status-toggle-svn-verbose-flag 함수를 이용하여 변경가능하다. 
;;(setq svn-status-verbose t)

;; 다음을 이용해 바로 commit 이 가능하지만 필요없다. 
;;(defun svn-commit-dir ( dir )
;;  "Commit selected files.
;;If some files have been marked, commit those non-recursively;
;;this is because marking a directory with \\[svn-status-set-user-mark]
;;normally marks all of its files as well.
;;If no files have been marked, commit recursively the file at point."
;;  (interactive (list (svn-read-directory-name "SVN status directory: "
;;                                              nil default-directory nil)))
;;
;;  (switch-to-buffer (dired-noselect dir ""))
;;  (svn-status-commit))
;;(global-set-key (kbd "C-.") 'svn-commit-dir)


(use-package psvn )
;;(load-library "dsvn" )                  ;; subversion 1.7 이상 
;;(setq svn-call-process-function 'call-process )
;;(setq svn-start-process-function 'start-process )

(defun link11-commit ()
  (interactive)
  (set-buffer (dired-noselect "c:/FFX/CFCS/DLP_LINK11"))
  (svn-status-commit))

(defun isdl-commit ()
  (interactive)
  (set-buffer (dired-noselect "c:/FFX/CFCS/DLP_ISDL"))
  (svn-status-commit))

(add-hook 'svn-log-edit-mode-hook
	  '(lambda () (set-buffer-file-coding-system 'cp949)))


(defvar ticket-history nil
  "History list for some commands that read regular expressions.

Maximum length of the history list is determined by the value
of `history-length', which see.")


(defun read-ticket-number (prompt &optional default)
  "Read a numeric value in the minibuffer, prompting with PROMPT.
DEFAULT specifies a default value to return if the user just types RET.
The value of DEFAULT is inserted into PROMPT."
  (let* ((n nil)
         (history-delete-duplicates t )
         (history-add-new-input nil)     ;;수동으로 history 에 포함 필요 
        )
    (when default
      (setq prompt
            (if (string-match "\\(\\):[ \t]*\\'" prompt)
                (replace-match (format " (기본값 %s)" default) t t prompt 1)
              (replace-regexp-in-string "[ \t]*\\'"
                                        (format " (기본값 %s) " default)
                                        prompt t t))))
    (while
        (progn
          (let ((str (read-from-minibuffer prompt nil nil nil 'ticket-history default)))
            (condition-case nil
                (setq n (cond
                         ((zerop (length str)) default)
                         ((stringp str) (prog1 (read str) (add-to-history 'ticket-history str))))) ;number-to-string
              (error nil)))
          (unless (numberp n)
            (message "숫자를 입력해 주세요.")
            (sit-for 1)
            t)))
    n))


(defun ticket (tn)
  (interactive (list (read-ticket-number "티켓번호를 입력해 주세요 : " (car ticket-history))))
  (insert ( format "//!!!ticket:%d %s 김동일 | " tn (format-time-string "%Y%m%d"))))

(defun nticket (tn)
  (interactive (list (read-ticket-number "티켓번호를 입력해 주세요 : " (car ticket-history))))
  (insert ( format "%d" tn )))

(defun dticket (tn)
  (interactive (list (read-ticket-number "티켓번호를 입력해 주세요 : " (car ticket-history))))
  (insert ( format "//DEPRECATEDBY-ticket:%d//" tn )))

(defun lticket (tn)
  (interactive (list (read-ticket-number "티켓번호를 입력해 주세요 : " (car ticket-history))))
  (insert ( format "//!!!lst-ticket:%d %s 김동일 | " tn (format-time-string "%Y%m%d"))))




(defun ffxlog ()
  (interactive)
  (insert-file "t:/usr/local/ffxsvn-dev/log-template.txt"))



;;deprecated-tooslow;;;;(setq semantic-load-turn-useful-things-on t)
;;deprecated-tooslow;;(require 'cedet)
;;deprecated-tooslow;;(require 'ecb)
;;deprecated-tooslow;;;; 에러시에 trace 윈도우 생성 
;;deprecated-tooslow;;(setq stack-trace-on-error nil )
;;deprecated-tooslow;;(setq ecb-tip-of-the-day nil)
;;deprecated-tooslow;;(setq ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
;;deprecated-tooslow;;;;(ecb-activate)
;;deprecated-tooslow;;(ecb-toggle-ecb-windows -1 )

(defun smerge ()
  (interactive)
  (let ((cmd 
         (completing-read "명령을 입력하세요: "
                          (mapcar (function (lambda (x) (list x t)))
                                  `(
                                    next                
                                    prev                
                                    resolve             
                                    all-keep            
                                    base-keep           
                                    other-keep          
                                    mine-keep           
                                    keep-current
                                    ediff               
                                    combine-with-next   
                                    refine              
                                    diff-base-mine      
                                    diff-base-other     
                                    diff-mine-other     
                                    ))
                          nil t nil nil "next")))
    (funcall
     (cdr 
      (assoc 
       (intern cmd )
       '(
         (next                . smerge-next              )
         (prev                . smerge-prev              )
         (resolve             . smerge-resolve           )
         (all-keep            . smerge-keep-all          )
         (base-keep           . smerge-keep-base         )
         (other-keep          . smerge-keep-other        )
         (mine-keep           . smerge-keep-mine         )
         (keep-current        . smerge-keep-current      )
         (ediff               . smerge-ediff             )
         (combine-with-next   . smerge-combine-with-next )
         (refine              . smerge-refine            )
         (diff-base-mine      . smerge-diff-base-mine    )
         (diff-base-other     . smerge-diff-base-other   )
         (diff-mine-other     . smerge-diff-mine-other   )))))))
                                   
(global-set-key (kbd "M-n") 'smerge)
