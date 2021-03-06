(w32-unix-eval
 (;;(message "win32")
  (prefer-coding-system 'cp949)
  ;; 한글 인코딩을 설정한다. 
  ;;(setq-default default-buffer-file-coding-system 'utf-8 )
  ;;(prefer-coding-system 'cp949)
  ;;(set-default-coding-systems 'cp949)
  (setq-default file-name-coding-system 'cp949)
  (setq-default default-buffer-file-coding-system 'cp949 ))
 ((prefer-coding-system 'utf-8)
  ;; 한글 인코딩을 설정한다. 
  ;;(setq-default default-buffer-file-coding-system 'utf-8 )
  ;;(prefer-coding-system 'cp949)
  (set-default-coding-systems 'utf-8)
  (setq-default file-name-coding-system 'utf-8)
  (setq-default default-buffer-file-coding-system 'utf-8 )))




;;; utf-8 설정 
;; ;; http://stackoverflow.com/questions/2901541/which-coding-system-should-i-use-in-emacs
;; (setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
;;   (set-language-environment 'utf-8)
;;   (setq locale-coding-system 'utf-8)
;;   (set-default-coding-systems 'utf-8)
;;   (set-terminal-coding-system 'utf-8)
;;   (unless (eq system-type 'windows-nt)
;;    (set-selection-coding-system 'utf-8))
;;   (prefer-coding-system 'utf-8)

;; 외부프로그램 호출할 때 사용하는 encoding 을 결정합니다. 
;; 테스트 하는 경우 universal-coding-system-argument 함수를 참고 
;; ENCODING 설정방법 
;; (modify-coding-system-alist 'process ".*" 'cp949)
;; (modify-coding-system-alist 'process "git\.exe" '(utf-8 . cp949))
;; (modify-coding-system-alist 'process "ls\.exe" 'utf-8 )
;;(require 'unicad ) ;;CP949 를 우선 하는 방법을 찾을 것 


;;http://superuser.com/questions/325182/how-do-i-set-emacs-character-coding-for-files-in-a-directory
;;I'm using Aquamacs, a distro of GNU Emacs 23.3.50.1.
;;
;;I'm looking at some source files written with some comments in Greek, and they are encoded in CP1253.
;;
;;And, I can either revert with the proper encoding or I can add a file local variable:
;;
;;/* -*- mode: c-mode; tab-width: 4; coding: cp1253-unix; -*- */
;;
;;So I can get them to open properly, and I could certainly tack on file variables to each file.
;;
;;But I'd like to set the coding for the whole directory. Rather than editing .dir-locals.el by hand, I thought I'd simply:
;;
;;M-x copy-file-locals-to-dir-locals
;;
;;From the file that opened correctly. And that generates:
;;
;;;;; Directory Local Variables
;;;;; See Info node `(emacs) Directory Variables' for more information.
;;
;;((c-mode
;;  (tab-width . 4)
;;  (coding . cp1253-unix)))
;;
;;No dice. Yet it clearly recognizes the new tab-width, so it's reading the file.
;;
;;Any ideas why? And is there any log as emacs is processing the a-list?
;;emacs
;;share|improve this question
;;	
;;asked Aug 19 '11 at 9:36
;;Ben
;;	
;;feedback
;;migrated from serverfault.com Aug 19 '11 at 11:25
;;
;;1 Answer
;;active oldest votes
;;up vote 0 down vote
;;	
;;
;;Unfortunately, it appears that the coding header, by design, does not propagate from Emacs dir-locals; I struggled with your setup, and replicated the issue as well.
;;
;;Later I came across this source that seems to verify what you found: http://www.emacsmirror.org/package/dir-locals.html
;;
;;I'm not sure if there is a log for processing the a-list, but in case you aren't familiar with this variable, you can verify your encoding after visiting a file with:
;;
;;C-h v buffer-file-coding-system RET
;;
;;or
;;
;;M-x describe-variable RET buffer-file-coding-system RET
;;
;;Personally, I think your best bet would be what you already have working - file local variables.
;;
;;Alternatives I can think of (first is untested) would be to take a look at some of the elisp functions:
;;
;;(coding-system-priority-list)
;;(set-coding-system-priority &rest coding-systems)
;;
;;OR second: (assuming your directory structure is /something/blah/greekcode/file.c)
;;
;;(add-to-list 'auto-coding-alist 
;;     '("/greekcode/[^/]+.c\\'" . cp1253-unix))
;;
;;This takes precedence even over file local variables. Modify the regexp as you need, and experiment by evaluating:
;;
;;(find-auto-coding "/home/brian/greekcode/garbage.c" 1) <= C-x C-e
;;
;;returns:
;;
;;(cp1253-unix . auto-coding-alist)
;;
;;Hopefully this helps! Would love to hear what other emacs users propose as solutions.

;;http://www.emacswiki.org/emacs/AutoCodingAlist
;; \\ 다음에 ' 이 있음을 주의하라 
;;`\`'
;;     matches the empty string, but only at the beginning of the string
;;     or buffer (or its accessible portion) being matched against.
;;
;;`\''
;;     matches the empty string, but only at the end of the string or
;;     buffer (or its accessible portion) being matched against.
;;
;;deprecatedbynext;;(setq file-coding-system-alist (append '(("\\.js$" . utf-8)) file-coding-system-alist ) ) ;; 자바 스크립트의 인코딩을 UTF-8 로 합니다. 
(add-to-list 'file-coding-system-alist '("itsalltext" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.py\\'" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.org\\'" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.json\\'" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.tex\\'" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.sql$" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.latex\\'" . utf-8))
(add-to-list 'file-coding-system-alist '("COMMIT_EDITMSG" . utf-8))
;;deprecated;; (add-to-list 'auto-coding-alist '("\\.latex\\'" . utf-8))


;;;_ http://www.emacswiki.org/emacs/ChangingEncodings


;;ChangingEncodings
;;When Emacs reads a file, it determines the encoding, reads the file, decodes it into an internal representation, and stores the coding-system used in a variable to be used when saving the file. When saving, the buffer is encoded using the stored coding-system and written to the file again.
;;
;;You can change the encoding to use for the file when saving using ‘C-x C-m f’. You can also force this immediately by using ‘C-x C-m c <encoding> RET C-x C-w RET’.
;;
;;You can force Emacs to read a file in a specific encoding with ‘C-x RET c C-x C-f’. If you opened a file and EMACS determined the encoding incorrectly, you can use ‘M-x revert-buffer-with-coding-system’, to reload the file with a named encoding.
;;
;;For characters covered by ISO 8859, you can interconvert most encodings in Emacs 21.3, courtesy of the code in ucs-tables.el.  fx
;;
;;Maybe some more explanation is needed, here. In an Emacs running in a Latin-1 locale, create a buffer containing the letter ‘’. Save. The modeline indicates Latin-1 via the ‘1’. Now save using ‘C-x C-m c latin-2 RET C-x C-w RET’. The modeline indicates Latin-2 via the ‘2’. Kill the buffer, reopen it. It displays correctly, but the modeline indicates Latin-1 again. When and why did Emacs do the change from Latin-2 back to Latin-1? Does Locale take precedence over ‘C-x C-m c’?
;;
;;If, in a Latin-1 environment, you visit a non-ASCII file that doesn’t contain bytes in the range #x80 to #x9f, it is decoded as Latin-1 unless its encoding is specified explicitly somehow. The character `’ has the same code point in Latin-1 and Latin-2, which is why it `displays correctly’. See M-x list-charset-chars and C-u C-x =.
;;Contents
;;Partial Recoding
;;Forcing windows-1252 coding
;;Partial Recoding
;;Sometimes you need to recode parts of a buffer. Here is an example: You are using Gnus to read mail, and somebody sends you a Word document. You use the AntiWord trick to automatically insert the output of antiword into your buffer. Normally, a Gnus “Article” buffer has the coding system undecided. The antiword output might be inserted using the wrong coding system. On my system, I might end up with something like this:
;;
;;    Mit freundschaftlichen Grssen und den besten Wnschen fr 2004,
;;    Aikido Dojo ZrichBut what I want is this:
;;
;;    Mit freundschaftlichen Grssen und den besten Wnschen fr 2004,
;;    Aikido Dojo ZrichIt seems that the process output was decoded as Latin-1 instead of UTF-8. I want to recode it! To that effect, use M-x recode-region. The command recode-region is part of MULE as of Emacs 22.1; here is a surrogate for older Emacsen:
;;
;;    (defun recode-region (start end &optional coding-system)
;;      "Replace the region with a recoded text."
;;      (interactive "r\n\zCoding System (utf-8): ")
;;      (setq coding-system (or coding-system 'utf-8))
;;      (let ((buffer-read-only nil)
;;	    (text (buffer-substring start end)))
;;        (delete-region start end)
;;        (insert (decode-coding-string (string-make-unibyte text) coding-system))))Now I can mark the attachment in the buffer and use M-x recode-region to recode it as UTF-8. The important part is that I need to convert the old text into “unibyte” representation. Without it, I will get the bytes used for the emacs-mule coding-system encoded as UTF-8.
;;
;;Forcing windows-1252 coding
;;Symptom: some files that used to be opened with the right coding under Emacs 21 are now opened with raw coding under Emacs 23. This is especially true with some files that had french accents that are now shown with codes such as \340 for “acute a”.
;;
;;Root cause: unknown.
;;
;;proposed “Solutions” seen for this problem: this does not work in my case: (prefer-coding-system ‘windows-1252)
;;
;;Since Emacs is not able to guess the coding for these types of files, here are 3 ways to address the problem.
;;
;;1) On a file by file basis: reopen the file by forcing the coding with this utility function:
;;    (defun has-revisit-file-with-coding-windows-1252 ()
;;    "Re-opens currently visited file with the windows-1252 coding. (By: hassansrc at gmail dot com)
;;    Example: 
;;    the currently opened file has french accents showing as codes such as:
;;        french: t\342ches et activit\340s   (\340 is shown as a unique char) 
;;    then execute this function: has-revisit-file-with-coding-windows-1252
;;      consequence: the file is reopened with the windows-1252 coding with no other action on the part of the user. 
;;                   Hopefully, the accents are now shown properly.
;;                   Otherwise, find another coding...
;;    
;;    "
;;        (interactive)
;;        (let ((coding-system-for-read 'windows-1252)
;;    	  (coding-system-for-write 'windows-1252)
;;    	  (coding-system-require-warning t)
;;    	  (current-prefix-arg nil))
;;          (message "has: Reopened file with coding set to windows-1252")
;;          (find-alternate-file buffer-file-name)
;;          )
;;    )Other ways to deal with accents that appear as codes (ex:\340 for acute e) when visiting files: 
;;
;;2)Intrusive way: put this at the beginning of the specific file that shows the problem :
;;    ;;; Emacs 23 is unable to open this file properly:  -*- coding: windows-1252 -*-3) General solution: apply this recipe to all *.txt files (put it in your .emacs file):
;;    (modify-coding-system-alist 'file "\\.txt\\'" 'windows-1252)These 3 solutions worked well under Emacs23 on Windows 7.
;;
;;HassanSrc



;;deprecated;;(defun recode-region (start end &optional coding-system)
;;deprecated;;  "Replace the region with a recoded text."
;;deprecated;;  (interactive "r\n\zCoding System (utf-8): ")
;;deprecated;;  (setq coding-system (or coding-system 'utf-8))
;;deprecated;;  (let ((buffer-read-only nil)
;;deprecated;;	    (text (buffer-substring start end)))
;;deprecated;;    (delete-region start end)
;;deprecated;;    (insert (decode-coding-string (string-make-unibyte text) coding-system))))




;; (defun set-default-coding-systems (coding-system)
;;   "Set default value of various coding systems to CODING-SYSTEM.
;; This sets the following coding systems:
;;   o coding system of a newly created buffer
;;   o default coding system for terminal output
;;   o default coding system for keyboard input
;;   o default coding system for subprocess I/O
;;   o default coding system for converting file names."
;;   (check-coding-system coding-system)
;;   ;;(setq-default buffer-file-coding-system coding-system)
;;   ;; (set-default-buffer-file-coding-system coding-system)
;;   ;; (if default-enable-multibyte-characters
;;   ;;     (setq default-file-name-coding-system coding-system))
;;   ;; If coding-system is nil, honor that on MS-DOS as well, so
;;   ;; that they could reset the terminal coding system.
;;   ;; (unless (and (eq window-system 'pc) coding-system)
;;   ;;   (setq default-terminal-coding-system coding-system))
;;   (set-terminal-coding-system coding-system)
;;   ;;(setq default-keyboard-coding-system coding-system)
;;   (set-keyboard-coding-system coding-system)
;;   (setq default-process-coding-system (cons coding-system coding-system))
;;   ;; Refer to coding-system-for-read and coding-system-for-write
;;   ;; so that C-x RET c works.
;;   (add-hook 'comint-exec-hook
;; 	    `(lambda ()
;; 	       (let ((proc (get-buffer-process (current-buffer))))
;; 		 (set-process-input-coding-system
;; 		  proc (or coding-system-for-read ',coding-system))
;; 		 (set-process-output-coding-system
;; 		  proc (or coding-system-for-write ',coding-system))))
;; 	    'append)
;;   (setq file-name-coding-system coding-system))

;; (set-default-coding-systems 'utf-8)
