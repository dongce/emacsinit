;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t; lexical-binding: t ;-*-

(defmacro w32-unix-eval ( w32 unix )
  (if (eq window-system 'w32)
      `(progn ,@w32)
    `(progn ,@unix)))


(defun eheader ()
  (interactive) 
  (save-excursion
    (save-restriction
      (narrow-to-region (point-min) (point-min))
      (insert "-*- coding: utf-8; -*-\n")
      (comment-region (point-min) (point-max))
      )))

(defun etrailer ()
  (interactive) 
  (save-excursion
    (save-restriction
      (narrow-to-region (point-max) (point-max))
      (insert "Local Variables:  \n")
      (insert "mode: allout-minor\n")
      (insert "End:              \n")
      (comment-region (point-min) (point-max))
      )))



(defun bin2hexl(fromfile ) 
  (interactive)
  (with-current-buffer (find-file fromfile)
    (hexl-mode)
    (let ((str (buffer-string)))
      (with-temp-file (format "%s.hexl" fromfile)
        (insert str)        
        ))))

(defmacro aif (&rest forms)
  "Create an anonymous interactive function.
    Mainly for use when binding a key to a non-interactive function."
  `(lambda () (interactive) ,@forms))

;;; Calling it from IELM yields the following answer:
;;; 
;;; ELISP> (hms-to-dec "37°26′36.42″N 06°15′14.28″W")

(defun hms-to-dec (hms-str)
  (let ((hms (split-string hms-str "[°′″NW ]" t)))
    (cl-flet ((to-deg ()
                   (string-to-number
                    (calc-eval (format "deg(%s@ %s' %s\")"
                                       (pop hms) (pop hms) (pop hms))))))
      (list (to-deg) (to-deg)))))

(defun calc-eval-region (begin end )
  (interactive "r")
  (let ((result (calc-eval (filter-buffer-substring begin end))))
    (set-register ?r result )
    (message "결과 : %s" result )))

;;deprecated;;(defun mt-repl (a b files )
;;deprecated;;  (interactive)
;;deprecated;;  (mapcar 
;;deprecated;;   (lambda ( funcname )
;;deprecated;;     (if (symbolp funcname ) (setq funcname (symbol-name funcname )))
;;deprecated;;
;;deprecated;;     (macrolet (( with-writable-file 
;;deprecated;;                  (&rest body)
;;deprecated;;                  `(let ((omodes (file-modes ,funcname)))
;;deprecated;;                     (set-file-modes ,funcname (logior omodes 128 ))
;;deprecated;;                     (with-current-buffer (find-file ,funcname)
;;deprecated;;                       (read-only-mode  -2 )
;;deprecated;;                       ,@body)
;;deprecated;;                     (set-file-modes ,funcname omodes))))
;;deprecated;;       (with-writable-file 
;;deprecated;;        (replace-regexp a b )
;;deprecated;;        (basic-save-buffer)
;;deprecated;;        (kill-this-buffer)))) files ))


(defun save-macro (name)                  
  "save a macro. Take a name as argument
     and save the last defined macro under 
     this name at the end of your .emacs"
  (interactive "S매크로 이름을 입력해 주세요 :")  ; ask for the name of the macro    
  (kmacro-name-last-macro name)         ; use this name for the macro    
  (let ((macrofile "~/savemacro.el"))
    (let ((omodes (file-modes macrofile)))
      (set-file-modes macrofile (logior omodes 128 ))
      (with-current-buffer (find-file macrofile)
        (read-only-mode  -2 )
        (save-excursion
          (save-restriction
            (goto-char (point-max))               ; go to the end of the .emacs
            (newline)                             ; insert a newline
            (insert-kbd-macro name)               ; copy the macro 
            (newline)                             ; insert a newline
            
            (basic-save-buffer)
            (kill-this-buffer))))
      (set-file-modes macrofile omodes))))

(defun elisp ()
  (interactive)
  (ielm))


(defun what-hexadecimal-value ()
  "Prints the decimal value of a hexadecimal string under cursor.
Samples of valid input:

  ffff
  0xffff
  #xffff
  FFFF
  0xFFFF
  #xFFFF

Test cases
  64*0xc8+#x12c 190*0x1f4+#x258
  100 200 300   400 500 600"
  (interactive )

  (let (inputStr tempStr p1 p2 )
    (save-excursion
      (search-backward-regexp "[^0-9A-Fa-fx#]" nil t)
      (forward-char)
      (setq p1 (point) )
      (search-forward-regexp "[^0-9A-Fa-fx#]" nil t)
      (backward-char)
      (setq p2 (point) ) )

    (setq inputStr (buffer-substring-no-properties p1 p2) )

    (let ((case-fold-search nil) )
      (setq tempStr (replace-regexp-in-string "^0x" "" inputStr )) ; C, Perl, …
      (setq tempStr (replace-regexp-in-string "^#x" "" tempStr )) ; elisp …
      (setq tempStr (replace-regexp-in-string "^#" "" tempStr ))  ; CSS …
      )
    
    (message "Hex %s is %d" tempStr (string-to-number tempStr 16 ) )
    ))



(defun* get-closest-pathname (&optional (file "Makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
                      (loop 
                       for d = default-directory then (expand-file-name ".." d)
                       if (file-exists-p (expand-file-name file d))
                       return d
                       if (equal d root)
                       return nil))))

(defun 2zip ()
  "Zip the current file/dir in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip commandline tool."
  (interactive)
  (require 'dired)
  (let ( (fileName (elt (dired-get-marked-files) 0))  )
    (shell-command (format "zip -r '%s.zip' '%s'" (file-relative-name fileName) (file-relative-name fileName)))
    ))


(defun upward-find-file (filename &optional startdir)
  "Move up directories until we find a certain filename. If we
  manage to find it, return the containing directory. Else if we
  get to the toplevel directory and still can't find it, return
  nil. Start at startdir or . if startdir not given"

  (let ((dirname (expand-file-name
		  (if startdir startdir ".")))
	(found nil) ; found is set as a flag to leave loop if we find it
	(top nil))  ; top is set when we get
		    ; to / so that we only check it once

    ; While we've neither been at the top last time nor have we found
    ; the file.
    (while (not (or found top))
      ; If we're at / set top flag.
      (if (string= (expand-file-name dirname) "/")
	  (setq top t))
      
      ; Check for the file
      (if (file-exists-p (expand-file-name filename dirname))
	  (setq found t)
	; If not, move up a directory
	(setq dirname (expand-file-name ".." dirname))))
    ; return statement
    (if found dirname nil)))

;; ergoemacs 설정 입니다. 
;; ergoemacs 
(defun toggle-line-move-visual ()
  "Toggle behavior of up/down arrow key, by visual line vs logical line."
  (interactive)
  (if line-move-visual
      (setq line-move-visual nil)
    (setq line-move-visual t))
  )

(defun soft-wrap-lines ()
  "Make lines wrap at window edge and on word boundary,
in current buffer."
  (interactive)
  (setq truncate-lines nil)
  (setq word-wrap t)
  )


(defun sd ()
  (interactive)
  (dotimes (x 3 ) (forward-sexp))
  (beginning-of-line)
  (insert "default : break ; \n")
  (win-switch-dispatch)
  (next-line)
)

(defun ed ()
  (interactive)
  (right-char 1 )
  (insert "else{  }")
  (win-switch-dispatch)
  (next-line)

)


(defun in()
  (interactive)
  (forward-sexp)
  (insert "(0)")
  (win-switch-dispatch)
  (next-line)
)

(defun tst ()
 (interactive )
 (narrow-to-region (region-beginning) (region-end))
 (replace-string ":" " " nil (point-min) (point-max))
 (replace-regexp "([0-9])" "" nil (point-min) (point-max))
 (widen))

(defun tst2 ()
 (interactive )
 (insert "(topic-send \n '")
 (yank)
 (insert "\n`(\n"))

(defun tst3 ()
 (interactive )
 (insert "(topic-add '")
 (yank)
 (insert "\n"))




;;참고;;(defun fsproject-collect-files(root project-regexp file-filter &optional ignore-folders)
;;참고;;  "Parse the ROOT folder and all of it's sub-folder, and create a file list.
;;참고;;FILE-FILTER is a list of regexp which are used to filter the file list.
;;참고;;PROJECT-REGEXP should represent a regular expression which will help finding the project folders
;;참고;;If IGNORE-FOLDERS is non nil, it should specify a list of folder name to ignore.
;;참고;;
;;참고;;The return is a list of two lists: ((project...) (files...))
;;참고;;Note: the project list is sorted in descending alphabetic order."
;;참고;;  (let ((dir-list (directory-files-and-attributes root t))
;;참고;;     (ign-reg  (regexp-opt ignore-folders))
;;참고;;     file-list proj-list)
;;참고;;    (while dir-list
;;참고;;      (let* ((cur-node (pop dir-list))
;;참고;;          (fullpath (car cur-node))
;;참고;;          (is-dir   (eq (car (cdr cur-node)) t))
;;참고;;          (is-file  (not (car (cdr cur-node))))
;;참고;;          (basename (file-name-nondirectory fullpath)))
;;참고;;     (cond
;;참고;;     ;; if the current node is a directory different from "." or "..", all it's file gets added to the list
;;참고;;     ((and is-dir
;;참고;;            (not (string-equal basename "."))
;;참고;;            (not (string-equal basename ".."))
;;참고;;            (or (not ignore-folders)
;;참고;;             (not (string-match ign-reg basename))))
;;참고;;            (setq dir-list (append dir-list (directory-files-and-attributes fullpath t))))
;;참고;;     ;; if the current node is a file
;;참고;;     (is-file
;;참고;;       ;; check against the file filter, if it succeed: add the file to the file-list
;;참고;;       (when (some '(lambda (item) (string-match item basename)) file-filter)
;;참고;;         (setq file-list (cons fullpath file-list)))
;;참고;;       ;; check also against the project-regexp: if succeed, we had the base directory of the project of the project list
;;참고;;       ;; (including the final '/')
;;참고;;       (let ((pos (string-match project-regexp fullpath)))
;;참고;;         (when pos
;;참고;;           (setq proj-list (cons (cons (file-name-directory (substring fullpath 0 pos)) fullpath) proj-list)))
;;참고;;       )))))
;;참고;;    (cons (sort proj-list '(lambda (a b) (string-lessp (car a) (car b)))) file-list)))


(defun files(root  file-filter &optional ignore-folders)
  "Parse the ROOT folder and all of it's sub-folder, and create a file list.
FILE-FILTER is a list of regexp which are used to filter the file list.
PROJECT-REGEXP should represent a regular expression which will help finding the project folders
If IGNORE-FOLDERS is non nil, it should specify a list of folder name to ignore.

The return is a list of two lists: ((project...) (files...))
Note: the project list is sorted in descending alphabetic order."
  (let ((dir-list (directory-files-and-attributes root t))
     (ign-reg  (regexp-opt ignore-folders))
     file-list proj-list)
    (while dir-list
      (let* ((cur-node (pop dir-list))
          (fullpath (car cur-node))
          (is-dir   (eq (car (cdr cur-node)) t))
          (is-file  (not (car (cdr cur-node))))
          (basename (file-name-nondirectory fullpath)))
     (cond
     ;; if the current node is a directory different from "." or "..", all it's file gets added to the list
     ((and is-dir
            (not (string-equal basename "."))
            (not (string-equal basename ".."))
            (or (not ignore-folders)
             (not (string-match ign-reg basename))))
            (setq dir-list (append dir-list (directory-files-and-attributes fullpath t))))
     ;; if the current node is a file
     (is-file
       ;; check against the file filter, if it succeed: add the file to the file-list
       (when (some '(lambda (item) (string-match item basename)) file-filter)
         (setq file-list (cons fullpath file-list)))
       ;; check also against the project-regexp: if succeed, we had the base directory of the project of the project list
       ;; (including the final '/')
       ;;(let ((pos (string-match project-regexp fullpath)))
      ;;  )
      ))))
    ;;(cons (sort proj-list '(lambda (a b) (string-lessp (car a) (car b)))) file-list)))
    file-list))

(defun clip-file-position ( &optional win) 
  (interactive "P")
  (let ((bufname (buffer-file-name)))
    (kill-new  (format "%s:%d" (if win (replace-regexp-in-string "/" "\\" bufname nil t) bufname ) (line-number-at-pos)))))

(defun join-string (joinstring lststring)
  (mapconcat 'identity lststring joinstring))

(defun netuse (ip passwd user )
  (interactive "sIP주소: \ns암호 : \ns사용자명 : ")
  (async-shell-command (format "net use \\\\%s %s /user:%s" ip passwd user)))

(defun clip-elisp-position ()
  (interactive)
  (kill-new
   (format 
    "(progn (find-file \"%s\") (goto-char %d))"
   (buffer-file-name)
   (point)))
  (message "emacs lisp 형태의 북마크를 복사하였습니다."))


(defun sort-lines-length (reverse beg end)
  "Sort lines in region alphabetically; argument means descending order.
Called from a program, there are three arguments:
REVERSE (non-nil means reverse order), BEG and END (region to sort).
The variable `sort-fold-case' determines whether alphabetic case affects
the sort order."
  (interactive "P\nr")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let ;; To make `end-of-line' and etc. to ignore fields.
          ((inhibit-field-text-motion t))
        (sort-subr 
         reverse 
         'forward-line 
         'end-of-line 
         '(lambda () (save-excursion (end-of-line) (current-column))))))))

(global-set-key (kbd "M-p")   'clip-elisp-position)

;;(defun share ()
;;  (interactive)
;;  (async-shell-command "net use \\\\10.239.12.87  02902774   /user:김동일")
;;  (async-shell-command "net use \\\\10.239.12.103 jangbogo3* /user:kss3")
;;  (async-shell-command "net use \\\\10.239.12.180 buildadmin /user:buildadmin")
;;  (async-shell-command "net use \\\\10.239.12.181 buildadmin /user:buildadmin"))
  
(defun alyac-quit ()
  (interactive)
  (execute-program "taskkill /s localhost /u system /t /f /im AYRTSrv.aye /im AYAgent.aye /im AYUpdSrv.aye /im EpTray.exe /im AYAgentSrv.aye")
  (execute-program "sc stop ALYac_RTSrv")
  (execute-program "sc stop ALYac_AgentSrv")
  (execute-program "sc stop ALYac_UpdSrv")
  )

(defun alyac-restart ()
  (interactive)
  (alyac-quit)
  (execute-program "c:/usr/local/alyac/AYLaunch.exe")
  )


(defun python-quit ()
  (interactive)
  (execute-program "taskkill /t /f /im python.exe "))


(defun shareip (ip)
  (interactive "nIP마지막자리 : ")
  (let ((serverlist '(
                      (133 "net use \\\\10.239.12.133 02902774 /user:김동일")
                      (132 "net use \\\\10.239.12.132 windlp /user:WinDLP")
                      (103 "net use \\\\10.239.12.103 jangbogo3* /user:kss3")
                      (87  "net use \\\\10.239.12.87  02902774   /user:김동일")
                      (180 "net use \\\\10.239.12.180 buildadmin /user:buildadmin")
                      ;;(175  "net use \\\\10.239.12.175  02902774   /user:김동일")
                      (175  "net use \\\\10.239.12.175  04900441 /user:최윤석")
                      ;; (175  "net use \\\\10.239.12.175  02902774 /user:김동일")
                      (181 "net use \\\\10.239.12.181 buildadmin /user:buildadmin"))))
    (if (> ip 0 )
        (execute-program (cadr (assoc ip serverlist)))
      (mapcar (lambda (s) (execute-program (cadr s ))) serverlist)
      )))


(defun get-above-makefile () 
  (expand-file-name
   "Makefile" 
   (loop as d = default-directory then (expand-file-name ".." d) 
         if (file-exists-p (expand-file-name "Makefile" d)) return d)))

;; bind compiling with get-above-makefile to f5
;;(global-set-key [f5] (lambda () (interactive) (compile (format
;;	   "make -f %s" (get-above-makefile)))))



(defun f (n)
  "Check for overflow since Emacs Lisp won't."
  ;; Expression: (+ (sqrt (abs n)) (* n n n))
  ;; Registers:
  (let (r0 ;; (abs n)
        r1 ;; (sqrt r0)
        r2 ;; (* n n)
        r3 ;; (* r2 n)
        r4) ;; (+ r1 r3)
    (setq r0 (abs n))
    (when (or (< r0 0) (> n r0))
      (signal 'overflow-error (list (list 'abs n) r0)))
    (setq r1 (sqrt r0))
    (when (or (< r1 0) (< r0 r1)) ;!
      (signal 'overflow-error (list (list 'sqrt r0) r1)))
    (setq r2 (* n n))
    (when (or (and (< n 0) (<= r2 0))
              (and (< n -1) (<= r2 (- n)))
              (and (> n 0) (<= r2 0)))
      (signal 'overflow-error (list (list '* n n) r2)))
    (setq r3 (* r2 n))
    (when (or (and (< r2 0) (< n 0) (>= r3 0))
              (and (< r2 -1) (< n -1) (<= r3 1))
              (and (> r2 0) (> n 0) (<= r3 0)))
      (signal 'overflow-error (list (list '* r2 n) r3)))
    (setq r4 (+ r1 r3))
    (when (or (and (< r1 0) (< r3 0) (> r4 0))
              (and (> r1 0) (> r3 0) (< r4 0))
              (and (> r1 0) (> r3 0) (or (< r4 r1) (< r4 r3)))
              (and (< r1 0) (< r3 0) (or (> r4 r1) (> r4 r3))))
      (signal 'overflow-error (list (list '+ r1 r3) r4)))
    r4))

(defun read-number-vector (n)
  "Read N numbers from user."
  (let ((S (make-vector n nil)))
    (dotimes (i n S)
      (aset S i (read-number (format "Number %d: " (1+ i)))))))

(defun reverse-vector (vector)
  "Reverse VECTOR."
  (vconcat (nreverse (append vector nil))))

(defun tpk (n S)
  "From ``Early Development of Programming Languages'', 1977."
  (interactive
   (let ((n (truncate (read-number "How many numbers? " 11))))
     ;; Ask for 11 numbers to be read into a sequence S
     (list n (read-number-vector n))))
  ;; Reverse S
  (setq S (reverse-vector S))
  ;; For each number in S
  (dotimes (i n)
    (let ((x (aref S i)))
      (report-errors (format "Alert for %d is %%s" x)
        (let ((result (funcall 'f x)))
          ;; else
          (message "Result for %d is %s" x result))))))

;;Here’s example output:
;;
;;  (tpk 11 [1152921504606846975 -1152921504606846976
;;           536870911 -536870912
;;           16777216 -16777216
;;           65536 16384 7225 0 -1])
;;  Result for -1 is 0.0
;;  Result for 0 is 0.0
;;  Result for 7225 is 266135486.0
;;  Alert for 16384 is (overflow-error (* 268435456 16384) 0)
;;  Alert for 65536 is (overflow-error (* 65536 65536) 0)
;;  Alert for -16777216 is (overflow-error (* -16777216 -16777216) 0)
;;  Alert for 16777216 is (overflow-error (* 16777216 16777216) 0)
;;  Alert for -536870912 is (overflow-error (abs -536870912) -536870912)
;;  Result for 536870911 is 536894081.4749843
;;  Result for -1152921504606846976 is -1.532495540865889e+054
;;  Result for 1152921504606846976 is 1.532495540865889e+054
;;
;;Knuth, Donald Ervin, and Luis Trabb Pardo. The early development of programming languages. In Encyclopedia of Computer Science and Technology, Marcel Dekker, New York, 1977, pages 419-96.


(defun rotate-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))

                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))

                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))


(defun desktop()
  (interactive)
  (dired "c:/Documents and Settings/dongil/바탕 화면"))

(defun w32-open (x &optional thisbuffer)
  "Open an sln file and create a project buffer using the data in it."
  (interactive
   (list (read-file-name "파일 열기: " nil (buffer-file-name) t nil )
	 current-prefix-arg))

  (w32-shell-execute nil x))

;; F6 copy whole buffer
(defun FM-copy-whole-buffer ()
  "Copy the whole buffer into the kill ring"
  (interactive)
  (copy-region-as-kill (point-min) (point-max)))

(global-set-key [C-f5] 'FM-copy-whole-buffer )

(defun wrap-html-tag (tagName &optional className ξid)
  "Add a HTML tag to beginning and ending of current word or text selection.

When preceded with `universal-argument',
no arg = prompt for tag, class.
2 = prompt for tag, id.
any = prompt for tag, id, class.

When called interactively,
Default id value is [id<random number>].
Default class value is [xy].

When called in lisp program, if className is nil or empty string, don't add the attribute. Same for ξid."
  (interactive
   (cond
    ((equal current-prefix-arg nil)     ; universal-argument not called
     (list
      (read-string "Tag (span):" nil nil "span") ))
    ((equal current-prefix-arg '(4))    ; C-u
     (list
      (read-string "Tag (span):" nil nil "span")
      (read-string "Class (xyz):" nil nil "xyz") ))
    ((equal current-prefix-arg 2)       ; C-u 2
     (list
      (read-string "Tag (span):" nil nil "span")
      (read-string "id:" nil nil (format "id%d" (random (expt 2 28 ))))
      ))
    (t                                  ; all other cases
     (list
      (read-string "Tag (span):" nil nil "span")
      (read-string "Class (xyz):" nil nil "xyz")
      (read-string "id:" nil nil (format "id%d" (random (expt 2 28 )))) )) ) )
  (let (bds p1 p2 inputText outputText
            (classStr (if (equal className nil) "" (format " class=\"%s\"" className)))
            (idStr (if (equal ξid nil) "" (format " id=\"%s\"" ξid)))      
            )
    (setq bds (get-selection-or-unit 'word))
    (setq inputText (elt bds 0) )
    (setq p1 (elt bds 1) )
    (setq p2 (elt bds 2) )
    
    (setq outputText (format "<%s%s%s>%s</%s>" tagName idStr classStr inputText tagName ) )

    (delete-region p1 p2)
    (goto-char p1)
    (insert outputText) ) )

;;http://ergoemacs.org/emacs/elisp_idioms_batch.html
(defun make-backup ()
  "Make a backup copy of current buffer's file.
Create a backup of current buffer's file.
The new file name is the old file name postfixed with “~”, in the same dir.
If such a file already exist, append more “~”.
If the current buffer is not associated with a file, its a error."
  (interactive)
  (let (cfile bfilename)
    (setq cfile (buffer-file-name))
    (setq bfilename (concat cfile "~"))

    (while (file-exists-p bfilename)
      (setq bfilename (concat bfilename "~"))
      )

    (copy-file cfile bfilename t)
    (message (concat "Backup saved as: " (file-name-nondirectory bfilename)))
    ))
  
;; http://ergoemacs.org/emacs/emacs_unfill-paragraph.html

;;; package unfill
;; (defun unfill-paragraph ()
;;   "Replace newline chars in current paragraph by single spaces.
;; This command does the reverse of `fill-paragraph'."
;;   (interactive)
;;   (let ((fill-column 90002000))
;;     (fill-paragraph nil)))

;; (defun unfill-region (start end)
;;   "Replace newline chars in region by single spaces.
;; This command does the reverse of `fill-region'."
;;   (interactive "r")
;;   (let ((fill-column 90002000))
;;     (fill-region start end)))

(defun compact-uncompact-block ()
  "Remove or add line ending chars on current paragraph.
This command is similar to a toggle of `fill-paragraph'.
When there is a text selection, act on the region."
  (interactive)

  ;; This command symbol has a property “'stateIsCompact-p”.
  (let (currentStateIsCompact (bigFillColumnVal 4333999) (deactivate-mark nil))

    (save-excursion
      ;; Determine whether the text is currently compact.
      (setq currentStateIsCompact
            (if (eq last-command this-command)
                (get this-command 'stateIsCompact-p)
              (if (> (- (line-end-position) (line-beginning-position)) fill-column) t nil) ) )

      (if (region-active-p)
          (if currentStateIsCompact
              (fill-region (region-beginning) (region-end))
            (let ((fill-column bigFillColumnVal))
              (fill-region (region-beginning) (region-end))) )
        (if currentStateIsCompact
            (fill-paragraph nil)
          (let ((fill-column bigFillColumnVal))
            (fill-paragraph nil)) ) )

      (put this-command 'stateIsCompact-p (if currentStateIsCompact nil t)) ) ) )

;; http://ergoemacs.org/emacs/elisp_idioms_batch.html

(defun read-lines (fPath)
  "Return a list of lines of a file at FPATH."
  (with-temp-buffer
    (insert-file-contents fPath)
    (split-string (buffer-string) "\n" t)))

;;; File and Dir Manipulation
;;; Filename Manipulation
;;; 
;;; Commonly used functions to manipulate file names.

;;doc;;(file-name-directory f)      ; get dir path
;;doc;;(file-name-nondirectory f)   ; get file name
;;doc;;
;;doc;;(file-name-extension f)      ; get suffix
;;doc;;(file-name-sans-extension f) ; remove suffix
;;doc;;
;;doc;;(file-relative-name f )      ; get relative path
;;doc;;(expand-file-name f )        ; get full path
;;doc;;
;;doc;;default-directory       ; get the current dir (this is a variable)

;;; File and Dir Manipulation
;;; 
;;; Commonly used functions to manipulate files and dirs.

;;doc;; (file-exists-p FILENAME)
;;doc;; 
;;doc;; (rename-file FILE NEWNAME &optional OK-IF-ALREADY-EXISTS)
;;doc;; 
;;doc;; (copy-file FILE NEWNAME &optional OK-IF-ALREADY-EXISTS KEEP-TIME PRESERVE-UID-GID)
;;doc;; 
;;doc;; (delete-file FILE)
;;doc;; 
;;doc;; (set-file-modes FILE MODE)
;;doc;; 
;;doc;; ;; get list of file names
;;doc;; (directory-files DIR &optional FULL MATCH NOSORT)
;;doc;; 
;;doc;; ;; create a dir. Non existent paren dirs will be created
;;doc;; (make-directory DIR &optional PARENTS)
;;doc;; 
;;doc;; ;; copy/delete whole dir
;;doc;; (delete-directory DIRECTORY &optional RECURSIVE) ; RECURSIVE option new in emacs 23.2
;;doc;; (copy-directory DIR NEWNAME &optional KEEP-TIME PARENTS) ; new in emacs 23.2


;;;_ Reading and Writing to Files
;;;_ Reading Files Only
;;;_ 
;;;_ To process thousands of files, read only, use with-temp-buffer.

;;doc;; (defun my-process-file (fPath)
;;doc;;   "Process the file at path FPATH …"
;;doc;;   (with-temp-buffer fPath
;;doc;;     (insert-file-contents fPath)
;;doc;;     ;; process it …
;;doc;;     ) )

;;;_ Modifying Files
;;;_ 
;;;_ If you want to write to file ONLY when you actually changed the file, you can create flag variable and call write-region, like this:

;;doc;; (defun my-process-file (fPath)
;;doc;;   "Process the file at path FPATH …"
;;doc;;   (let ( fileChanged-p )
;;doc;;     (with-temp-buffer
;;doc;;       (insert-file-contents fPath)
;;doc;; 
;;doc;;       ;; process text …
;;doc;;       ;; set fileChanged-p to true/false
;;doc;; 
;;doc;;       (when fileChanged-p (write-region 1 (point-max) fPath) ) ) ) )

;;;_ http://ergoemacs.org/emacs/elisp_change_space-hyphen_underscore.html

(defun cycle-hyphen-underscore-space ()
  "Cyclically replace {underscore, space, hypen} chars current line or text selection.
When called repeatedly, this command cycles the {“ ”, “_”, “-”} characters."
  (interactive)
  ;; this function sets a property 「'state」. Possible values are 0 to length of charArray.
  (let (mainText charArray p1 p2 currentState nextState changeFrom
                 changeTo startedWithRegion-p )

    (if (region-active-p)
        (progn
          (setq startedWithRegion-p t )
          (setq p1 (region-beginning))
          (setq p2 (region-end))
          )
      (progn (setq startedWithRegion-p nil ) 
             (setq p1 (line-beginning-position))
             (setq p2 (line-end-position)) ) )

    (setq charArray [" " "_" "-"])

    (setq currentState
          (if (get 'cycle-hyphen-underscore-space 'state) 
              (get 'cycle-hyphen-underscore-space 'state)
            0))
    (setq nextState (% (+ currentState 1) (length charArray)))

    (setq changeFrom (elt charArray currentState ))
    (setq changeTo (elt charArray nextState ))

    (setq mainText (replace-regexp-in-string changeFrom changeTo (buffer-substring-no-properties p1 p2)) )
    (delete-region p1 p2)
    (insert mainText)
    
    (put 'cycle-hyphen-underscore-space 'state nextState)

    (when startedWithRegion-p 
      (goto-char p2)
      (set-mark p1)
      (setq deactivate-mark nil) ) ) )


(w32-unix-eval

 (
  (defun append-path (p)
    (let (( path (file-truename p)))
      (if (not  (member path exec-path))
          (progn 
            (setq exec-path (append  exec-path (list path) ))
            (setenv "PATH" (s-join ";" (mapcar (lambda (x) (replace-regexp-in-string "/" "\\" x nil t )) exec-path)))))))


  (defun prepend-path (p)
    (let (( path (file-truename p)))
      (if (not  (member path exec-path))
          (progn 
            (setq exec-path (append   (list path) exec-path))
            (setenv "PATH" (s-join ";" (mapcar (lambda (x) (replace-regexp-in-string "/" "\\" x nil t )) exec-path)))))))
  )

 (
  (defun append-path (p)
    (let (( path (file-truename p)))
      (if (not  (member path exec-path))
          (progn 
            (setq exec-path (append  exec-path (list path) ))
            (setenv "PATH" (s-join ":" exec-path))))))


  (defun prepend-path (p)
    (let (( path (file-truename p)))
      (if (not  (member path exec-path))
          (progn 
            (setq exec-path (append   (list path) exec-path))
            (setenv "PATH" (s-join ";"  exec-path))))))


  )

 )

(defun insert-line (x)
  (insert (concat x "\n")))

(defun iarrange ()
  (interactive)
  (insert-line "* 정리필요")
  (insert-line "** 지금해")
  (insert-line "** 연락해")
  (insert-line "** 도움받아")
  (insert-line "** 버려")
  (org-mode))

;;; http://sachachua.com/notebook/emacs/small-functions.el

;; small-functions.el --- Small function definitions that are usefull.
;;
;;  Steve Kemp <skx@tardis.ed.ac.uk>
;;  http://www.tardis.ed.ac.uk/~skx/
;;
;;  These function definitions are the partly written myself
;; and partly borrowed/stolen/copied from other people - credit
;; is given where known.
;;
;;  Feel free to borrow/copy/steal code found in this file..
;;
;; Tue Aug 17 15:51:03 1999
;;
;;;;

;;
;;;;  Make sure I don't accidentally kill emacs.
;;;; This will force emacs to ask me if I'm sure that I want to quit.
;;;; Bind the function to C-c C-x
;;(global-set-key "\C-x\C-c" '(lambda () 
;;			      (interactive)
;;			      (if (y-or-n-p-with-timeout "Do you want to exit " 4 nil)
;;				  (save-buffers-kill-emacs))))

;; Stop Emacs from asking for "y-e-s", when a "y" will do.
;;(fset 'yes-or-no-p 'y-or-n-p)



;; The following little lump of lisp will ensure the first assignment operators
;; on each of the lines line up. This is part of our local formatting style
;; 'cos it looks nice ;-)
;; The style of the lisp however, is atrocious. All the problems come from ==,
;; which looks too much like 'op='.
;; Paul Hudson
(defun align-equals (start end)
 "Make the first assignment operator on each line line up vertically"
 (interactive "*r")
 (save-excursion
   (let ((indent 0))
     (narrow-to-region start end)
     (beginning-of-buffer)
     (while (not (eobp))
       (if (find-assignment)
	   (progn
	     (exchange-point-and-mark)
	     (setq indent (max indent (current-column)))
	     (delete-horizontal-space)
	     (insert " ")))
       (forward-line 1))
     (beginning-of-buffer)
     (while (not (eobp))
       (if (find-assignment)
	   (indent-to-column (1+ (- indent  (- (mark) (point))))))
       (forward-line 1)))
   (widen)))


;;
;; Find an assignment statement
;;
(defun find-assignment ()
  (if (re-search-forward
	     "[^<>=!]=\\|\\+=\\|-=\\|\\*=\\|/=\\|&=\\||=\\|\\^=\\|<<=\\|>>="
	     (save-excursion (end-of-line) (point)) t)
      (progn
	(goto-char (match-beginning 0))
	(if (looking-at ".==")
	    nil
	  (if (looking-at "\\+=\\|-=\\|\\*=\\|/=\\|&=\\||=\\|\\^=\\|<<=\\|>>=")
	      (set-mark (match-end 0))
	    (forward-char 1)
	    (set-mark (1+ (point))))
	  (delete-horizontal-space)
	  t))
    nil))


;;
;; Insert a time stamp at the point
;;
;;(defun insert-time-stamp ()
;;  "Insert current date and time."
;;  (interactive "*")
;;  (insert (current-time-string)))

;;
;;  A simple function to move the point the the previous window, when
;; there are multiple windows on screen.  Simpler to use that
;; "other-window"
;;
(defun other-window-backward (&optional n)
  "Select Nth previous window"
  (interactive "P")
  (other-window (- (prefix-numeric-value n))))

;;
;; Key bindings for next window, and previous window.
;; taken straight from the Glickenstein.
;;(global-set-key "\C-x\C-n" 'other-window)
;;(global-set-key "\C-x\C-p" 'other-window-backward)

;;
;; An equivilent of Apropos, but it acts up lisp variables.
;;
(defun variable-apropos (string)
  "Like apropos, but lists only symbols that are names of user
modifiable variables.  Argument REGEXP is a regular expression.
   Returns a list of symbols, and documentation found"
  (interactive "sVariable apropos (regexp): ")
  (let ((message
         (let ((standard-output (get-buffer-create "*Help*")))
           (print-help-return-message 'identity))))
    (if (apropos string  'user-variable-p)
        (and message (message message)))))
(define-key help-map "\C-v" 'variable-apropos)


;;
;; Run a shell command on a region, and paste the results of the command
;; over that region.
;;
(defun my-shell-command-on-region nil
  "Replace region with ``shell-command-on-region''.

By default, this will make mark active if it is not and then prompt
you for a shell command to run and replaces region with the results.
This is handy for doing things like getting external program locations
in scripts and running grep and whatnot on a region."
  (interactive)
  (save-excursion
    (if (equal mark-active nil)
        (push-mark nil nil -1))
    ; Next couple lines stolen from simple.el
    (setq string
          (read-from-minibuffer "Shell command on region: " nil nil nil
                                'shell-command-history))
    (shell-command-on-region (region-beginning) (region-end) string -1)
    ; Get rid of final newline cause I normally did by hand anyway.
    (delete-char -1)))


(defun reindent-files (filelist)
  "Allow files to be reindented.."
  (while filelist
      (reindent-file (car filelist))
      (setq filelist (cdr filelist))))

(defun reindent-file (file)
  "This will reindent a file"
  (interactive)
  (save-excursion
    (find-file file)
    (indent-region (point-min) (point-max) nil)
    ;; uncomment these two lines after testing with a few files
    ;;(save-buffer)
    ;;(kill-buffer nil)
    ))

;;(reindent-files (list "first.c" "second.c" "some/path/third.c"))

(defun ^m-buffer ()
  "Remove all ^M's from the buffer."
  (interactive)
  (^m-region (point-min) (point-max)))

(defalias '^M '^m-buffer)
(defalias '^M '^m-buffer)

(defun ^m-region (min max)
  "Remove all ^M's from the region."
  (interactive "r")
  (save-excursion
    (goto-char max)
    (while (re-search-backward "\C-m$" min t)
      (delete-char 1))))





;; From: terra@diku.dk (Morten Welinder)
;; Newsgroups: gnu.emacs.help
;; Subject: Re: How do you get *scratch buffer after lost ?
;; Date: 7 May 1997 23:18:51 GMT
;; Organization: Department of Computer Science, U of Copenhagen
;;
;; sramani@imtn.dsccc.com (Shubha Ramani) writes:
;;
;; >If one accidently kills the scratch buffer, how do you >regain it
;; ? Is there a command to bring it back ?
;;
;; You can always do "C-x C-b *scratch* RET" but keeping the following
;; piece of code around in your ~/.emacs file will make *scratch*
;; harder to delete in the first place -- it magically reappears when
;; you kill it.

;; Morten
;;

;;; Make the *scratch* buffer behave like "The thing your aunt gave you,
;;; which you don't know what is."
;;(save-excursion
;;  (set-buffer (get-buffer-create "*scratch*"))
;;  (lisp-interaction-mode)
;;  (make-local-variable 'kill-buffer-query-functions)
;;  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer))

(defun kill-scratch-buffer ()
  "Kill the current (*scratch*) buffer, then create a new one.
 This is called from a hook, kill-buffer-query-functions, and its
 purpose is to prevent the *scratch* buffer from being killed."
  (remove-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  (kill-buffer (current-buffer))

  ;; Make a brand new *scratch* buffer
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer)

  ;; Since we killed it, don't let caller do that.
  nil)

;; Ditto for the messags buffer
;;(save-excursion
;;  (set-buffer (get-buffer-create "*Messages*"))
;;  (fundamental-mode)
;;  (make-local-variable 'kill-buffer-query-functions)
;;  (add-hook 'kill-buffer-query-functions 'kill-messages-buffer))

(defun kill-messages-buffer ()
  "Kill the current (*Messages*) buffer, then create a new one.
 This is called from a hook, kill-buffer-query-functions, and its
 purpose is to prevent the *Messages* buffer from being killed."
  (remove-hook 'kill-buffer-query-functions 'kill-messages-buffer)
  (kill-buffer (current-buffer))
  ;; Make a brand new *messages* buffer
  (set-buffer (get-buffer-create "*Messages*"))
  (fundamental-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-messages-buffer)
  ;; Since we killed it, don't let caller do that.
  nil)


(defun remove-blank-lines ()
  "Delete blank lines from the current buffer."
  (interactive "*")
  (while (re-search-forward "^$")
    (kill-line)))

(defun add-full-stop ()
  "Terminate each line with a full stop."
  (interactive "*")
  (while (re-search-forward "$")
    (insert ".")
    (forward-char )))


(defun get-ip-address ()
  "Show the IP address of the current machine."
  (interactive)
  (save-excursion
    (ipconfig);; autoloaded from net-utils.el
    (unwind-protect
        (progn
          ;; We are now in buffer "*Ipconfig*".
          ;; wait for the ipconfig process to finish.
          (while (let ((p (get-process "Ipconfig")))
                   (and p (process-status p)))
            (sit-for 1))
          (beginning-of-buffer)
          (if (save-match-data ;; Don't mess up my caller's match data.
                (re-search-forward "^[ \t]*IP Address[. ]*:[ \t]*" nil t))
              (buffer-substring (point) (progn (end-of-line) (point)))
            (error "Can't find IP address")
            )
          )
      (kill-buffer "*Ipconfig*")
      )
    )
  )



(defun strip-html ()
  "Remove HTML tags from the current buffer, 
   (this will affect the whole buffer regardless of the restrictions in effect)."
  (interactive "*")
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (while (re-search-forward "<[^<]*>" (point-max) t)
	(replace-match "\\1"))
      (goto-char (point-min))
      (replace-string "&copy;" "(c)")
      (goto-char (point-min))
      (replace-string "&amp;" "&")
      (goto-char (point-min))
      (replace-string "&lt;" "<")
      (goto-char (point-min))
      (replace-string "&gt;" ">")
      (goto-char (point-min)))))



;;; Set the % key to goto matched parenthesis.
;;; Posted to the NTEmacs mailing list by
;;; Chris McMahan
(show-paren-mode t)
(global-set-key (kbd "C-%")  'match-paren)
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	  ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	  (t (self-insert-command (or arg 1)))))


(defun delete-header-cruft (P)
  "Delete lines which appear to be RFC-822 cruft, mail or news.
With prefix arg, start from point; otherwise do whole buffer."
  (interactive "P")
  (or P (goto-char (point-min)))
  (while (re-search-forward
          (concat "^\\("
                  "Xref\\|Path\\|Newsgroups\\|Followup-To\\|"
                  "Lines\\|Message-ID\\|Reply-To\\|NNTP-Posting-Host\\|"
                  "Received\\|X-Mailer\\|MIME-Version\\|References\\|"
                  "Content-Type\\|Content-Transfer-Encoding\\|Status\\|"
                  "In-Reply-To\\|X-Newsreader\\|"
                  "\\): .*\n")
          nil t)
    (replace-match "")))


(defsubst PMIN ()
  "Go to `point-min'."
  (goto-char (point-min)))

(defsubst PMAX ()
  "Go to `point-max'."
  (goto-char (point-max)))


;;; ----------------------------------------------------------------------
;;;
(defun bin-string-to-int (8bit-string)
  "Convert 8BIT-STRING  string to integer."
  (let* ((list  '(128 64 32 16 8 4 2 1))
	 (i   0)
	 (int 0)
         )
    (while (< i 8)
      (if (not (string= "0" (substring 8bit-string i (1+ i))))
	  (setq int (+ int (nth i list) )))
      (incf  i)
      )
    int
    ))

;;; http://lisptips.com/post/44261316742/how-do-i-convert-an-integer-to-a-list-of-bits 참고 
;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun int-to-bin-string (n &optional length)
  "Convert integer N to bit string (LENGTH, default 8)."
  (let* ((i    0)
         (len  (or length (+ 1 (ceiling (log n 2)))))
         (s    (make-string len ?0))
         )
    (while (< i len)
      (if (not (zerop (logand n (ash 1 i))))
          (aset s (- len (1+ i)) ?1))
      (setq i (1+ i))
      )
    s
    ))

;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun int-to-hex-string (n &optional separator pad)
  "Convert integer N to hex string. SEPARATOR between hunks is \"\".
PAD says to padd (bit hex string with leading zeroes."
  (or separator
      (setq separator ""))
  (mapconcat
   (function (lambda (x)
	       (setq x (format "%x" (logand x 255)))
	       (if (= 1 (length x)) (concat "0" x) x)))
   (list (ash n -24) (ash n -16) (ash n -8) n)
   separator))

;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun int-to-oct-string (n &optional separator)
  "Convert integer N into Octal. SEPARATOR between hunks is \"\"."
  (or separator
      (setq separator ""))
  (mapconcat
   (function (lambda (x)
	       (setq x (format "%o" (logand x 511)))
	       (if (= 1 (length x)) (concat "00" x)
		 (if (= 2 (length x)) (concat "0" x) x))))
   (list (ash n -27) (ash n -18) (ash n -9) n)
   separator))

;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun radix (str base)
  "Convert STR according to BASE."
  (let ((chars "0123456789abcdefghijklmnopqrstuvwxyz")
        (case-fold-search t)
        (n 0)
        i)
    (mapcar (lambda (c)
               (setq i (string-match (make-string 1 c) chars))
               (if (>= (or i 65536) base)
                   (error "%c illegal in base %d" c base))
               (setq n (+ (* n base) i)))
            (append str nil))
    n))

;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun bin-to-int (str)
  "Convert STR into binary."
  (radix str 2))

;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun oct-to-int (str)
  "Convert STR into octal."
  (radix str 8))

;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun hex-to-int (str)
  "Convert STR into hex."
  (if (string-match "\\`0x" str) (setq str (substring str 2)))
  (radix str 16))

;;; ----------------------------------------------------------------------
;;; 08 Jun 1997 Jamie Zawinski <jwz@netscape.com> comp.emacs
;;;
(defun int-to-net (float)
  "Decode packed FLOAT 32 bit IP addresses."
  (format "%d.%d.%d.%d"
          (truncate (% float 256))
          (truncate (% (/ float 256.0) 256))
          (truncate (% (/ float (* 256.0 256.0)) 256))
          (truncate (% (/ float (* 256.0 256.0 256.0)) 256))
          ))

;;; ----------------------------------------------------------------------
;;;
(defsubst str-left (str count)
  "Use STR and read COUNT chars from left.
If the COUNT exeeds string length or is zero, whole string is returned."
  (if (> count 0)
      (substring str 0 (min (length str) count))
    str))

;;; ----------------------------------------------------------------------
;;;  - You can do this with negative argument to substring, but if you exceed
;;;    the string len, substring will barf and quit with error.
;;;  - This one will never call 'error'.
;;;
(defsubst str-right (str count)
  "Use STR and read COUNT chars from right.
If the COUNT exeeds string length or is zero, whole string is returned."
  (let* ((pos (- (length str)  count))
	 )
    (if (> pos 0)
	(substring str (- 0 count))
      str
      )))

;;; ----------------------------------------------------------------------
;;; - This old version is equivalent to the new one. The NEW one
;;;   was needed because Emacs 19.30+ didn't allow integer in
;;;   'concat function any more.
;;; - This is interesting macro, but ... Hmm, I think it is
;;;   too slow to be used regularly. Use with care in places where
;;;   time is not critical.
;;;
;;old (defmacro strcat (var-sym &rest body)
;;old"Shorthand to (setq VAR-SYM (concat VAR-SYM ...))"
;;old   (` (setq (, var-sym) (concat (or (, var-sym) "") (,@ body)))))

;;; #todo: Remove strcat

(defmacro strcat (var &rest body)
  "Like C strcat. Put results to VAR using BODY forms.
Integers and variables passed in BODY to VAR
Example call:  (strcat var \"hello \" \"there \" 1234 \" \" 55)"
  (` (setq (, var)
	   (concat
	    (or (, var) "")
	    (mapconcat
	     (function
	      (lambda (x)
		(cond
		 ((stringp x) x)
		 ((integerp x) (int-to-string x))
		 (t   (eval x))          ;; it's variable
		 )))
	     (quote (, body))
	     ""
	     )))))

(defsubst line-wrap-p ()
  "Check if line wraps. ie. line is longer that current window."
  (> (line-length) (nth 2 (window-edges))))

;;; ----------------------------------------------------------------------
;;; - Ever struggled with peeking the lists..?
;;; - I have, and printing the contents of auto-mode-alist into
;;;   the buffer is very easy with this.
;;; - Should be default emacs function.
;;;
(defun list-print (list)
  "Insert content of LIST into current point."
  (interactive "XLisp symbol, list name: ")
  (mapcar
   (function
    (lambda (x) (insert (2str x) "\n")))
   list))

;;; ----------------------------------------------------------------------
;;; 1990, Sebastian Kremer, Institute for Theoretical Physics, West Germany
;;; BITNET: ab027@dk0rrzk0.bitnet
;;;
(defsubst list-to-string (list &optional separator)
  "Convert LIST into string. Optional SEPARATOR defaults to \" \".

Input:

  LIST       '(\"str\" \"str\" ...)
  separator  ' '

Return:
  str"
  (mapconcat
   (function identity)			;returns "as is"
   list
   (or separator " ")
   ))


(defun shell-command-to-string (command)
  "Returns shell COMMAND's ouput as string. Tinylibm."
  (with-temp-buffer
    (shell-execute command (current-buffer))
    (buffer-string)))

;;; ----------------------------------------------------------------------
;;; Easier to use than lowlevel `call-process'
;;;
(defsubst shell-execute (command &optional buffer)
  "Executes shell COMMAND and optionally output to BUFFER.

References:

  `shell-file-name'	variable
  `shell-exec-nok-p'	function

Return:

  0	error
  nbr	ok"
  (call-process
   shell-file-name
   nil
   buffer
   nil
   shell-command-switch ;; -c
   command
   ))


;;; ----------------------------------------------------------------------
;;;
(defsubst file-name-dos (file)
  "Convert FILE slashes to dos format."
  (subst-char file ?/ ?\\))

;;; ----------------------------------------------------------------------
;;;
(defsubst file-name-unix (file)
  "Convert FILE slashes to unix format."
  (subst-char file ?\\ ?/))

;;exist;;(defun point-at-bol ()
;;exist;;  "Return the index of the character at the start of the line.
;;exist;;  This is a built in function in Xemacs, but not Emacs."
;;exist;;  (interactive)
;;exist;;  (save-excursion
;;exist;;    (beginning-of-line)
;;exist;;    (point)))


(defun pbug ()
  "Check parenthesis bugs or similar horrors.

Even with Emacs advanced programming facilities, checking mismatching
parenthesis or missing quote (so called \"pbug\") is no less annoying than
pointer chasing in C.

This function divides the buffer into regions and tries evaluating them one
by one.  It stops at the first region where it fails to evaluate because of
pbug or any other errors. It sets point and mark (and highlights if
`transient-mark-mode' is on) on the failing region and center its first
line.  \"^def\" is used to define regions.  You may also `eval-region'
right after pbug is done to let lisp parse pinpoint the bug.

No more \"End of file during parsing\" horrors!"
  (interactive)
  (let ((point (point))
	(region-regex "^(def..")
	defs beg end)
    (goto-char (point-min))
    (setq defs (loop while (search-forward-regexp region-regex nil t)
		     collect (point-at-bol)))
    ;; so it evals last definition
    (nconc defs (list (point-max)))
    (setq beg (point-min))
    (while defs
      (goto-char beg)
      (setq end (pop defs))
      ;; to be cool, uncomment these to see pbug doing step by step
      ;; (message "checking pbug from %s to %s..." beg end)
      ;; (sit-for 1)
      (when (eq (condition-case nil
		    (eval-region beg (1- end))
		  (error 'pbug-error))
		'pbug-error)
	(push-mark end 'nomsg 'activate)
	(goto-char beg)
	(recenter)
	(error "a pbug found from %s to %s" beg end))
      (setq beg end))
    (goto-char point)
    (message "no pbug found")))


(defun debug-on-error ()
  "Toggle variable `debug-on-error'."
  (interactive)
  (setq debug-on-error (not debug-on-error))
  (message "debug-on-error=%s" debug-on-error)
  )



;; (provide 'small-functions)

;; http://ergoemacs.org/emacs/elisp_extract_url_command.html
(defun extract-url (&optional p1 p2)
  "Returns a list of URLs in the region p1 p2.
The region's text should be HTML.

When called interactively, use text selection as input, or current text block between empty lines. Output URLs in a buffer named 「*extract URL output*」.

When called in a program, the first URL is the last list element.

WARNING: this function extract all text of the form 「<a … href=\"…\" …>」 by a simple regex. It does not extract single quote form 「href='…'」 nor 「src=\"…\"」 , nor other considerations."
(interactive
 (if (region-active-p)
     (list (buffer-substring-no-properties (region-beginning) (region-end)) )
   (let ((bds (bounds-of-thing-at-point 'paragraph)))
     (list (car bds) (cdr bds)) ) ) )
  (let ((htmlText (buffer-substring-no-properties p1 p2)) (urlList (list)))
    (with-temp-buffer
      (insert htmlText)
      (goto-char 1)
      (while (re-search-forward "<a.+?href=\"\\([^\"]+?\\)\".+?>" nil t)
        (setq urlList (cons (match-string 1) urlList))
        ))

    (when (called-interactively-p 'any)
        (with-output-to-temp-buffer "*extract URL output*"
          (mapc (lambda (ξx) (princ ξx) (terpri) ) (reverse urlList))
          )
      )
    urlList
    ))


(require 'xeu_elisp_util)
(require 'xah-replace-pairs)


(defun change-bracket-pairs (fromType toType)
  "Change bracket pairs from one type to another on text selection or text block.
For example, change all parenthesis () to square brackets [].

When called in lisp program, fromType and toType is a string of a bracket pair. ⁖ \"()\", likewise for toType."
  (interactive
   (let (
         (bracketTypes '("[]" "()" "{}" "“”" "‘’" "〈〉" "《》" "「」" "『』" "【】" "〖〗"))
         )
     (list
      (ido-completing-read "Replace this:" bracketTypes )
      (ido-completing-read "To:" bracketTypes ) ) ) )

  (let* (
         (bds (get-selection-or-unit 'block))
         (p1 (elt bds 1))
         (p2 (elt bds 2))
         (changePairs (vector
                       (vector (char-to-string (elt fromType 0)) (char-to-string (elt toType 0)))
                       (vector (char-to-string (elt fromType 1)) (char-to-string (elt toType 1)))
                       ))
         )
    (replace-pairs-region p1 p2 changePairs) ) )

(defun run-elisp () 
  (interactive)
  (async-shell-command (format "emacs -Q --batch --script \"%s\"" (buffer-file-name)))
  )

(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))


(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))


;;deprecated;;(global-set-key (kbd "M-o") 'smart-open-line)
;;deprecated;;(global-set-key (kbd "M-O") 'smart-open-line-above)
(global-set-key [(control shift return)] 'smart-open-line-above)
(global-set-key [(shift return)] 'smart-open-line)

(defun open-file-at-cursor ()
  "Open the file path under cursor.
If there is text selection, uses the text selection for path.
If the path is starts with “http://”, open the URL in browser.
Input path can be {relative, full path, URL}.
This command is similar to `find-file-at-point' but without prompting for confirmation.
"
  (interactive)
  (let ( (path (if (region-active-p)
                   (buffer-substring-no-properties (region-beginning) (region-end))
                 (thing-at-point 'filename) ) ))
    (if (string-match-p "\\`https?://" path)
        (browse-url path)
      (progn ; not starting “http://”
        (if (file-exists-p path)
            (find-file path)
          (if (file-exists-p (concat path ".el"))
              (find-file (concat path ".el"))
            (when (y-or-n-p (format "file doesn't exist: 「%s」. Create?" path) )
              (find-file path )) ) ) ) ) ))


(defun copy-rectangle-to-clipboard (p1 p2)
  "Copy region as column (rectangle) to operating system's clipboard.
This command will also put the text in register 0.

See also: `kill-rectangle', `copy-to-register'."
  (interactive "r")
  (let ((x-select-enable-clipboard t))
    (copy-rectangle-to-register ?0 p1 p2)
    (kill-new
     (with-temp-buffer
       (insert-register ?0)
       (buffer-string) )) ) )

(defun youngfrog/copy-rectangle-to-kill-ring (start end)
  "Saves a rectangle to the normal kill ring. Not suitable for yank-rectangle."
  (interactive "r")
  (let ((lines (extract-rectangle start end)))
    (with-temp-buffer
      (while lines ;; insert-rectangle, but without the unneeded stuff
        ;; (most importantly no push-mark)
        (insert-for-yank (car lines))
        (insert "\n")
        (setq lines (cdr lines)))
      (kill-ring-save (point-min) (point-max)))))

;; http://emacsredux.com/blog/2013/07/17/advise-multiple-commands-in-the-same-manner/
(defmacro advise-commands (advice-name commands &rest body)
  "Apply advice named ADVICE-NAME to multiple COMMANDS.

The body of the advice is in BODY."
  `(progn
     ,@(mapcar (lambda (command)
                 `(defadvice ,command (before ,(intern (concat (symbol-name command) "-" advice-name)) activate)
                    ,@body))
               commands)))
;;; example 
;; (advise-commands "auto-save"
;;                  (switch-to-buffer other-window windmove-up windmove-down windmove-left windmove-right)
;;                  (prelude-auto-save))
;; http://ergoemacs.org/emacs/emacs_unfill-paragraph.html
(defun unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000)) ; 90002000 is just random. you can use `most-positive-fixnum'
    (fill-paragraph nil)))

(defun unfill-region (start end)
  "Replace newline chars in region by single spaces.
This command does the inverse of `fill-region'."
  (interactive "r")
  (let ((fill-column 90002000))
    (fill-region start end)))



;; http://ergoemacs.org/emacs/modernization_mark-word.html
;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun semnav-up (arg)
  (interactive "p")
  (when (nth 3 (syntax-ppss))
    (if (> arg 0)
        (progn
          (skip-syntax-forward "^\"")
          (goto-char (1+ (point)))
          (decf arg))
      (skip-syntax-backward "^\"")
      (goto-char (1- (point)))
      (incf arg)))
  (up-list arg))

;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun extend-selection (arg &optional incremental)
  "Select the current word.
Subsequent calls expands the selection to larger semantic unit."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     (or (region-active-p)
                         (eq last-command this-command))))
  (if incremental
      (progn
        (semnav-up (- arg))
        (forward-sexp)
        (mark-sexp -1))
    (if (> arg 1)
        (extend-selection (1- arg) t)
      (if (looking-at "\\=\\(\\s_\\|\\sw\\)*\\_>")
          (goto-char (match-end 0))
        (unless (memq (char-before) '(?\) ?\"))
          (forward-sexp)))
      (mark-sexp -1))))

(defun select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters are paired characters:
 () [] {} «» ‹› “” 〖〗 【】 「」 『』 （） 〈〉 《》 〔〕 ⦗⦘ 〘〙 ⦅⦆ 〚〛 ⦃⦄
 For practical purposes, also: \"\", but not single quotes."
 (interactive)
 (let (p1)
   (skip-chars-backward "^<>([{“「『‹«（〈《〔【〖⦗〘⦅〚⦃\"")
   (setq p1 (point))
   (skip-chars-forward "^<>)]}”」』›»）〉》〕】〗⦘〙⦆〛⦄\"")
   (set-mark p1)
   )
 )


(defun org2trac (s e) 
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region s e )
      (replace-regexp "^\\* \\(.*\\)" "= \\1 =" nil (point-min) (point-max))
      (replace-regexp "^\\*\\* \\(.*\\)" "== \\1 ==" nil (point-min) (point-max))
      (replace-regexp "^\\*\\*\\* \\(.*\\)" "=== \\1 ===" nil (point-min) (point-max) )
  )))
  
(defun bfname ()

  (interactive)
  (kill-new
   (ff-basename
    (buffer-file-name) ) )) 



(defun unedebug-defun ()
  "I can't believe emacs doesn't give you a way to do this!!"
  (interactive t)
  (eval-expression (edebug-read-top-level-form)))



(defun buffer-file-name-sans-directory ()
  "Returns the current buffer file name without it's directory"
  (file-name-nondirectory (buffer-file-name)))

(defun buffer-file-name-extension ()
  "Returns the extention of the buffer file"
  (file-name-extension (buffer-file-name)))

(defun copy-thing-at-point (thing)
  "Copy thing at point"
  (interactive "P")
  (let ((bounds (bounds-of-thing-at-point thing)))
    (copy-region-as-kill (car bounds) (cdr bounds))))

(defun copy-word-at-point ()
  "Copy word at point"
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (copy-region-as-kill (car bounds) (cdr bounds))))

(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without marking the line "
  (interactive "P")
  (let ((beg (line-beginning-position))
       (end (line-end-position)))
    (copy-region-as-kill beg end)))


(defun strline (b e &optional arg)
  (interactive "r\nP")
  (save-excursion
    (save-restriction 
      (message (format"%d" e))
      (narrow-to-region b e)
      (if (not  arg) 
          (strip-trailing-whitespace (point-min) (point-max)))
      (message (format "%s" arg))
      (goto-char (point-min))

      (move-beginning-of-line nil)
      (insert "\"")
      (end-of-line)    
      (insert "\"")

      (while (and  (= (forward-line) 0)  (not  (= (point-at-bol) (point-at-eol) )))
        (move-beginning-of-line nil)
        (insert "\"")
        (end-of-line)    
        (insert "\"")))
    ;; (widen)
    ))

(defun parline (b e &optional arg)
  (interactive "r\nP")
  (save-excursion
    (save-restriction 
      (message (format"%d" e))
      (narrow-to-region b e)
      (if (not  arg) 
          (strip-trailing-whitespace (point-min) (point-max)))
      (message (format "%s" arg))
      (goto-char (point-min))

      (move-beginning-of-line nil)
      (insert "(")
      (end-of-line)    
      (insert ")")

      (while (and  (= (forward-line) 0)  (not  (= (point-at-bol) (point-at-eol) )))
        (move-beginning-of-line nil)
        (insert "(")
        (end-of-line)    
        (insert ")")))
    ;; (widen)
    ))


(defun lstline (b e &optional arg)
  (interactive "r\nP")
  (save-excursion
    (save-restriction 
      (message (format"%d" e))
      (narrow-to-region b e)
      (if (not  arg) 
          (strip-trailing-whitespace (point-min) (point-max)))
      (message (format "%s" arg))
      (goto-char (point-min))

      (move-beginning-of-line nil)
      (insert "(")
      (end-of-line)    
      (insert ")")

      (while (and  (= (forward-line) 0)  (not  (= (point-at-bol) (point-at-eol) )))
        (move-beginning-of-line nil)
        (insert "(")
        (end-of-line)    
        (insert ")")))
    ;; (widen)
    ))

(defun browse-url-line (b e &optional arg)
  (interactive "r\nP")
  (save-excursion
    (save-restriction 
      (narrow-to-region b e)
      (if (not  arg) 
          (strip-trailing-whitespace (point-min) (point-max)))
      (message (format "%s" arg))
      (dolist (line (split-string  (buffer-string) "\n" t))
        (browse-url line)
        )
    )))

(defun copy-paragraph (&optional arg)
  "Copy paragraph at point"
  (interactive "P")
  (let ((beg (progn (backward-paragraph 1) (point)))
       (end (progn (forward-paragraph arg) (point))))
    (copy-region-as-kill beg end)))

(defun wcopy ()
  (interactive)
  (kill-new (current-word)))

(defvar processhacker (fullpath  "../../processhacker/x64/ProcessHacker.exe"))

(defun v3restart () 
  (interactive)
  (require 'proced)
  (let ((ph  processhacker ))
    (mapcar (lambda (x) 
              (w32-shell-execute 
               "" 
               ph
               (format "-c -ctype process -cobject %d -caction terminate" (cdr  (assoc 'pid x )))) )
            (remove-if-not 
             (lambda (x) (member (intern ( cdr (assoc 'comm x ))) 
                            '(V3SP.exe 
                              V3Svc.exe 
                              V3PScan.exe 
                              V3Medic.exe 
                              ;;PaSvc.exe 
                              ;;PaTray.exe
                              )))  
             (proced-process-attributes)))
    (w32-shell-execute 
     "" 
     ph
     "-c -ctype service -cobject \"V3 Service\" -caction start"
     )
    (w32-shell-execute 
     "" 
     "c:/Program Files/AhnLab/V3IS80/V3SP.exe")  
    )
  ) 


(defun v3kill () 
  (interactive)
  (require 'proced)
  (let ((ph  processhacker )
        (fmt "-c -ctype process -cobject %d -caction terminate" ))
    (mapcar
     (lambda (x) 
       (w32-shell-execute "" ph (format fmt (cdr  (assoc 'pid x ))))
       (w32-shell-execute "" ph (format fmt (cdr  (assoc 'pid x )))))
     (remove-if-not 
      (lambda (x) (member (intern ( cdr (assoc 'comm x ))) 
                      '(
                        V3UI.exe 
                        V3Svc.exe 
                        V3PScan.exe 
                        V3Medic.exe 
                        PaSvc.exe 
                        PaTray.exe

                        ;; NHCASysMon.exe
                        ;; NHCARemote.exe
                        ;; NHCAUI.exe 

                        )))  
      (proced-process-attributes)))
    (mapcar
     (lambda (x) 
       (w32-shell-execute "" ph (format fmt (cdr  (assoc 'pid x ))))
       (w32-shell-execute "" ph (format fmt (cdr  (assoc 'pid x )))))
     (remove-if-not 
      (lambda (x) (member (intern ( cdr (assoc 'comm x ))) 
                      '(
                        V3SP.exe 
                        V3Svc.exe 
                        V3PScan.exe 
                        V3Medic.exe 
                        PaSvc.exe 
                        PaTray.exe

                        ;; NHCASysMon.exe
                        ;; NHCARemote.exe
                        ;; NHCAUI.exe 
                        )))  
      (proced-process-attributes)))
    ))

(defun iekill () 
  (interactive)
  (require 'proced)
  (let ((ph  processhacker ))
    (mapcar (lambda (x) 
              (w32-shell-execute 
               "" 
               ph
               (format "-c -ctype process -cobject %d -caction terminate" (cdr  (assoc 'pid x )))) )
            (remove-if-not 
             (lambda (x) (member (intern ( cdr (assoc 'comm x ))) 
                            '(iexplore.exe
                              )))  
             (proced-process-attributes)))))


(defun cmd/v3kill () 
  (interactive)
  (require 'proced)
  (let ((ph  processhacker ))
    (with-temp-buffer 
      (mapcar (lambda (x) 
                (insert
                 (format "%s -c -ctype process -cobject %d -caction terminate\n" ph (cdr  (assoc 'pid x )))) )
              (remove-if-not 
               (lambda (x) (member (intern ( cdr (assoc 'comm x ))) 
                               '(V3SP.exe 
                                 V3Svc.exe 
                                 V3PScan.exe 
                                 V3Medic.exe 
                                 ;;PaSvc.exe 
                                 ;;PaTray.exe
                                 )))  
               (proced-process-attributes)))
      (kill-new (buffer-substring (point-min) (point-max))))
    ))


(defun unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000)) ; 90002000 is just random. you can use `most-positive-fixnum'
    (fill-paragraph nil)))

(defun unfill-region (start end)
  "Replace newline chars in region by single spaces.
This command does the inverse of `fill-region'."
  (interactive "r")
  (let ((fill-column 90002000))
    (fill-region start end)))


(defun ido-choose-from-recentf ()
  "Use ido to select a recently opened file from the `recentf-list'"
  (interactive)
  (let ((home (expand-file-name (getenv "HOME"))))
    (find-file
     (ido-completing-read "Recentf open: "
                          (mapcar (lambda (path)
                                    (replace-regexp-in-string home "~/" path))
                                  recentf-list)
                          nil t))))

(defun helm-choose-from-recentf ()
  "Use helm to select a recently opened file from the `recentf-list'"
  (interactive)
  (let ((home (expand-file-name (getenv "HOME"))))
    (find-file
     (helm-comp-read 
      "파일명을 입력하세요 : "
      (mapcar (lambda (path)
                (replace-regexp-in-string home "~/" path))
              recentf-list)
      ))))


(defun next-user-buffer ()
  "Switch to the next user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(defun previous-user-buffer ()
  "Switch to the previous user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

(defun next-emacs-buffer ()
  "Switch to the next emacs buffer.
Emacs buffers are those whose name starts with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (not (string-match "^*" (buffer-name))) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(defun previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
Emacs buffers are those whose name starts with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (not (string-match "^*" (buffer-name))) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))


(defun mark-line(&optional arg allow-extend)
  "Set mark ARG sexps from point.
The place mark goes is the same place \\[forward-sexp] would
move to with the same argument.
Interactively, if this command is repeated
or (in Transient Mark mode) if the mark is active,
it marks the next ARG sexps after the ones already marked.
This command assumes point is not in a string or comment."
  (interactive "P\np")
  (cond ((and allow-extend
	      (or (and (eq last-command this-command) (mark t))
		  (and transient-mark-mode mark-active)))
	 (setq arg (if arg (prefix-numeric-value arg)
		     (if (< (mark) (point)) -1 1)))
	 (set-mark
	  (save-excursion
	    (goto-char (mark))
	    (end-of-line arg)
	    (point))))
	(t
	 (push-mark
	  (save-excursion
	    (end-of-line (prefix-numeric-value arg))
	    (point))
	  nil t))))

(defun scale-image (fileList scalePercentage)
  "Create a scaled jpg version of images of marked files in dired.
The new names have “-s” appended before the file name extension.
Requires ImageMagick shell tool."
  (interactive
   (list (dired-get-marked-files) (read-from-minibuffer "scale percentage:")))
  (require 'dired)

  (mapc
     (lambda (ξf)
       (let ( newName cmdStr )
         (setq newName (concat (file-name-sans-extension ξf) "-s" ".jpg") )
         (while (file-exists-p newName)
           (setq newName (concat (file-name-sans-extension newName) "-s" (file-name-extension newName t))) )

         ;; relative paths used to get around Windows/Cygwin path remapping problem
         (setq cmdStr (concat "convert -scale " scalePercentage "% -quality 85% " (file-relative-name ξf) " " (file-relative-name newName)) )
         (shell-command cmdStr)
         ))
     fileList ))


(defun 2-jpg (fileList)
  "Create a jpg version of images of marked files in dired.
Requires ImageMagick shell tool.
"
  (interactive (list (dired-get-marked-files) ))
  (require 'dired)

  (mapc
     (lambda (ξf)
       (let ( newName cmdStr )
         (setq newName (concat (file-name-sans-extension ξf) ".jpg") )
         (while (file-exists-p newName)
           (setq newName (concat (file-name-sans-extension newName) "-2" (file-name-extension newName t))) )

         ;; relative paths used to get around Windows/Cygwin path remapping problem
         (setq cmdStr (concat "convert  -density 300 -quality 80 " (file-relative-name ξf) " " (file-relative-name newName)) )

         ;; (async-shell-command cmdStr)
         (shell-command cmdStr)
         ))
     fileList ))


;; (defun 2-jpg (fileList)
;;   "Create a jpg version of images of marked files in dired.
;; Requires ImageMagick shell tool.
;; "
;;   (interactive (list (dired-get-marked-files) ))
;;   (require 'dired)

;;   (mapc
;;    (lambda (ξf)
;;      (let ( newName cmdStr )
;;        (setq newName (concat (file-name-sans-extension ξf) ".jpg") )
;;        (while (file-exists-p newName)
;;          (setq newName (concat (file-name-sans-extension newName) "-2" (file-name-extension newName t))) )

;;        ;; (async-shell-command cmdStr)
;;        ;; " " 은 async-start-process 가 자동으로 넣어준다. 
;;        (async-start-process 
;;         "2-jpg"
;;         "gswin32c"   
;;         nil
;;         "-dNOPAUSE" 
;;         "-dBATCH" 
;;         "-sDEVICE=jpeg"  
;;         "-r256" 
;;         (concat "-sOutputFile=" (file-relative-name newName))
;;         (file-relative-name ξf))
;;        ;;deprecated;;(async-shell-command 
;;        ;;deprecated;; (format "gswin32c -dNOPAUSE -dBATCH -sDEVICE=jpeg  -r256 -sOutputFile=\"%s\" \"%s\"" 
;;        ;;deprecated;;         (file-relative-name newName)  (file-relative-name ξf)) )
;;        ;;deprecated;;))

;;        ))
   
;;    fileList))


(defun 2-tif(fileList)
  "Create a jpg version of images of marked files in dired.
Requires ImageMagick shell tool.
"
  (interactive (list (dired-get-marked-files) ))
  (require 'dired)

  (mapc
   (lambda (ξf)
     (let ( newName cmdStr )
       (setq newName (concat (file-name-sans-extension ξf) ".tif") )
       (while (file-exists-p newName)
         (setq newName (concat (file-name-sans-extension newName) "-2" (file-name-extension newName t))) )

       ;; (async-shell-command cmdStr)
       ;;deprecated;;(async-shell-command 
       ;;deprecated;; (format "gswin32c -dNOPAUSE -dBATCH -r512-sDEVICE=tiffg4 -sOutputFile=\"%s\" \"%s\"" (file-relative-name newName)  (file-relative-name ξf)) )
       ;;deprecated;;)

       (async-start-process 
        "2-tif"
        "gswin32c"   
        nil
        "-dNOPAUSE" 
        "-dBATCH" 
        "-sDEVICE=tiffg4"  
        "-r256" 
        (concat "-sOutputFile=" (file-relative-name newName))
        (file-relative-name ξf))

       ))
   fileList))



(defun rotate-image (fileList)
  "Create a jpg version of images of marked files in dired.
Requires ImageMagick shell tool.
"
  (interactive (list (dired-get-marked-files) ))
  (require 'dired)

  (mapc
   (lambda (ξf)
     (let ( newName cmdStr )
       (setq newName (concat (file-name-sans-extension ξf) "-r180." (file-name-extension ξf)) )
       (while (file-exists-p newName)
         (setq newName (concat (file-name-sans-extension newName) "-2" (file-name-extension newName t))) )

       ;; (async-shell-command cmdStr)
       ;;deprecated;;(async-shell-command 
       ;;deprecated;; (format "convert -rotate 180 \"%s\" \"%s\""   (file-relative-name ξf) (file-relative-name newName)) )

       (async-start-process 
        "rotate-image"
        "convert"   
        nil
        "-rotate" 
        "180" 
        (file-relative-name ξf)
        (file-relative-name newName))

       ))
   fileList ))


;; http://www.imagemagick.org/script/formats.php
;; http://www.imagemagick.org/script/command-line-options.php

(defun 2fax () 
  (interactive)
  (require 'dired)

  (mapcar 
   (lambda (f)
     (let ((tmpfilename (make-temp-name "fax")))

     (async-start-process
      "2fax"
      "convert"
      (lambda (p) (rename-file tmpfilename f t) (message f))
      f
      "-resample"
      "144x144"
      "-compress"
      ;; "Fax"                             ;Group4 - 압축률 더 높음 
      "Group4" 
      tmpfilename
      )))
   (dired-get-marked-files)))

(defun image-identity () 
  (interactive)
  (require 'dired)

  (mapcar 
   (lambda (f)
     (async-start-process ;;impossible;;-reuse-buffer
      "image-identity"
      "identify"
      nil
      "-verbose"
      f
      ))
   (dired-get-marked-files)))


(defcustom pyclip (fullpath "../misc/pyclip3.py") "python clip")



(defun copy-image-file (file)
  "Display Windows context menu on selected files"
  (interactive)

  (if (eq system-type 'windows-nt)
      
      ;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Calling-Functions.html
      (async-start-process ;;impossible;;-reuse-buffer 
       "clip-image" 
       "python.exe"
       (lambda (p) (message "이미지 복사 완료"))
       pyclip
       "--image"
       file)))

(defun copy-files (&rest files)
  "Display Windows context menu on selected files"
  (interactive)
  (if (eq system-type 'windows-nt)
      
        (apply
         #'async-start-process  ;;impossible;;-reuse-buffer 
         "clip-file" 
         "c:/usr/local/python35/python.exe"
         (lambda (p) (message "파일복사 완료"))
         pyclip
         files)))


(defun clip-file ()
  "Display Windows context menu on selected files"
  (interactive)

  (if (eq system-type 'windows-nt)
      (let* ((files (dired-get-marked-files))
             (files (if (null files)
                        (list (dired-current-directory) )
                      files)))
        ;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Calling-Functions.html
        (apply #'copy-files files))))

(defun clip-image ()
  "Display Windows context menu on selected files"
  (interactive)

  (if (eq system-type 'windows-nt)
      (let* ((files (dired-get-marked-files))
             (files (if (null files)
                        (list (dired-current-directory) )
                      files)))
        ;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Calling-Functions.html
        (copy-image-file (car files)))))




(use-package dired
  :config
  (define-key dired-mode-map ":c" 'clip-file)
  (define-key dired-mode-map ":i" 'clip-image))



(defun 2-zip ()
  "Zip the current file/dir in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip commandline tool."
  (interactive)
  (require 'dired)
  (let ( (fileName (elt (dired-get-marked-files) 0))  )
    (shell-command (format "zip -r '%s.zip' '%s'" (file-relative-name fileName) (file-relative-name fileName)))
    ))


(defun unzip(fileList)
  "Zip the current file/dir in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip commandline tool."
  (interactive (list (dired-get-marked-files) ))
  (require 'dired)
  (mapc
   (lambda (ξf)
     (let ( newName cmdStr )
       (setq newName (file-name-sans-extension ξf))
       (while (file-exists-p newName)
         (setq newName (concat (file-name-sans-extension newName) "-2" (file-name-extension newName t))) )

       ;; (async-shell-command cmdStr)
       ;;deprecated;;(async-shell-command 
       ;;deprecated;; (format "convert -rotate 180 \"%s\" \"%s\""   (file-relative-name ξf) (file-relative-name newName)) )

       (async-start-process 
        "unzip"
        "unzip"   
        nil
        ξf
        "-d"
        (file-relative-name newName))

       ))
   fileList ))


(defun 2-7zip ()
  "Zip the current file/dir in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip commandline tool."
  (interactive)
  (require 'dired)
  (let ( (fileName (elt (dired-get-marked-files) 0))  )
    (async-shell-command (format "7z a \"%s.7z\" \"%s\"" (file-relative-name fileName) (file-relative-name fileName)))
    ))

(defun youtube ()
  "Search YouTube with a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.youtube.com/results?search_query="
    (url-hexify-string (if mark-active
                           (buffer-substring (region-beginning) (region-end))
                         (read-string "Search YouTube: "))))))
(defun delete-current-file (ξno-backup-p)
  "Delete the file associated with the current buffer.

Also close the current buffer.  If no file is associated, just close buffer without prompt for save.

A backup file is created with filename appended “~‹date time stamp›~”. Existing file of the same name is overwritten.

when called with `universal-argument', don't create backup."
  (interactive "P")
  (let (fName)
    (when (buffer-file-name) ; buffer is associated with a file
      (setq fName (buffer-file-name))
      (save-buffer fName)
      (if ξno-backup-p
          (progn )
        (copy-file fName (concat fName "~" (format-time-string "%Y%m%d_%H%M%S") "~") t)
        )
      (delete-file fName)
      (message "「%s」 deleted." fName)
      )
    (kill-buffer (current-buffer))
    ) )


(defvar firefox-bookmark-backup-folder (fullpath "../../bookmarks/"))
(defun fbmk ()
  (interactive)
  (let* ((fb
          (caar (sort 
                 (directory-files-and-attributes "C:/Users/dongil/AppData/Roaming/Mozilla/Firefox/Profiles/iyq62fu7.default/bookmarkbackups" t ".json")
                 (lambda (x y) (> (float-time (nth 6 x)) (float-time (nth 6 y))))
                 )))

         (children (cdr (assoc 'children (json-read-file (pyutil-mozlz4-decompress fb)) )))
         ;;(bookmenu (elt children 0))
         ;;(booktool (elt children 1))
         (allbookmark (cdr (assoc 'children (elt children 0))))
         ;;(untag (elt children 3))
         (stag (helm-comp-read ;;ido-completing-read 
                "TAG 를 입력하세요 : "
                ;;completing-read;;(mapcar (function (lambda (x) (list (car x) t))) winexe-cmdlist)
                (sort (delete-dups (remove nil  (mapcar (lambda (x)  (cdr (assoc 'tags x ))) allbookmark ))) #'string<)))
         (tagcontents (remove-if (lambda (x) (not (string= stag (cdr (assoc 'tags x ))))) allbookmark))
         (btitle (helm-comp-read
                  "TITLE 를 입력하세요 : "
                  (mapcar (lambda (x) (cdr (assoc 'title x ))) tagcontents ) ))
         (bookmark (find-if (lambda (x) (string= btitle (cdr (assoc 'title x )))) tagcontents)))
    (browse-url (cdr (assoc 'uri bookmark )))
    (copy-file fb firefox-bookmark-backup-folder  t t   )
    )) 


;;(with-package (multi))

;; (defun one-space (b e &optional)
;;   "Delete lines which appear to be RFC-822 cruft, mail or news.
;; With prefix arg, start from point; otherwise do whole buffer."
;;   (interactive "r\nP")
;;   (save-excursion
;;     (save-restriction 
;;       (goto-char (point-min))
;;       (while (re-search-forward "  " nil t)
;;         (replace-match " ")
;;         (goto-char (point-min))
;;         ))))



(defun tags-replace-string (from to &optional delimited file-list-form)
  "Do `query-replace-regexp' of FROM with TO on all files listed in tags table.
Third arg DELIMITED (prefix arg) means replace only word-delimited matches.
If you exit (\\[keyboard-quit], RET or q), you can resume the query replace
with the command \\[tags-loop-continue].
Fourth arg FILE-LIST-FORM non-nil means initialize the replacement loop.
Fifth and sixth arguments START and END are accepted, for compatibility
with `query-replace-regexp', and ignored.

If FILE-LIST-FORM is non-nil, it is a form to evaluate to
produce the list of files to search.

See also the documentation of the variable `tags-file-name'."
  (interactive (query-replace-read-args "Tags query replace (regexp)" t t))
  (setq tags-loop-scan `(let ,(unless (equal from (downcase from))
				'((case-fold-search nil)))
			  (if (re-search-forward ',from nil t)
			      ;; When we find a match, move back
			      ;; to the beginning of it so perform-replace
			      ;; will see it.
			      (goto-char (match-beginning 0))))
	tags-loop-operate `(perform-replace ',from ',to nil nil ',delimited
					    nil multi-query-replace-map))
  (tags-loop-continue (or file-list-form t)))



(defun dired-do-replace-string(from to &optional delimited)
  "Do `query-replace-regexp' of FROM with TO, on all marked files.
Third arg DELIMITED (prefix arg) means replace only word-delimited matches.
If you exit (\\[keyboard-quit], RET or q), you can resume the query replace
with the command \\[tags-loop-continue]."
  (interactive
   (let ((common
	  (query-replace-read-args
	   "Query replace regexp in marked files" t t)))
     (list (nth 0 common) (nth 1 common) (nth 2 common))))
  (dolist (file (dired-get-marked-files nil nil 'dired-nondirectory-p))
    (let ((buffer (get-file-buffer file)))
      (if (and buffer (with-current-buffer buffer
			buffer-read-only))
	  (error "File `%s' is visited read-only" file))))
  (tags-replace-string from to delimited
		      '(dired-get-marked-files nil nil 'dired-nondirectory-p)))
;;; http://planet.emacsen.org/
(defun url-humanify ()
  "Take the URL at point and make it human readable."
  (interactive)
  (let* ((area (bounds-of-thing-at-point 'url))
         (num-params  (count-occurances-in-region "&" (car area) (cdr area)))
         (i 0))
    (beginning-of-thing 'url)
    (when (search-forward "?" (cdr area) t nil)
      (insert "\n  ")
      (while (< i num-params)
        (search-forward "&" nil t nil)
        (insert "\n  ")
        (save-excursion
          (previous-line)
          (beginning-of-line)
          (let ((start (search-forward "="))
                (end (search-forward "&")))
            (url-decode-region start end)))
        (setq i (+ i 1))))))

(defun url-decode-region (start end)
  "Replace a region with the same contents, only URL decoded."
  (interactive "r")
  (let ((text (url-unhex-string (buffer-substring start end))))
    (delete-region start end)
    (insert text)))

(defun count-occurances-in-region (needle start end)
  (save-excursion
    (let ((found 0))
      (goto-char start)
      (while (search-forward needle end t nil)
        (setq found (+ found 1)))
      found)))


(defun append-rectangle ()
  "Yank the last killed rectangle with upper left corner at point."
  (interactive "*")
  (let ((lines killed-rectangle)
	(insertcolumn (current-column))
	(first t))
    (push-mark)
    (while lines
      (or first
	  (progn
	   (forward-line 1)
	   (or (bolp) (insert ?\n))
	   (end-of-line)))
      (setq first nil)
      (insert-for-yank (car lines))
      (setq lines (cdr lines)))))


(defun folder175 (folder) 
  (interactive
   (list 
    (ido-completing-read "폴더명을 입력하세요 :"
                         '("0. 연구소 공통"
                           "1. 완료 사업"
                           "2. 진행 사업"
                           "4. 공통"
                           "5. 제안서"))))
  
  (dired (concat  "//10.239.12.175/" folder)))

;;; http://ergoemacs.org/emacs/elisp_make-html-table.html

(defun make-html-table-string (textblock delim)
  "Transform the string TEXTBLOCK into a HTML marked up table.
“\n” is used as delimiter of rows.
The argument DELIM is a char used as the delimiter for columns.

See the parent function `make-html-table'."
  (setq textblock (replace-regexp-in-string delim "</td><td>" textblock))
  (setq textblock (replace-regexp-in-string "\n" "</td></tr>\n<tr><td>" textblock))
  (setq textblock (substring textblock 0 -8)) ; delete the beginning “<tr><td>” in last line
  (concat "<table class=\"nrm\">\n<tr><td>" textblock "</table>")
  )


(defun make-html-table (sep)
  "Transform the current paragraph into a HTML table.

The “current paragraph” is defined as having empty lines before and
after the block of text the cursor is on.

For example:

a*b*c
1*2*3
this*and*that

with “*” as separator, becomes

<table class=\"nrm\">
<tr><td>a</td><td>b</td><td>c</td></tr>
<tr><td>1</td><td>2</td><td>3</td></tr>
<tr><td>this</td><td>and</td><td>that</td></tr>
</table>"
  (interactive "sEnter string pattern for column separation:")
  (let (bds p1 p2 myStr)
    (setq bds (bounds-of-thing-at-point 'paragraph))
    (setq p1 (+ (car bds) 1))
    (setq p2 (cdr bds))
    (setq myStr (buffer-substring-no-properties p1 p2))
    (delete-region p1 p2)
    (insert (make-html-table-string myStr sep) "\n")
  ))


;;; http://www.reddit.com/r/emacs/comments/1n3nhg/simple_templates/?utm_source=dlvr.it&utm_medium=twitter


(defun ido-insert-template ()
  (interactive)
  (let ((default-directory "~/template"))
    (call-interactively #'ido-insert-file)))



;;; http://nullprogram.com/blog/2010/09/29/
;; ID: c7db6dec-e7ab-3b0f-bf26-0fa268674c6c
(defun expose (function)
  "Return an interactive version of FUNCTION."
  (lexical-let ((lex-func function))
    (lambda ()
      (interactive)
      (funcall lex-func))))

;;; usage : (global-set-key [f2] (expose (apply-partially 'revert-buffer nil t)))
;;; https://github.com/skeeto/.emacs.d/blob/master/etc/package-helper.el



(defun replace-string-exhaust (from-string to-string &optional delimited start end)
  "Replace occurrences of FROM-STRING with TO-STRING.
Preserve case in each match if `case-replace' and `case-fold-search'
are non-nil and FROM-STRING has no uppercase letters.
\(Preserving case means that if the string matched is all caps, or capitalized,
then its replacement is upcased or capitalized.)

Ignore read-only matches if `query-replace-skip-read-only' is non-nil,
ignore hidden matches if `search-invisible' is nil, and ignore more
matches using `isearch-filter-predicate'.

If `replace-lax-whitespace' is non-nil, a space or spaces in the string
to be replaced will match a sequence of whitespace chars defined by the
regexp in `search-whitespace-regexp'.

Third arg DELIMITED (prefix arg if interactive), if non-nil, means replace
only matches surrounded by word boundaries.

Operates on the region between START and END (if both are nil, from point
to the end of the buffer).  Interactively, if Transient Mark mode is
enabled and the mark is active, operates on the contents of the region;
otherwise from point to the end of the buffer.

Use \\<minibuffer-local-map>\\[next-history-element] \
to pull the last incremental search string to the minibuffer
that reads FROM-STRING.

This function is usually the wrong thing to use in a Lisp program.
What you probably want is a loop like this:
  (while (search-forward FROM-STRING nil t)
    (replace-match TO-STRING nil t))
which will run faster and will not set the mark or print anything.
\(You may need a more complex loop if FROM-STRING can match the null string
and TO-STRING is also null.)"
  (interactive
   (let ((common
	  (query-replace-read-args
	   (concat "Replace"
		   (if current-prefix-arg " word" "")
		   " string"
		   (if (and transient-mark-mode mark-active) " in region" ""))
	   nil)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
	   (if (and transient-mark-mode mark-active)
	       (region-beginning) (point))
	   (if (and transient-mark-mode mark-active)
	       (region-end) (point-max)))))
  (save-excursion
    (save-restriction
      (narrow-to-region start end))
    (while (search-forward from-string nil t)
      (replace-match to-string nil t)
      (goto-char (point-min))
      )))

(defun unicode-debug ()
  (interactive)
  (unicode-fonts-debug-info-at-point))


(require 'dpaste_de)


(defun depend-files (fileList)
  "Zip the current file/dir in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip commandline tool."
  (interactive (list (dired-get-marked-files)))
  (require 'dired)

  (with-current-buffer (get-buffer-create "*depend-output*")
    (setq allout-primary-bullet "---*")
    (allout-mode)
    (goto-char (point-min))
    (mapcar 
     (lambda (f)
       (shell-command (format "depends.exe /c /ot:\"%s/depend.txt\"  \"%s\"  " (getenv "TEMP") f))
       (message (format "depends.exe /c /ot:\"%s/depend.txt\"  \"%s\"  " (getenv "TEMP") f))

       (insert (format "---* %s\n" f))
       
       (insert-file-contents (format "%s/depend.txt" (getenv "TEMP"))) 
       (goto-char (point-max))
       (insert (format "\n" f))) fileList)))
     

(defun what ()   
  (interactive )
  (what-cursor-position t))
;; depends.exe  /c /ot:"t:/xxx.txt" depends.exe


(defun replace-html-chars-region (start end)
  "Replace “<” to “&lt;” and other chars in HTML.
This works on the current region."
  (interactive "r")
  (save-restriction 
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (search-forward "&" nil t) (replace-match "&amp;" nil t))
    (goto-char (point-min))
    (while (search-forward "<" nil t) (replace-match "&lt;" nil t))
    (goto-char (point-min))
    (while (search-forward ">" nil t) (replace-match "&gt;" nil t))
    )
  ) 

;; Type chcp 65001. This will change output's encoding to
;; utf-8. Also, you need to change font to Lucinda Console. However, even
;; this doesn't work well, because Lucinda Console does not contain main
;; Unicode symbols, and i still get dangerous beeps when type
;; my_unicode.txt.
(defun shellutf8 ()
  (interactive )
  (universal-coding-system-argument 'utf-8)
  (shell)
)


(cl-defun remove-from-list (list-var element &key key test)
  "Remove ELEMENT from the value of LIST-VAR if present.

This can be used as an inverse of `add-to-list'."
  (unless key (setq key #'identity))
  (unless test (setq test #'equal))
  (setf (symbol-value list-var)
        (cl-remove element
                   (symbol-value list-var)
                   :key key
                   :test test)))


(defun toggle-current-window-dedication ()
 (interactive)
 (let* ((window    (selected-window))
        (dedicated (window-dedicated-p window)))
   (set-window-dedicated-p window (not dedicated))
   (message "Window %sdedicated to %s"
            (if dedicated "no longer " "")
            (buffer-name))))


(defun replace-auto-mode-alist (mode-from mode-to)
  (setq auto-mode-alist (mapcar (lambda (x) (if (equal mode-from (cdr x)) (cons (car x) mode-to) x)) auto-mode-alist)))


(define-key isearch-mode-map (kbd "C-d")
  'fc/isearch-yank-symbol)
(defun fc/isearch-yank-symbol ()
  "Yank the symbol at point into the isearch minibuffer.

C-w does something similar in isearch, but it only looks for
the rest of the word. I want to look for the whole string. And
symbol, not word, as I need this for programming the most."
  (interactive)
  (isearch-yank-string
   (save-excursion
     (when (and (not isearch-forward)
                isearch-other-end)
       (goto-char isearch-other-end))
     (thing-at-point 'symbol))))


(defun int-to-binary-string (i)
  "convert an integer into it's binary representation in string format"
  (let ((res ""))
    (while (not (= i 0))
      (setq res (concat (if (= 1 (logand i 1)) "1" "0") res))
      (setq i (lsh i -1)))
    (if (string= res "")
        (setq res "0"))
    res))

(defun xah-make-backup ()
  "Make a backup copy of current file.
The backup file name has the form 「‹name›~‹timestamp›~」, in the same dir. If such a file already exist, it's overwritten.
If the current buffer is not associated with a file, nothing's done.
URL `http://ergoemacs.org/emacs/elisp_make-backup.html'
Version 2014-10-13"
  (interactive)
  (if (buffer-file-name)
      (let* ((ξcurrentName (buffer-file-name)) 
             (ξbackupName (concat ξcurrentName "~" (format-time-string "%Y%m%d_%H%M%S") "~")))
        (copy-file ξcurrentName ξbackupName t)
        (message (concat "Backup saved as: " (file-name-nondirectory ξbackupName))))
    (user-error "buffer is not a file.")
    ))



(defun xah-shrink-whitespaces ()
  "Remove whitespaces around cursor to just one or none.
Remove whitespaces around cursor to just one space, or remove neighboring blank lines to just one or none.
URL `http://ergoemacs.org/emacs/emacs_shrink_whitespace.html'
Version 2015-03-03"
  (interactive)
  (let ((ξpos (point))
        ξline-has-char-p ; current line contains non-white space chars
        ξhas-space-tab-neighbor-p
        ξwhitespace-begin ξwhitespace-end
        ξspace-or-tab-begin ξspace-or-tab-end
        )
    (save-excursion
      (setq ξhas-space-tab-neighbor-p (if (or (looking-at " \\|\t") (looking-back " \\|\t")) t nil))
      (beginning-of-line)
      (setq ξline-has-char-p (search-forward-regexp "[[:graph:]]" (line-end-position) t))

      (goto-char ξpos)
      (skip-chars-backward "\t ")
      (setq ξspace-or-tab-begin (point))

      (skip-chars-backward "\t \n")
      (setq ξwhitespace-begin (point))

      (goto-char ξpos)
      (skip-chars-forward "\t ")
      (setq ξspace-or-tab-end (point))
      (skip-chars-forward "\t \n")
      (setq ξwhitespace-end (point)))

    (if ξline-has-char-p
        (if ξhas-space-tab-neighbor-p
            (let (ξdeleted-text)
              ;; remove all whitespaces in the range
              (setq ξdeleted-text
                    (delete-and-extract-region ξspace-or-tab-begin ξspace-or-tab-end))
              ;; insert a whitespace only if we have removed something different than a simple whitespace
              (when (not (string= ξdeleted-text " "))
                (insert " ")))

          (progn
            (when (equal (char-before) 10) (delete-char -1))
            (when (equal (char-after) 10) (delete-char 1))))
      (progn (delete-blank-lines)))))

(defun funbm ()
  (interactive)
  (kill-new
   (format "%s:%s"
           (buffer-name) (which-function))))



(defun xah-cycle-hyphen-underscore-space (φp1 φp2)
  "Cycle {underscore, space, hypen} chars of current word or text selection.
When called repeatedly, this command cycles the {“_”, “-”, “ ”} characters, in that order.

When called in elisp code, φp1 φp2 are region begin/end positions.
URL `http://ergoemacs.org/emacs/elisp_change_space-hyphen_underscore.html'
Version 2015-04-13"
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (let ((ξbounds (bounds-of-thing-at-point 'symbol)))
       (list (car ξbounds) (cdr ξbounds)))))
  ;; this function sets a property 「'state」. Possible values are 0 to length of ξcharArray.
  (let* ((ξinputText (buffer-substring-no-properties φp1 φp2))
         (ξcharArray ["_" "-" " "])
         (ξlength (length ξcharArray))
         (ξregionWasActive-p (region-active-p))
         (ξnowState
          (if (equal last-command this-command )
              (get 'xah-cycle-hyphen-underscore-space 'state)
            0 ))
         (ξchangeTo (elt ξcharArray ξnowState)))
    (save-excursion
      (save-restriction
        (narrow-to-region φp1 φp2)
        (goto-char (point-min))
        (while
            (search-forward-regexp
             (concat
              (elt ξcharArray (% (+ ξnowState 1) ξlength))
              "\\|"
              (elt ξcharArray (% (+ ξnowState 2) ξlength)))
             (point-max)
             'NOERROR)
          (replace-match ξchangeTo 'FIXEDCASE 'LITERAL))))
    (when (or (string= ξchangeTo " ") ξregionWasActive-p)
      (goto-char φp2)
      (set-mark φp1)
      (setq deactivate-mark nil))
    (put 'xah-cycle-hyphen-underscore-space 'state (% (+ ξnowState 1) ξlength))))


(defun isearchback ()
  "Delete the failed portion of the search string, or the last char if successful."
  (interactive)
  (with-isearch-suspended
      (setq isearch-new-string
            (substring
             isearch-string 0 (or (isearch-fail-pos) (1- (length isearch-string))))
            isearch-new-message
            (mapconcat 'isearch-text-char-description isearch-new-string ""))))

(define-key isearch-mode-map (kbd "<backspace>") 'isearchback)



(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))
;; thanks to “Pascal J Bourguignon” and “TheFlyingDutchman 〔zzbba…@aol.com〕”. 2010-09-02


(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))



;; https://github.com/NicolasPetton/seq.el
(require 'seq)
(load "~/savemacro.el")

(defun vdpaste (name)
  (interactive "Spaste 이름을 입력해 주세요 :")  ; ask for the name of the macro
  (eww (format "http://10.239.12.181:8000/dpaste/%s/raw" name)))






(defun xah-copy-to-register-1 ()
  "Copy current line or text selection to register 1.
See also: `xah-paste-from-register-1', `copy-to-register'.

URL `http://ergoemacs.org/emacs/elisp_copy-paste_register_1.html'
Version 2015-12-08"
  (interactive)
  (let (ξp1 ξp2)
    (if (region-active-p)
        (progn (setq ξp1 (region-beginning))
               (setq ξp2 (region-end)))
      (progn (setq ξp1 (line-beginning-position))
             (setq ξp2 (line-end-position))))
    (copy-to-register ?1 ξp1 ξp2)
    (message "copied to register 1: 「%s」." (buffer-substring-no-properties ξp1 ξp2))))



(defun xah-paste-from-register-1 ()
  "Paste text from register 1.
See also: `xah-copy-to-register-1', `insert-register'.
URL `http://ergoemacs.org/emacs/elisp_copy-paste_register_1.html'
Version 2015-12-08"
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end)))
  (insert-register ?1 t))


;;_ http://emacsredux.com/blog/2013/03/27/copy-filename-to-the-clipboard/ https://github.com/bbatsov/prelude 
(defun prelude-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

;; http://pages.sachachua.com/.emacs.d/Sacha.html#orgheadline13
(defun my/shuffle-lines-in-region (beg end)
  (interactive "r")
  (let ((list (split-string (buffer-substring beg end) "[\r\n]+")))
    (delete-region beg end)
    (insert (mapconcat 'identity (shuffle-list list) "\n"))))



;; 재미있는 함수 
(defun create-scratch-buffer nil
  "create a new scratch buffer to work in. (could be *scratch* - *scratchX*)"
  (interactive)
  (let ((n 0)
	bufname)
    (while (progn
	     (setq bufname (concat "*scratch" (if (= n 0) "" (int-to-string n)) "*"))
	     (setq n (1+ n))
	     (get-buffer bufname)))
    (switch-to-buffer (get-buffer-create bufname))
    (if (= n 1) (lisp-interaction-mode))))  ; 1, because n was incremented))

(defun tmpscratch ()
  (interactive)
  (let ((b (get-buffer "*scratch*"))) 
    (if (equal nil b ) (create-scratch-buffer) (switch-to-buffer b ))))

(global-set-key 
 (kbd  "M-<pause>") 
 #'tmpscratch
 )



(defun bury-scratch ()
  "Bury scratch buffer and return nil. Intended to be added to
kill-buffer-query-functions in order to prevent the scratch
buffer being killed."
  (if (or  (string= (buffer-name) "*scratch*")
           (string-match "^\*new" (buffer-name)))
      (progn (bury-buffer) nil)
    t))

(add-to-list 'kill-buffer-query-functions 'bury-scratch)

(defun new-scratch ()
  "open up a guaranteed new scratch buffer"
  (interactive)
  (switch-to-buffer (make-temp-file "kim")))

;; (loop for num from 0 
;; for name = (format "blah-%03i" num) while (get-buffer name) finally return name))) 


(defun copy-file-name ()
  "Returns the extention of the buffer file"
  (interactive)
  (kill-new (buffer-file-name)))

;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with SPC f and enter text in its buffer.

(defun refine-all ()
  (interactive)
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (while (>  (point-max) (point))
        (diff-hunk-next)
        (diff-refine-hunk)))))


(defun vimish-fold-dwim ()
  (interactive)
  (if (region-active-p)
      (vimish-fold (region-beginning) (region-end))
    (vimish-fold-toggle)))
