;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t; lexical-binding : t -*-

;;(require 'edom)

(defun find-prototype-region ()
  (interactive)
  (re-search-forward "#include")
  (while (not (equal nil (re-search-forward "^[a-zA-Z]" (point-max) t) ))
    (goto-char (point-at-bol))
    (cmt-fun)))


(defun current-time-stamp ()
  (concat  (format-time-string  "%Y년 %m월 %d일 %V주 %H시 %M분 %S초 ")
           (cadr (assoc  (nth 6  (decode-time (current-time)))
                         '(
                           (0 "일요일")
                           (1 "월요일")
                           (2 "화요일")
                           (3 "수요일")
                           (4 "목요일")
                           (5 "금요일")
                           (6 "토요일"))))))

(defun cmt-fun ()
  (interactive)
  (let* ((min (point-at-bol))
         (max (- (re-search-forward ")") 1 ))
         (str (buffer-substring min max))
         (name (car (s-split "(" str )))
         (args (cadr (s-split "(" str )))
         (rtn "")
         (fname "")
         (keywords '("struct" "enum" "class" "File" "Author:" "E-mail:" "$Rev:" "Limitation" "마지막" "Description:" "Limitation:" "Caution:" "Usage:" "Copyright" "All"))
         (tstamp (format-time-string  "%Y년 %m월 %d일 %V주 %a 요일 %p %I시 %M분 %S초"))
         ;;(tstamp (current-time-stamp))
         )
    (goto-char min)

    (setf name (s-replace "\n+" " " name ))
    (setf name (s-split " " name))
    (setf args (s-split "," args))

    (case (length name )
      ((1) (setf fname (s-trim (car name ))) (setf rtn "void"))
      ((2 3) (setf fname (s-trim (cadr name ))) (setf rtn (s-trim (car name )))))
    
    (if (and
         (> 3 (length name))
         (equal nil (member fname keywords))
         (equal nil (member rtn keywords)))
        
        (progn
          
          (insert "//|||***************************************************************************") (newline)
          (insert (format "//||| 파일명        : %s" (buffer-name))) (newline)
          (insert (format "//||| 최초 작성일   : %s" tstamp)) (newline)
          (insert (format "//||| 마지막 수정일 : %s" tstamp)) (newline)
          (insert "//||| 최초 작성자   : SW22 김동일") (newline)
          (insert "//||| 마지막 수정자 : SW22 김동일") (newline)
          (insert (format "//||| 함수명        : %s" fname)) (newline)
          (insert "//||| 설명          : ") (newline)

          (if (equal 0 (length args)) 
              (insert "//||| 입력값        : [IN] 없음\n")
            (insert (format "//||| 입력값        : [IN] %s\n"  (s-trim (car args) ))))

          (mapcar 
           (lambda (arg)
             (insert (format "//|||        [IN] %s\n" (s-trim arg))))
           (cdr args))

          (insert "//||| 리턴값        : " (s-trim rtn))(newline)
          (insert "//||| 비고          : ")(newline)
          (insert "//|||***************************************************************************")(newline)))
    (re-search-forward ")")))





(defun cmt-class ()
  (interactive)
  (end-of-buffer)
  (if (not (equal nil (re-search-backward "^class" (point-min) t)))
      
      (let* ((min (point-at-bol))
             (max (- (re-search-forward "{") 1 ))
             (str (buffer-substring min max))
             (name (car (s-split ":" str )))
             (tstamp (format-time-string  "%Y년 %m월 %d일 %V주 %a요일 %p %I시 %M분 %S초"))
             ;;(tstamp (current-time-stamp))
             (cname (cadr (s-split " " name))))

        (goto-char min)

        (insert "//***************************************************************************") (newline)
        (insert (format "// 파일명        : %s" (buffer-name))) (newline)
        (insert "// 프로젝트명    : FFX LINK11 DLP") (newline)
        (insert (format "// 최초 작성일     : %s" tstamp )) (newline)
        (insert (format "// 마지막 수정일   : %s" tstamp )) (newline)
        (insert "// 최초 작성자   : SW22 김동일") (newline)
        (insert "// 마지막 수정자 : SW22 김동일 ") (newline)
        (insert (format "// 클래스명      : %s" cname)) (newline)
        (insert "// 클래스 설명   :  ") (newline)
        (insert "// 비고          : ") (newline)
        (insert "//***************************************************************************") (newline)
        )))



;;deprecated;;(defun ffx-header ( funname )
;;deprecated;;  (interactive)
;;deprecated;;  (message funname)
;;deprecated;;  (if (symbolp funname) (setf funname (symbol-name funname)))
;;deprecated;;  (macrolet (( with-writable-file 
;;deprecated;;               (name &rest body)
;;deprecated;;               `(let ((omodes (file-modes ,name)))
;;deprecated;;                  (set-file-modes ,name (logior omodes 128 ))
;;deprecated;;                  (with-current-buffer (find-file ,name)
;;deprecated;;                    (read-only-mode  -2 )
;;deprecated;;                    ,@body)
;;deprecated;;                  (set-file-modes ,name omodes))))
;;deprecated;;    (with-writable-file funname
;;deprecated;;     (beginning-of-buffer)
;;deprecated;;     
;;deprecated;;     (insert (format 
;;deprecated;;              "/*****************************************************************************
;;deprecated;;    File name:    %s
;;deprecated;;    Author:       김동일
;;deprecated;;    E-mail:       di7979.kim@samsung.com
;;deprecated;;
;;deprecated;;    마지막 변경 시각: <>
;;deprecated;;
;;deprecated;;------------------------------------------------------------------------------
;;deprecated;;    Description:
;;deprecated;;        -
;;deprecated;;
;;deprecated;;Limitation:
;;deprecated;;- None
;;deprecated;;
;;deprecated;;Caution:
;;deprecated;;- None
;;deprecated;;
;;deprecated;;------------------------------------------------------------------------------
;;deprecated;;Usage:
;;deprecated;;
;;deprecated;;------------------------------------------------------------------------------
;;deprecated;;Update History:
;;deprecated;;- 2009년 07월 10일 28주 금요일 오전 10시 24분 56초 헤더생성
;;deprecated;;
;;deprecated;;------------------------------------------------------------------------------
;;deprecated;;Copyright (c) 2006 Samsung Thales Co.,Inc.
;;deprecated;;All Rights Reserved
;;deprecated;;*****************************************************************************/
;;deprecated;;" funname))
;;deprecated;;     (basic-save-buffer)
;;deprecated;;     (kill-this-buffer))))


;;deprecated;;(defun ffx-prototype ( fname )
;;deprecated;;  (interactive)
;;deprecated;;  (if (symbolp fname) (setf fname (symbol-name fname)))
;;deprecated;;  (macrolet (( with-writable-file 
;;deprecated;;               (&rest body)
;;deprecated;;               `(let ((omodes (file-modes ,fname)))
;;deprecated;;                  (set-file-modes ,fname (logior omodes 128 ))
;;deprecated;;                  (with-current-buffer (find-file ,fname)
;;deprecated;;                    (read-only-mode  -2 )
;;deprecated;;                    ,@body)
;;deprecated;;                  (set-file-modes ,fname omodes))))
;;deprecated;;    (with-writable-file 
;;deprecated;;     (find-prototype-region)
;;deprecated;;     (basic-save-buffer)
;;deprecated;;     (kill-this-buffer))))





(defun count-fun ()
  (interactive)
  (count-matches "^[a-zA-Z]" (re-search-forward "^#") (point-max)))


(defun cmt-py ()
  (interactive)
  (evil-beginning-of-line)
  (evil-forward-word-begin 2)

  (let* ((str (buffer-substring (point) (- (re-search-forward ")") 1 )))
         (name (s-trim  (car (s-split "(" str ))))
         (args (mapcar (lambda (x) (s-trim x)) (s-split "," (cadr (s-split "(" str ))))))
    (save-excursion
      (save-restriction
        (narrow-to-region (point-at-bol ) (point-at-eol))
        (evil-open-below 0) (insert "\"\"\"" ) (evil-open-below 0) (insert "\"\"\"" ) (evil-open-above 0 )
        (insert "기능 : ") (evil-open-below 0)
        (insert (format  "함수명 : %s" name) ) (evil-open-below 0)
        (insert "입력 : ") (evil-open-below 0)
        
        (string= "abcd" "abcd")
        (mapcar (lambda (arg) 
                  (if (string= "self" arg)
                      (insert (format "    %s - 클래스 인스턴스" arg))
                    (insert (format "    %s - " arg)))
                   (evil-open-below 0)) args)
        (insert "출력 : ")    (evil-open-below 0)
        (insert "처리 : ")    (evil-open-below 0)
        (insert "예외처리 : ")(evil-open-below 0)
        (insert "비고 : ")    (evil-open-below 0)

     ))
    (evil-normal-state))) 


(defun cmt-xml (b e)

  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region b e)
      (replace-string "기능 : "      ""             nil (point-min) (point-max))
      (replace-string "함수명 : "    "|"            nil (point-min) (point-max))
      (replace-string "입력 : "      "|MISCDialog.py"    nil (point-min) (point-max))
      (replace-string "출력 : "      "|"            nil (point-min) (point-max))
      (replace-string "예외처리 : "  "|"            nil (point-min) (point-max))
      (replace-string "비고 : "      "|"            nil (point-min) (point-max))
      
      (goto-char (point-min))
      (re-search-forward "처리 : ")
      (end-of-line)
      (replace-string " " "^" nil (point) (point-max))
      (replace-string "처리 : "      "|"            nil (point-min) (point-max))

(goto-char (point-min))
(insert "
      <함수테이블>
        <클래스>MISDialog</클래스>
        <내용><![CDATA[
")

      (goto-char (point-max))

(insert "
        ]]></내용>
      </함수테이블>
")


))
)


;; (global-set-key [f9] #'cmt-py)
