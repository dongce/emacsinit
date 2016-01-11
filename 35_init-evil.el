;; -*- coding: utf-8; -*-
; http://d.hatena.ne.jp/tarao/20130304/evil_config


(require 'evil-visual-mark-mode)
(evil-visual-mark-mode t)


;;(require 'evil-nerd-commenter)
;; (require 'evil-escape)
;; (evil-escape-mode)

;; (require 'evil-lisp-state)
;; (with-package* (better-registers)
;;   (define-key evil-normal-state-map "\C-r" better-registers-map))

(with-package*  
  (
   better-registers
	 evil-leader
    ;;evil-lisp-state
   evil-nerd-commenter
    evil-commentary
    evil projectile owdriver
				)

 ;;  (evil-commentary-mode)
 ;; (owdriver-define-command scroll-up               t)
 ;; (owdriver-define-command scroll-down             t)
 ;; (owdriver-define-command move-beginning-of-line  t)
 ;; (owdriver-define-command move-end-of-line        t)
 ;; (owdriver-define-command beginning-of-buffer     t)
 ;; (owdriver-define-command end-of-buffer           t)
 ;; (owdriver-define-command isearch-forward         t (isearch-forward))
 ;; (owdriver-define-command isearch-backward        t (isearch-backward))
 ;; (owdriver-define-command set-mark-command        t)
  
  (global-evil-leader-mode) 

;;; EMACS 와 같은 visual line 및 eol 입니다. 
;;; '(evil-want-visual-char-semi-exclusive t)
;;; '(evil-move-cursor-back nil)

  ;; https://github.com/syl20bnr/dotemacs/blob/master/my-keybindings.el


  (evil-leader/set-key-for-mode 'org-mode
    "A"  #'(lambda () (interactive) (switch-to-buffer "*Org Agenda*"))
    )
  
  (evil-leader/set-key 
  "<tab>" #'back-to-indentation
  "f" 'find-file
  "b" 'switch-to-buffer
  ;; "i" 'ibuffer
  ;; "j" 'tmpscratch
  "<home>" 'ibuffer
  "<end>" 'tmpscratch
  "," 'smex
  "s" search-map ;;'save-buffer
  "st" 'sr-speedbar-toggle
  "sl" 'loccur
  "sn" 'smartscan-symbol-go-forward
  "sp" 'smartscan-symbol-go-backward
  "j" 'save-buffer
  "u" #'wgrep
  ";" 'evilnc-comment-or-uncomment-lines
  "l" 'evilnc-comment-or-uncomment-to-the-line
  "c" #'wcopy ;;deprecated;;'evilnc-copy-and-comment-lines
  "O" 'win-switch-next-window
  ;; "O" (lambda (multi) (interactive "P") (if multi  (call-interactively 'multi-occur-in-this-mode) (call-interactively 'occur))  (other-window 1)) 
  "`o" #'owdriver-next-window
  "`J" #'owdriver-do-scroll-up
  "`K" #'owdriver-do-scroll-down
  "`s" #'owdriver-do-isearch-forward
  "`r" #'owdriver-do-isearch-backward
  "`<" #'owdriver-do-beginning-of-buffer
  "`>" #'owdriver-do-end-of-buffer
  "]" 'exit-recursive-edit
  "v" 'evil-scroll-down
  "V" 'evil-scroll-up
  "R" ctl-x-r-map ;;'ido-choose-from-recentf
  "r" better-registers-r-map ;;better-registers-map
  ;; "gg" 'keyboard-quit
  ;; "g," 'grep-o-matic-visited-files
  ;; "g." 'grep-o-matic-repository
  ;; "g/" 'grep-o-matic-current-directory
  "G" 'keyboard-quit
  "e" 'eval-last-sexp
  "t" 'ido-choose-from-recentf ;;'string-rectangle ;;'recentf-open-most-recent-file
  "T" 'helm-choose-from-recentf ;;'string-rectangle ;;'recentf-open-most-recent-file
  "w" 'read-only-mode
  "W" 'save-some-buffers
  "a" 'winexe
  "+" #'evil-numbers/inc-at-pt
  "-" #'evil-numbers/dec-at-pt
  "M" #'pop-to-mark-command ;;'evil-scroll-down
  "m" #'er/expand-region ;;#'extend-selection
  "S-m" #'mark-line ;;#'extend-selection
  ;; "m" #'backward-sexp
  ;; "." #'forward-sexp
  "<" #'loccur
  "0" #'delete-window
  "1" #'delete-other-windows
  "2" #'split-window-below
  "3" #'split-window-right
  "(" #'kmacro-start-macro
  ")" #'kmacro-end-macro
  ;;"x" ctl-x-map ;;projectile-mode-map
  "x"  #'kmacro-end-and-call-macro
  "d" 'dired
  "D" #'toggle-current-window-dedication
  "k" 'kill-buffer
  ;; projectile -----------------------------------------------------------------
  "p"  (cdar (cddr  (cadr  projectile-mode-map)))
  "pE"  'project-explorer-open
  "pC"  'project-explorer-close
  ;;deprecated;; "pb" 'projectile-switch-to-buffer
  ;;deprecated;; "pC" 'projectile-invalidate-cache
  ;;deprecated;; "pd" 'projectile-dired
  ;;deprecated;; "pf" 'helm-projectile
  ;;deprecated;; "pF" 'projectile-find-file
  ;;deprecated;; "pk" 'projectile-kill-buffers
  ;;deprecated;; "pg" 'projectile-grep
  ;;deprecated;; "po" 'projectile-multi-occur
  ;;deprecated;; "pr" 'projectile-replace 
  ;; "<SPC>" (lambda () (interactive) (evil-change-state 'insert) (set-mark (point)))
  "<SPC>" #'smex
  
  ;; "h" #'smex ;; "h" help-map
  ;; "h" help-map
  "hz" 'zeal-at-point

  "hh"      'helm-mini
  "ha"      'helm-apropos
  "hB"      'helm-buffers-list
  "hb"      'helm-descbindings
  "hy"      'helm-show-kill-ring
  "hx"      'helm-M-x
  "hco"     'helm-occur
  "hcs"     'helm-swoop
  "hcy"     'helm-yas-complete
  "hcY"     'helm-yas-create-snippet-on-region
  "hcb"     'my/helm-do-grep-book-notes
  "hj"      'winner-undo
  "hk"      'winner-redo
  "hf"      'prelude-copy-file-name-to-clipboard
  "hc<SPC>" 'helm-all-mark-rings
  "or" 'org-capture
  "oa" 'org-agenda
  "os" 'org-store-link
  "oi" 'org-insert-link-global
  "oo" 'org-open-at-point-global
  "oR" 'org-refile
  "oc" 'org-cliplink
  "od" 'org-deadline
  "ot" 'org-set-tags
  "oS" 'org-attach-screenshot
  "om" 'orgmail
  "ob" 'org-iswitchb

  "oS" 'tmpscratch
  "oI" 'ibuffer
  
  )

  
;;; evil leader 와 충돌이 발생할 경우 evil-leader 다음에 로딩할 수 있도독 한다. 
  ;; (require 'quack)

  (require 'evil-mode-line)
  (require  'evil-surround)
  (evil-define-key 'visual evil-surround-mode-map "s" 'evil-surround-region)
  (global-evil-surround-mode 1 )
  
  ;;deprecated;;(evilnc-default-hotkeys)


(require 'dired)
;;; Dired
(define-key dired-mode-map (kbd "SPC") nil)
(define-key dired-mode-map (kbd "/") nil)
(define-key dired-mode-map (kbd "n") nil)
(define-key dired-mode-map (kbd "N") nil)
(progn
  ;; use the standard Dired bindings as a base
  (evil-make-overriding-map dired-mode-map 'normal t)
  (evil-add-hjkl-bindings dired-mode-map 'normal
    "J" 'dired-goto-file     ; "j"
    "K" 'dired-do-kill-lines ; "k"
    "r" 'dired-do-redisplay  ; "l"
    "g" 'revert-buffer
    (kbd  "RET") 'diredp-find-file-reuse-dir-buffer
    ";" (lookup-key dired-mode-map ":"))) ; ":d", ":v", ":s", ":e"
(evil-define-key 'normal dired-mode-map "R" 'dired-do-rename)
(evil-define-key 'normal dired-mode-map "g" 'revert-buffer)
(evil-declare-key 'normal dired-mode-map "g" 'revert-buffer)

(with-package* (dired)
  (define-key dired-mode-map ":;" 'dired-sort-menu-toggle-dirs-first)
  )

;; (with-package* (better-registers)
;;   (define-key evil-normal-state-map "\C-r" better-registers-map))

;; (define-key quack-scheme-mode-keymap (kbd  "<SPC>") nil)


	
  (evil-mode 1)

  ;;deprecated;;(global-set-key (kbd "C-x r t") 'inline-string-rectangle)
  (evil-set-toggle-key "<pause>")



  (define-key evil-normal-state-map "U" 'undo-tree-redo)
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
  ;; (define-key minibuffer-local-isearch-map [escape] 'keyboard-quit)
  ;;(define-key minibuffer-local-isearch-map [?\S- ] 'toggle-korean-input-method)




  ;;deprecated;;(global-set-key [M-return] 'smex)
  (define-key evil-normal-state-map (kbd "C-c +") #'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "C-c -") #'evil-numbers/dec-at-pt)
  (define-key evil-normal-state-map "zx" 'smex)

  (define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
  (define-key evil-insert-state-map "\C-e" 'end-of-line)
  (define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
  (define-key evil-normal-state-map "\C-f" 'evil-forward-char)
  (define-key evil-insert-state-map "\C-f" 'evil-forward-char)
  (define-key evil-insert-state-map "\C-f" 'evil-forward-char)
  (define-key evil-normal-state-map "\C-b" 'evil-backward-char)
  (define-key evil-insert-state-map "\C-b" 'evil-backward-char)
  (define-key evil-visual-state-map "\C-b" 'evil-backward-char)
  (define-key evil-normal-state-map "\C-d" 'evil-delete-char)
  (define-key evil-insert-state-map "\C-d" 'evil-delete-char)
  (define-key evil-visual-state-map "\C-d" 'evil-delete-char)
  (define-key evil-normal-state-map "\C-n" 'evil-next-line)
  (define-key evil-insert-state-map "\C-n" 'evil-next-line)
  (define-key evil-visual-state-map "\C-n" 'evil-next-line)
  (define-key evil-normal-state-map "\C-p" 'evil-previous-line)
  (define-key evil-insert-state-map "\C-p" 'evil-previous-line)
  (define-key evil-visual-state-map "\C-p" 'evil-previous-line)
  ;; (define-key evil-normal-state-map "\C-w" 'phi-rectangle-kill-region)
  ;; (define-key evil-insert-state-map "\C-w" 'phi-rectangle-kill-region)
  ;; (define-key evil-visual-state-map "\C-w" 'phi-rectangle-kill-region)
  (define-key evil-normal-state-map "\C-w" 'kill-region-dwim)
  (define-key evil-insert-state-map "\C-w" 'kill-region-dwim)
  (define-key evil-visual-state-map "\C-w" 'kill-region-dwim)
  (define-key evil-normal-state-map "\C-y" 'yank)
  (define-key evil-insert-state-map "\C-y" 'yank)
  (define-key evil-visual-state-map "\C-y" 'yank)
  (define-key evil-normal-state-map "\C-k" 'kill-line)
  (define-key evil-insert-state-map "\C-k" 'kill-line)
  (define-key evil-visual-state-map "\C-k" 'kill-line)
  (define-key evil-normal-state-map "Q" 'call-last-kbd-macro)
  (define-key evil-visual-state-map "Q" 'call-last-kbd-macro)
  (define-key evil-normal-state-map (kbd "TAB") 'evil-undefine)
  (define-key evil-normal-state-map (kbd "<tab>") 'evil-undefine)
  (define-key evil-motion-state-map "\C-]" 'find-tag-dwim)

  (define-key evil-motion-state-map "[[" 'backward-sexp)
  (define-key evil-motion-state-map "]]" 'forward-sexp)

  (define-key evil-normal-state-map (kbd "C-c :" ) 'ac-complete-with-helm)
  (define-key evil-insert-state-map (kbd "C-c :" ) 'ac-complete-with-helm)

  (defun evil-undefine ()
    (interactive)
    (let (evil-mode-map-alist)
      (call-interactively (key-binding (this-command-keys))))))
;;; http://leavinsprogramming.blogspot.kr/2012/05/evil-emacs-mode-for-vivim-users.html




(define-key evil-normal-state-map "zf" 'vimish-fold-toggle) 
(define-key evil-visual-state-map "zf" 'vimish-fold) 
(define-key evil-normal-state-map "zd" 'vimish-fold-delete) 
(define-key evil-normal-state-map "zs" 'vimish-fold-next-fold) 
(define-key evil-normal-state-map "zw" 'vimish-fold-previous-fold)

(define-key evil-normal-state-map "zF" 'hs-toggle-hiding)



(with-package* 
 (org)
;;;* _ EVIL ORG setting 
;;;** 참고 - https://github.com/cofi/dotfiles/blob/master/emacs.d/config/cofi-evil.el#L149 
 (require 'org)
 (evil-define-key 'normal org-mode-map
   (kbd "RET") 'org-open-at-point
   "za" 'org-cycle
   "zA" 'org-shifttab
   "zm" 'hide-body
   "zr" 'show-all
   "zo" 'show-subtree
   "zO" 'show-all
   "zc" 'hide-subtree
   "zC" 'hide-all
   [f2] 'org-cliplink
   (kbd "<kp-multiply>") 'org-insert-star
   (kbd "M-j") 'org-shiftleft
   (kbd "M-k") 'org-shiftright
   (kbd "M-H") 'org-metaleft
   (kbd "M-J") 'org-metadown
   (kbd "M-K") 'org-metaup
   (kbd "M-L") 'org-metaright)

 (evil-define-key 'normal orgstruct-mode-map
   (kbd "RET") 'org-open-at-point
   "za" 'org-cycle
   "zA" 'org-shifttab
   "zm" 'hide-body
   "zr" 'show-all
   "zo" 'show-subtree
   "zO" 'show-all
   "zc" 'hide-subtree
   "zC" 'hide-all
   (kbd "M-j") 'org-shiftleft
   (kbd "M-k") 'org-shiftright
   (kbd "M-H") 'org-metaleft
   (kbd "M-J") 'org-metadown
   (kbd "M-K") 'org-metaup
   (kbd "M-L") 'org-metaright)

 (evil-define-key 'insert org-mode-map
   [f2] 'org-cliplink
   (kbd "M-j") 'org-shiftleft
   (kbd "M-k") 'org-shiftright
   (kbd "M-H") 'org-metaleft
   (kbd "M-J") 'org-metadown
   (kbd "M-K") 'org-metaup
   (kbd "M-L") 'org-metaright)

 (evil-define-key 'insert orgstruct-mode-map
   (kbd "M-j") 'org-shiftleft
   (kbd "M-k") 'org-shiftright
   (kbd "M-H") 'org-metaleft
   (kbd "M-J") 'org-metadown
   (kbd "M-K") 'org-metaup
   (kbd "M-L") 'org-metaright)





 '(progn
    (evil-make-overriding-map ibuffer-mode-map 'normal t)
    (evil-define-key 'normal ibuffer-mode-map
      "j" 'evil-next-line
      "k" 'evil-previous-line
      "RET" 'ibuffer-visit-buffer)))



;;;* vim keys -  http://www.tuxfiles.org/linuxhelp/vimcheat.html  

;; http://stackoverflow.com/questions/11052678/emacs-combine-iseach-forward-and-recenter-top-bottom
;; http://stackoverflow.com/questions/11052678/emacs-combine-iseach-forward-and-recenter-top-bottom

;; / 한글 
;; (defvar evil-search-norm-state nil)
;; (make-variable-buffer-local 'evil-search-norm-state)

;; (defadvice
;;     evil-search-forward
;;     (before evil-search-insert-state activate)
;;     (if (evil-normal-state-p) (progn (setq evil-search-norm-state t) (evil-insert-state))))

;; (defadvice
;;     evil-search-forward
;;     (after evil-search-normal-state activate)
;;     (if evil-search-norm-state  (evil-normal-state))
;;     (setf evil-search-norm-state nil))
;; (ad-activate 'evil-search-forward)


(defun evil-search-incrementally (forward regexp-p)
  "Search incrementally for user-entered text."
  (let ((evil-search-prompt (evil-search-prompt forward))
        (isearch-search-fun-function 'evil-isearch-function)
        (point (point))
        isearch-success search-nonincremental-instead)
    (setq isearch-forward forward)
    (evil-save-echo-area
      ;; set the input method locally rather than globally to ensure that
      ;; isearch clears the input method when it's finished
      (evil-insert-state)
      (if forward
          (isearch-forward regexp-p)
        (isearch-backward regexp-p))
      (evil-normal-state)
      (if (not isearch-success)
          (goto-char point)
        ;; always position point at the beginning of the match
        (when (and forward isearch-other-end)
          (goto-char isearch-other-end))
        (when (and (eq point (point))
                   (not (string= isearch-string "")))
          (if forward
              (isearch-repeat-forward)
            (isearch-repeat-backward))
          (isearch-exit)
          (when (and forward isearch-other-end)
            (goto-char isearch-other-end)))
        (evil-flash-search-pattern
         (evil-search-message isearch-string forward))))))




;;deprecated;;(evil-define-motion evil-search-forward ()
;;deprecated;;  (format "Search forward for user-entered text.
;;deprecated;;Searches for regular expression if `evil-regexp-search' is t.%s"
;;deprecated;;          (if (and (fboundp 'isearch-forward)
;;deprecated;;                   (documentation 'isearch-forward))
;;deprecated;;              (format "\n\nBelow is the documentation string \
;;deprecated;;for `isearch-forward',\nwhich lists available keys:\n\n%s"
;;deprecated;;                      (documentation 'isearch-forward)) ""))
;;deprecated;;  :jump t
;;deprecated;;  :type exclusive
;;deprecated;;  :repeat evil-repeat-search
;;deprecated;;    (progn                 ;MADE CHANGES HERE
;;deprecated;;      (evil-insert-state)
;;deprecated;;      (evil-search-incrementally t evil-regexp-search)
;;deprecated;;      (evil-normal-state)
;;deprecated;;    ))
;;deprecated;;
;;deprecated;;(evil-define-motion evil-search-backward ()
;;deprecated;;  (format "Search forward for user-entered text.
;;deprecated;;Searches for regular expression if `evil-regexp-search' is t.%s"
;;deprecated;;          (if (and (fboundp 'isearch-forward)
;;deprecated;;                   (documentation 'isearch-forward))
;;deprecated;;              (format "\n\nBelow is the documentation string \
;;deprecated;;for `isearch-forward',\nwhich lists available keys:\n\n%s"
;;deprecated;;                      (documentation 'isearch-forward)) ""))
;;deprecated;;  :jump t
;;deprecated;;  :type exclusive
;;deprecated;;  :repeat evil-repeat-search
;;deprecated;;    (progn                 ;MADE CHANGES HERE
;;deprecated;;      (evil-insert-state)
;;deprecated;;      (evil-search-incrementally nil evil-regexp-search)
;;deprecated;;      (evil-normal-state)
;;deprecated;;    ))


;; https://github.com/emacsmirror/evil/blob/master/evil-integration.el
;; Ibuffer
(define-key ibuffer-mode-map (kbd  "<SPC>") nil)
(progn
  (evil-make-overriding-map ibuffer-mode-map 'normal t)
  (evil-define-key 'normal ibuffer-mode-map
    "j" 'evil-next-line
    "k" 'evil-previous-line
    "RET" 'ibuffer-visit-buffer))



;;; Auto-complete
(use-package
  auto-complete
  :config
  (evil-add-command-properties 'ac-complete :repeat 'evil-ac-repeat)
  (evil-add-command-properties 'ac-expand :repeat 'evil-ac-repeat)
  (evil-add-command-properties 'ac-next :repeat 'ignore)
  (evil-add-command-properties 'ac-previous :repeat 'ignore)

  (defvar evil-ac-prefix-len nil
    "The length of the prefix of the current item to be completed.")

  (defun evil-ac-repeat (flag)
    "Record the changes for auto-completion."
    (cond
     ((eq flag 'pre)
      (setq evil-ac-prefix-len (length ac-prefix))
      (evil-repeat-start-record-changes))
     ((eq flag 'post)
      ;; Add change to remove the prefix
      (evil-repeat-record-change (- evil-ac-prefix-len)
                                 ""
                                 evil-ac-prefix-len)
      ;; Add change to insert the full completed text
      (evil-repeat-record-change
       (- evil-ac-prefix-len)
       (buffer-substring-no-properties (- evil-repeat-pos
                                          evil-ac-prefix-len)
                                       (point))
       0)
      ;; Finish repeation
      (evil-repeat-finish-record-changes)))))

(progn
  (add-hook 'wdired-mode-hook #'evil-change-to-initial-state)
  (defadvice wdired-change-to-dired-mode (after evil activate)
    (evil-change-to-initial-state nil t)))

;; https://github.com/timcharper/evil-surround
;; (global-surround-mode 1)
(evil-ex-define-cmd "[sc]ratch" #'tmpscratch)


;; https://github.com/glynnforrest/emacs.d/blob/master/setup-occur-grep-ack.el

(defun get-buffers-matching-mode (mode)
  "Returns a list of buffers where their major-mode is equal to MODE"
  (let ((buffer-mode-matches '()))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (if (eq mode major-mode)
            (add-to-list 'buffer-mode-matches buf))))
    buffer-mode-matches))

(defun multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with this major mode."
  (interactive)
  (multi-occur
   (get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))

(defun occur-goto-occurrence-recenter ()
  "Go to the occurrence on the current line and recenter."
  (interactive)
  (occur-mode-goto-occurrence)
  (recenter))

;; Preview occurrences in occur without leaving the buffer
(defun occur-display-occurrence-recenter ()
  "Display the occurrence on the current line in another window and recenter."
  (interactive)
  (occur-goto-occurrence-recenter)
  (other-window 1))


;; Grep mode
(defun grep-goto-occurrence-recenter ()
  "Go to the occurrence on the current line and recenter."
  (interactive)
  (compile-goto-error)
  (recenter))

(defun grep-display-occurrence-recenter ()
  "Display the grep result of the current line in another window and recenter."
  (interactive)
  (grep-goto-occurrence-recenter)
  (other-window 1))


;;deprecated;;(defun gf/narrow-grep-buffer ()
;;deprecated;;  "Narrow the grep buffer stripping out the really long grep command."
;;deprecated;;  (interactive)
;;deprecated;;  (goto-line 5)
;;deprecated;;  (narrow-to-region (point) (point-max))
;;deprecated;;  (goto-line 1))
;;deprecated;;
;;deprecated;;(define-key evil-normal-state-map (kbd "C-c g")
;;deprecated;;  (lambda()
;;deprecated;;    (interactive)
;;deprecated;;    (call-interactively 'projectile-ack)
;;deprecated;;    (other-window 1)
;;deprecated;;    (gf/narrow-grep-buffer)
;;deprecated;;    ))


(use-package wgrep
  :config
  (evil-declare-key 'motion occur-mode-map (kbd "<return>")   'occur-goto-occurrence-recenter)
  (evil-declare-key 'motion occur-mode-map (kbd "<S-return>") 'occur-display-occurrence-recenter)
  (evil-declare-key 'motion occur-mode-map "e" 'occur-edit-mode)
  (evil-declare-key 'motion occur-edit-mode-map "e" 'occur-cease-edit)
  (evil-declare-key 'motion grep-mode-map (kbd "<return>") 'grep-goto-occurrence-recenter)
  (evil-declare-key 'motion grep-mode-map (kbd "<S-return>") 'grep-display-occurrence-recenter)
  (evil-declare-key 'motion ack-and-a-half-mode-map (kbd "<return>") 'grep-goto-occurrence-recenter)
  (evil-declare-key 'motion ack-and-a-half-mode-map (kbd "<S-return>") 'grep-display-occurrence-recenter)
  (evil-declare-key 'motion grep-mode-map "e" 'wgrep-change-to-wgrep-mode)
  (evil-declare-key 'motion grep-mode-map "w" 'wgrep-save-all-buffers)
  ;;notuse;;(evil-declare-key 'motion ack-and-a-half-mode-map ",e" 'wgrep-change-to-wgrep-mode)
  ;;notuse;;(evil-declare-key 'motion ack-and-a-half-mode-map ",w" 'wgrep-save-all-buffers)
  (evil-declare-key 'motion wgrep-mode-map "e" 'wgrep-finish-edit)
  (evil-declare-key 'motion wgrep-mode-map "x" 'wgrep-abort-changes))

;;; https://github.com/laynor/emacs-conf/blob/master/site-lisp/evil-sexp/evil-sexp.el

(defun beginning-and-end-of-sexp ()
  (destructuring-bind (b . e)
      (save-excursion
        (forward-char)
        (bounds-of-thing-at-point 'sexp))
    (cons b e)))

(evil-define-motion evil-forward-sexp (count)
  :type inclusive
  (dotimes (i (or count 1))
    (let ((lookahead-1 (char-syntax (char-after (point))))
          (lookahead-2 (char-syntax (char-after (1+ (point)))))
          (new-point (point)))
      (condition-case nil
          (progn (save-excursion
                   (message "lookahead1 = %S, lookahead-2 = %S"
                            (string lookahead-1) (string lookahead-2))
                   (cond ((or (memq lookahead-2 '(?\ ?>))
                              (member lookahead-1 '(?\ ?>)))
                          (forward-char)
                          (skip-syntax-forward "->")
                          (setq new-point (point)))
                         (t (unless (memq lookahead-1 '(?\" ?\())
                              (forward-char))
                            (sp-forward-sexp)
                            (backward-char)
                            (setq new-point (point)))))
                 (goto-char new-point))
        (error (error "End of sexp"))))))

(evil-define-motion evil-backward-sexp (count)
  :type inclusive
  (dotimes (i (or count 1))
    (let ((lookahead (char-syntax (char-after (point))))
          (new-point (point)))
      (condition-case nil
          (progn (save-excursion
                   (when (memq lookahead '(?\) ?\"))
                     (forward-char))
                   (sp-backward-sexp)
                   (setq new-point (point)))
                 (goto-char new-point))
        (error (error "Beginning of sexp"))))))

(evil-define-motion evil-enter-sexp (count)
  :type inclusive
  (dotimes (i (or count 1))
    (let ((lookahead-1 (char-syntax (char-after (point))))
          (lookahead-2 (char-syntax (char-after (1+ (point)))))
          (lookbehind-1 (char-syntax (char-before (point))))
          (lookbehind-2 (char-syntax (char-before (1- (point))))))
      (cond ((and (= lookahead-1 ?\()
                  (/= lookbehind-1 ?\\)
                  (= (char-after (1+ (point))) ?\n))
             (forward-char)
             (skip-syntax-forward "-"))
            ((and (= lookahead-1 ?\()
                  (/= lookbehind-1 ?\\)
                  (/= lookahead-2 ?\)))
             ;; do not move the cursor if it's on the opening paren of ()
             (forward-char)
             (skip-syntax-forward "-"))
            ((and (= lookahead-1 ?\))
                  (or (/= lookbehind-1 ?\( )
                      (= lookbehind-2 ?\\)))
             ;; do not move the cursor if it's on the closing paren of ()
             (skip-syntax-backward "-")
             (backward-char))
            (t (error "Already at the deepest level"))))))



;; Does not work correctly when there are spaces after parens
;; does not work correctly when inside a string, check paredit.
;; check when there are spaces before parens
;; When the cursor is on an open paren, go up one level on an open paren
(use-package paredit ;; (smartparens)
  :config
  (evil-define-motion evil-exit-sexp (count)
    :type inclusive
    (dotimes (i (or count 1))
      (let (op-pos cl-pos)
        (condition-case nil
            (progn (save-excursion
                     (sp-backward-up-sexp)
                     (setq op-pos (point))
                     (sp-forward-sexp)
                     (setq cl-pos (point)))
                   (let ((lookahead (char-syntax (char-after (point)))))
                     (case lookahead
                       (?\( (goto-char op-pos))
                       (?\) (goto-char cl-pos))
                       (otherwise (goto-char (if (> (abs (- (point) cl-pos))
                                                    (abs (- (point) op-pos)))
                                                 op-pos
                                               cl-pos))))))
          (error (error "Already at top-level."))))) )

  ;; (provide 'evil-sexp)


  (define-key evil-motion-state-map (kbd "H-j") 'evil-enter-sexp)
  (define-key evil-motion-state-map (kbd "H-k") 'evil-exit-sexp)
  (define-key evil-motion-state-map (kbd "H-h") 'evil-backward-sexp)
  (define-key evil-motion-state-map (kbd "H-l") 'evil-forward-sexp)
  (define-key evil-motion-state-map (kbd "<C-H-up>")     'buf-move-up)
  (define-key evil-motion-state-map (kbd "<C-H-down>")   'buf-move-down)
  (define-key evil-motion-state-map (kbd "<C-H-left>")   'buf-move-left)
  (define-key evil-motion-state-map (kbd "<C-H-right>")  'buf-move-right)
  (define-key evil-motion-state-map "zl" 'evil-forward-sexp)
  (define-key evil-motion-state-map "zh" 'evil-backward-sexp)
  (define-key evil-motion-state-map "zj" 'evil-enter-sexp)
  (define-key evil-motion-state-map "zk" 'evil-exit-sexp))


;;; http://blog.binchen.org/?p=782
(eval-after-load "evil" '(setq expand-region-contract-fast-key "z"))
;;; guide-key 

(use-package guide-key
  :config
  (guide-key-mode))

;; https://github.com/redguardtoo/evil-matchit/blob/master/README.org
(use-package evil-matchit
  :config
  (global-evil-matchit-mode 1 )
  (plist-put evilmi-plugins 'xah-html-mode '((evilmi-html-get-tag evilmi-html-jump)))
  (plist-put evilmi-plugins 'web-mode '((evilmi-html-get-tag evilmi-html-jump))))


(require 'evil-args)

;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map "L" 'evil-forward-arg)
(define-key evil-normal-state-map "H" 'evil-backward-arg)
(define-key evil-motion-state-map "L" 'evil-forward-arg)
(define-key evil-motion-state-map "H" 'evil-backward-arg)

;; bind evil-jump-out-args
(define-key evil-normal-state-map "K" 'evil-jump-out-args)



;; (use-package magit
;;   :commands (magit-status magit-diff magit-log magit-blame-mode)
;;   :init
;;   (evil-leader/set-key
;;     "g t" 'magit-status
;;     "g b" 'magit-blame-mode
;;     "g l" 'magit-log
;;     "g d" 'magit-diff)
;;   :config
;;   (progn
;;     (evil-make-overriding-map magit-mode-map 'emacs)
;;     (define-key magit-mode-map "\C-w" 'evil-window-map)
;;     (evil-define-key 'emacs magit-mode-map "j" 'magit-goto-next-section)
;;     (evil-define-key 'emacs magit-mode-map "k" 'magit-goto-previous-section)
;;     (evil-define-key 'emacs magit-mode-map "K" 'magit-discard-item))) 

(use-package evil-magit)

(use-package evil-visualstar
  :config
  (global-evil-visualstar-mode t))



;; @see https://bitbucket.org/lyro/evil/issue/511/let-certain-minor-modes-key-bindings
(use-package git-timemachine
  :config
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

(defun org-show-current-heading-tidily ()
  (interactive)  ;Inteactive
  "Show next entry, keeping other entries closed."
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (outline-back-to-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

;;; evil-org 

(evil-define-key 'normal evil-org-mode-map
  "=" 'org-show-current-heading-tidily
  "<" 'org-shiftleft
  ">" 'org-shiftright
  )

(evil-leader/set-key-for-mode 'org-mode
  "ha" 'helm-org-agenda-files-headings
  "hH" 'helm-org-headlines
  ;; "hh" 'helm-org-in-buffer-headings
  )




