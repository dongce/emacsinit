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


(require 'package-helper)
(defalias 'fullpath 'fullpath-relative-to-call-location)

(load "site-start")

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




(require 'string)
(require 'htmlize)
(require 'gtags )
(require 'bc-mode)
(require 'browse-kill-ring)
(require 'nsi-mode )
(require 'iedit)
(require 'csv-mode)

;; BAT 파일 모드 
(require 'dos)
(require 'ntcmd)
;;https://github.com/juergenhoetzel/tramp-adb
;;adb 에 접근가능 
(require 'tramp-adb)
;;(require 'rfringe)
(require 'whole-line-or-region)
(require 'ack-emacs)
;;(require 'full-ack)
;;(require 'deft)
;;NOTWORK;;(require 'grep-edit)
(require 'grep-ed)
(require 'markerpen)
;;(require 'highlight)
(require 'highline)
(require 'sml-modeline)
(sml-modeline-mode)
;;(require 'nyan-mode)
;;(nyan-mode)
;;deprecatedbyelpa;;(require 'ascii)
;;deprecatedby init-edit;; (require 'misc-cmds)
(require 'saveplace)
(setq-default save-place t)
;;https://github.com/syohex/emacs-quickrun
(require 'quickrun)
;; copy/undo 등의 작업을 highlight 한다. 
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; ruby 개발환경 
;;deprecateby-elpa;;(require 'ruby-mode)
;;deprecateby-elpa;;(require 'rubydb)
;;deprecateby-elpa;;(require 'inf-ruby)
;;deprecateby-elpa;;(require 'ruby-electric)

;;(require 'highlight-indentation)

;; diff mode 를 매우 느리게 합니다. 
;;(require 'rainbow-delimiters)
;;(global-rainbow-delimiters-mode 1 )

(require 'dove-ext)
;; javascript
;; jsshell 명령 이용
(require 'jsshell-bundle)
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

;;
;; Tex 사용환경 구성
;;
;;deprecateby-elpa;;(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(require 'tex-mik)

(with-package* (time-stamp)
  (require 'time-stamp)
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

(with-package* (nxml-mode)
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



;;(require 'diffstat)
;;(add-hook 'diff-mode-hook (lambda () (local-set-key "\C-c\C-l" 'diffstat)))

(global-set-key "\C-cr" 'read-only-mode)





;; SDD 작성동안 temporary 
;;(add-hook 
;; 'c-mode-common-hook 
;; '(lambda () 
;;    ;; define comment style to "//"
;;    (hl-line-mode 1 )))

(require 'wiki-nav)
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


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





;; 트위터 클라이언트 
;;확인필요;;(require 'twittering-mode)
;;확인필요;;(setq twittering-curl-program "c:\\usr\\local\\editor\\emacsW32\\site-lisp\\twittering-mode-2.0.0\\win-curl\\curl.exe")

(defun maxwin ()
  (interactive)
  (w32-send-sys-command #xf030))

;; 간단하게 mode 를 만들 수 있는 방법입니다. 
;;CHECK MODE MAKING;;(require 'smart-operator)
;;CHECK MODE MAKING;;
;;CHECK MODE MAKING;;(defun smart-operator-self-insert-command (arg)
;;CHECK MODE MAKING;;  "Insert the entered operator plus surrounding spaces."
;;CHECK MODE MAKING;;  (interactive "p")
;;CHECK MODE MAKING;;  (smart-insert-operator (string last-command-char)))
;;CHECK MODE MAKING;;
;;CHECK MODE MAKING;;(defvar smart-operator-mode-map
;;CHECK MODE MAKING;;  (let ((keymap (make-sparse-keymap)))
;;CHECK MODE MAKING;;    (define-key keymap "=" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "+" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "-" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "/" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "%" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "&" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "*" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "!" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "|" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "<" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap ">" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "," 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap "." 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    (define-key keymap ":" 'smart-operator-self-insert-command)
;;CHECK MODE MAKING;;    keymap)
;;CHECK MODE MAKING;;  "Keymap used my `smart-operator-mode'.")
;;CHECK MODE MAKING;;
;;CHECK MODE MAKING;;(define-minor-mode smart-operator-mode
;;CHECK MODE MAKING;;  "Insert operators packed with whitespaces smartly."
;;CHECK MODE MAKING;;  nil " _=_" smart-operator-mode-map)

;;CODING;;http://www.delorie.com/gnu/docs/emacs/emacs_222.html
;;CODING::C-x RET f coding RET
;;CODING::    Use coding system coding for the visited file in the current buffer.
;;CODING::
;;CODING::C-x RET c coding RET
;;CODING::    Specify coding system coding for the immediately following command.
;;CODING::
;;CODING::C-x RET k coding RET
;;CODING::    Use coding system coding for keyboard input.
;;CODING::
;;CODING::C-x RET t coding RET
;;CODING::    Use coding system coding for terminal output.
;;CODING::
;;CODING::C-x RET p input-coding RET output-coding RET
;;CODING::    Use coding systems input-coding and output-coding for subprocess input and output in the current buffer.
;;CODING::
;;CODING::C-x RET x coding RET
;;CODING::    Use coding system coding for transferring selections to and from other programs through the window system.
;;CODING::
;;CODING::C-x RET X coding RET
;;CODING::    Use coding system coding for transferring one selection--the next one--to or from the window system. 

;;;; 80 컬렴 이상일 경우 표시하는 모드
;;(global-whitespace-mode)

;;;; 기본적으로 readonly 속성을 지정할 수 있다. 
;;(setq-default buffer-read-only t )

;; color 확인 
;; (list-colors-display)

;;w32shell;;(when (and (eq system-type 'windows-nt)
;;w32shell;;           (string= (substring emacs-version 0 3) "22."))
;;w32shell;;  (setq pr-gs-command "c:\\gs\\gs8.51\\bin\\gswin32c.exe")
;;w32shell;;  (setq pr-gv-command "C:\\Program Files\\Ghostgum\\gsview\\gsview32.exe")
;;w32shell;;  (setq w32-print-menu-show-print nil)
;;w32shell;;  (setq w32-print-menu-show-ps-print nil)
;;w32shell;;  (setq htmlize-view-print-visible t)
;;w32shell;;  (setq emacsw32-style-frame-title t)
;;w32shell;;  (setq emacsw32-mode nil) ; Keep Emacs bindings
;;w32shell;;  (setq w32shell-cygwin-bin "C:\\cygwin\\bin")
;;w32shell;;  (setq w32shell-msys-bin "C:/msys/1.0/bin")
;;w32shell;;  (require 'emacsw32)
;;w32shell;;  (require 'w32-integ)
;;w32shell;;  (require 'w32shell)
;;w32shell;;  (w32shell-add-emacs)
;;w32shell;;  (w32shell-set-shell "msys")
;;w32shell;;  (require 'cmd-mode)
;;w32shell;;  (require 'w32-print))
;;(require 'popwin)







;; calendar 읽기 전용이며 google calendar 와 연동 가능하다 .
;;(require 'calfw)
;;(require 'calfw-org)


;;LAST2DIRECTORY;;(defun add-mode-line-dirtrack ()
;;LAST2DIRECTORY;;  "When editing a file, show the last 2 directories of the current path in the mode line."
;;LAST2DIRECTORY;;  (add-to-list 'mode-line-buffer-identification 
;;LAST2DIRECTORY;;               '(:eval (substring default-directory 
;;LAST2DIRECTORY;;                                  (+ 1 (string-match "/[^/]+/[^/]+/$" default-directory)) nil))))


;; 경로명 처리 
;;(load "pathname-dos.el")
;;(load "pathname-unix.el")
;;(load "pathname.el")

;;paren-navigation;;C-M-n     Move forward over a parenthetical group 
;;paren-navigation;;C-M-p     Move backward over a parenthetical group 
;;paren-navigation;;C-M-f     Move forward over a balanced expression
;;paren-navigation;;C-M-b     Move backward over a balanced expression
;;paren-navigation;;C-M-k     Kill balanced expression forward
;;paren-navigation;;C-M-SPC   put the mark at the end of the sexp.

(autoload 'transpose-paragraph-as-table "transpar"
  "텍스트테이블 편집 명령" t)

;; 다음과 같이 문단을 이용하는 것이 도움이 될 수 있다. 
;;(defun transpose-paragraph-as-table ()
;;  "Transpose and align current paragraph."
;;  (interactive)
;;  (transpose-region-as-table (paragraph-beginning-position) (paragraph-end-position)))

(defun add-mode-line-dirtrack ()
  (add-to-list 'mode-line-buffer-identification 
               '(:propertize (" " default-directory " ") face dired-directory)))

(add-hook 'shell-mode-hook 'add-mode-line-dirtrack)
(add-hook 'find-file-hook 'add-mode-line-dirtrack)

(autoload 'wc-mode "wc-mode"
  "단어수 계산" t)




(autoload 'emacs-init-check "emacs-init-check"
  "~/.emacs 파일의 정상 여부를 확인 " t)

;;veryslow;;(require 'unicode-fonts)
;;veryslow;;(unicode-fonts-setup)

;; 북마크 를 사용한다. 
;;(bookmark-bmenu-list)
;;(switch-to-buffer "*Bookmark List*")



;;(toggle-full-screen)








;; Local Variables:
;; eval: (orgstruct-mode t)
;; eval: (setq orgstruct-heading-prefix-regexp ";;;;")
;; End:
