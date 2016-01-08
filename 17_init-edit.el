;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

;;SDD;;(defun ib () (interactive)  (insert "default : break; "))
;;SDD;;(defun sdd () (interactive) (insert ( format "//@@@ " )) (kill-new "//@@@\n"))
;;SDD;;
;;SDD;;(global-set-key [f12] 'sdd )
;;SDD;;
;;SDD;;(defun ifsdd () 
;;SDD;;  (interactive) 
;;SDD;;  (insert "
;;SDD;;  //@@@ if( ){
;;SDD;;  //@@@   return ; 
;;SDD;;  //@@@ }
;;SDD;;"))
;;SDD;;
;;SDD;;(global-set-key [f11] 'ifsdd )

(defun sdd-cmt (start end )
 (interactive "r ")
 (let ((proto (buffer-substring-no-properties start end) ))
  (insert (string-replace-match "[(),]" proto " " t t ))))

(defun sdd-header (start end )
 (interactive "r ")
 (hl-line-mode t )
 (save-excursion
   (save-restriction
     (narrow-to-region start end)
     (replace-string ";" "; //@@@ " nil (point-min) (point-max))
     (set-middle (point-min) (point-max) "//@@@")
     (widen))))

(defun sdd-single ()
 (interactive )
 (insert "//@@@ 클래스의 유일한 인스턴스를 리턴하는 클래스함수 "))

(defun set-middle-m (start end &optional s)
  (interactive "r\ns구분자 : ")
  (save-excursion
    (let ((result '()))
      (goto-char start)
      (while (not (equal nil (re-search-forward "[A-Za-z0-9] +[A-Za-z]" end t) ))
        (backward-char)
        (setf result (cons (list (point-at-bol) (point)) result )))

      (setf result (reverse result))

      (let ((middle (apply #'max (mapcar (lambda (x) (- (cadr x ) (car x ))) result ))   ))
        (goto-char start)
        (while (not (equal nil (re-search-forward "[A-Za-z0-9] +[A-Za-z]" end t)))
          (backward-char)
          (let ((pos (car result)))
            (setf result (cdr result))
            (backward-char 1)
            (insert-before-markers (make-string  (- middle (- (cadr pos ) (car pos ))) ?\s))

            (move-end-of-line nil )))))))
          

;;(defun set-middle (start end  s)
;;  (interactive "r\ns구분자 : ")
;;  (save-excursion
;;    (let ((result '()))
;;      (goto-char start)
;;      (while (not (equal nil (search-forward s end t) ))
;;        (setf result (cons (list (point-at-bol) (point)) result ))
;;        (move-end-of-line nil ))
;;      (setf result (reverse result))
;;      (let ((middle (apply #'max (mapcar (lambda (x) (- (cadr x ) (car x ))) result ))   ))
;;        (goto-char start)
;;        (while (not (equal nil (search-forward s end t) ))
;;          (let ((pos (car result)))
;;            (setf result (cdr result))
;;            (backward-char 1)
;;            (insert-before-markers (make-string  (- middle (- (cadr pos ) (car pos ))) ?\s))
;;            (setf end (+ end (- middle (- (cadr pos ) (car pos )))))
;;            (move-end-of-line nil )))))))


;;;(defun set-middle (start end  s)
;;;  (interactive "r\ns구분자 정규식: ")
;;;  (save-excursion
;;;    (let ((result '()))
;;;      (goto-char start)
;;;      (while (not (equal nil (search-forward-regexp s end t) ))
;;;        (message (format "%d" (point-at-bol)))
;;;        (setf result (cons (list (point-at-bol) (point)) result ))
;;;        (move-end-of-line nil ))
;;;      (setf result (reverse result))
;;;      (let ((middle (apply #'max (mapcar (lambda (x) (- (cadr x ) (car x ))) result ))   ))
;;;        (goto-char start)
;;;        (while (not (equal nil (search-forward-regexp s end t) ))
;;;          (let ((pos (car result)))
;;;            (message (format "%d" (point-at-bol)))
;;;            (setf result (cdr result))
;;;            (backward-char 1)
;;;            (insert-before-markers (make-string  (- middle (- (cadr pos ) (car pos ))) ?\s))
;;;            (setf end (+ end (- middle (- (cadr pos ) (car pos )))))
;;;            (move-end-of-line nil )))))))



(defun set-middle (start end  s)
  (interactive "r\ns구분자 정규식: ")
  (save-excursion
    (let ((result '()))
      (goto-char start)
      (while (not (equal nil (search-forward-regexp s end t) ))
        (message (format "%d" (point-at-bol)))
        (setf result (cons (list (point-at-bol) (match-beginning 0)) result ))
        (move-end-of-line nil ))
      (setf result (reverse result))
      (let ((middle (apply #'max (mapcar (lambda (x) (- (cadr x ) (car x ))) result ))   ))
        (goto-char start)
        (while (not (equal nil (search-forward-regexp s end t) ))
          (let ((pos (car result)))
            (message (format "%d" (point-at-bol)))
            (setf result (cdr result))
            ;;(backward-char 1)
            (goto-char (match-beginning 0))
            (insert-before-markers (make-string  (- middle (- (cadr pos ) (car pos ))) ?\s))
            (setf end (+ end (- middle (- (cadr pos ) (car pos )))))
            (move-end-of-line nil )))))))

(define-key esc-map (kbd "C-;") 'set-middle)

(defun insert-function-table ()
  (interactive)
  (insert "<함수테이블> <내용>" ))

(defun insert-cross-reference ()
  (interactive)
  (insert "# #" ) (backward-char 1))

(defun insert-cdata ()
  (interactive)
  (insert " <![CDATA[]]>" ))

(global-set-key "\C-ct" 'insert-function-table )
(global-set-key "\C-cj" 'insert-cross-reference )

(defun insert-string() 
  (interactive)
  (insert " : \"\"" ) (backward-char 1 ))

(defun upcase-symbol (syms)
  (interactive)
  (mapcar 
   (lambda (x)
     (replace-string 
      (symbol-name x )
      (upcase (symbol-name x )) t (point-min) (point-max )))
   syms ))


(defun xmltable ()
  (interactive)
  (replace-string "기능	" "")
  (beginning-of-buffer)
  (replace-string "함수명	" "")
  (beginning-of-buffer)
  (replace-string "입력	" "")
  (beginning-of-buffer)
  (replace-string "출력	" "")
  (beginning-of-buffer)
  (replace-string "예외 처리
" "")
  (beginning-of-buffer)
  (replace-string "처리
" "")
  (beginning-of-buffer)
  (replace-string "비고
" ""))

(defun insert-a ()
  (interactive)
  (save-excursion  (yank))
  (insert-register ?a))

;;맵핑하기좋는키입니다. (global-set-key [f2] '(aif (insert-register ?a) ))
;;맵핑하기좋는키입니다. 
;;맵핑하기좋는키입니다. (defun other-next ()
;;맵핑하기좋는키입니다.   (interactive)
;;맵핑하기좋는키입니다.   (switch-to-buffer "grepresult.txt")
;;맵핑하기좋는키입니다.   (other-window 1)
;;맵핑하기좋는키입니다.   (forward-line)
;;맵핑하기좋는키입니다.   (compile-goto-error)
;;맵핑하기좋는키입니다.   )
;;맵핑하기좋는키입니다. 
;;맵핑하기좋는키입니다. (global-set-key "\C-\\" 'other-next )
;;맵핑하기좋는키입니다. 
;;맵핑하기좋는키입니다. (global-set-key "\C-\M-\\" 'insert-a)

;; 날짜 삽입가능 
(defun insert-date ( )
  "편집 시점의 날짜를 삽입한다."
  (interactive)
  (insert (format-time-string  "%Y년 %m월 %d일 %V주 %a요일 %p %I시 %M분 %S초")))


;; 다음은 간단히 사용할 수 있는 함수이다. 

(defun cmt ()
	(interactive)
	(insert "////////////////////////////////////////////////////////////////////////\n")
	(insert "//\t\n")
	(insert "////////////////////////////////////////////////////////////////////////")
	(previous-line 1)
	(end-of-line) )


(defun kill-whole-line nil
  "kills the entire line on which the cursor is located, and places the 
cursor as close to its previous position as possible."
  (interactive)
  (progn
    (let ((y (current-column))
	  (a (progn (beginning-of-line) (point)))
	  (b (progn (forward-line 1) (point))))
      (kill-region a b)
      (move-to-column y))))

(defun strip-trailing-whitespace (b e )
  "strips whitespace from the end of all the lines in the buffer;
equivalent to (`replace-regexp' \" \\t+$\" \"\")"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region b e)
      (goto-char (point-min))
      (while (re-search-forward "[ \t]+$" nil t) (replace-match "" nil t)) 
      nil)))
          
(defun uniquify-region ()
  "remove duplicate adjacent lines in the given region"
  (interactive)
  (save-excursion
    (save-restriction
      (narrow-to-region (region-beginning) (region-end))
      (sort-lines nil (point-min) (point-max))
      (beginning-of-buffer)
      (while (re-search-forward "\\(.*\n\\)\\1+" nil t)
        (replace-match "\\1" nil nil))
      (widen) 
      nil)))

(defun find-duplicate-lines (&optional insertp interp)
  (interactive "i\np")
  (let ((max-pon (line-number-at-pos (point-max)))
        (gather-dups))
    (while (< (line-number-at-pos) max-pon) (= (forward-line) 0)
           (let ((this-line (buffer-substring-no-properties (line-beginning-position 1) (line-end-position 1)))
                 (next-line (buffer-substring-no-properties (line-beginning-position 2) (line-end-position 2))))
             (when  (equal this-line next-line)  (setq gather-dups (cons this-line gather-dups)))))
    (if (or insertp interp)
        (save-excursion  (princ gather-dups (current-buffer)))
      gather-dups)))

(defun occur-duplicate-lines ()
  (interactive)
  (occur "\\(.*\n\\)\\1+"))

;; 다음을 이용하여 한 단어를 capitalize 할 수 있다. 
(defun ucap ( )
  (interactive)
  (let ((start (point))
        (end (progn (forward-sexp) (point))))
    (replace-string "_" " " nil start end )
    (capitalize-region start end )
    (replace-string " " "" nil start end )))


;; eamcs lisp 는 ielm 을 사용하면 됩니다. 

(global-set-key [(kana)] 'toggle-input-method)
(global-set-key [(kanji)] 'hangul-to-hanja-conversion)


;; Type 3
(global-set-key [(shift kana)] 'toggle-input-method)
(global-set-key [(control kanji)] 'set-mark-command)


(defun w32-fontified-region-to-clipboard (START END)
  "Htmlizes region, saves it as a html file, scripts Microsoft Word to
open in the background and to copy all text to the clipboard, then
quits. Useful if you want to send fontified source code snippets to
your friends using RTF-formatted e-mails.

Version: 0.1

Author:

Mathias Dahl, <mathias@cucumber.dahl.net>. Remove the big, green
vegetable from my e-mail address...

Requirements:

* htmlize.el
* wscript.exe must be installed and enabled
* Microsoft Word must be installed

Usage:

Mark a region of fontified text, run this function and in a number of
seconds you have the whole colorful text on your clipboard, ready to
be pasted into a RTF-enabled application.

"
  (interactive "r")
  (let ((snippet (buffer-substring START END))
        (buf (get-buffer-create "*htmlized_to_clipboard*"))
        (script-file-name (expand-file-name "~/htmlized_to_clipboard.vbs"))
        (htmlized-file-name (expand-file-name "~/htmlized.html")))
    (set-buffer buf)
    (delete-region (point-min) (point-max))
    (insert snippet)
    (htmlize-buffer)
    (write-file htmlized-file-name)
    (delete-region (point-min) (point-max))
    (setq htmlized-file-name 
          (substitute ?\\ ?/ htmlized-file-name))
    (insert
     (concat
      "Set oWord = CreateObject(\"Word.Application\")\n"
      "oWord.Documents.Open(\"" htmlized-file-name "\")\n"
      "oWord.Selection.HomeKey 6\n"
      "oWord.Selection.EndKey 6,1\n"
      "oWord.Selection.Copy\n"
      "oWord.Quit\n"
      "Set oWord = Nothing\n"))
    (write-file script-file-name)
    (kill-buffer "htmlized_to_clipboard.vbs")
    (setq script-file-name
          (substitute ?\\ ?/ script-file-name))
    (w32-shell-execute nil "wscript.exe" 
                       script-file-name)))


(defun copy-line ()
  "Copy lines  in the kill ring"
  (interactive )
  (save-excursion
    (kill-ring-save (point-at-bol) (point-at-eol))))
                    

;; optional key binding
(global-set-key "\C-c\C-k" 'copy-line)

;; 오른쪽에 일괄적으로 주석달 때 사용한다. 
(require 'rect)
(defun string-right (beg end str)                                             
  (interactive
   (progn (barf-if-buffer-read-only)
	  (list
	   (region-beginning)
	   (region-end)
	   (read-string (format "String insert rectangle (default %s): "
				(or (car string-rectangle-history) ""))
			nil 'string-rectangle-history
			(car string-rectangle-history)))))
  (save-excursion
    (save-restriction
      (if (> end beg)
          (narrow-to-region 
           (progn (goto-char beg) (point-at-bol)) 
           (progn (goto-char end) (point-at-eol)))
          (narrow-to-region 
           (progn (goto-char end) (point-at-bol)) 
           (progn (goto-char beg) (point-at-eol))))
      (beginning-of-buffer)
      (end-of-line)
      (let ((col (current-column)))
        (while (not (eobp))
          (end-of-line 2)
          (if (> (current-column) col) (setf col (current-column))))
        (beginning-of-buffer)
        (while (not (eobp))
          (move-to-column col t)
          (insert str)
          (forward-line 1))))))

(define-key ctl-x-r-map "h" 'string-right)

;; 중복 라인을 제거한다. 
(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
          (progn
            (goto-char start)
            (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
        (replace-match "\\1\n\\2")))))

;; Useful function:
;; convert dos (^M) end of line to unix end of line
;; DOS CR-LF
;; UNIX LF


(defun dos2unix ()
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix)
  (goto-char (point-min))
  (while (search-forward-regexp "$" nil t) 
    (replace-match "")))


;versa vice
(defun unix2dos ()
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos)
  (goto-char (point-min))
  (while (search-forward-regexp "$" nil t)
    (replace-match "")))

(defun emacs-header ()
  (interactive)
  (narrow-to-region 1 1 )
  (insert "-*-mode: C; coding: utf-8; buffer-read-only: t;-*-")
  (comment-region (point-min) (point-max))
  (newline-and-indent)
  (widen)
  )

(defun swap-regions (beg1 end1 beg2 end2)
  "Swap region between BEG1 and END1 with region BEG2 and END2.

For the first region, mark the first region and set mark at
point.  The second region only needs to be marked normally.
Again, set the mark at the beginning and end of the first region,
then mark the second region with mark and point.

The order of the two regions in the buffer doesn't matter.
Either one can precede the other.  However, the regions can not
be swapped if they overlap.

All arguments can either be a number for a position in the buffer
or a marker."
  (interactive
   (if (< (length mark-ring) 2)
       (error "Not enough in mark-ring to swap a region")
     (let ((region (list (region-beginning) (region-end)))
           (marks (sort (list (marker-position (car mark-ring))
                              (marker-position (cadr mark-ring)))
                        '<)))
       (if (< (car region) (car marks))
           (append region marks)
         (append marks region)))))
  (if (or (and (< beg2 beg1) (< beg1 end2))
          (and (< beg1 beg2) (< beg2 end1)))
      (error "Unable to swap overlapping regions")
    (save-excursion
      (insert 
       (prog1 (delete-and-extract-region beg2 end2)
         (goto-char beg2)
         (insert 
          (delete-and-extract-region beg1 end1))
         (goto-char beg1))))))


;;; Take the line from the cursor and move it up a line.
(defun move-line-up ()
  (interactive)
  (let ((beg (point)))
    (previous-line)
    (delete-region beg (point))))

(defun pg-kill-this-line (n)
  "Kill the line point is on.
  With prefix arg, kill this many lines starting at the line point is on."
  (interactive "p")
  (kill-region (line-beginning-position)
               (progn (forward-line n) (point)))) 

(defun pg-duplicate-this-line (n)
  "Duplicates the line point is on.  
 With prefix arg, duplicate current line this many times."
  (interactive "p")
  (save-excursion 
    (copy-region-as-kill (line-beginning-position) 
                         (progn (forward-line 1) (point)))
    (while (< 0 n)
      (yank)
      (setq n (1- n)))))


(defun kill-line-retain-column ()
  (interactive)
  (let ((goal-column (truncate temporary-goal-column))
        (column (current-column)))
    ;; Are we on a blank line?
    (if (= (line-beginning-position) (line-end-position))
        (progn (if (= (point) (buffer-end 1))
                   ;; Just delete the newline character.
                   (backward-delete-char-untabify 1)
                 (kill-line))
               (move-to-column goal-column))
      (progn
        ;; Are we on the last line of the buffer?
        (if (= (line-number-at-pos)
               (line-number-at-pos (buffer-end 1)))
            ;; We are, so delete the line and move up.
            (kill-whole-line -1)
          (kill-whole-line))
        ;; Assign a new temporary goal column.
        (setq temporary-goal-column column)
        ;; Retain the column.
        (move-to-column column)))))

;;(global-set-key [delete] 'kill-line-retain-column)


(define-key global-map (kbd "s-i") 'move-line-up)      ;;; A line killing function vaguely similar to vim's dd.
(define-key global-map (kbd "s-k") 'pg-kill-this-line) 
(define-key global-map (kbd "s-o") 'pg-duplicate-this-line) 

(defun copy-rectangle-to-clipboard (p1 p2)
  "Copy region as column (rectangle) to operating system's clipboard.
This command will also put the text in register 0. (see: `copy-to-register')"
  (interactive "r")
  (let ((x-select-enable-clipboard t))
    (copy-rectangle-to-register ?0 p1 p2)
    (kill-new
     (with-temp-buffer
       (insert-register ?0)
       (buffer-string) ))))


;; REGISTER 관련 
(defun copy-to-register-1 ()
  "Copy current line or text selection to register 1.
See also: `paste-from-register-1', `copy-to-register'."
  (interactive)
  (let* (
         (bds (get-selection-or-unit 'line ))
         (inputStr (elt bds 0) )
         (p1 (elt bds 1) )
         (p2 (elt bds 2) )
         )
    (copy-to-register ?1 p1 p2)
    (message "copied to register 1: 「%s」." inputStr)
))

(defun paste-from-register-1 ()
  "Paste text from register 1.
See also: `copy-to-register-1', `insert-register'."
  (interactive)
  (insert-register ?1))



;;;
;;;
;;; ※ 유용한 함수 정의
;;;
;;;


(defun swap-text (str1 str2 beg end)
  "Changes all STR1 to STR2 and all STR2 to STR1 in beg/end region."
  (interactive "sString A: \nsString B: \nr")
  (if mark-active
      (setq deactivate-mark t)
    (setq beg (point-min) end (point-max))) 
  (goto-char beg)
  (while (re-search-forward
	  (concat "\\(?:\\b\\(" (regexp-quote str1) "\\)\\|\\("
		  (regexp-quote str2) "\\)\\b\\)") end t)
    (if (match-string 1)
	(replace-match str2 t t)
      (replace-match str1 t t))))

(defun forward-delete ( &optional x)
  (interactive "p")
  (or x (setf x 1 ))
  (forward-sexp x )
  (kill-line)
  (next-line)
  (move-beginning-of-line nil))


(defun switch-equal (begin end )
  (interactive "r" )
  (replace-regexp " *\\(.*\\) *= *\\(.*\\) *;" "\\2 = \\1 ;" nil begin end ))

(defun make-buffer-readonly () (read-only-mode 1 ))

(defun global-read-only ( &optional v)
  (interactive
   (list (prefix-numeric-value current-prefix-arg) ))
  (if (= 1 v)
      (progn 
        (remove-hook 'find-file-hook #'make-buffer-readonly)
        (add-hook 'find-file-hook #'make-buffer-readonly))
    (remove-hook 'find-file-hook #'make-buffer-readonly)))

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (message "Current line is copied.")
       (list (line-beginning-position) (line-beginning-position 2)) ) ) ))

;;deprecated;;(defadvice kill-region (before slick-copy activate compile)
;;deprecated;;  "When called interactively with no active region, cut the current line."
;;deprecated;;  (interactive
;;deprecated;;   (if mark-active
;;deprecated;;       (list (region-beginning) (region-end))
;;deprecated;;     (list (line-beginning-position) (line-beginning-position 2)) ) ) )

;;; 영역이 있으면 KILL, 아니면 라인카피 
(defun kill-region-dwim (beg end )
  (interactive (list (point) (mark)))
  (if mark-active (kill-region beg end) (copy-line)))

(defun copy-region-dwim (beg end )
  (interactive (list (point) (mark)))
  (if mark-active (kill-ring-region beg end) (copy-line)))

(global-set-key [remap kill-region] 'kill-region-dwim)



(defun backward-symbol (arg)
  (interactive "p")
  (forward-symbol (* -1 arg )))

;;;
;;;
;;; ※ 변수 설정
;;;
;;;
(setq tab-stop-list 
      '(2 4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 ))
;; 탭을 공백으로 만들 수 있다. 
(setq-default indent-tabs-mode nil )
(setq-default tab-width 2 )

(require 'delsel)
(delete-selection-mode 1)

(defun dongif (beg end)
  "Changes all STR1 to STR2 and all STR2 to STR1 in beg/end region."
  (interactive "r")
  (if mark-active
      (setq deactivate-mark t)
    (setq beg (point-min) end (point-max))) 
  (replace-regexp " *\\([0-9a-zA-Z_]+\\) * \\([=!]\\)= *\\([0-9a-zA-Z_]+\\) *" "\\3 \\2=\\1" nil beg end ))


(defun byte-compile-current-buffer ()
  "`byte-compile' current buffer if it's emacs-lisp-mode and compiled file exists."
  (interactive)
  (when (and (eq major-mode 'emacs-lisp-mode)
             (file-exists-p (byte-compile-dest-file buffer-file-name)))
    (byte-compile-file buffer-file-name)))

;;moveto customize value ;; (add-hook 'after-save-hook 'byte-compile-current-buffer)




;;(require 'inline-string-rectangle)
;;(global-set-key (kbd "C-x r t") 'inline-string-rectangle)


;;(require 'mark-more-like-this)
;;(global-set-key (kbd "C-<") 'mark-previous-like-this)
;;(global-set-key (kbd "C->") 'mark-next-like-this)
;;(global-set-key (kbd "C-M-m") 'mark-more-like-this) ; like the other two, but takes an argument (negative is previous)
;;(global-set-key (kbd "C-*") 'mark-all-like-this)



;;(add-hook 
;; 'sgml-mode-hook
;; (lambda ()
;;   (require 'rename-sgml-tag)
;;   (define-key sgml-mode-map (kbd "C-c C-r") 'rename-sgml-tag)))

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'misc-cmds)
(global-set-key (kbd "<home>") 'beginning-or-indentation) 

;;deprecated;;(substitute-key-definition       'kill-buffer 'kill-buffer-and-its-windows global-map)
;;deprecated;;(substitute-key-definition       'recenter 'recenter-top-bottom global-map)
;;deprecated;;(substitute-key-definition       'beginning-of-line 'beginning-of-line+ global-map)
;;deprecated;;(substitute-key-definition       'end-of-line 'end-of-line+ global-map)
;;deprecated;;
;;deprecated;;;;   The first two of these are needed to remove the default remappings.
;;deprecated;;(define-key visual-line-mode-map [remap move-beginning-of-line] nil)
;;deprecated;;(define-key visual-line-mode-map [remap move-end-of-line] nil)
;;deprecated;;(define-key visual-line-mode-map [home] 'beginning-of-line+)
;;deprecated;;(define-key visual-line-mode-map [end]  'end-of-line+)
;;deprecated;;(define-key visual-line-mode-map "\C-a" 'beginning-of-visual-line+)
;;deprecated;;(define-key visual-line-mode-map "\C-e" 'end-of-visual-line+)


(require 'hide-region)

(if (not (version<= "24.3" emacs-version ));;deprecatedat 24.3
    (progn                                 ;;deprecatedat 24.3
      (require 'tabkey2)                   ;;deprecatedat 24.3
      (tabkey2-mode t)))                   ;;deprecatedat 24.3


(defun toggle-line-move-visual ()
  "Toggle behavior of up/down arrow key, by visual line vs logical line."
  (interactive)
  (if line-move-visual
      (setq line-move-visual nil)
    (setq line-move-visual t))
  )

;;;_ REVERT BUFFER http://www.emacswiki.org/emacs/RevertBuffer
(global-auto-revert-mode 1)

;;; _ AUTO COMPLETE 
(require 'auto-complete)
(define-key ac-completing-map (kbd "C-j") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)
(define-key ac-completing-map (kbd "C-o") 'ac-expand)



;;; javascript indent 
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status))
           node)

      (save-excursion

        (back-to-indentation)
        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation ( 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (overlay-put ovl 'face 'highlight)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        (run-with-timer 0.5 nil '(lambda(ovl)
                                   (delete-overlay ovl)) ovl)))))

(defun my-js2-mode-hook ()
  (require 'js)
  (setq js-indent-level 2
        indent-tabs-mode nil
        c-basic-offset 2)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)] 
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)



;; https://gist.github.com/Wilfred/4715345

(defun dwim-at-point ()
  "If there's an active selection, return that. Otherwise, get
the symbol at point."
  (if (use-region-p)
      (buffer-substring-no-properties (region-beginning) (region-end))
    (if (symbol-at-point)
        (symbol-name (symbol-at-point)))))

;; todo: investigate whether we're reinventing the wheel, since query-replace-history already exists

(defvar replace-at-point/history nil)

(defun replace-at-point (from-string to-string)
  "Replace occurrences of FROM-STRING with TO-STRING, defaulting
to the symbol at point."
  (interactive (list
                (read-from-minibuffer "Replace what? " (dwim-at-point))
                (read-from-minibuffer "With what? " (if (equal kill-ring nil) (dwim-at-point) (car kill-ring)))))
  
  
  (forward-symbol -1)
              
  (add-to-list 'replace-at-point/history
               (list (format "%s -> %s" from-string to-string)
                     from-string to-string))
  (perform-replace from-string to-string nil nil nil))

(eval-when-compile (require 'cl)) ; first, second

(defun replace-repeat ()
  (interactive)
  (unless replace-at-point/history
    (error "You need to have done query-replace-at-point first"))
  (let* ((choices (mapcar 'first query-replace/history))
         (choice (ido-completing-read "Previous replaces: " choices))
         (from-with-to (cdr (assoc choice replace-at-point/history)))
         (from-string (first from-with-to))
         (to-string (second from-with-to)))
    (perform-replace from-string to-string nil nil nil)))
