;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-

;; 정규표현을 highlight 한다. 
;; (require 'highlight-sexp)
;;deprecated;;(add-hook 'lisp-mode-hook   'highlight-sexp-mode)
;;deprecated;;(add-hook 'scheme-mode-hook 'highlight-sexp-mode)
;;deprecated;;(add-hook 'emacs-lisp-mode-hook 'highlight-sexp-mode)

;; http://mumble.net/~campbell/emacs/paredit.html
;; http://mumble.net/~campbell/emacs/
;; https://github.com/joelittlejohn/paredit-cheatsheet

(use-package paredit
  ;;  "Minor mode for pseudo-structurally editing Lisp code."
  :commands paredit-mode 
  )

(use-package evil-paredit
  ;;"Minor mode for pseudo-structurally editing Lisp code."
  :commands evil-paredit-mode 
  )




(use-package repl-toggle
  ;; "Switch to the repl asscociated with the major mode of the
  ;; current buffer. If in a repl already switch back to the buffer we
  ;; came from.\(fn)"
  :commands rtog/activate )


;; (with-package (smartparen )
;;   (sp-pair "`" nil :actions :rem)
;;   (sp-pair "'" nil :actions :rem)

;;   (add-hook 'emacs-lisp-mode-hook       
;;             (lambda () (turn-on-eldoc-mode) (smartparens-mode +1)  (rtog/activate) )) ;;(litable-mode t)

;;   (add-hook 'lisp-mode-hook             (lambda () (turn-on-eldoc-mode) (smartparens-mode +1) ))

;;   (add-hook 'lisp-interaction-mode-hook (lambda () (turn-on-eldoc-mode) (smartparens-mode +1) ))
;;   (add-hook 'scheme-mode-hook           (lambda () (turn-on-eldoc-mode) (smartparens-mode +1) )))

;;;_ paredit key 
(use-package paredit
  :config
  (progn (setq paredit-commands
               `(
                 "Basic Insertion Commands"
                 "Movement & Navigation"
                 (("M-S-<up>" "ESC <up>")
                  paredit-splice-sexp-killing-backward
                  ("(foo (let ((x 5)) |(sqrt n)) bar)"
                   "(foo (sqrt n) bar)"))
                 (("M-S-<down>" "ESC <down>")
                  paredit-splice-sexp-killing-forward
                  ("(a (b c| d e) f)"
                   "(a b c f)"))
                 "Barfage & Slurpage"
                 (("M-S-<right>" ) ;;"C-<right>")
                  paredit-forward-slurp-sexp
                  ("(foo (bar |baz) quux zot)"
                   "(foo (bar |baz quux) zot)")
                  ("(a b ((c| d)) e f)"
                   "(a b ((c| d) e) f)"))
                 (("M-S-<left>"  ) ;;"C-<left>")
                  paredit-forward-barf-sexp
                  ("(foo (bar |baz quux) zot)"
                   "(foo (bar |baz) quux zot)"))
                 ))
         nil)                             ; end of PROGN

  (add-hook 'emacs-lisp-mode-hook       
            (lambda () (turn-on-eldoc-mode) (paredit-mode +1)  (rtog/activate) )) ;;(litable-mode t)
  
  (add-hook 'lisp-mode-hook             (lambda () (turn-on-eldoc-mode) (paredit-mode +1) ))
  (add-hook 'lisp-interaction-mode-hook (lambda () (turn-on-eldoc-mode) (paredit-mode +1) ))
  (add-hook 'scheme-mode-hook           (lambda () (turn-on-eldoc-mode) (paredit-mode +1) )))




;;;
;;;
;;; ※ 파일모드 설정
;;;
;;;
;; 다음과 같이 파일 헤더 부분을 이용하여 mode 를 결정할 수도 있다. 
;;(add-to-list 'magic-mode-alist '("<!DOCTYPE html .+DTD XHTML .+>" . nxml-mode))

;;(setq auto-mode-alist
;;      (append (mapcar 
;;	       (lambda ( x ) 
;;		 ( if (equal (cdr x)  (car '(c-mode) )) 
;;		     ( cons (car x ) (car '(c++-mode) )) 
;;		   (car (list x) ) ) ) auto-mode-alist)))


(with-package*
  (
   ;; xah-elisp-mode
   xah-css-mode
   xah-html-mode)
  ;; (replace-auto-mode-alist 'emacs-lisp-mode 'xah-elisp-mode )
  (replace-auto-mode-alist 'css-mode        'xah-css-mode )
  (replace-auto-mode-alist 'html-mode       'xah-html-mode )
  )

(add-to-list 'auto-mode-alist '("\\.topic\\'"  . scheme-mode  ))  
(add-to-list 'auto-mode-alist '("\\.vcproj\\'" . xah-html-mode))
(add-to-list 'auto-mode-alist '("\\.grep\\'"   . grep-mode    ))
(add-to-list 'auto-mode-alist '("\\.py\\'"     . python-mode  ))
(add-to-list 'auto-mode-alist '("\\.pyw\\'"    . python-mode  ))
(add-to-list 'auto-mode-alist '("\\.tex\\'"    . latex-mode   ))
(add-to-list 'auto-mode-alist '("\\.a\\'"      . ada-mode     ))
(add-to-list 'auto-mode-alist '("\\.tst\\'"    . scheme-mode  ))
(add-to-list 'auto-mode-alist '("Makefile*"    . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.bin\\'"    . hexl-mode    ))
(add-to-list 'auto-mode-alist '("\\.text*"     . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md*"       . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.dlog\\'"   . scheme-mode  ))
(add-to-list 'auto-mode-alist '("\\.mak\\'"    . makefile-mode  ))
;; ("vxWorks*" . hexl-mode)                     )



(use-package markdown-mode 
  ;;"Major mode for editing Markdown files"
  :commands markdown-mode
  )

(require 'ada-mode)
(ada-add-extensions "_s.a" "_b.a")

(add-hook  'xah-html-mode-hook (lambda()(rainbow-mode t )))
;;font-lock-add-keywords 이용;;(defvar hexcolour-keywords
;;font-lock-add-keywords 이용;;  '(("#[abcdef[:digit:]]\\{6\\}"
;;font-lock-add-keywords 이용;;     (0 (put-text-property
;;font-lock-add-keywords 이용;;         (match-beginning 0)
;;font-lock-add-keywords 이용;;         (match-end 0)
;;font-lock-add-keywords 이용;;         'face (list :background
;;font-lock-add-keywords 이용;;                     (match-string-no-properties 0)))))))
;;font-lock-add-keywords 이용;;(defun hexcolour-add-to-font-lock ()
;;font-lock-add-keywords 이용;;  (font-lock-add-keywords nil hexcolour-keywords))
;;font-lock-add-keywords 이용;;
;;font-lock-add-keywords 이용;;(add-hook 'css-mode-hook 'hexcolour-add-to-font-lock)
;;font-lock-add-keywords 이용;;(add-hook 'php-mode-hook 'hexcolour-add-to-font-lock)
;;font-lock-add-keywords 이용;;(add-hook 'html-mode-hook 'hexcolour-add-to-font-lock)
;;관련 변수;; font-lock-keywords


(add-hook 
 'makefile-mode-hook 
 (lambda()(setq indent-tabs-mode t )))

(add-hook 
 'c-mode-common-hook 
 '(lambda() 
    ;; define comment style to "//"
    (setq comment-start "//")
    (setq comment-end "")))

(add-hook 
 'c++-mode-hook 
 '(lambda ()  
    (auto-fill-mode 0) 
    (column-number-mode 1) 
    ;;(if (not (eq nil (string-match "isdl" (buffer-file-name))))
    ;;    (c-set-style "stroustrup"))
    ))


(add-hook 'c++-mode-hook '(lambda () (gtags-mode 1)))
(remove-hook 'c++-mode-hook 'semantic-default-c-setup)

(setq gtags-mode-hook '(lambda () (setq gtags-pop-delete t) (setq gtags-path-style 'relative)))
(setq gtags-select-mode-hook '(lambda () (setq hl-line-face 'underline) (hl-line-mode 1)))

(add-hook 
 'ibuffer-mode-hook
 (lambda ()
   (ibuffer-switch-to-saved-filter-groups "default")))

(add-hook 
 'grep-mode-hook
 (lambda ()
   (toggle-truncate-lines 1)))

(add-hook 
 'occur-mode-hook
 (lambda ()
   (toggle-truncate-lines 1)))



;; comint echo 를 방지한다. 
;;guile과충돌;;(when (eq system-type 'windows-nt)
;;guile과충돌;;  (setq-default comint-process-echoes 'on))
(add-hook 'shell-mode-hook #'(lambda () (setf comint-process-echoes 'on))) ;; scheme 모드와 충돌 방지 




;;;
;;;
;;; ※ 여러 가지 훅 설정
;;;
;;;

;; 
;; 2007년 01월 07일 일요일 오후 05시 35분 38초
;; 파일 경로명에 특정 문자열이 있는 경우 어떤 작업을 할 것인지 설정할 수 있도록 하는 명령이다. 

(defvar find-file-path-match-hook
  '( ("기간별정리" . '(org-mode))
     ("rej" . '(read-only-mode 1 ))
     ("usr" . '(read-only-mode 1 ))
     ("tests" . '(read-only-mode 0 ))
     ("elpa" . '(read-only-mode 0 ))))

(add-hook 
 'find-file-hook
 (lambda ( )
   (let ((bn (buffer-file-name)))
     (mapcar
      (lambda ( x ) (if (not (eql nil (string-match (car x ) bn )))
                        (eval (eval (cdr x )))))
      find-file-path-match-hook ))))


(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;(global-set-key [f5] 'slime-js-reload)
(add-hook 
 'js2-mode-hook
 (lambda ()
   (slime-js-minor-mode 1)))

(add-hook 
 'css-mode-hook
 (lambda ()
   (define-key css-mode-map "\M-\C-x" 'slime-js-refresh-css)
   (define-key css-mode-map "\C-c\C-r" 'slime-js-embed-css)))


(require 'yaml-mode)


;;(autoload 'dos-mode "dos" "Edit Dos scripts." t)

(if (eq window-system 'w32)
    (use-package  dos
      (add-to-list 'auto-mode-alist '("\\.bat$" . dos-mode))
      (add-to-list 'auto-mode-alist '("\\.cmd$" . dos-mode))
      (define-key dos-mode-map [?\C-c ?\C-e] (lambda () "Run Dos script." (interactive)(save-buffer) (w32-shell-execute nil (buffer-file-name))))))


;; yas mode 
;; yas repo http://coderepos.org/share/browser/config/yasnippet
;; https://github.com/capitaomorte/yasnippet
;; git://github.com/capitaomorte/yasnippet.git
(require 'yasnippet)
;;(setq yas-snippet-dirs
;;      '("~/.emacs.d/snippets"            ;; personal snippets
;;        "/path/to/some/collection/"      ;; just some foo-mode snippets
;;        "/path/to/some/othercollection/" ;; some more foo-mode and a complete baz-mode
;;        "/path/to/yasnippet/snippets"    ;; the default collection
;;        ))

;;(yas-global-mode)
;;(add-hook 'prog-mode-hook
;;          '(lambda ()
;;             (yas-minor-mode)))

(yas-reload-all)

(require 'auto-yasnippet)
(global-set-key (kbd "s-c") 'create-auto-yasnippet)
(global-set-key (kbd "s-y") 'expand-auto-yasnippet)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;;deprecatedby-xah-html-mode;;(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-html-offset 2)
(setq web-mode-css-offset 2)
(setq web-mode-html-offset 2)
(setq web-mode-javascript-offset 2)
(setq web-mode-java-offset 2)

(require 'mmm-auto)
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class 'html-mode nil 'html-js)


;;If your template extension is tpl, "\\.phtml" becomes "\\.tpl"
;;
;;Using web-mode for editing plain HTML files can be done this way 
;;Customisation
;;The following customisations (except the last one) can be put in a hook this way 
;;
;;(defun web-mode-hook () "Hooks for Web mode." (setq web-mode-html-offset 2) ) (add-hook 'web-mode-hook 'web-mode-hook)

;;sp-offset. 

;;Syntax Highlighting Change face color (set-face-attribute 'web-mode-css-rule-face nil :foreground "Pink3") Available faces:
;;web-mode-doctype-face, web-mode-html-tag-face, web-mode-html-attr-name-face, web-mode-html-attr-value-face
;;web-mode-css-rule-face, web-mode-css-prop-face, web-mode-css-pseudo-class-face, web-mode-css-at-rule-face
;;web-mode-preprocessor-face, web-mode-string-face, web-mode-comment-face
;;web-mode-variable-name-face, web-mode-function-name-face, web-mode-constant-face, web-mode-type-face, web-mode-keyword-face
;;web-mode-folded-face
;;Shortcuts Change the shortcut for element navigation (define-key web-mode-map (kbd "C-n") 'web-mode-match-tag)
;;Snippets Add a snippet (add-to-list 'web-mode-snippets '("mydiv" "<div>" "</div>")) name, beg, end (if region exists, the content is inserted between beg and end)
;;Autocompletes Disable autocomplete (setq web-mode-autocompletes-flag nil)
;;Keywords Add PHP constants (setq web-mode-extra-php-constants '("constant1" "constant2")) Also available : web-mode-extra-php-keywords, web-mode-extra-js-keywords, web-mode-extra-jsp-keywords, web-mode-extra-asp-keywords
;;(Note: do not put this line in the hook)



;; · C-c C-; : comment / uncomment line(s)
;; · C-c C-a : indent all buffer
;; · C-c C-d : delete current HTML element
;; · C-c C-f : toggle folding on a block
;; · C-c C-i : insert snippet
;; · C-c C-j : duplicate current HTML element
;; · C-c C-n : jump to opening/closing tag
;; · C-c C-p : jump to parent HTML element
;; · C-c C-s : select current HTML element

(require 'xub-mode)
(defalias 'utf8-browser 'xub-mode)
(defalias 'unicode-browser 'xub-mode)

;; interactive name completion for describe-function, describe-variable, etc.
(icomplete-mode 1)


;;emacsdefault;;(require 'which-func)
;;emacsdefault;;(which-function-mode t)

;; ;;(Note: Emacs 24.2.91 seems to put the which-func configuration in
;; ;;‘mode-line-misc-info’ instead, so you may need to replace
;; ;;‘mode-line-format’ with ‘mode-line-misc-info’ in the above snippet.)
;; 
;; 
;; (setq mode-line-format (delete (assoc 'which-func-mode
;;                                       mode-line-format) mode-line-format)
;;       which-func-header-line-format '(which-func-mode ("" which-func-format)))
;; 
;; (defadvice which-func-ff-hook (after header-line activate)
;;   (when which-func-mode
;;     (setq mode-line-format (delete (assoc 'which-func-mode
;;                                           mode-line-format) mode-line-format)
;;           header-line-format which-func-header-line-format)))







(with-package*
 (eval-in-repl

  eval-in-repl-ielm
  ;; eval-in-repl-slime
  eval-in-repl-scheme
  eval-in-repl-python
  )

 (defun eval-dwim ()
   (interactive)
   (case major-mode
     ( (emacs-lisp-mode lisp-interaction-mode Info-mode-map)  (eir-eval-in-ielm) )
     ( (slime-mode)  (eir-eval-in-slime)  )
     ( (scheme-mode) (eir-eval-in-scheme)  )
     ( (python-mode) (eir-eval-in-python)  ))))


(use-package geiser
  :config
  (defun geiser-autodoc--autodoc (path &optional signs)
    (ignore-errors 
      (let ((signs (or signs (geiser-autodoc--get-signatures (mapcar 'car path))))
            (p (car path))
            (s))
        (while (and p (not s))
          (unless (setq s (cdr (assoc (car p) signs)))
            (setq p (car path))
            (setq path (cdr path))))
        (when s (geiser-autodoc--str p s))))
    ;; (mode-line-color-update)
    )
  )


(use-package emamux
  :config
  (defun emamux:read-dwim (prompt )
    (let ((cmd (read-shell-command prompt 
                                   (if (region-active-p)
                                       (s-trim (buffer-substring-no-properties (region-beginning) (region-end)))
                                     (substring-no-properties (car kill-ring))
                                     ))))
      (setq emamux:last-command cmd)
      cmd))

  (defun emamux:send-dwim ()
    "Send command to target-session of tmux"
    (interactive)
    (emamux:check-tmux-running)
    (condition-case nil
        (progn
          (if (or current-prefix-arg (not (emamux:set-parameters-p)))
              (emamux:set-parameters))
          (let* ((target (emamux:target-session))
                 (prompt (format "Command [Send to (%s)]: " target))
                 (input  (emamux:read-dwim prompt )))
            (emamux:reset-prompt target)
            (emamux:send-keys input)))
      (quit (emamux:unset-parameters)))))

