;; -*- coding: utf-8; -*-

;;;_ hyper key 
;; hyper super key define
;; setting the PC keyboard's various keys to
;; Super or Hyper, for emacs running on Windows.
;; super 및 hyper 키 사용하기 
(setq w32-pass-lwindow-to-system nil 
      w32-pass-rwindow-to-system nil 
      w32-pass-apps-to-system nil 
      w32-lwindow-modifier nil ;;'super ; Left Windows key 
      w32-rwindow-modifier nil ;;'super ; Right Windows key 
      w32-apps-modifier 'hyper) ; Menu key

(when-os 'windows-nt (global-set-key [rwindow] 'helm-smex))

;;hyper super define;;(global-set-key (kbd "H-b") 'backward-word) ; H is for hyper
;;hyper super define;;(global-set-key (kbd "s-b") 'backward-word) ; lower case “s” is for super
;;hyper super define;;(global-set-key (kbd "M-H-b") 'backward-word) ; Meta+Hyper+b
;;hyper super define;;(global-set-key (kbd "M-s-b") 'backward-word) ; Meta+Super+b
;;hyper super define;;
;;hyper super define;;;; type parens in pairs with Hyper and right hands's home-row
;;hyper super define;;(global-set-key (kbd "H-j") (lambda () (interactive) (insert "{}") (backward-char 1)))
;;hyper super define;;(global-set-key (kbd "H-k") (lambda () (interactive) (insert "()") (backward-char 1)))
;;hyper super define;;(global-set-key (kbd "H-l") (lambda () (interactive) (insert "[]") (backward-char 1)))


;;;_ esdf-mode

;;I use this hack to let me use my left hand more often, which in turn
;;lightens the load on my right hand. I started with the more common
;;“wasd” but I quickly noticed that “esdf” is much more convenient
;;from the home position.  

(defun esdf-pre-command-hook ()
  "This hook turns OFF `esdf-mode` if you hit
      \(i\) ENTER or
     \(ii\) BACKSPACE or,
    \(iii\) an ASCII character other than esdf (case-insensitive)."
  (let ((k (elt (this-command-keys-vector) 0)))
    (when (or (memq k '(13 backspace))
     	      (and (numberp k) (>= k 32) (<= k 126)
                   (not (memq k '(?e ?E ?s ?S ?d ?D ?f ?F)))))
      (esdf-mode 0))))

(define-minor-mode esdf-mode
  "If enabled, esdf will behave exactly like the arrow keys in an inverted-T."
  :global t
  :init-value nil
  :lighter " esdf "
  :keymap '(([4] . (lambda () (interactive) (esdf-mode 0)))
     	    ("e" . [up]) ("E" . [S-up])
     	    ("s" . [left]) ("S" . [S-left])
     	    ("d" . [down]) ("D" . [S-down])
     	    ("f" . [right]) ("F" . [S-right]))
  (if esdf-mode (add-hook 'pre-command-hook 'esdf-pre-command-hook)
    (remove-hook 'pre-command-hook 'esdf-pre-command-hook))
  (message "esdf-mode turned %s" (if esdf-mode "ON" "OFF")))

;;I use the following bindings to start this minor mode. Mouse-3 is
;;the right mouse button on my laptop and it sits right under the
;;space-bar. 

;;(global-set-key [mouse-3] 'esdf-mode)
;;(global-set-key [escape ?e] (lambda () (interactive) (esdf-mode) (previous-line)))
;;(global-set-key [escape ?s] (lambda () (interactive) (esdf-mode) (backward-char)))
;;(global-set-key [escape ?d] (lambda () (interactive) (esdf-mode) (next-line)))
;;(global-set-key [escape ?f] (lambda () (interactive) (esdf-mode) (forward-char)))

;;Tested on Emacs 23.2 on Windows.
;;
;;P.S. In practice I bind the unshifted keys in the keymap to actual
;;functions like previous-line and next-line so that Accelerate can
;;pick them up. 





;;;_ fold-dwim
(require 'fold-dwim)
;; more …
;;deprecated;;(define-prefix-command 'xah-numpad-keymap)
;;deprecated;;(global-set-key (kbd "<kp-home>") 'xah-numpad-keymap)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-home>")      'ibuffer)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-up>")        'bookmark-bmenu-list)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-divide>")    'recentf-open-files)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-multiply>")  'recentf-open-most-recent-file)
;;deprecated;;
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-end>")    'keyboard-escape-quit)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-add>")      'kill-ring-save)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-enter>")    'yank)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-delete>")   'kill-buffer)
;;deprecated;;
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-left>")  'fold-dwim-hide-all)
;;deprecated;;;;(global-set-key (kbd "<kp-home> <kp-space>") 'fold-dwim-toggle)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-space>") 'kmacro-end-and-call-macro)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-right>") 'fold-dwim-show-all)
;;deprecated;;
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-down>") 'win-switch-dispatch)
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-subtract>") 'kill-line)
;;deprecated;;
;;deprecated;;(global-set-key (kbd "<kp-home> <kp-insert>") 'projectile-switch-to-buffer)
;;deprecated;;

;;DEPRECATEDBY-WINSWITH//(global-set-key [M-up] '(lambda ( arg ) (interactive "p" ) ( other-window (* -1 arg) t )))
;;DEPRECATEDBY-WINSWITH//(global-set-key [M-down] 'other-window)



;; http://www.emacswiki.org/emacs/WinSwitch

;;(require 'windcycle)
;;windcycle;;(global-set-key (kbd "C-x x") 'delete-other-windows)
;;windcycle;;(global-set-key (kbd "C-x c") 'delete-window)



(use-package win-switch
  :config 
  (defun win-switch-setup-keys-hjkl (&rest dispatch-keys)
    "Restore default key commands and bind global dispatch keys.
Under this setup, keys i, j, k, and l will switch windows,
respectively, up, left, down, and right, with other functionality
bound to nearby keys. The arguments DISPATCH-KEYS, if non-nil,
should be a list of keys that will be bound globally to
`win-switch-dispatch'."
    (interactive)
    (win-switch-set-keys '("h") 'left)
    (win-switch-set-keys '("k") 'up)
    (win-switch-set-keys '("j") 'down)
    (win-switch-set-keys '("l") 'right)
    (win-switch-set-keys '("o") 'next-window)
    (win-switch-set-keys '("p") 'previous-window)
    (win-switch-set-keys '("J") 'shrink-vertically)
    (win-switch-set-keys '("K") 'enlarge-vertically)
    (win-switch-set-keys '("H") 'shrink-horizontally)
    (win-switch-set-keys '("L") 'enlarge-horizontally)
    (win-switch-set-keys '(" ") 'other-frame)
    (win-switch-set-keys '("u" [return]) 'exit)
    (win-switch-set-keys '(";") 'split-horizontally)
    (win-switch-set-keys '("i") 'split-vertically) ; visual not letter mnemonic
    (win-switch-set-keys '("0") 'delete-window)
    (win-switch-set-keys '("\M-\C-g") 'emergency-exit)
    (dolist (key dispatch-keys)
      (global-set-key key 'win-switch-dispatch)))

;;;###autoload
  (defun win-switch-setup-keys-hjkl-minimal (&rest dispatch-keys)
    "Restore default key commands and bind global dispatch keys.
Split and delete keys are excluded from the map for simplicity.
Under this setup, keys i, j, k, and l will switch windows,
respectively, up, left, down, and right, with other functionality
bound to nearby keys. The arguments DISPATCH-KEYS, if non-nil,
should be a list of keys that will be bound globally to
`win-switch-dispatch'."
    (interactive)
    (apply 'win-switch-setup-keys-hjkl dispatch-keys)
    (win-switch-remove-split-and-delete-keys))


  ;;(global-set-key "\C-xo" 'win-switch-dispatch)

  (win-switch-setup-keys-hjkl  "\C-xo" (kbd "H-o") ))

(global-set-key (kbd "C-x x") 'delete-other-windows)
(global-set-key (kbd "C-x c") 'delete-window)

(global-set-key [(control meta ?y)]     'secondary-dwim)

;;eprecatedbyevil##(global-set-key [M-up]   'win-switch-up)
;;eprecatedbyevil##(global-set-key [M-down] 'win-switch-down)
;;eprecatedbyevil##(global-set-key [M-left] 'win-switch-left)
;;eprecatedbyevil##(global-set-key [M-right] 'win-switch-right)
;;eprecatedbyevil##(global-set-key [H-down] 'win-switch-down)
;;eprecatedbyevil##(global-set-key [H-up] 'win-switch-up)

;;(global-set-key (kbd "C-c <left>")  'windmove-left)
;;(global-set-key (kbd "C-c <right>") 'windmove-right)
;;(global-set-key (kbd "C-c <up>")    'windmove-up)
;;(global-set-key (kbd "C-c <down>")  'windmove-down)

;;(windmove-default-keybindings)
;;(win-switch-setup-keys-arrow-meta)
;;(global-set-key (vector (list 'shift 'left))  'delete-window)
;;(global-set-key (vector (list 'shift 'right)) 'delete-other-windows)
;;(global-set-key (vector (list 'shift 'up))   
;;                #'(lambda ()
;;                    (interactive)
;;                    (append-next-kill)
;;                    (if mark-active
;;                        (kill-ring-save (region-beginning) (region-end))
;;                      (progn
;;                        (message "Current line is copied.")
;;                        (kill-ring-save (line-beginning-position) (line-beginning-position 2)) ) )))
;;
;;(global-set-key (vector (list 'shift 'down))   
;;                #'(lambda ()
;;                    (interactive)
;;                    (append-next-kill)
;;                    (if mark-active
;;                        (kill-ring-save (region-beginning) (region-end))
;;                      (progn
;;                        (message "Current line is copied.")
;;                        (kill-ring-save (line-beginning-position) (line-beginning-position 2)) ) )))
;;
;;
;;;;;
;;;; Move to beginning of word before yanking word in isearch-mode.
;;;; Make C-s C-w and C-r C-w act like Vim's g* and g#, keeping Emacs'
;;;; C-s C-w [C-w] [C-w]... behaviour.


;; USE MOUSE
;; ;; set the “forward button” (5th button) to close.
;; (cond
;;  ((string-equal system-type "windows-nt") ; Windows
;;   (global-set-key (kbd "<mouse-5>") 'ergoemacs-close-current-buffer)
;;   (global-set-key (kbd "<mouse-4>") 'describe-char)
;;   )
;;  ((string-equal system-type "gnu/linux")
;;   (global-set-key (kbd "<mouse-9>") 'ergoemacs-close-current-buffer)
;;   )
;;  ((string-equal system-type "darwin") ; Mac
;;   (global-set-key (kbd "<mouse-5>") 'ergoemacs-close-current-buffer) ) )
;; 
;; (global-set-key (kbd "<M-wheel-up>") 'ergoemacs-previous-user-buffer)
;; (global-set-key (kbd "<M-wheel-down>") 'ergoemacs-next-user-buffer)

;; Local Variables:
;; mode: allout-minor
;; End:

(global-set-key (kbd "s-h")  'previous-user-buffer)
(global-set-key (kbd "s-H")  'next-user-buffer)

;;(global-set-key (kbd "C-<")  'previous-user-buffer)
;;(global-set-key (kbd "C->")  'next-user-buffer)
(global-set-key (kbd "C-<")  'beginning-of-buffer)
(global-set-key (kbd "C->")  'end-of-buffer)

;; make cursor movement keys under right hand's home-row.
(global-set-key (kbd "H-h") 'backward-char) ; was indent-new-comment-line
(global-set-key (kbd "H-l") 'forward-char)  ; was downcase-word
(global-set-key (kbd "H-k") 'previous-line) ; was tab-to-tab-stop
(global-set-key (kbd "H-j") 'next-line) ; was kill-sentence

(global-set-key (kbd "H-u") 'universal-argument)

(define-key universal-argument-map (kbd "H-u") 'universal-argument-more)

(global-set-key (kbd "M-SPC") 'set-mark-command) ; was just-one-space
(global-set-key (kbd "M-a")   'execute-extended-command) ; was backward-sentence
(global-set-key (kbd "H-M-k") 'backward-sentence) ; was backward-sentence
(global-set-key (kbd "H-M-j") 'forward-sentence) ; was backward-sentence

(require 'ibuffer)
(global-set-key (kbd "H-i") 'ibuffer) 
(define-key ibuffer-mode-map (kbd "H-m") 'ibuffer-visit-buffer)

(global-set-key (kbd "H-SPC") 'set-mark-command) 
(global-set-key (kbd "H-w")   'kill-ring-save) 
(global-set-key (kbd "H-q")   'yank) 
(global-set-key (kbd "H-a")   'move-beginning-of-line) 
(global-set-key (kbd "H-v")   'yank) 


(global-set-key (kbd "C-H-h") 'backward-sexp) ; was backward-sentence
(global-set-key (kbd "C-H-l") 'forward-sexp) ; was backward-sentence
(global-set-key (kbd "C-H-j") 'forward-paragraph) ; was backward-sentence
(global-set-key (kbd "C-H-k") 'backward-paragraph) ; was backward-sentence


(global-set-key (kbd "H-1") 'delete-other-windows) ; was backward-sentence
(global-set-key (kbd "H-2") 'split-window-below) ; was backward-sentence
(global-set-key (kbd "H-3") 'split-window-right) ; was backward-sentence

(define-key dired-mode-map (kbd "H-m") 'diredp-find-file-reuse-dir-buffer)

;;; directory 
(define-key minibuffer-local-map (kbd "H-j") 'next-history-element)
(define-key minibuffer-local-map (kbd "H-k") 'previous-history-element)
(define-key minibuffer-local-map (kbd "H-m") 'exit-minibuffer)

(define-key dired-mode-map (kbd "H-m") 'diredp-find-file-reuse-dir-buffer)


;;;
;;;
;;;  ※ 키보드 셋팅 
;;;
;;;
(global-set-key (kbd "H-g") 'keyboard-escape-quit)
(global-set-key (kbd "H-y") 'yank)
(global-set-key (kbd "H-z") 'keyboard-quit)
(global-set-key "\C-z" 'set-mark-command)
(global-set-key ( kbd "C-H-w") 'kill-ring-save)
(global-set-key ( kbd "H-e") 'move-end-of-line)
(global-set-key ( kbd "H-x") 'smex)
(global-set-key ( kbd "C-H-x") 'smex)
(global-set-key ( kbd "H-s") 'save-buffer)
(global-set-key ( kbd "H-c") 'kill-ring-save)
(global-set-key ( kbd "H-v") 'yank)
(global-set-key ( kbd "H-f") 'ibuffer)
(global-set-key ( kbd "H-/") 'undo)
(global-set-key ( kbd "H-d") 'dired)
(global-set-key ( kbd "H-;") 'smex)
(global-set-key (kbd "H-n") 'forward-paragraph) 
(global-set-key (kbd "H-p") 'backward-paragraph) 
(global-set-key [f12] 'ibuffer)
;; (global-set-key (kbd "C-z") 'ibuffer)
;deprecated;;(global-set-key ( kbd "H-m") 'smex)
;;(define-key function-key-map (vector ?\H-m) (vector 'return))
;;(global-set-key (kbd "H-m") 'newline) ; was kill-sentence
(define-key function-key-map (kbd  "H-m") "\C-m")

;;deprecated;;(global-set-key [H-left] 'previous-buffer)
;;deprecated;;(global-set-key [H-right] 'next-buffer)

;; (global-set-key [H-right] 'iflipb-next-buffer)
;; (global-set-key [H-left] 'iflipb-previous-buffer)
;; (require 'cycle-buffer)
;; (global-set-key [H-right] 'cycle-buffer)
;; (global-set-key [H-left]  'cycle-buffer-backward)
;;deprecated;;(require 'swbuff)
;;deprecated;;(global-set-key [H-right] 'swbuff-switch-to-next-buffer)
;;deprecated;;(global-set-key [H-left]  'swbuff-switch-to-previous-buffer)
(global-set-key [H-up] 'bs-cycle-previous)
(global-set-key [H-down]  'bs-cycle-next)
(global-set-key [H-right] 'forward-sexp)
(global-set-key [H-left]  'backward-sexp)
(global-set-key (kbd "<C-tab>") 'set-mark-command)



(global-set-key [(mouse-4)] 
		'(aif (scroll-down 3)))
(global-set-key [(mouse-5)] 
		'(aif (scroll-up 3)))
(global-set-key "\M-#" 
		'( lambda (arg) 
		   (interactive "p" ) 
		   (mark-word arg) 
		   (exchange-point-and-mark)))
(global-set-key "\C-cd" 'insert-date )
(global-set-key [f6] 'ff-find-other-file )
(global-set-key [f7] 'isearch-forward-regexp ) 
(global-set-key [f8] 'isearch-backward-regexp )
(global-set-key [S-f7] 'isearch-forward )
(global-set-key [S-f8] 'isearch-backward ) 
(define-key isearch-mode-map [f7] 'isearch-repeat-forward ) 
(define-key isearch-mode-map [f8] 'isearch-repeat-backward )
(global-set-key [f5] 'repeat )
;;VERY LITTILE USED;;(global-set-key [f11] 'cscope-find-global-definition )
;;VERY LITTILE USED;;(global-set-key [f12] 'cscope-pop-mark ) 
(global-set-key (kbd "<M-return>") 'imenu )




(defun endless/isearch-symbol-with-prefix (p)
  "Like isearch, unless prefix argument is provided.
With a prefix argument P, isearch for the symbol at point."
  (interactive "P")
  (let ((current-prefix-arg nil))
    (call-interactively
     (if p #'isearch-forward-symbol-at-point
       #'isearch-forward))))

(global-set-key [remap isearch-forward]
                #'endless/isearch-symbol-with-prefix)


(global-set-key [remap toggle-input-method]
                #'toggle-korean-input-method)


(global-set-key [C-M-down] 'set-mark-command)

(w32-unix-eval
 ;; 윈도우 시스템의 경우
 ;; emacs 에서 FIND 가능
 (
  (global-set-key "\M-]"  'forward-page )
  (global-set-key "\M-["  'backward-page )

  )
 ())
(global-set-key [C-M-return] 'goto-line) 
(global-set-key [C-return] 'dabbrev-expand )
(define-key ctl-x-map "\C-z" 'keyboard-escape-quit)
(define-key ctl-x-map [down] 
  '(lambda() 
     ( interactive) 
     ( kill-ring-save 
       ( point ) 
       ( cond 
	 ( ( < (point-max ) ( + 1 (point-at-eol ) )  ) (point-at-eol) ) 
	 ( t (+ 1 (point-at-eol )))))))
(global-set-key [C-kp-add] '(lambda() ( interactive ) (next-error) (recenter) ))
(global-set-key [C-kp-subtract] 'previous-error )

(global-set-key [C-right] 'forward-sexp )
(global-set-key [C-left] 'backward-sexp )
(global-set-key [C-kp-divide] 'occur)
(global-set-key [C-kp-multiply] 'occur-compile )
(global-set-key [C-kp-space] 'compile)
(global-set-key [M-kp-space] 'recompile)
;;
;; 미니버퍼에서도 CTRL-z 를 사용할 수 있도록 한다. 
;; simple.el 파일에 있던 내용을 수정하였음. 
;; 모든 map 목록을 아는 방법은 없는가 .
(define-key minibuffer-local-map "\C-z" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map "\C-z" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map "\C-z" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map "\C-z" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map "\C-z" 'minibuffer-keyboard-quit)
(define-key query-replace-map "\C-z" 'quit)






(defun xah-search-current-word ()
  "Call `isearch' on current word or text selection.
“word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of syntax table.
URL `http://ergoemacs.org/emacs/modernization_isearch.html'
Version 2015-04-09"
  (interactive)
  (let ( ξp1 ξp2 )
    (if (use-region-p)
        (progn
          (setq ξp1 (region-beginning))
          (setq ξp2 (region-end)))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq ξp1 (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq ξp2 (point))))
    (setq mark-active nil)
    (when (< ξp1 (point))
      (goto-char ξp1))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties ξp1 ξp2))))


(progn
  ;; set arrow keys in isearch. left/right is backward/forward, up/down is history. press Return to exit
  (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat )
  (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance )
  (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward) ; single key, useful
  (define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward) ; single key, useful
 )


;; UNIX 에서 유용하게 사용할 수 있습니다. 
;;(global-set-key "\C-c\C-m" 'execute-extended-command)
;;(global-set-key "\C-x\C-m" 'execute-extended-command)

;;(global-set-key (kbd "C-;") 'execute-extended-command)
(global-set-key (kbd "C-;") 'smex)
;;ac-complete (global-set-key (kbd "C-o") 'occur)
(global-set-key (kbd "M-s") 'yank)
(let ((map minibuffer-local-map))
  (define-key map "\es"   'yank))

(let ((map text-mode-map))
  (define-key map "\es"   'yank)) ;;원래는 center-line

;;(require 'smooth-scroll)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed t) ;;  accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode) ;; use 'e' to edit filenames

;; 한글세벌식 단점 극북 
;; http://www.gigamonkeys.com/book/numbers-characters-and-strings.html 참오 

;;DEPRECATED;;(defun insert-bar ()
;;DEPRECATED;;  (interactive) (insert "|"))
;;DEPRECATED;;
;;DEPRECATED;;(defun insert-lbrace () (interactive) (insert "{"))
;;DEPRECATED;;(defun insert-rbrace () (interactive) (insert "}"))
;;DEPRECATED;;(global-set-key "\C-\\" 'insert-bar )
;;DEPRECATED;;(global-set-key (kbd "C-{") 'insert-lbrace )
;;DEPRECATED;;(global-set-key (kbd "C-}") 'insert-rbrace )


(global-set-key "\C-c["  (aif (insert-char ?\[ 1 )))
(global-set-key "\C-c]"  (aif (insert-char ?\] 1 )))
(global-set-key "\C-c{"  (aif (insert-char ?\{ 1 )))
(global-set-key "\C-c}"  (aif (insert-char ?\} 1 )))
(global-set-key "\C-c("  (aif (insert-char ?\( 1 )))
(global-set-key "\C-c)"  (aif (insert-char ?\) 1 )))
(global-set-key "\C-c\\" (aif (insert-char ?\| 1 )))
(global-set-key "\C-c-"  (aif (insert-char ?\- 1 )))

(if (not (eq system-uses-terminfo t))
    (global-set-key "\C-\\"  (aif (insert-char ?\| 1 ))))
;;deprecated-smartparen;;(global-set-key (kbd "C-{")  (aif (insert-char ?\{ 1 )))
;;deprecated-smartparen;;(global-set-key (kbd "C-}")  (aif (insert-char ?\} 1 )))
;;deprecated-smartparen;;(global-set-key (kbd "C-(")  (aif (insert-char ?\( 1 )))
;;deprecated-smartparen;;(global-set-key (kbd "C-)")  (aif (insert-char ?\) 1 )))
;;deprecated-smartparen;;(global-set-key (kbd "C-)")  (aif (insert-char ?\) 1 )))
;;expand-region;;(global-set-key (kbd "C-=")  (aif (insert-char ?\= 1 )))
(global-set-key (kbd "C-&")  (aif (insert-char ?\& 1 )))
(global-set-key (kbd "C-`")  (aif (insert-char ?\* 1 )))
(global-set-key (kbd "C-|")  (aif (insert-char ?\| 1 )))


(global-set-key "\C-ce"      '(aif (delete-region (point) (point-at-eol)) (yank)))
(global-set-key "\C-cv"      'yank)





;;(defun smarter-move-beginning-of-line (arg)
;;  "Move point back to indentation of beginning of line.
;;
;;Move point to the first non-whitespace character on this line.
;;If point is already there, move to the beginning of the line.
;;Effectively toggle between the first non-whitespace character and
;;the beginning of the line.
;;
;;If ARG is not nil or 1, move forward ARG - 1 lines first.  If
;;point reaches the beginning or end of the buffer, stop there."
;;  (interactive "^p")
;;  (setq arg (or arg 1))
;;
;;  ;; Move lines first
;;  (when (/= arg 1)
;;    (let ((line-move-visual nil))
;;      (forward-line (1- arg))))
;;
;;  (let ((orig-point (point)))
;;    (back-to-indentation)
;;    (when (= orig-point (point))
;;      (move-beginning-of-line 1))))
;;
;;;; remap C-a to `smarter-move-beginning-of-line'
;;;;(global-set-key [remap move-beginning-of-line]
;;;;                'smarter-move-beginning-of-line)
;;
;;(global-set-key (kbd "C-a") 'smarter-move-beginning-of-line)
(global-set-key (kbd "H-a") 'back-to-indentation)

(define-key ctl-x-r-map "p" 'copy-rectangle-to-clipboard )


(use-package zygospore
  :config
  (global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows))


(use-package helm-descbinds
  :config
  (helm-descbinds-mode))




(use-package proced
  :config
 (defun proced-gdb ()
   (interactive)
   (let ((pid (proced-pid-at-point)))
     ;; (gdb  (format "gdb -i=mi /proc/%d/exe %d" pid pid))))
     (gdb  (format "/usr/bin/gdb -i=mi /proc/%d/exe %d" pid pid))))
 (define-key proced-mode-map ";" #'proced-gdb))



(use-package gdb-mi
  :config
  (defun gud-key ()
    (interactive)
    (global-set-key [f5] 'gud-cont)
    (global-set-key [f15] 'gud-stop-subjob)
    (global-set-key [f9] 'gud-break)
    (global-set-key [f19] 'gud-remove)
    (global-set-key [f10] 'gud-next)
    (global-set-key [C-f10] 'gud-finish)
    (global-set-key [f20] 'gud-until)
    (global-set-key [f11] 'gud-step)
    (global-set-key [f14] 'gdb-restore-windows)
    (global-set-key [f12] 'emamux:send-dwim)
    )


  (define-key gud-minor-mode-map [left-margin mouse-1]
    'gdb-mouse-toggle-breakpoint-margin)
  (define-key gud-minor-mode-map [left-fringe mouse-1]
    'gdb-mouse-toggle-breakpoint-fringe)


  (defvar gud-overlay
    (let* ((ov (make-overlay (point-min) (point-min))))
      (overlay-put ov 'face 'dvc-highlight );;secondary-selection 
      ov)
    "Overlay variable for GUD highlighting.")

  (defadvice gud-display-line (after my-gud-highlight act)
    "Highlight current line."
    (let* ((ov gud-overlay)
           (bf (gud-find-file true-file)))
      (save-excursion
        (set-buffer bf)
        (move-overlay ov (line-beginning-position) (line-end-position)
                      (current-buffer)))))

  (defun gud-kill-buffer ()
    (if (eq major-mode 'gud-mode)
        (delete-overlay gud-overlay)))

  (add-hook 'kill-buffer-hook 'gud-kill-buffer)
  

  ;; (defadvice pop-to-buffer (before cancel-other-window first)
  ;;   (ad-set-arg 1 nil))

  ;; (ad-activate 'pop-to-buffer)


  (defun gdb-inferior-filter (proc string)
    ;;(unless (string-equal string "")
    ;;  (gdb-display-buffer (gdb-get-buffer-create 'gdb-inferior-io)))
    (with-current-buffer (gdb-get-buffer-create 'gdb-inferior-io)
      (comint-output-filter proc string)))


  (if (not gdb-non-stop-setting)
      (defun gud-stop-subjob ()
        (interactive)
        (with-current-buffer gud-comint-buffer
          (cond ((string-equal gud-target-name "emacs")
                 (comint-stop-subjob))
                ((eq gud-minor-mode 'jdb)
                 (gud-call "suspend"))
                ;;use-comint;;((eq gud-minor-mode 'gdbmi)
                ;;use-comint;; (gud-call (gdb-gud-context-command "-exec-interrupt")))
                (t
                 (comint-interrupt-subjob)))))))

;; http://ergoemacs.org/emacs/emacs_isearch_by_arrow_keys.html
(progn
  ;; set arrow keys in isearch. left/right is backward/forward, up/down is history. press Return to exit
  (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat )
  (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance )

  (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward)

  (define-key minibuffer-local-isearch-map (kbd "<left>") 'isearch-reverse-exit-minibuffer)
  (define-key minibuffer-local-isearch-map (kbd "<right>") 'isearch-forward-exit-minibuffer))
