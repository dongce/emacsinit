;; -*- coding: utf-8;  -*-

;;;;* language 
(setenv "HANGUL_KEYBOARD_TYPE" "3f")
(setq  default-korean-keyboard "3f")
(set-language-environment "Korean")
;; 이렇게 하여서 한글을 사용할 때 깜박이는 현상을 없앨 수 있을 것이다. 
;; 이 환경 변수가 정의 된 곳은 mule-cmds.el 파일이다. 이곳에 입력 기능 관련하여
;; 다른 변수들이 있을 것이다. 
(setq input-method-verbose-flag nil )

(defun fullpath-relative-to-call-location (file-path)
  "Returns the full path of FILE-PATH, relative to file location where this function is called.

Example: If the file that calls fullpath-relative-to-call-location is at:
/Users/xah/web/emacs/emacs_init.el then,
 (fullpath-relative-to-call-location \"xyz.el\")
returns
 /Users/xah/web/emacs/xyz.el

This function solves 2 problems.
 (1) if you have file A that contains the line “(load \"B\")”,
and file B calls load with a relative path “(load \"../C\")”,
then Emacs will complain about unable to find C. Because, emacs
does not switch current directory with “load”. To solve this, you
call “(load (fullpath-relative-to-call-location <your path of C
relative to B>))” in B.  A common solution is add all dirs to
load path, but that is not always desirable.

 (2) To know the current file's full path, emacs has 2 ways:
load-file-name and buffer-file-name. If the file is called by
“load”, then load-file-name contains the file's path, but not
buffer-file-name. But if the file is called by eval-buffer, then
load-file-name is nil. So, to know the running file's path
regardless how it is called, use “(or load-file-name
buffer-file-name)”. This is part of this function."
  (file-truename (concat (file-name-directory (or load-file-name buffer-file-name)) file-path))
)

(require 'use-package)
(use-package package-helper)
(defalias 'fullpath 'fullpath-relative-to-call-location)

;;(load "site-start")
;; ****** Added by emacsw32-setup-base at Mon Nov 09 14:52:29 2009
;; Add EmacsW32/lisp to load-path if found.

;;스타트업 메시지를 사용하지 않기로 한다. 
(setq inhibit-startup-message t) 
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
;;(setq-default c-default-style "stroustrup" )

(setq-default c-default-style "gnu" )


;;'(grep-command "ack.pl --smart-case ")

;;한글지원안됨;;(require 'pabbrev)
;;한글지원안됨;;(custom-set-faces
;;한글지원안됨;; ;; custom-set-faces was added by Custom.
;;한글지원안됨;; ;; If you edit it by hand, you could mess it up, so be careful.
;;한글지원안됨;; ;; Your init file should contain only one such instance.
;;한글지원안됨;; ;; If there is more than one, they won't work right.
;;한글지원안됨;; '(pabbrev-suggestions-face ((t (:foreground "green")))))

;;;;* initial init 




;;(require 'string)
;;(require 'htmlize)
;;(require 'gtags )
(require 'bc-mode)
;;(require 'browse-kill-ring)
;(require 'nsi-mode )
;(require 'iedit)
;(require 'csv-mode)

;; BAT 파일 모드 
;(require 'dos)
;(require 'ntcmd)
;;https://github.com/juergenhoetzel/tramp-adb
;;adb 에 접근가능 
(require 'tramp-adb)
;;(require 'rfringe)
;(require 'whole-line-or-region)
;(require 'ack-emacs)
;;(require 'full-ack)
;;(require 'deft)
;;NOTWORK;;(require 'grep-edit)
(require 'grep-ed)
(require 'markerpen)
;;(require 'highlight)
(require 'highline)
;;(require 'nyan-mode)
;;(nyan-mode)
;;deprecatedbyelpa;;(require 'ascii)
;;deprecatedby init-edit;; (require 'misc-cmds)
(require 'saveplace)
(setq-default save-place t)
;;https://github.com/syohex/emacs-quickrun
(require 'quickrun)
;; copy/undo 등의 작업을 highlight 한다. 
;;(require 'volatile-highlights)
;;(volatile-highlights-mode t)

;; ruby 개발환경 
;;deprecateby-elpa;;(require 'ruby-mode)
;;deprecateby-elpa;;(require 'rubydb)
;;deprecateby-elpa;;(require 'inf-ruby)
;;deprecateby-elpa;;(require 'ruby-electric)

;;(require 'highlight-indentation)

;; diff mode 를 매우 느리게 합니다. 
;;(require 'rainbow-delimiters)
;;(global-rainbow-delimiters-mode 1 )

;(require 'dove-ext)
;; javascript
;; jsshell 명령 이용
;(require 'jsshell-bundle)
(require 'second-sel)
(global-set-key [(control meta ?y)]     'secondary-dwim)

(require 'url)
(require 'thingatpt)
;;(require 'thingatpt+)
;;(require 'thing-cmds)
(require 'hide-comnt)

;; 다음을 이용해서 불필요한 라인을 잠시 숨길 수 있다. 
;; http://www.emacswiki.org/emacs/CategoryHideStuff 참고 
(require 'hide-lines)
(global-set-key "\C-ch" 'hide-lines)


(use-package time-stamp
  :init
  (setf time-stamp-start "마지막 변경 시각:[ 	]+[\"<]+")
  (setf time-stamp-format "%:y년 %02m월 %02d일 %:a %02H시 %02M분 %02S초")
;;(add-hook 'before-save-hook 'time-stamp) ;;TIME STAMP 의 경우 merge 하기 어렵다. 
)




(put 'upcase-region 'disabled nil)
;;;
;;;
;;; ※ 라이브러리 로딩
;;;
;;;
(load-library "replace")







;;(load "c:/usr/local/editor/emacsW32/EmacsW32/nxhtml/autostart.el")


;; 다음은 추가적으로 보태어진 것으로 유용하게 사용할 수 있는 쇼트 컷이다. 
;;(global-set-key (kbd "C-,")  (aif (svn-status "g:/svndir/WinDLP/dlp-src"  '-)))
;;(global-set-key (kbd "C-.")  (aif (read-only-mode)))

;;deprecatedby-ido;;(iswitchb-mode)       

(use-package nxml-mode
  :config
  (define-key nxml-mode-map  [C-right] 'forward-word )
  (define-key nxml-mode-map  [C-left] 'backward-word ))


;;;Force emacs to open files in unix mode
;;;April 8, 2007 · Posted in Computer 
;;;
;;;I believe that emacs by default will use the line endings for current system when opening and saving text files.  This may cause a problem when you want to force the file to be saved with different line endings. I found this series of commands to force the file to be opened in unix mode:
;;;
;;;
;;;C-x RET c unix RET C-x C-f

;;(require 'icicles)


;;;(defun dired-modified ()
;;;  (interactive)
;;;  (dired-sort-menu-set-switches "t" ))

;;deprecated;;(require 'color-moccur)

;;(setq 
;; vs2005-header-path
;; '("d:/usr/microsoft/vs2005/SDK/v2.0/Include"
;;   "d:/usr/microsoft/vs2005/VC/include"
;;   "d:/usr/microsoft/vs2005/VC/atlmfc/include"
;;   "d:/usr/microsoft/vs2005/VC/PlatformSDK/Include"))





;;;(defun grep-symbol ()
;;;  ;; TODO prefix argument 를 주어서 디렉토리 설정할 수 있도록 
;;;  (interactive)
;;;  (grep (format "ack --smart-case \"%s\" " (thing-at-point 'sexp))))

;;NOTWORK;;(require 'repeat-insert)


;;;AUTOHOTKEY;;; autohotkey
;;;AUTOHOTKEY;;; 글쓴이: dreamstorm 작성 일시: 화, 2009/04/07 - 11:13오전
;;;AUTOHOTKEY;;; 
;;;AUTOHOTKEY;;; 저도 비슷한 고민을 했었네요.
;;;AUTOHOTKEY;;; 
;;;AUTOHOTKEY;;; 한영키가 달린 키보드를 쓸때는 다른 어플에서는 한영키를 쓰고
;;;AUTOHOTKEY;;; 이맥스에서는 shift-space 를 썼었는데 한영키가 없는 키보드로 바꾼후에
;;;AUTOHOTKEY;;; 윈도 IME 에서 shift-space 를 쓰도록 한 후에는 이맥스를 쓸때 좀
;;;AUTOHOTKEY;;; 답답했습니다.
;;;AUTOHOTKEY;;; 
;;;AUTOHOTKEY;;; 그래서 한영키가 없는 키보드지만 한영키가 달린 키보드로 드라이버를
;;;AUTOHOTKEY;;; 잡아주고(타입3?) autohotkey 를 이용해서 shift-space 가 들어오면 emacs
;;;AUTOHOTKEY;;; 를 제외한 어플에서는 한영키로 변환을 하고 emacs 에서는 그냥
;;;AUTOHOTKEY;;; 통과시켰습니다.( 오래된 일이라 키보드 타입 바꿔준건 기억이 가물가물
;;;AUTOHOTKEY;;; 하네요. 지금은 거의 리눅스만 써서.. )
;;;AUTOHOTKEY;;; 
;;;AUTOHOTKEY;;; * auto hot key 스크립트 
;;;AUTOHOTKEY;;; {{{
;;;AUTOHOTKEY;;; 
;;;AUTOHOTKEY;;; #IfWinNotActive ,GNU Emacs 23
;;;AUTOHOTKEY;;; +space::Send, {vk15sc138}
;;;AUTOHOTKEY;;; 
;;;AUTOHOTKEY;;; }}}






;; 다음함수를 이용하여 파일의 로컬변수를 설정할 수 있다. 
;; http://www.gnu.org/software/libtool/manual/emacs/Variables.html#Variables 메뉴얼참고 
;; add-file-local-variable-prop-line' 

(require 'uniquify)

;; 다음과 같이 해서 주기적으로 숫자를 증가할 수 있다. 
;;;;; (global-set-key (kbd "<f5>") 'init-macro-counter-default)
;;;;; (global-set-key (kbd "<f6>") 'kmacro-insert-counter)






;;DEPRECATED;;(require 'bbdb)
;;DEPRECATED;;(bbdb-initialize)

(load-library "highlight-symbol")




;; ELPA  이멕스 패키지 시스템 
;; FUNCTION DEFINITION 

;; SDD 작성동안 temporary 
;;(add-hook 
;; 'c-mode-common-hook 
;; '(lambda () 
;;    ;; define comment style to "//"
;;    (hl-line-mode 1 )))

(require 'wiki-nav)
(use-package smex
:config  
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
)
;; www.emacswiki.org/emacs/PredictiveMode
;;(autoload 'predictive-mode "predictive" "predictive" t)
;;(set-default 'predictive-auto-add-to-dict t)
;;(setq 
;;      predictive-auto-learn t
;;      predictive-add-to-dict-ask nil
;;      predictive-use-auto-learn-cache nil
;;      predictive-which-dict t
;;      ;;predictive-main-dict 'rpg-dictionary
;;      )






(use-package transpar
  :commands transpose-paragraph-as-table 
 )

;; Local Variables:
;; eval: (orgstruct-mode t)
;; eval: (setq orgstruct-heading-prefix-regexp ";;;;")
;; End:
