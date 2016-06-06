;; -*-mode: emacs-lisp; coding: utf-8 ; buffer-read-only: t;-*-


(defun tjcode (code1 code2 securitycard )
  (let ((table (eval (read (epg-decrypt-file (epg-make-context) securitycard nil)))))
    (message "코드: %d %d"  (car (cadr (assoc code1 table))) (cadr (cadr (assoc code2 table))))
    (kill-buffer "*Messages*")))

(defun tjcodeall (code1 code2 securitycard )
  (let ((table (eval (read (epg-decrypt-file (epg-make-context) securitycard nil)))))
    (message "코드: %s %s"  (cadr (assoc code1 table)) (cadr (assoc code2 table)))
    (kill-buffer "*Messages*")))

(defun dgbcode( code1 code2 ) 
  (interactive "n대구은행 첫번째 코드: \nn대구은행 두번째 코드 : ")
  (tjcode code1 code2 "q:/cypher/각종번호/대구은행.gpg" ))

(defun mtjcode( code1 code2 ) 
  (interactive "n새마을 첫번째 코드: \nn새마을 두번째 코드 : ")
  (tjcode code1 code2 "q:/cypher/각종번호/새마을.gpg" ))

(defun dtjcode (code1 code2 )
  (interactive "n동양증권 첫번째 코드: \nn동양증권 두번째 코드 : ")
  (tjcode code1 code2 "q:/cypher/각종번호/동양종금보안카드.gpg" ))

(defun stjcode (code1 code2 )
  (interactive "n삼성증권 첫번째 코드: \nn삼성증권 두번째 코드 : ")
  (tjcode code1 code2 "q:/cypher/각종번호/삼성증권대구은행보안카드.gpg" ))

(defun  htjcode(code1 code2 )
  (interactive "n하나은행 첫번째 코드: \nn하나은행 두번째 코드 : ")
  (tjcodeall code1 code2 "q:/cypher/각종번호/하나은행.gpg" ))



(defun hpnum (names)
  (interactive "s성명을 입력하세요: \n")
  (let* ((hpassoc (eval (read (with-temp-buffer (insert-file-contents "f:/svndir/스크랩/mobile.el" ) (buffer-string)))))
         (result  (mapcar
                   (lambda (x)
                     (assoc (intern x ) hpassoc ))
                   (split-string names ))))
    (print result)
    (kill-new "")
    (mapcar 
     (lambda (x)
       (kill-append (replace-regexp-in-string "\+82\-" "0" (symbol-name (cadr x)) ) nil )
       (kill-append "\n" nil ))
       result)))



(defun single-name ()
  (apply 
   #'append 
   (mapcar 
    (lambda (b)
      (mapcar 
       (lambda (v) 
         (cdr  (assoc 'cn v ))) 
       (cdr 
        (assoc 'empvo 
               (json-read-file (car  b))))))
    (directory-files-and-attributes "t:/MISC/single-mail/jsonaddressbook" t ".json$")))) 

(defun single-content (name )
  (let ((result nil))
    (dolist (json (directory-files-and-attributes "t:/MISC/single-mail/jsonaddressbook" t ".json$") result)
      (mapcar 
       (lambda (v)
         (if (string-equal name (cdr (assoc 'cn v )))  (setf result  (cons v result))))
       (cdr (assoc 'empvo (json-read-file (car  json))))))))


;;; content example 
;; (((epTitleCode . R4) (iTotalPageCount . 0) (serverLocation . KR) (description . S/W) (epValidLoginPeriod . 2003022720030430) (epSubOrgCode . ) (epSendRegionCode . ) (cn . 김동일) (sn . 김) (iTotalCount . 0) (epId . S021211222312C100638) (epSendBusiCode . ) (preferredLanguage . ko) (epRegionCode . MA) (epSendSubOrgCode . ) (mailHost . ms17.samsung.com) (o . 삼성탈레스) (epEnSendCompanyName . ) (epDefaultCompCode . O) (epmiddlename . ) (epUserStatus . B) (otherFacsimileTelephoneNumber . ) (epenmiddlename . ) (epEnSendSubOrgName . ) (epSubOrgName . ) (epSendSecurityLevel . 5) (facsimileTelephoneNumber . 054-460-8709) (epAttachSize . 10) (epUserLevel . U) (department . SW그룹) (givenname . 동일) (epSmsotp . ) (epSendCompanyName . ) (epSendGradeOrTitle . ) (epServiceCode . U) (title . 선임연구원) (mobile . +82-10-3826-0719) (epOrganizationCode . PC7) (epEnDepartment . SW Group) (telephoneNumber . +82-054-460-8717) (epSendGradeName . ) (epEnTitle . Engineer) (epEnOrganizationName . Samsung Thales) (postalAddress .  경북 구미시 공단동 259 사서함 50) (iCurrentPage . 0) (epHomePostalCode . 706-050) (epSendTitleName . ) (iPageCount . 0) (epSendDeptCode . ) (epPreferredLanguage . ko) (mail . di7979.kim@samsung.com) (epEnCn . dong il Kim) (homePhone . 053-762-1146) (employeeNumber . 02902774) (uid . di7979.kim) (epSendCompanyCode . ) (epensn . Kim) (epEnDescription . S/W) (epEnPostalAddress . Gongdan-Dong Gumi-City Gyoungsangbok-Do) (epSendDeptName . ) (employeeType . N) (epAlternativeMail . dikim97@samsung.co.kr) (homePostalAddress .     대구시 수성구 중동 521-5번지) (departmentNumber . T10D5302) (epUserLocation . AK) (dn . uid=di7979.kim,ou=regular,ou=people,o=samsung) (epEnGradeName . Engineer) (epBusiCode . MA) (postalCode . 730-030) (epengivenname . dong il) (bEpIsBlue . :json-false) (nickName . ) (epEnSendGradeName . ) (epEnSendTitleName . ) (epSecurityLevel . 5) (epSendTitleNumber . ) (epGradeName . 선임연구원) (epNative . N) (epEnHomePostalAddress . Jung-dong Susung-gu Daegu-city) (epGradeOrTitle . T) (epvoipnumber . ) (bEpAutofoward . :json-false) (epTitleSortOrder . 52) (epEnSendDeptName . ))
;; ....
;;  )


(defun singleid()
  (interactive)
  (let ((ntag (helm-comp-read "성명을 입력하세요 : " (single-name))))
    
    ;; (insert (format "%s" (single-content ntag )))
    (mapcar 
     (lambda (x)
       (let ((mail   (cdr (assoc 'mail x))))
         (message mail)
         (kill-new  mail)))  
     (single-content ntag ))
    ))    


(defun hanwhaid()
  (interactive)
  (let ((ntag (helm-comp-read "성명을 입력하세요 : " (single-name))))
    
    ;; (insert (format "%s" (single-content ntag )))
    (mapcar 
     (lambda (x)
       (let ((mail   (cdr (assoc 'mail x))))
         (message mail)
         (insert  (format "%s,"  mail))))  
     (single-content ntag ))
    ))    




