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
        (set-fontset-font "fontset-default" '(61548 . 61549) (cons defaultfont  "unicode-bmp") ))))



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

;;customize;;(font-lock-add-keywords 'python-mode
;;customize;;  '(("\\btry\\b" . font-lock-keyword-face)
;;customize;;    ("\\bfinally\\b" . font-lock-keyword-face)
;;customize;;    ("\\bwith\\b" . font-lock-keyword-face)
;;customize;;    ("\\bas\\b" . font-lock-keyword-face)
;;customize;;    ))




