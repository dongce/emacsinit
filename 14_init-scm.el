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


(load-library "psvn" )
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



;;(global-set-key (kbd "M-n") 'ecb-goto-window-compilation)
(global-set-key (kbd "M-N") 'ecb-toggle-ecb-windows)
(global-set-key (kbd "C-M-]") '(lambda() ( interactive )  (delete-other-windows) (ecb-toggle-compile-window -1 ) ))
(global-set-key [C-M-backspace] 'ecb-toggle-compile-window)

;;  Basic q-commands: 
;;  
;;      qadd - GUI for adding files or directories.
;;      qannotate - Show the origin of each line in a file.
;;      qbind - Convert the current branch into a checkout of the supplied branch.
;;      qbranch - Create a new copy of a branch.
;;      qcat - View the contents of a file as of a given revision.
;;      qcommit - GUI for committing revisions.
;;      qconflicts - Show conflicts.
;;      qdiff - Show differences in working tree in a GUI window.
;;      qexport - Export current or past revision to a destination directory or archive.
;;      qinfo - Shows information about the current location.
;;      qinit - Initializes a new branch or shared repository.
;;      qlog - Show log of a repository, branch, file, or directory in a Qt window.
;;      qmerge - Perform a three-way merge.
;;      qplugins - Display information about installed plugins.
;;      qpull - Turn this branch into a mirror of another branch.
;;      qpush - Update a mirror of this branch.
;;      qrevert - Revert changes files.
;;      qsend - Mail or create a merge-directive for submitting changes.
;;      qswitch - Set the branch of a checkout and update.
;;      qtag - Edit tags.
;;      qunbind - Convert the current checkout into a regular branch.
;;      quncommit - Move the tip of a branch to an earlier revision.
;;      qupdate - Update working tree with latest changes in the branch.
;;      qverify-signatures - Show digital signatures information.
;;      qversion - Show version/system information. 
;;  
;;  Hybrid dialogs:
;;  
;;      qgetnew - Creates a new working tree (either a checkout or full branch).
;;      qgetupdates - Fetches external changes into the working tree. 
;;  
;;  Additional commands:
;;  
;;      qbrowse - Show inventory or working tree.
;;      qconfig - Configure Bazaar and QBzr.
;;      qrun - Run arbitrary bzr command.
;;      qviewer - Simple file viewer. 

(defvar bzrexe "c:\\usr\\local\\python27\\Scripts\\bzr.bat")
;;(setq bzrexe  "t:\\usr\\local\\bazaar\\bzr.exe")

(defun qbzr ()
  (interactive)
  (let ((cmd 
         ;;deprecatedby ido-complete-read;;(completing-read "명령을 입력하세요: "
         ;;deprecatedby ido-complete-read;;                 (mapcar (function (lambda (x) (list x t)))
         ;;deprecatedby ido-complete-read;;                         `(
         ;;deprecatedby ido-complete-read;;                           qadd
         ;;deprecatedby ido-complete-read;;                           qannotate
         ;;deprecatedby ido-complete-read;;                           qbind
         ;;deprecatedby ido-complete-read;;                           qbranch
         ;;deprecatedby ido-complete-read;;                           qcat
         ;;deprecatedby ido-complete-read;;                           qcommit
         ;;deprecatedby ido-complete-read;;                           qconflicts
         ;;deprecatedby ido-complete-read;;                           qdiff
         ;;deprecatedby ido-complete-read;;                           qexport
         ;;deprecatedby ido-complete-read;;                           qinfo
         ;;deprecatedby ido-complete-read;;                           qinit
         ;;deprecatedby ido-complete-read;;                           qlog
         ;;deprecatedby ido-complete-read;;                           qmerge
         ;;deprecatedby ido-complete-read;;                           qplugins
         ;;deprecatedby ido-complete-read;;                           qpull
         ;;deprecatedby ido-complete-read;;                           qpush
         ;;deprecatedby ido-complete-read;;                           qrevert
         ;;deprecatedby ido-complete-read;;                           qsend
         ;;deprecatedby ido-complete-read;;                           qswitch
         ;;deprecatedby ido-complete-read;;                           qtag
         ;;deprecatedby ido-complete-read;;                           qunbind
         ;;deprecatedby ido-complete-read;;                           quncommit
         ;;deprecatedby ido-complete-read;;                           qupdate
         ;;deprecatedby ido-complete-read;;                           qverif
         ;;deprecatedby ido-complete-read;;                           qversion
         ;;deprecatedby ido-complete-read;;                           qgetnew
         ;;deprecatedby ido-complete-read;;                           qgetupdates
         ;;deprecatedby ido-complete-read;;                           qbrowse
         ;;deprecatedby ido-complete-read;;                           qconfig
         ;;deprecatedby ido-complete-read;;                           qrun
         ;;deprecatedby ido-complete-read;;                           qviewer
         ;;deprecatedby ido-complete-read;;                           explorer
         ;;deprecatedby ido-complete-read;;                           ))
         ;;deprecatedby ido-complete-read;;                 nil t nil nil "qlog")))
         (ido-completing-read "명령을 입력하세요: "
                              (mapcar (function (lambda (x) (symbol-name x )))
                                  `(
                                    qlog
                                    qadd
                                    qannotate
                                    qbind
                                    qbranch
                                    qcat
                                    qcommit
                                    qconflicts
                                    qdiff
                                    qexport
                                    qinfo
                                    qinit
                                    qmerge
                                    qplugins
                                    qpull
                                    qpush
                                    qrevert
                                    qsend
                                    qswitch
                                    qtag
                                    qunbind
                                    quncommit
                                    qupdate
                                    qverif
                                    qversion
                                    qgetnew
                                    qgetupdates
                                    qbrowse
                                    qconfig
                                    qrun
                                    qviewer
                                    explorer
                                    )))))

    (w32-shell-execute nil bzrexe cmd 0 )))


(require 'dvc-autoloads)
(setq bzr-executable "bzremacs.bat")
(setq dvc-sh-executable "t:/usr/local/mingwDevKit/bin/sh.exe" )
(dired ".")                             ;; DIRED 가 열리지 않으면 DVC 초기화가 정상적이지  않다. 

(remove-from-list 'auto-mode-alist '("/COMMIT_EDITMSG$" . xgit-log-edit-mode))



(defun get-diff-coding (bcoding) 
  (cond
   ((member bcoding '(cp949)) 'cp949-dos)
   ((member bcoding '(utf-8)) 'utf8-dos)
   (t 'cp949-dos ;;undecided-dos
      )
   )
)


(require 'git)


(require 'helm-github-stars)


