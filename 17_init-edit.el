(defun uniq-region ()
   "remove duplicate adjacent lines in the given region"
   (interactive)
   (save-excursion
     (save-restriction
       (narrow-to-region (region-beginning) (region-end))
       (strip-trailing-whitespace (point-min) (point-max))
       (let (( contents (s-split "\n" (buffer-substring-no-properties (point-min) (point-max))))
             ( unified nil)
             )
         (dolist (it contents (setf unified  (reverse  unified)))
           (if (not  (member it unified))
               (setf unified (cons it unified) )))
         (delete-region (point-min) (point-max))
         (insert (s-join "\n" unified))))))


          
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

(defun insert-a ()
  (interactive)
  (save-excursion  (yank))
  (insert-register ?a))

;;deprecated;; ;;; javascript indent 
;;deprecated;; (defun my-js2-indent-function ()
;;deprecated;;   (interactive)
;;deprecated;;   (save-restriction
;;deprecated;;     (widen)
;;deprecated;;     (let* ((inhibit-point-motion-hooks t)
;;deprecated;;            (parse-status (save-excursion (syntax-ppss (point-at-bol))))
;;deprecated;;            (offset (- (current-column) (current-indentation)))
;;deprecated;;            (indentation (js--proper-indentation parse-status))
;;deprecated;;            node)
;;deprecated;; 
;;deprecated;;       (save-excursion
;;deprecated;; 
;;deprecated;;         (back-to-indentation)
;;deprecated;;         ;; consecutive declarations in a var statement are nice if
;;deprecated;;         ;; properly aligned, i.e:
;;deprecated;;         ;;
;;deprecated;;         ;; var foo = "bar",
;;deprecated;;         ;;     bar = "foo";
;;deprecated;;         (setq node (js2-node-at-point))
;;deprecated;;         (when (and node
;;deprecated;;                    (= js2-NAME (js2-node-type node))
;;deprecated;;                    (= js2-VAR (js2-node-type (js2-node-parent node))))
;;deprecated;;           (setq indentation ( 4 indentation))))
;;deprecated;; 
;;deprecated;;       (indent-line-to indentation)
;;deprecated;;       (when (> offset 0) (forward-char offset)))))
;;deprecated;; 
;;deprecated;; (defun my-indent-sexp ()
;;deprecated;;   (interactive)
;;deprecated;;   (save-restriction
;;deprecated;;     (save-excursion
;;deprecated;;       (widen)
;;deprecated;;       (let* ((inhibit-point-motion-hooks t)
;;deprecated;;              (parse-status (syntax-ppss (point)))
;;deprecated;;              (beg (nth 1 parse-status))
;;deprecated;;              (end-marker (make-marker))
;;deprecated;;              (end (progn (goto-char beg) (forward-list) (point)))
;;deprecated;;              (ovl (make-overlay beg end)))
;;deprecated;;         (set-marker end-marker end)
;;deprecated;;         (overlay-put ovl 'face 'highlight)
;;deprecated;;         (goto-char beg)
;;deprecated;;         (while (< (point) (marker-position end-marker))
;;deprecated;;           ;; don't reindent blank lines so we don't set the "buffer
;;deprecated;;           ;; modified" property for nothing
;;deprecated;;           (beginning-of-line)
;;deprecated;;           (unless (looking-at "\\s-*$")
;;deprecated;;             (indent-according-to-mode))
;;deprecated;;           (forward-line))
;;deprecated;;         (run-with-timer 0.5 nil '(lambda(ovl)
;;deprecated;;                                    (delete-overlay ovl)) ovl)))))
;;deprecated;; 
;;deprecated;; (defun my-js2-mode-hook ()
;;deprecated;;   (require 'js)
;;deprecated;;   (setq js-indent-level 2
;;deprecated;;         indent-tabs-mode nil
;;deprecated;;         c-basic-offset 2)
;;deprecated;;   (c-toggle-auto-state 0)
;;deprecated;;   (c-toggle-hungry-state 1)
;;deprecated;;   (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
;;deprecated;;   (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
;;deprecated;;   (define-key js2-mode-map [(meta control \;)] 
;;deprecated;;     '(lambda()
;;deprecated;;        (interactive)
;;deprecated;;        (insert "/* -----[ ")
;;deprecated;;        (save-excursion
;;deprecated;;          (insert " ]----- */"))
;;deprecated;;        ))
;;deprecated;;   (define-key js2-mode-map [(return)] 'newline-and-indent)
;;deprecated;;   (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
;;deprecated;;   (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
;;deprecated;;   (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
;;deprecated;;   (if (featurep 'js2-highlight-vars)
;;deprecated;;     (js2-highlight-vars-mode))
;;deprecated;;   (message "My JS2 hook"))
;;deprecated;; 
;;deprecated;; (add-hook 'js2-mode-hook 'my-js2-mode-hook)

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

(global-set-key (kbd "C-=") 'set-middle)

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


(defun insert-string() 
  (interactive)
  (insert " : \"\"" ) (backward-char 1 ))

(defun emacs-header ()
  (interactive)
  (narrow-to-region 1 1 )
  (insert "-*-mode: C; coding: utf-8; buffer-read-only: t;-*-")
  (comment-region (point-min) (point-max))
  (newline-and-indent)
  (widen)
  )

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

(defun upcase-symbol (syms)
  (interactive)
  (mapcar 
   (lambda (x)
     (replace-string 
      (symbol-name x )
      (upcase (symbol-name x )) t (point-min) (point-max )))
   syms ))



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

;; 다음을 이용하여 한 단어를 capitalize 할 수 있다. 
(defun ucap ( )
  (interactive)
  (let ((start (point))
        (end (progn (forward-sexp) (point))))
    (replace-string "_" " " nil start end )
    (capitalize-region start end )
    (replace-string " " "" nil start end )))

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

(defun dongif (beg end)
  "Changes all STR1 to STR2 and all STR2 to STR1 in beg/end region."
  (interactive "r")
  (if mark-active
      (setq deactivate-mark t)
    (setq beg (point-min) end (point-max))) 
  (replace-regexp " *\\([0-9a-zA-Z_]+\\) * \\([=!]\\)= *\\([0-9a-zA-Z_]+\\) *" "\\3 \\2=\\1" nil beg end ))

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

(defun make-buffer-readonly () (read-only-mode 1 ))

(defun global-read-only ( &optional v)
  (interactive
   (list (prefix-numeric-value current-prefix-arg) ))
  (if (= 1 v)
      (progn 
        (remove-hook 'find-file-hook #'make-buffer-readonly)
        (add-hook 'find-file-hook #'make-buffer-readonly))
    (remove-hook 'find-file-hook #'make-buffer-readonly)))

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


(defun xmltable ()
  (interactive)
  (replace-string "기능 " "")
  (beginning-of-buffer)
  (replace-string "함수명 " "")
  (beginning-of-buffer)
  (replace-string "입력 " "")
  (beginning-of-buffer)
  (replace-string "출력 " "")
  (beginning-of-buffer)
  (replace-string "예외 처리
" "")
  (beginning-of-buffer)
  (replace-string "처리
" "")
  (beginning-of-buffer)
  (replace-string "비고
" ""))

(defun backward-symbol (arg)
  (interactive "p")
  (forward-symbol (* -1 arg )))

(defun toggle-line-move-visual ()
  "Toggle behavior of up/down arrow key, by visual line vs logical line."
  (interactive)
  (if line-move-visual
      (setq line-move-visual nil)
    (setq line-move-visual t))
  )

(use-package expand-region)

(require 'misc-cmds)
(global-set-key (kbd "<home>") 'beginning-or-indentation)

(use-package delsel
  :config
  (delete-selection-mode 1))

(use-package hide-region+
  :commands hide-region-hide hide-region-unhide)

(defun byte-compile-current-buffer ()
  "`byte-compile' current buffer if it's emacs-lisp-mode and compiled file exists."
  (interactive)
  (when (and (eq major-mode 'emacs-lisp-mode)
             (file-exists-p (byte-compile-dest-file buffer-file-name)))
    (byte-compile-file buffer-file-name)))

;;;_ REVERT BUFFER http://www.emacswiki.org/emacs/RevertBuffer
(global-auto-revert-mode 1)
