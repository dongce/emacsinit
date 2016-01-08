;; -*- coding: utf-8; -*-

(defun* cycle-font (num &optional (hangul nil))
  "Change font in current frame.
Each time this is called, font cycles thru a predefined set of fonts.
If NUM is 1, cycle forward.
If NUM is -1, cycle backward.
Warning: tested on Windows Vista only."
  (interactive "p")
  ;; this function sets a property “state”. It is a integer. Possible values are any index to the fontList.
  (let (fontList hanFontList fontToUse currentState nextState )
    (setq fontList (list
                    "Courier New-10" 
                    "DejaVu Sans Mono-9" 
                    "Lucida Console-10"
                    "DejaVu Sans-10" 
                    "Lucida Sans Unicode-10" 
                    "Arial Unicode MS-10" 
                    "Consolas-10"
                    "Inconsolata-10"
                    "Monaco-9"
                    ))
    (setq hanFontList (list
                       '("돋움체" . "unicode-bmp")
                       '("새굴림" . "unicode-bmp")
                       '("나눔고딕_코딩" . "unicode-bmp")
                       '("맑은 고딕" . "unicode-bmp")
                       '("나눔고딕코딩" . "unicode-bmp")
                    ))
    ;; fixed-width "Courier New" "Unifont"  "FixedsysTTF" "Miriam Fixed" "Lucida Console" "Lucida Sans Typewriter"
    ;; variable-width "Code2000"
    
    (if hangul
        (progn
          (setq currentState (if (get 'cycle-font 'hanstate) (get 'cycle-font 'hanstate) 0))
          (setq nextState (% (+ currentState (length hanFontList) num) (length hanFontList)))
          (setq fontToUse (nth nextState hanFontList))
          (set-fontset-font "fontset-default" 'hangul fontToUse)
          (redraw-frame (selected-frame))
          (message "Current font is: %s" (car fontToUse ))
          (put 'cycle-font 'hanstate nextState)
          )
      (progn
        (setq currentState (if (get 'cycle-font 'state) (get 'cycle-font 'state) 0))
        (setq nextState (% (+ currentState (length fontList) num) (length fontList)))
        (setq fontToUse (nth nextState fontList))
        ;;(set-frame-parameter nil 'font fontToUse)
        (set-face-font 'default fontToUse)
        (redraw-frame (selected-frame))
        (message "Current font is: %s" fontToUse )
        (put 'cycle-font 'state nextState)
        )
      )))

(defun cycle-font-forward (&optional hangul)
  "Switch to the next font, in the current frame.
See `cycle-font'."
  (interactive "P")
  (if hangul
      (cycle-font 1 t)
    (cycle-font 1 nil)
  ))

(defun cycle-font-backward(&optional hangul)
  "Switch to the previous font, in the current frame.
See `cycle-font'."
  (interactive "P")
  (if hangul
      (cycle-font -1 t)
    (cycle-font -1 nil)
  ))

;; https://github.com/rolandwalker/unicode-fonts
;; (with-package* (unicode-fonts)
;;   (unicode-fonts-setup))

;; (with-package* (dynamic-fonts)
;;   (dynamic-fonts-setup))

(with-package* (font-utils)
  (let ((defaultfont (find-if 
                      (lambda (x) (font-utils-exists-p x)) 
                      '(
                        "Bitstream Vera Sans Mono-11"
                        "DejaVu Sans Mono-11"
                        "Consolas-11"
                        "Inconsolata-11"
                        "Source Code Pro-10"
                        "Menlo-10"
                        ))))
    (if (stringp  defaultfont)
        
          ;; (set-fontset-font "fontset-default" 'latin (font-spec :name defaultfont :size 15) )
        (set-face-font 'default defaultfont)
        ;; (set-face-attribute 'default nil :family defaultfont)

      ))


  (let ((defaultfont (find-if 
                      (lambda (x) (font-utils-exists-p x)) 
                      '( "StixGeneral"))))
    (if (stringp  defaultfont) 
        (progn 
          (set-fontset-font "fontset-default" 'symbol (font-spec :name defaultfont :size 15) )
          (set-fontset-font "fontset-default" 'mathematical (font-spec :name defaultfont :size 15) )
          (set-fontset-font "fontset-default" '(9089 . 9090) (font-spec :name defaultfont :size 15) nil 'prepend))))

  (let ((defaultfont (find-if 
                      (lambda (x) (font-utils-exists-p x)) 
                      '( "맑은 고딕" "돋움체" "나눔고딕코딩"))))
    (if (stringp  defaultfont) 
        (progn 
          (set-fontset-font "fontset-default" 'hangul (cons defaultfont  "unicode-bmp") )
          (set-fontset-font "fontset-default" '(8251 . 8252) (cons defaultfont  "unicode-bmp") )
          (set-fontset-font "fontset-default" '(61548 . 61549) (cons defaultfont  "unicode-bmp") )))))


;; http://ergoemacs.org/emacs/emacs_pretty_lambda.html
;;(setq prettify-symbols-alist
;;      '(
;;        ("lambda" . 955) ; λ
;;        ("->" . 8594)    ; →
;;        ("=>" . 8658)    ; ⇒
;;        ("map" . 8614)    ; ↦
;;        ))


;;(defun my-add-pretty-lambda ()
;;  "make some word or string show as pretty Unicode symbols"
;;  (setq prettify-symbols-alist
;;        '(
;;          ("lambda" . 955) ; λ
;;          ("->" . 8594)    ; →
;;          ("=>" . 8658)    ; ⇒
;;          ("map" . 8614)   ; ↦
;;          )))
;;
;;(add-hook 'clojure-mode-hook 'my-add-pretty-lambda)
;;(add-hook 'haskell-mode-hook 'my-add-pretty-lambda)
;;(add-hook 'shen-mode-hook 'my-add-pretty-lambda)
;;(add-hook 'tex-mode-hook 'my-add-pretty-lambda)


(add-hook 'python-mode-hook #'(lambda () (setq prettify-symbols-alist '("map" . 8614))))

;;
;;JPEG가동작해야한다;;(defvar big-lambda-image
;;JPEG가동작해야한다;;  (create-image
;;JPEG가동작해야한다;;   (base64-decode-string
;;JPEG가동작해야한다;;    "/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAsICAoIBwsKCQoNDAsNERwSEQ8PESIZGhQcKSQrKigk
;;JPEG가동작해야한다;;  JyctMkA3LTA9MCcnOEw5PUNFSElIKzZPVU5GVEBHSEX/2wBDAQwNDREPESESEiFFLicuRUVFRUVF
;;JPEG가동작해야한다;;  RUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUX/wAARCAAwAEADASIA
;;JPEG가동작해야한다;;  AhEBAxEB/8QAGgABAQEBAAMAAAAAAAAAAAAAAAUEAwIGB//EACgQAAEEAQIEBgMAAAAAAAAAAAEA
;;JPEG가동작해야한다;;  AgMEERIhBTFhcQYUIjJBgRVRkf/EABcBAQEBAQAAAAAAAAAAAAAAAAABAwL/xAAcEQEBAQACAwEA
;;JPEG가동작해야한다;;  AAAAAAAAAAAAAQIRIQMxQVH/2gAMAwEAAhEDEQA/APriIiAThZqvEKd5zxUtQzmP3CN4dj+Lyu1G
;;JPEG가동작해야한다;;  XqklaRzmxyDDtJwSM7jsRsehWHiUbKlrh1qJgYWTCu7TtmN/p09g7QfpaYznXX1FVERZqIiICIiA
;;JPEG가동작해야한다;;  ofiK6IvJV2t1vdZhkfv7I2yNy4/ZAHforM80deCSaZ4ZHG0uc48gBuSoTqE13g1+1Kwi5dj1MYec
;;JPEG가동작해야한다;;  bW7xs+uZ6krfwyTU1r0lewIuNOyy5ThsR+yZgeOxGV2WNnF4qiIigIiIJd+N/EL8NIsd5WPE87iN
;;JPEG가동작해야한다;;  n4PoZ13GT0AHyqiIurrmSfgixT/gpJa9hjxRc4vgmYwuEeTksdgbYJJB5YOPjffQuOvNllETo4Ne
;;JPEG가동작해야한다;;  InPBaZG4GXYO4Gc4/eMrWi61ua7s7QREWav/2Q==")
;;JPEG가동작해야한다;;   'jpeg t))
;;JPEG가동작해야한다;;
;;JPEG가동작해야한다;;(defvar big-lambda-font-lock-keywords
;;JPEG가동작해야한다;;  '((".+" (0 (prog1 nil
;;JPEG가동작해야한다;;               (big-lambda-remove-region
;;JPEG가동작해야한다;;                (match-beginning 0) (match-end 0)))))
;;JPEG가동작해야한다;;    ("(\\(lambda\\)\\>"
;;JPEG가동작해야한다;;     (0 (prog1 nil
;;JPEG가동작해야한다;;          (big-lambda-region (match-beginning 1) (match-end 1)))))))
;;JPEG가동작해야한다;;
;;JPEG가동작해야한다;;(defun big-lambda-remove-region (beg end)
;;JPEG가동작해야한다;;  "Remove big lambda property in region between BEG and END."
;;JPEG가동작해야한다;;  (let (pos)
;;JPEG가동작해야한다;;    (while (setq pos (text-property-any beg end 'display big-lambda-image))
;;JPEG가동작해야한다;;      (remove-text-properties
;;JPEG가동작해야한다;;       pos
;;JPEG가동작해야한다;;       (or (next-single-property-change pos 'display) end)
;;JPEG가동작해야한다;;       '(display)))))
;;JPEG가동작해야한다;;
;;JPEG가동작해야한다;;(defun big-lambda-region (beg end)
;;JPEG가동작해야한다;;  "Add big lambda property in region between BEG and END."
;;JPEG가동작해야한다;;  (put-text-property beg end 'display big-lambda-image))
;;JPEG가동작해야한다;;
;;JPEG가동작해야한다;;(define-minor-mode big-lambda-mode
;;JPEG가동작해야한다;;  "Display big lambda."
;;JPEG가동작해야한다;;  :lighter " Lambda"
;;JPEG가동작해야한다;;  (if big-lambda-mode
;;JPEG가동작해야한다;;      (progn
;;JPEG가동작해야한다;;        (save-restriction
;;JPEG가동작해야한다;;          (widen)
;;JPEG가동작해야한다;;          (let ((font-lock-keywords big-lambda-font-lock-keywords))
;;JPEG가동작해야한다;;            (font-lock-fontify-buffer)))
;;JPEG가동작해야한다;;        (font-lock-add-keywords nil big-lambda-font-lock-keywords))
;;JPEG가동작해야한다;;    (font-lock-remove-keywords nil big-lambda-font-lock-keywords)
;;JPEG가동작해야한다;;    (save-restriction
;;JPEG가동작해야한다;;      (widen)
;;JPEG가동작해야한다;;      (let ((modified-p (buffer-modified-p)))
;;JPEG가동작해야한다;;        (big-lambda-remove-region (point-min) (point-max))
;;JPEG가동작해야한다;;        (set-buffer-modified-p modified-p)))))
;;JPEG가동작해야한다;;
;;JPEG가동작해야한다;;(defun big-lambda-mode-turn-on ()
;;JPEG가동작해야한다;;  "Turn on `big-lambda-mode'."
;;JPEG가동작해야한다;;  (interactive)
;;JPEG가동작해야한다;;  (big-lambda-mode 1))
;;JPEG가동작해야한다;;
;;JPEG가동작해야한다;;(add-hook 'emacs-lisp-mode 'big-lambda-mode-turn-on)

;;(require 'pretty-lambdada)
;;(pretty-lambda-for-modes nil)
;;deprecatedby-packages;;(require 'pretty-symbols)
(add-hook 'emacs-lisp-mode-hook 'pretty-symbols-mode)
(add-hook 'scheme-mode-hook 'pretty-symbols-mode)

;;(add-hook 'c++-mode-hook        'pretty-symbols-mode)

;;; http://www.reddit.com/r/emacs/comments/1huhsg/i_need_help_with_adding_keywords_for_syntax/
;; font lock 설정 
(global-font-lock-mode 1)                     ; for all buffers

(setq 
 font-lock-maximum-decoration 
 '(
   (c-mode . t)
   ;;(c++-mode . 1)
   (c++-mode . 2)
   (t . t)
   ))


(setq font-lock-maximum-size nil)
;;(setq font-lock-support-mode 'fast-lock-mode ; lazy-lock-mode jit-lock-mode
;;      fast-lock-cache-directories '("~/.emacs-flc"))

;; 모드별로 키워드 추가가 가능하다. 
;; http://www.emacswiki.org/emacs/AddKeywords
;;FONT-LOCK;;(defvar font-lock-comment-face		'font-lock-comment-face
;;FONT-LOCK;;  "Face name to use for comments.")
;;FONT-LOCK;;(defvar font-lock-comment-delimiter-face 'font-lock-comment-delimiter-face
;;FONT-LOCK;;  "Face name to use for comment delimiters.")
;;FONT-LOCK;;(defvar font-lock-string-face		'font-lock-string-face
;;FONT-LOCK;;  "Face name to use for strings.")
;;FONT-LOCK;;(defvar font-lock-doc-face		'font-lock-doc-face
;;FONT-LOCK;;  "Face name to use for documentation.")
;;FONT-LOCK;;(defvar font-lock-keyword-face		'font-lock-keyword-face
;;FONT-LOCK;;  "Face name to use for keywords.")
;;FONT-LOCK;;(defvar font-lock-builtin-face		'font-lock-builtin-face
;;FONT-LOCK;;  "Face name to use for builtins.")
;;FONT-LOCK;;(defvar font-lock-function-name-face	'font-lock-function-name-face
;;FONT-LOCK;;  "Face name to use for function names.")
;;FONT-LOCK;;(defvar font-lock-variable-name-face	'font-lock-variable-name-face
;;FONT-LOCK;;  "Face name to use for variable names.")
;;FONT-LOCK;;(defvar font-lock-type-face		'font-lock-type-face
;;FONT-LOCK;;  "Face name to use for type and class names.")
;;FONT-LOCK;;(defvar font-lock-constant-face		'font-lock-constant-face
;;FONT-LOCK;;  "Face name to use for constant and label names.")
;;FONT-LOCK;;(defvar font-lock-warning-face		'font-lock-warning-face
;;FONT-LOCK;;  "Face name to use for things that should stand out.")
;;FONT-LOCK;;(defvar font-lock-negation-char-face	'font-lock-negation-char-face
;;FONT-LOCK;;  "Face name to use for easy to overlook negation.
;;FONT-LOCK;;This can be an \"!\" or the \"n\" in \"ifndef\".")
;;FONT-LOCK;;(defvar font-lock-preprocessor-face	'font-lock-preprocessor-face
;;FONT-LOCK;;  "Face name to use for preprocessor directives.")
;;FONT-LOCK;;(defvar font-lock-reference-face	'font-lock-constant-face)
(font-lock-add-keywords 'python-mode
  '(("\\btry\\b" . font-lock-keyword-face)
    ("\\bfinally\\b" . font-lock-keyword-face)
    ("\\bwith\\b" . font-lock-keyword-face)
    ("\\bas\\b" . font-lock-keyword-face)
    ))




;;fontset;;;;; 참고자료 
;;fontset;;;;; http://stackoverflow.com/questions/14080021/emacs-set-fontset-font-for-specific-unicode-char-under-windows
;;fontset;;
;;fontset;;
;;fontset;;Stack Exchange
;;fontset;;sign up log in careers 2.0
;;fontset;;
;;fontset;;Stack Overflow
;;fontset;;
;;fontset;;    Questions
;;fontset;;    Tags
;;fontset;;    Tour
;;fontset;;    Users
;;fontset;;
;;fontset;;    Ask Question
;;fontset;;
;;fontset;;Tell me more ×
;;fontset;;Stack Overflow is a question and answer site for professional and enthusiast programmers. It's 100% free, no registration required.
;;fontset;;emacs set-fontset-font for specific unicode char under windows
;;fontset;;up vote 0 down vote favorite
;;fontset;;	
;;fontset;;
;;fontset;;I use the following setting to config the font for emacs under windows system
;;fontset;;
;;fontset;;(create-fontset-from-fontset-spec
;;fontset;; "-outline-Cousine-normal-normal-normal-*-*-*-*-*-*-*-fontset-Consolas")
;;fontset;;(set-fontset-font "fontset-Consolas" 
;;fontset;;                  '(#x6d4b . #x6d4c) 
;;fontset;;                  "Microsoft YaHei" nil 'prepend)
;;fontset;;(set-face-attribute 'default nil :font "fontset-Consolas")
;;fontset;;
;;fontset;;After emacs start up, I input that char #x6d4b into the emacs buffer, but it turns out to be a square, which means the font setting does not work. I also use describe-char to show detail information, and get the following result:
;;fontset;;
;;fontset;;             position: 2888 of 4342 (66%), column: 13
;;fontset;;            character: 测 (displayed as 测) (codepoint 27979, #o66513, #x6d4b)
;;fontset;;    preferred charset: unicode-bmp (Unicode Basic Multilingual Plane (U+0000..U+FFFF))
;;fontset;;code point in charset: 0x6D4B
;;fontset;;               syntax: w    which means: word
;;fontset;;             category: .:Base, C:2-byte han, L:Left-to-right (strong), c:Chinese, |:line breakable
;;fontset;;          buffer code: #xE6 #xB5 #x8B
;;fontset;;            file code: #xE6 #xB5 #x8B (encoded by coding system utf-8-dos)
;;fontset;;              display: no font available
;;fontset;;
;;fontset;;We can find that the display property shows it does not have available font for it, but I indeed give that in the font config.
;;fontset;;
;;fontset;;Could you point out where is the problem? I suppose the set-fontset-font should work even under windows system
;;fontset;;windows emacs font-face
;;fontset;;share|improve this question
;;fontset;;	
;;fontset;;asked Dec 29 '12 at 8:31
;;fontset;;winterTTr
;;fontset;;958311
;;fontset;;	
;;fontset;;1 Answer
;;fontset;;active oldest votes
;;fontset;;up vote 0 down vote accepted
;;fontset;;	
;;fontset;;
;;fontset;;As long as you just want to set the default font and a different font for two specific characters, the following works for me:
;;fontset;;
;;fontset;;(set-face-attribute 'default nil :family "Consolas")
;;fontset;;(set-fontset-font "fontset-default" '(#x6d4b . #x6d4c)
;;fontset;;                  "Microsoft YaHei" nil 'prepend)
;;fontset;;
;;fontset;;(prepend is unnecessary with Consolas, but may help with your font).
;;fontset;;share|improve this answer
;;fontset;;	
;;fontset;;answered Dec 29 '12 at 23:07
;;fontset;;Dmitry
;;fontset;;1,7251913
;;fontset;;	
;;fontset;;	
;;fontset;;Could you explain why I need to set the fontset-default, instead of my own fontset-Consolas? – winterTTr Dec 30 '12 at 10:57
;;fontset;;	
;;fontset;;No idea, I just adapted a snippet from my own config. – Dmitry Dec 30 '12 at 12:53
;;fontset;;	
;;fontset;;Emacs' mailing lists may be a better place to ask questions like this. – Dmitry Dec 30 '12 at 12:54
;;fontset;;	
;;fontset;;Got it, thanks for your help. – winterTTr Dec 30 '12 at 13:35
;;fontset;;Your Answer
;;fontset;;
;;fontset;; 
;;fontset;;Sign up or login
;;fontset;;
;;fontset;;Sign up using Google
;;fontset;;
;;fontset;;Sign up using Facebook
;;fontset;;
;;fontset;;Sign up using Stack Exchange
;;fontset;;Post as a guest
;;fontset;;Name
;;fontset;;Email
;;fontset;;
;;fontset;;By posting your answer, you agree to the privacy policy and terms of service.
;;fontset;;Not the answer you're looking for? Browse other questions tagged windows emacs font-face or ask your own question.
;;fontset;;
;;fontset;;tagged
;;fontset;;windows × 52374
;;fontset;;emacs × 8520
;;fontset;;font-face × 1561
;;fontset;;
;;fontset;;asked
;;fontset;;	
;;fontset;;
;;fontset;;7 months ago
;;fontset;;
;;fontset;;viewed
;;fontset;;	
;;fontset;;
;;fontset;;177 times
;;fontset;;
;;fontset;;active
;;fontset;;	
;;fontset;;
;;fontset;;7 months ago
;;fontset;;
;;fontset;;    Front End Developer
;;fontset;;    NobleHour Portland, OR / remote
;;fontset;;    Sr. Software Development Engineer
;;fontset;;    Amazon Seattle, WA / relocation
;;fontset;;    Django developer for dynamic London digital agency
;;fontset;;    U-Dox London, United Kingdom
;;fontset;;
;;fontset;;Related
;;fontset;;63
;;fontset;;Emacs in Windows
;;fontset;;139
;;fontset;;How to set the font size in Emacs?
;;fontset;;13
;;fontset;;Emacs under Windows and PNG files
;;fontset;;1
;;fontset;;Copy emacs font settings to another computer
;;fontset;;3
;;fontset;;Setting emacs font under windows
;;fontset;;4
;;fontset;;Emacs: Font setup for displaying unicode characters in OSX
;;fontset;;1
;;fontset;;Emacs change font face in LaTeX mode
;;fontset;;1
;;fontset;;Is it possible to set font per mode/buffer and per charset in Emacs?
;;fontset;;1
;;fontset;;Why does @font-face render weird in Windows?
;;fontset;;2
;;fontset;;Windows 8 + Emacs 24.3 + emacs-for-python: Pymacs helper did not start within 30 seconds
;;fontset;;question feed
;;fontset;;about help badges blog chat data legal privacy policy jobs advertising info mobile contact us feedback
;;fontset;;Technology 	Life / Arts 	Culture / Recreation 	Science 	Other
;;fontset;;
;;fontset;;    Stack Overflow
;;fontset;;    Server Fault
;;fontset;;    Super User
;;fontset;;    Web Applications
;;fontset;;    Ask Ubuntu
;;fontset;;    Webmasters
;;fontset;;    Game Development
;;fontset;;    TeX - LaTeX
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Programmers
;;fontset;;    Unix & Linux
;;fontset;;    Ask Different (Apple)
;;fontset;;    WordPress Answers
;;fontset;;    Geographic Information Systems
;;fontset;;    Electrical Engineering
;;fontset;;    Android Enthusiasts
;;fontset;;    IT Security
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Database Administrators
;;fontset;;    Drupal Answers
;;fontset;;    SharePoint
;;fontset;;    User Experience
;;fontset;;    Mathematica
;;fontset;;    more (13)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Photography
;;fontset;;    Science Fiction & Fantasy
;;fontset;;    Seasoned Advice (cooking)
;;fontset;;    Home Improvement
;;fontset;;    more (13)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    English Language & Usage
;;fontset;;    Skeptics
;;fontset;;    Mi Yodeya (Judaism)
;;fontset;;    Travel
;;fontset;;    Christianity
;;fontset;;    Arqade (gaming)
;;fontset;;    Bicycles
;;fontset;;    Role-playing Games
;;fontset;;    more (21)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Mathematics
;;fontset;;    Cross Validated (stats)
;;fontset;;    Theoretical Computer Science
;;fontset;;    Physics
;;fontset;;    MathOverflow
;;fontset;;    more (7)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Stack Apps
;;fontset;;    Meta Stack Overflow
;;fontset;;    Area 51
;;fontset;;    Stack Overflow Careers
;;fontset;;
;;fontset;;site design / logo © 2013 stack exchange inc; user contributions licensed under cc-wiki with attribution required
;;fontset;;rev 2013.8.21.964
;;fontset;;
;;fontset;;;;; http://stackoverflow.com/questions/7176276/what-is-script-name-symbol-means-for-emacs-set-fontset-font-function
;;fontset;;
;;fontset;;Stack Exchange
;;fontset;;sign up log in careers 2.0
;;fontset;;
;;fontset;;Stack Overflow
;;fontset;;
;;fontset;;    Questions
;;fontset;;    Tags
;;fontset;;    Tour
;;fontset;;    Users
;;fontset;;
;;fontset;;    Ask Question
;;fontset;;
;;fontset;;Tell me more ×
;;fontset;;Stack Overflow is a question and answer site for professional and enthusiast programmers. It's 100% free, no registration required.
;;fontset;;what is “script name symbol” means for emacs set-fontset-font function?
;;fontset;;up vote 3 down vote favorite
;;fontset;;1
;;fontset;;	
;;fontset;;
;;fontset;;When I read the documentation about set-fontset-font, I found there is a sentence like below:
;;fontset;;
;;fontset;;    (set-fontset-font NAME TARGET FONT-SPEC &optional FRAME ADD)
;;fontset;;
;;fontset;;    Modify fontset NAME to use FONT-SPEC for TARGET characters.
;;fontset;;    ...
;;fontset;;    TARGET may be a script name symbol. In that case, use FONT-SPEC for all characters that belong to the script.
;;fontset;;    TARGET may be a charset. In that case, use FONT-SPEC for all characters in the charset.
;;fontset;;    ...
;;fontset;;
;;fontset;;But I cannot find any more information about what the "script name symbol" is?
;;fontset;;I search via google to find some example that uses 'kan 'ascii 'kana. But I don't find any detail information about what it exactly is? Is there a way to list all the possible value?
;;fontset;;
;;fontset;;BTW,
;;fontset;;Is there a way to list all the possible value of "charset" that is available to set-fontset-font?
;;fontset;;emacs configuration fonts elisp emacs23
;;fontset;;share|improve this question
;;fontset;;	
;;fontset;;asked Aug 24 '11 at 13:31
;;fontset;;winterTTr
;;fontset;;958311
;;fontset;;	
;;fontset;;2 Answers
;;fontset;;active oldest votes
;;fontset;;up vote 1 down vote accepted
;;fontset;;	
;;fontset;;
;;fontset;;M-:(char-table-extra-slot char-script-table 0) gives
;;fontset;;
;;fontset;;'(latin phonetic greek coptic cyrillic armenian hebrew arabic
;;fontset;;  syriac nko thaana devanagari bengali gurmukhi gujarati oriya
;;fontset;;  tamil telugu kannada malayalam sinhala thai lao tibetan burmese
;;fontset;;  georgian hangul ethiopic cherokee canadian-aboriginal ogham runic
;;fontset;;  khmer mongolian symbol braille han ideographic-description
;;fontset;;  cjk-misc kana bopomofo kanbun yi cham tai-viet linear-b
;;fontset;;  aegean-number ancient-greek-number ancient-symbol phaistos-disc
;;fontset;;  lycian carian olt-italic ugaritic old-persian deseret shavian
;;fontset;;  osmanya cypriot-syllabary phoenician lydian kharoshthi cuneiform
;;fontset;;  cuneiform-numbers-and-punctuation byzantine-musical-symbol
;;fontset;;  musical-symbol ancient-greek-musical-notation
;;fontset;;  tai-xuan-jing-symbol counting-rod-numeral mathematical
;;fontset;;  mahjong-tile domino-tile)
;;fontset;;
;;fontset;;For character sets, try M-xlist-character-sets.
;;fontset;;share|improve this answer
;;fontset;;	
;;fontset;;answered Aug 24 '11 at 16:17
;;fontset;;huaiyuan
;;fontset;;14.6k41837
;;fontset;;	
;;fontset;;	
;;fontset;;That's Cool! And I have to said "HOW YOU KNOW THAT!" :D – winterTTr Aug 24 '11 at 23:56
;;fontset;;	
;;fontset;;Source diving. :] – huaiyuan Aug 25 '11 at 20:36
;;fontset;;up vote 3 down vote
;;fontset;;	
;;fontset;;
;;fontset;;A "script name symbol" is a means to associate a lisp symbol with a particular charset, a set of charsets, or a range of characters. So, for example, if you look at the value of the variable "charset-script-alist", you will see an Alist of charsets vs the corresponding most appropriate script name symbols. If you look at the value of the variable "script-representative-chars", you will see an Alist of script name symbols vs the representative characters. The variable "char-script-table" shows the full mapping of characters to script name symbols (as specified by "script-representative-chars"). I don't know of any "definitive" list of script names (for example, "ascii" is a script name as well but isn't contained in these 2 variables); however, the values that are contained in the variables "charset-script-alist" and "char-script-table" are probably most of them.
;;fontset;;
;;fontset;;To get a list of all the possible values of "charset" that is available to set-fontset-font, use the "list-character-sets" function. You can also use the "list-charset-chars" function to see the list of characters contained in a specific charset.
;;fontset;;share|improve this answer
;;fontset;;	
;;fontset;;edited Aug 24 '11 at 17:36
;;fontset;;
;;fontset;;	
;;fontset;;answered Aug 24 '11 at 17:00
;;fontset;;zev
;;fontset;;2,20246
;;fontset;;	
;;fontset;;	
;;fontset;;You answer is also great! Thanks for the detail explanation. – winterTTr Aug 24 '11 at 23:55
;;fontset;;Your Answer
;;fontset;;
;;fontset;; 
;;fontset;;Sign up or login
;;fontset;;
;;fontset;;Sign up using Google
;;fontset;;
;;fontset;;Sign up using Facebook
;;fontset;;
;;fontset;;Sign up using Stack Exchange
;;fontset;;Post as a guest
;;fontset;;Name
;;fontset;;Email
;;fontset;;
;;fontset;;By posting your answer, you agree to the privacy policy and terms of service.
;;fontset;;Not the answer you're looking for? Browse other questions tagged emacs configuration fonts elisp emacs23 or ask your own question.
;;fontset;;
;;fontset;;tagged
;;fontset;;emacs × 8520
;;fontset;;configuration × 6944
;;fontset;;fonts × 6079
;;fontset;;elisp × 1976
;;fontset;;emacs23 × 217
;;fontset;;
;;fontset;;asked
;;fontset;;	
;;fontset;;
;;fontset;;1 year ago
;;fontset;;
;;fontset;;viewed
;;fontset;;	
;;fontset;;
;;fontset;;312 times
;;fontset;;
;;fontset;;active
;;fontset;;	
;;fontset;;
;;fontset;;1 year ago
;;fontset;;
;;fontset;;    Application Support Engineer - MySQL, Complex Enterprise…
;;fontset;;    CognoLink London, United Kingdom
;;fontset;;    Senior or Tech Lead Java Developers
;;fontset;;    Intertec International San Jose, Costa Rica /…
;;fontset;;    Manager, Software Engineering
;;fontset;;    ClearSlide San Francisco, CA / relocation
;;fontset;;
;;fontset;;Related
;;fontset;;1
;;fontset;;Antialiased fonts in emacs 23.2 on Windows
;;fontset;;0
;;fontset;;Can't seem to get rid of Ctrl-x Ctrl-z Key Binding in Emacs for minimizing window ('suspend-frame)
;;fontset;;2
;;fontset;;Emacs - set mark on edit location
;;fontset;;4
;;fontset;;Emacs 23.3 lost all fonts
;;fontset;;1
;;fontset;;Add/edit functions of Emacs Editor
;;fontset;;1
;;fontset;;set the window size of emacs on Window 7
;;fontset;;1
;;fontset;;setting font size and highlighting comments in emacs
;;fontset;;1
;;fontset;;Is it possible to set font per mode/buffer and per charset in Emacs?
;;fontset;;0
;;fontset;;Using a list of fonts with a daemonized Emacs
;;fontset;;0
;;fontset;;How do I select a specific font for display for a particular set of Unicode codepoints in Emacs?
;;fontset;;question feed
;;fontset;;about help badges blog chat data legal privacy policy jobs advertising info mobile contact us feedback
;;fontset;;Technology 	Life / Arts 	Culture / Recreation 	Science 	Other
;;fontset;;
;;fontset;;    Stack Overflow
;;fontset;;    Server Fault
;;fontset;;    Super User
;;fontset;;    Web Applications
;;fontset;;    Ask Ubuntu
;;fontset;;    Webmasters
;;fontset;;    Game Development
;;fontset;;    TeX - LaTeX
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Programmers
;;fontset;;    Unix & Linux
;;fontset;;    Ask Different (Apple)
;;fontset;;    WordPress Answers
;;fontset;;    Geographic Information Systems
;;fontset;;    Electrical Engineering
;;fontset;;    Android Enthusiasts
;;fontset;;    IT Security
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Database Administrators
;;fontset;;    Drupal Answers
;;fontset;;    SharePoint
;;fontset;;    User Experience
;;fontset;;    Mathematica
;;fontset;;    more (13)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Photography
;;fontset;;    Science Fiction & Fantasy
;;fontset;;    Seasoned Advice (cooking)
;;fontset;;    Home Improvement
;;fontset;;    more (13)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    English Language & Usage
;;fontset;;    Skeptics
;;fontset;;    Mi Yodeya (Judaism)
;;fontset;;    Travel
;;fontset;;    Christianity
;;fontset;;    Arqade (gaming)
;;fontset;;    Bicycles
;;fontset;;    Role-playing Games
;;fontset;;    more (21)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Mathematics
;;fontset;;    Cross Validated (stats)
;;fontset;;    Theoretical Computer Science
;;fontset;;    Physics
;;fontset;;    MathOverflow
;;fontset;;    more (7)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Stack Apps
;;fontset;;    Meta Stack Overflow
;;fontset;;    Area 51
;;fontset;;    Stack Overflow Careers
;;fontset;;
;;fontset;;site design / logo © 2013 stack exchange inc; user contributions licensed under cc-wiki with attribution required
;;fontset;;rev 2013.8.21.964
;;fontset;;
;;fontset;;;;; http://stackoverflow.com/questions/14090375/how-does-fontset-work-in-emacs
;;fontset;;
;;fontset;;Stack Exchange
;;fontset;;sign up log in careers 2.0
;;fontset;;
;;fontset;;Stack Overflow
;;fontset;;
;;fontset;;    Questions
;;fontset;;    Tags
;;fontset;;    Tour
;;fontset;;    Users
;;fontset;;
;;fontset;;    Ask Question
;;fontset;;
;;fontset;;Tell me more ×
;;fontset;;Stack Overflow is a question and answer site for professional and enthusiast programmers. It's 100% free, no registration required.
;;fontset;;How does fontset work in emacs?
;;fontset;;up vote 2 down vote favorite
;;fontset;;	
;;fontset;;
;;fontset;;I read some documentation about font configuration in Emacs, I found two concept, which areFONT and FONTSET. Currently, my understanding is that, fontset is a set of font which are grouped by the script( aka encoding ), and we can create a fontset and specify some set of chars to use specific font.
;;fontset;;
;;fontset;;But until now, some experiments code does not always work as I wish, so I want to find what's the problem is?
;;fontset;;
;;fontset;;First, I create my own fontset
;;fontset;;
;;fontset;;(create-fontset-from-fontset-spec
;;fontset;; "-outline-Cousine-normal-normal-normal-*-*-*-*-*-*-*-fontset-Consolas")
;;fontset;;
;;fontset;;Then I want to use it as current emacs fontset( or is this possible? I am not sure), the following code seems works:
;;fontset;;
;;fontset;;(set-frame-font "fontset-Consolas" nil t)
;;fontset;;
;;fontset;;Then I try to customize my fontset for some specific character or encoding:
;;fontset;;
;;fontset;;(set-fontset-font "fontset-Consolas" 'han "Microsoft YaHei" nil 'prepend)
;;fontset;;
;;fontset;;However, it's pity that this does not work, and the char in 'han category do not change its font. Then I got some sample code and try the following one:
;;fontset;;
;;fontset;;(set-fontset-font "fontset-Default" 'han "Microsoft YaHei" nil 'prepend)
;;fontset;;
;;fontset;;This time, it works, the char in 'han category use the correct font. But why i need to change fontset-default instead of my fontset-consolas. Then I try to revert my change, with following code:
;;fontset;;
;;fontset;;(set-fontset-font "fontset-Default" 'han "Consolas" nil 'prepend)
;;fontset;;
;;fontset;;However, the 'han category char remains the same, which I expect these char should not display correctly, as I use a font does not contains those char. Why does changing fontset-default not work this time?
;;fontset;;
;;fontset;;Besides the code above, some more universal question:
;;fontset;;
;;fontset;;    How to change the emacs default fontset to my own one, is it possible?
;;fontset;;    Is multi fontset works at the same time or only one fontset work? Why my test code need to change default instead of mine?
;;fontset;;    The set-fontset-font second parameter is target, how can I know which script name is suitable for the char under current cursor. I can use describe-char to display the char information, but I don't find which word in this description is the correct one for that target param.
;;fontset;;    Some points worthy of notice for font configuration in emacs?
;;fontset;;
;;fontset;;My question is kind of lengthy, so thanks for your patient and share your suggestion.
;;fontset;;emacs character-encoding fonts
;;fontset;;share|improve this question
;;fontset;;	
;;fontset;;asked Dec 30 '12 at 11:35
;;fontset;;winterTTr
;;fontset;;958311
;;fontset;;	
;;fontset;;	
;;fontset;;This is a good question, but apparently very few people are familiar with Emacs fontsets. That your customization of fontset-Consolas does not have effect might be the result of an Emacs bug. I recommend that you mail a reduced variant of the question (only the part pertaining to set-fontset-font apparently not working for user-created fontsets) to bug-gnu-emacs@gnu.org. – user4815162342 Jan 3 at 22:15
;;fontset;;	
;;fontset;;Thanks for you suggestion, I will do that :-) – winterTTr Jan 4 at 14:38
;;fontset;;Know someone who can answer? Share a link to this question via email, Google+, Twitter, or Facebook.
;;fontset;;Your Answer
;;fontset;;
;;fontset;; 
;;fontset;;Sign up or login
;;fontset;;
;;fontset;;Sign up using Google
;;fontset;;
;;fontset;;Sign up using Facebook
;;fontset;;
;;fontset;;Sign up using Stack Exchange
;;fontset;;Post as a guest
;;fontset;;Name
;;fontset;;Email
;;fontset;;
;;fontset;;By posting your answer, you agree to the privacy policy and terms of service.
;;fontset;;Browse other questions tagged emacs character-encoding fonts or ask your own question.
;;fontset;;
;;fontset;;tagged
;;fontset;;emacs × 8520
;;fontset;;fonts × 6079
;;fontset;;character-encoding × 6056
;;fontset;;
;;fontset;;asked
;;fontset;;	
;;fontset;;
;;fontset;;7 months ago
;;fontset;;
;;fontset;;viewed
;;fontset;;	
;;fontset;;
;;fontset;;135 times
;;fontset;;
;;fontset;;    Sr. Web Application Developer
;;fontset;;    Mentor Graphics Portland, OR / relocation
;;fontset;;    Software Development Engineer - Windows EC2
;;fontset;;    Amazon Seattle, WA / relocation
;;fontset;;    Full-Stack Developer
;;fontset;;    BrightBytes San Francisco, CA
;;fontset;;    Build Engineer
;;fontset;;    Wargaming.net Chicago, IL / relocation
;;fontset;;    Senior Software Engineer
;;fontset;;    Tapjoy Atlanta, GA
;;fontset;;    Front End Developer - Analytics
;;fontset;;    Wikimedia Foundation San Francisco, CA / remote
;;fontset;;
;;fontset;;Related
;;fontset;;1
;;fontset;;How can I change fonts of elements between HTML tags in Emacs?
;;fontset;;12
;;fontset;;Which coding system should I use in Emacs?
;;fontset;;1
;;fontset;;Copy emacs font settings to another computer
;;fontset;;4
;;fontset;;Emacs: how to specify where the true-type font is?
;;fontset;;4
;;fontset;;How do I set fonts on Emacs for Mac?
;;fontset;;2
;;fontset;;Emacs buffer-local font
;;fontset;;4
;;fontset;;Emacs font with antialiasing and hinting
;;fontset;;0
;;fontset;;emacs set-fontset-font for specific unicode char under windows
;;fontset;;2
;;fontset;;Emacs `Invalid font name`
;;fontset;;0
;;fontset;;How do I select a specific font for display for a particular set of Unicode codepoints in Emacs?
;;fontset;;question feed
;;fontset;;about help badges blog chat data legal privacy policy jobs advertising info mobile contact us feedback
;;fontset;;Technology 	Life / Arts 	Culture / Recreation 	Science 	Other
;;fontset;;
;;fontset;;    Stack Overflow
;;fontset;;    Server Fault
;;fontset;;    Super User
;;fontset;;    Web Applications
;;fontset;;    Ask Ubuntu
;;fontset;;    Webmasters
;;fontset;;    Game Development
;;fontset;;    TeX - LaTeX
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Programmers
;;fontset;;    Unix & Linux
;;fontset;;    Ask Different (Apple)
;;fontset;;    WordPress Answers
;;fontset;;    Geographic Information Systems
;;fontset;;    Electrical Engineering
;;fontset;;    Android Enthusiasts
;;fontset;;    IT Security
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Database Administrators
;;fontset;;    Drupal Answers
;;fontset;;    SharePoint
;;fontset;;    User Experience
;;fontset;;    Mathematica
;;fontset;;    more (13)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Photography
;;fontset;;    Science Fiction & Fantasy
;;fontset;;    Seasoned Advice (cooking)
;;fontset;;    Home Improvement
;;fontset;;    more (13)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    English Language & Usage
;;fontset;;    Skeptics
;;fontset;;    Mi Yodeya (Judaism)
;;fontset;;    Travel
;;fontset;;    Christianity
;;fontset;;    Arqade (gaming)
;;fontset;;    Bicycles
;;fontset;;    Role-playing Games
;;fontset;;    more (21)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Mathematics
;;fontset;;    Cross Validated (stats)
;;fontset;;    Theoretical Computer Science
;;fontset;;    Physics
;;fontset;;    MathOverflow
;;fontset;;    more (7)
;;fontset;;
;;fontset;;	
;;fontset;;
;;fontset;;    Stack Apps
;;fontset;;    Meta Stack Overflow
;;fontset;;    Area 51
;;fontset;;    Stack Overflow Careers
;;fontset;;
;;fontset;;site design / logo © 2013 stack exchange inc; user contributions licensed under cc-wiki with attribution required
;;fontset;;rev 2013.8.21.964
;;; http://ergoemacs.org/emacs/emacs_list_and_set_font.html

;;     Blog
;;     Emacs Tutorial
;;     Elisp Tutorial
;;     Buy Tutorial

;;     Emacs Modernization
;;     Keyboarding ⌨

;;     Emacs Manual
;;     Elisp Manual

     
;; Emacs Tutorial
;; 中文 git GitCafe.com
;; g700 mouse
;; Best Mouse

;; thank you donors

;; emacs lisp project
;; Emacs Lisp Project pledge
;; Emacs: How to List ＆ Set Font
;; Xah Lee
;; , 2012-10-22

;; This page shows you how to set font for emacs.

;; How to to change font?

;; Chose the menu 〖Options ▸ Set Default Font…〗

;; Then chose 〖Options ▸ Save Options〗.

;; How to list all fonts available to emacs?

;; You can evaluate the following code:

;; (print (font-family-list))

;; (list-fontsets "DejaVu Sans-10")

;; Select the elisp code, then call eval-region. 〔☛ Emacs: How to Evaluate Emacs Lisp Code〕

;; You can see the result in “*Messages*” buffer. view-echo-area-messages 【F1 e】.

;; How to set a font in emacs init file?

;; ;; set font for all windows
;; (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10"))

;; or

;; ;; set font for current window
;; (set-frame-parameter nil 'font "DejaVu Sans Mono-10")

;; How to see all fonts in Linux?

;; In Linux, terminal, you can type fc-list to list available fonts.

;; For a sample output of fc-list, see: linux_ubuntu_default_fonts.txt.

;; How to install a font to emacs?

;; Just install to the OS normally. Restart emacs. Emacs should see it.

;; What's the best font for coding?

;; I recommend DejaVu Sans Mono, because it's the best font and has the best Unicode support. See: Best Unicode Fonts for Programing.

;; See also: How to Quickly Switch Fonts in Emacs.

;; (info "(emacs) Fonts")

;;     Emacs: How to Set a Color Theme
;;     Emacs ＆ Unicode Tips
;;     How to Set Emacs's User Interface to Modern Conventions
;;     Emacs: How to Set a Theme Depending on Mode?

;; ∑ ErgoEmacs
;; © 2006, …, 2013 Xah Lee.
;;deprecated;;  (set-face-font 'default "-outline-DejaVu Sans Mono-normal-normal-normal-mono-12-112-96-96-c-*-iso8859-1") ;;- not clear type
;;deprecated;;  ;;(set-face-font 'default "-outline-Bitstream Vera Sans Mono-*-r-*-*-12-112-96-96-c-*-iso8859-1")
;;deprecated;;  ;;(set-face-font 'default "-outline-Consolas-*-*-*-mono-13-112-96-96-c-*-iso8859-1") ;;- clear type
;;deprecated;;  ;;(set-face-font 'default "-outline-Inconsolata-*-*-*-mono-14-112-96-96-c-*-iso8859-1") ;;- clear type
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'hangul '("돋움체" . "unicode-bmp"))    ;;- no clear type
;;deprecated;;  (set-fontset-font "fontset-default" 'hangul '("맑은 고딕" . "unicode-bmp") ) ;;- clear type
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'hangul '("나눔고딕코딩" . "unicode-bmp"))    ;;- no clear type  
;;deprecated;;  ;; http://ergoemacs.org/emacs/emacs_unicode_fonts.html
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'symbol '("StixGeneral" . "unicode-bmp"))
;;deprecated;;  (set-fontset-font "fontset-default" 'symbol (font-spec :name "StixGeneral" :size 15) )
;;deprecated;;  (set-fontset-font "fontset-default" '(9089 . 9090) (font-spec :name "StixGeneral" :size 15) nil 'prepend)
;;deprecated;;  
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'symbol '("-*-StixGeneral-*-*-*-mono-12-*-*-*-p-*-iso10646-1" . "unicode-bmp"))
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'symbol '("Arial" . "unicode-bmp"))
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'symbol '("unifont" . "unicode-bmp"))
;;deprecated;;
;;deprecated;;
;;deprecated;;
;;deprecated;;  ;;(set-face-font 'default "-outline-Consolas-normal-normal-normal-mono-13-112-96-96-c-*-iso8859-1") ;;- clear type
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'hangul '("맑은 고딕" . "unicode-bmp")) ;;- clear type
;;deprecated;;
;;deprecated;;  ;;(set-face-font 'default "-outline-Anonymous Pro-normal-normal-normal-mono-14-112-96-96-c-*-iso8859-1") ;;-  clear type
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'hangul '("새굴림" . "unicode-bmp"))    ;;- no clear type
;;deprecated;;  ;;(set-fontset-font "fontset-default" 'hangul '("나눔고딕_코딩" . "unicode-bmp")) ;; 
;;deprecated;;
;;deprecated;;;;;(set-fontset-font "fontset-default" '(#x1100 . #xffdc)  '("Malgun Gothic" . "unicode-bmp")) ;;; 유니코드 한글영역
;;deprecated;;;;;(set-fontset-font "fontset-default" '(#xe0bc . #xf66e)  '("New Gulim" . "unicode-bmp")) ;;;유니코드 사용자 영역
;;deprecated;;;;;(set-fontset-font "fontset-default" 'kana '("Meiryo" . "unicode-bmp"))
;;deprecated;;;;;(set-fontset-font "fontset-default" 'han '("Microsoft YaHei" . "unicode-bmp"))
;;deprecated;;
;;deprecated;;  ;;  (create-fontset-from-fontset-spec
;;deprecated;;  ;;   "-*-fixed-medium-r-normal-*-12-*-*-*-c-*-fontset-bdf,
;;deprecated;;  ;; ascii: -outline-Bitstream Vera Sans Mono-*-r-*-*-12-112-96-96-c-*-iso8859-1,
;;deprecated;;  ;; korean-ksc5601: -outline-Batang-*-r-*-*-12-120-96-96-p-*-ksc5601.1987*-*")
;;deprecated;;
;;deprecated;;  ;; 글꼴이 깔끔하네 괜찮음. 
;;deprecated;;  ;;  (create-fontset-from-fontset-spec
;;deprecated;;  ;;   "-*-fixed-medium-r-normal-*-12-*-*-*-c-*-fontset-bdf,
;;deprecated;;  ;; ascii: -outline-Bitstream Vera Sans Mono-*-r-*-*-12-112-96-96-c-*-iso8859-1,
;;deprecated;;  ;; korean-ksc5601: -outline-다음_Regular-*-r-*-*-12-*-96-96-p-*-ksc5601.1987*-*")
;;deprecated;;
;;deprecated;;  ;;  (create-fontset-from-fontset-spec
;;deprecated;;  ;;   "-*-fixed-medium-r-normal-*-12-*-*-*-c-*-fontset-bdf,
;;deprecated;;  ;; ascii: -outline-Bitstream Vera Sans Mono-*-r-*-*-12-112-96-96-c-*-iso8859-1,
;;deprecated;;  ;; korean-ksc5601: -outline-나눔고딕-*-r-*-*-12-*-96-96-p-*-ksc5601.1987*-*")
;;deprecated;;
;;deprecated;;
;;deprecated;;  ;;  (create-fontset-from-fontset-spec
;;deprecated;;  ;;   "-*-fixed-medium-r-normal-*-12-*-*-*-c-*-fontset-bdf,
;;deprecated;;  ;; ascii: -outline-Bitstream Vera Sans Mono-*-r-*-*-13-112-96-96-c-*-iso8859-1,
;;deprecated;;  ;; korean-ksc5601: -outline-은진-*-r-*-*-12-120-96-96-p-*-ksc5601.1987*-*")
;;deprecated;;  ;;-outline-은진-medium-r-normal-normal-*-*-96-96-p-*-ksc5601.1992
;;deprecated;;
;;deprecated;;
;;deprecated;;  ;;  (create-fontset-from-fontset-spec
;;deprecated;;  ;;   "-*-fixed-medium-r-normal-*-12-*-*-*-c-*-fontset-bdf,
;;deprecated;;  ;; ascii: -outline-Bitstream Vera Sans Mono-*-r-*-*-12-112-96-96-c-*-iso8859-1,
;;deprecated;;  ;; korean-ksc5601: -outline-굵은돋움한체-*-r-*-*-14-*-96-96-p-*-ksc5601.1987*-*")
;;deprecated;;
;;deprecated;;  ;;  (create-fontset-from-fontset-spec
;;deprecated;;  ;;   "-*-fixed-medium-r-normal-*-12-*-*-*-c-*-fontset-bdf,
;;deprecated;;  ;; ascii: -outline-Bitstream Vera Sans Mono-*-r-*-*-12-112-96-96-c-*-iso8859-1,
;;deprecated;;  ;; korean-ksc5601: -outline-굵은돋움한체-*-r-*-*-13-*-96-96-p-*-ksc5601.1987*-*")
;;deprecated;;
;;deprecated;;  ;;  (set-face-font 'default "-outline-Bitstream Vera Sans Mono-normal-normal-normal-mono-12-112-96-96-c-*-iso8859-1")
;;deprecated;;  ;;  (set-fontset-font "fontset-default" 'hangul '("다음_Regular" . "unicode-bmp"))

