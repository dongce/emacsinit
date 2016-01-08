;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-

;;(require 'color-theme)
;;(color-theme-initialize )
;;(color-theme-blue2)
;;(color-theme-dark-blue2-noitalic)
;;(color-theme-emacs-21)
;;(color-theme-blue)
;;(color-theme-jonadabian)
;;(color-theme-jacobian)
;; outlinemode 를 대체합니다. 
;;(color-theme-vim-colors)
;;(color-theme-emacs-nw)
;;(color-theme-gtk-ide)

;;(require 'zenburn)
;;;;(require 'color-theme-zenburn)
;;;;(require 'color-theme)
;;(color-theme-zenburn)
(load-theme 'hc-zenburn)
;; (load-theme 'zenburn)

;;(require 'color-theme)

;;(load-theme 'zenburn)
;;; 둘을 더한 것이 더 좋은 결과를 가져온다. 
;;thisisgood;;(color-theme-sanityinc-solarized-dark)
;;thisisgood;;(load-theme 'misterioso)

;; (ignore-errors
;;   (color-theme-sanityinc-solarized-dark)
;;   (add-to-list 'custom-theme-load-path "~/.emacs.d/")
;;   (load-theme 'misterioso-no-modeline t))

;;deprecated;;(add-to-list 'custom-theme-load-path (fullpath "../elpa/moe-theme-20131105.213"))
;;deprecated;;(load-theme 'moe-dark t )



;; (load-theme 'solarized-dark)
;;(load-theme 'solarized-light)
;;(load-theme 'tango)
;; (load-theme 'ample)

(tool-bar-mode 0 )
(menu-bar-mode 0 )
(scroll-bar-mode -1 )

(defun transparent(alpha-level no-focus-alpha-level)
  "Let's you make the window transparent"
  (interactive "nAlpha level (0-100): \nnNo focus alpha level (0-100): ")
  (set-frame-parameter (selected-frame) 'alpha (list alpha-level no-focus-alpha-level))
  (add-to-list 'default-frame-alist `(alpha ,alpha-level)))

;; three window 
(defun split-window-4()
 "Splite window into 4 sub-window"
 (interactive)
 (if (= 1 (length (window-list)))
     (progn (split-window-vertically)
	    (split-window-horizontally)
	    (other-window 2)
	    (split-window-horizontally)
	    )
   )
)

(defun change-split-type (split-fn &optional arg)
  "Change 3 window style from horizontal to vertical and vice-versa"
  (let ((bufList (mapcar 'window-buffer (window-list))))
    (select-window (get-largest-window))
    (funcall split-fn arg)
    (mapcar* 'set-window-buffer (window-list) bufList)))

(defun change-split-type-2 (&optional arg)
  "Changes splitting from vertical to horizontal and vice-versa"
  (interactive "P")
  (let ((split-type (lambda (&optional arg)
                      (delete-other-windows-internal)
                      (if arg (split-window-vertically)
                        (split-window-horizontally)))))
    (change-split-type split-type arg)))

(defun change-split-type-3-v (&optional arg)
  "change 3 window style from horizon to vertical"
  (interactive "P")
  (change-split-type 'split-window-3-horizontally arg))

(defun change-split-type-3-h (&optional arg)
  "change 3 window style from vertical to horizon"
  (interactive "P")
  (change-split-type 'split-window-3-vertically arg))

(defun split-window-3-horizontally (&optional arg)
  "Split window into 3 while largest one is in horizon"
;  (interactive "P")
  (delete-other-windows)
  (split-window-horizontally)
  (if arg (other-window 1))
  (split-window-vertically))

(defun split-window-3-vertically (&optional arg)
  "Split window into 3 while largest one is in vertical"
;  (interactive "P")
  (delete-other-windows)
  (split-window-vertically)
  (if arg (other-window 1))
  (split-window-horizontally))

;;deprecated;;;; paren
;;deprecated;;;; http://emacswiki.org/emacs/ShowParenMode
;;deprecated;;(require 'mic-paren)
;;deprecated;;(paren-activate)
;;deprecated;;(show-paren-mode t)

;;option(setq show-paren-delay 0)           ; how long to wait?
;;option(show-paren-mode t)                 ; turn paren-mode on
;;option(setq show-paren-style 'expression) ; alternatives are 'parenthesis' and 'mixed'
;;option(setq show-paren-style 'parenthesis)
;;option(setq show-paren-style 'mixed)

(require 'frame-cmds)
(define-key global-map "\C-xt." 'save-frame-config)
(define-key global-map "\C-xt," 'jump-to-frame-config-register)

;;(require 'autofit-frame)


(defun toggle-frame-split ()
  "If the frame is split vertically, split it horizontally or vice versa.
Assumes that the frame is only split into two."
  (interactive)
  (unless (= (length (window-list)) 2) (error "Can only toggle a frame split in two"))
  (let ((split-vertically-p (window-combined-p)))
    (delete-window) ; closes current window
    (if split-vertically-p
        (split-window-horizontally)
      (split-window-vertically)) ; gives us a split with the other window twice
    (switch-to-buffer nil))) ; restore the original window in this part of the frame

;; I don't use the default binding of 'C-x 5', so use toggle-frame-split instead

;;; (global-set-key (kbd "C-x 5") 'toggle-frame-split)


;;; modeline 
;; http://emacs-fu.blogspot.kr/2010/05/cleaning-up-mode-line.html


;;(when (require 'diminish nil 'noerror)
;;  (eval-after-load "company"
;;      '(diminish 'company-mode "Cmp"))
;;  (eval-after-load "abbrev"
;;    '(diminish 'abbrev-mode "Ab"))
;;  (eval-after-load "yasnippet"
;;    '(diminish 'yas/minor-mode "Y")))

;;And the major-modes, for example for Emacs Lisp mode:
;;
;;(add-hook 'emacs-lisp-mode-hook 
;;  (lambda()
;;    (setq mode-name "el")))
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))


;;customize;; (add-hook 'prog-mode-hook 'whitespace-mode)
;;customize;; (global-whitespace-mode +1)

(winner-mode t )

;; (with-package* (smart-mode-line) (sml-modeline-mode))

;;conflictwithhelm;;(with-package* (modeline-posn)
;;conflictwithhelm;;  (size-indication-mode t))

;;deprecated;;(defun update-diff-colors ()
;;deprecated;;  "update the colors for diff faces"
;;deprecated;;  (set-face-attribute 'diff-added nil
;;deprecated;;                      :foreground "white" :background "blue")
;;deprecated;;  (set-face-attribute 'diff-removed nil
;;deprecated;;                      :foreground "white" :background "red3")
;;deprecated;;  (set-face-attribute 'diff-changed nil
;;deprecated;;                      :foreground "white" :background "purple"))
;;deprecated;;;;(eval-after-load "diff-mode" '(update-diff-colors))



;; https://github.com/Bruce-Connor/smart-mode-line

;;deprecated;;(require 'smart-mode-line)
;;deprecated;;(if after-init-time (sml/setup)
;;deprecated;;  (add-hook 'after-init-hook 'sml/setup))


(with-package* (fringe-current-line)
  (global-fringe-current-line-mode t)
)


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


(add-hook 'python-mode-hook #'(lambda () (setq prettify-symbols-alist '("map" . 8614)) (pretty-symbols-mode) ))
(add-hook 'emacs-lisp-mode-hook 'pretty-symbols-mode)
(add-hook 'scheme-mode-hook 'pretty-symbols-mode)

;;(add-hook 'c++-mode-hook        'pretty-symbols-mode)

;;; http://www.reddit.com/r/emacs/comments/1huhsg/i_need_help_with_adding_keywords_for_syntax/
;; font lock 설정 
(global-font-lock-mode 1)                     ; for all buffers
