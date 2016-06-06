;; -*-mode: emacs-lisp ; coding: cp949; buffer-read-only: t;  -*-

;;;_ python-mode 
(require 'python)                       ;emacs �� �ִ� python.el �� ������ pytho-mode �� ��ü�Ѵ�. 
;; (require 'python-mode)                       ;emacs �� �ִ� python.el �� ������ pytho-mode �� ��ü�Ѵ�. 

;; (defun python-info-current-defun-short (&optional include-type)
;;   "Return name of surrounding function with Python compatible dotty syntax.
;; Optional argument INCLUDE-TYPE indicates to include the type of the defun.
;; This function is compatible to be used as
;; `add-log-current-defun-function' since it returns nil if point is
;; not inside a defun."
;;   (save-restriction
;;     (widen)
;;     (save-excursion
;;       (end-of-line 1)
;;       (let ((names)
;;             (starting-indentation (current-indentation))
;;             (starting-pos (point))
;;             (first-run t)
;;             (last-indent)
;;             (type))

;;         (python-nav-beginning-of-defun 1)
;;         (when (save-match-data
;;                 (and
;;                  (or (not last-indent)
;;                      (< (current-indentation) last-indent))
;;                  (or
;;                   (and first-run
;;                        (save-excursion
;;                          ;; If this is the first run, we may add
;;                          ;; the current defun at point.
;;                          (setq first-run nil)
;;                          (goto-char starting-pos)
;;                          (python-nav-beginning-of-statement)
;;                          (beginning-of-line 1)
;;                          (looking-at-p
;;                           python-nav-beginning-of-defun-regexp)))
;;                   (< starting-pos
;;                      (save-excursion
;;                        (let ((min-indent
;;                               (+ (current-indentation)
;;                                  python-indent-offset)))
;;                          (if (< starting-indentation  min-indent)
;;                              ;; If the starting indentation is not
;;                              ;; within the min defun indent make the
;;                              ;; check fail.
;;                              starting-pos
;;                            ;; Else go to the end of defun and add
;;                            ;; up the current indentation to the
;;                            ;; ending position.
;;                            ;; ( py-end-of-defun-function );;python-mode.el;;
;;                            ;; (python-end-of-defun-function) ;;old python.el
;;                            ;; (python-nav-end-of-defun) ;;slow python.el
;;                            (end-of-defun) ;;slow python.el
;;                            (+ (point)
;;                               (if (>= (current-indentation) min-indent)
;;                                   (1+ (current-indentation))
;;                                 0)))))))))
;;           (save-match-data (setq last-indent (current-indentation)))
;;           (if (or (not include-type) type)
;;               (setq names (cons (match-string-no-properties 1) names))
;;             (let ((match (split-string (match-string-no-properties 0))))
;;               (setq type (car match))
;;               (setq names (cons (cadr match) names))))) ;; Stop searching ASAP.)
;;         (and names
;;              (concat (and type (format "%s " type))
;;                     (mapconcat 'identity names ".")))))))


;;deprecated;;(require 'python-mode)
;;deprecated;;(require 'ipython)
;;deprecated;;(py-set-ipython-completion-command-string "ipython.exe")
;;deprecated;;(set-default 'py-python-command-args  '("-u" "c:/usr/local/python27/Scripts/ipython-script.py"  "--colors=NoColor"))



;; python -i �� ����¿� ���۸��� ������ �մϴ�.
(setq gud-pdb-command-name "python -i -m pdb" )

;;autocomplete;;(require 'ein)
;;autocomplete;;(autoload 'jedi:setup "jedi" nil t)
;;autocomplete;;(add-hook 'python-mode-hook 'jedi:setup)
;;autocomplete;;(add-hook 'python-mode-hook 'jedi:ac-setup)
;;autocomplete;;(setq jedi:setup-keys t)

(defun python-help (w)
  "Launch PyDOC on the Word at Point"
  (interactive
   (let ((symbol (with-syntax-table py-otted-expression-syntax-table
           (current-word)))
     (enable-recursive-minibuffers t))
     (list (read-string (if symbol
                (format "Describe symbol (default %s): " symbol)
              "Describe symbol: ")
            nil nil symbol))))
  (process-send-string (get-process py-which-bufname) "help(" w ")\n"))



;; START PYLOOKUP
; add pylookup to your loadpath, ex) "~/.lisp/addons/pylookup"
(setq pylookup-dir "c:/usr/local/editor/emacsW32/pylookup/")
;;(add-to-list 'load-path pylookup-dir)
;; load pylookup when compile time

(eval-when-compile (require 'pylookup))
;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.bat"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)
(autoload 'pylookup-update "pylookup" 
  "Run pylookup-update and create the database at `pylookup-db-file'." t)


(global-set-key "\C-h;" 'pylookup-lookup)
;; EMD PYLOOKUP


;;;_ PYMACS
;;(require 'pymacs)
;;tempdeprecated(setq pymacs-python-command "python.bat")
;;tempdeprecated(add-to-list 'pymacs-load-path "t:/usr/local/editor/emacsW32/site-lisp/pymacs/")
;;tempdeprecated;;; _ȯ����� http://docs.python.org/2/using/cmdline.html
;;tempdeprecated(setenv  "PYTHONPATH" "t:/usr/local/editor/emacsW32/site-lisp/pymacs/")
;;tempdeprecated;;(pymacs-load "pastemacs" "paste-")
;;tempdeprecated;;(pymacs-load "emacsuuid" "uuid-")
;;tempdeprecated;;(pymacs-load "pyutil" "pyutil-") ;;call like this (pyutil-int-to-bin 10 )
;;tempdeprecated;;(pymacs-load "pyclip" "pyclip-")
 ;; (pymacs-load "ropemacs" "rope-") (rope-show-doc) 


(use-package pymacs
  ;; :commands pyutil-mozlz4-decompress fbmk
  :config
  (setq pymacs-python-command "emacspython.bat")
  (add-to-list 'pymacs-load-path (fullpath  "../thirdparty/pymacs/"))
  (setenv  "PYTHONPATH" (fullpath  "../thirdparty/pymacs/"))
  ;; pyclip use external
  ;; (pymacs-load "pyclip" "pyclip-")
  ;; (defun pyclip-clip-file () 
  ;;   (interactive)
  ;;   (if (eq system-type 'windows-nt)
  ;;       (let* ((files (dired-get-marked-files))
  ;;              (files (if (null files)
  ;;                         (list (dired-current-directory) )
  ;;                       files)))
  ;;         (pyclip-mime files))))
  ;;(pymacs-load "pastemacs" "paste-")
  ;;(pymacs-load "emacsuuid" "uuid-")
  (pymacs-load "pyutil" "pyutil-"))

(use-package imenu-tree )

;;; _OUTLINE 
(use-package outline-magic
  :config
  (w32-unix-eval
   ((define-key outline-minor-mode-map [S-tab] 'outline-cycle))
   ((define-key outline-minor-mode-map [(backtab)]'outline-cycle))))

;; (with-package* (outshine)
;;   (add-hook  'outline-minor-mode-hook 'outshine-hook-function))
;; ������ ���α׷��ֿ� ���� 
;;(require 'python-magic)


;; python-magic ����
(add-hook 
 'python-mode-hook 
 (lambda ()
   ;;(setq outline-regexp "[ \t]*# \\|[ \t]+\\(class\\|def\\|if\\|elif\\|else\\|while\\|for\\|try\\|except\\|with\\) ")
   ;;(setq outline-regexp "def\\|class ")
   (setq outline-regexp "[ \t]*\\(class\\|def\\|with\\|for\\|@.*\\|###_.*\\) ")
   (setq outline-heading-end-regexp "\n")
   (setq 
    outline-level 
    (lambda ()
      (let (buffer-invisibility-spec)
        (save-excursion
          (skip-chars-forward " \t")         
          (if (char-equal ?\# (char-after))
              (current-column)
            (+ (current-column) 1)
            )))))
   ;; (smartparens-mode) 
   (outline-minor-mode t)
   ;; (set (make-local-variable 'eldoc-documentation-function) 'rope-eldoc-function)
   ;;deprecated;;(set (make-variable-buffer-local 'beginning-of-defun-function)
   ;;deprecated;;     'py-beginning-of-def-or-class)

   ;; (add-hook 'which-func-functions #'python-info-current-defun-short nil t)

   ;; (guide-key/add-local-guide-key-sequence "C-c")
   

   ;;(hide-body)
   ;;(show-body)
   ;;(define-key outline-minor-mode-map [tab]    'outline-cycle)
   ;;(define-key outline-minor-mode-map [S-tab]  'indent-for-tab-command)
   ;;(define-key outline-minor-mode-map [M-down] 'outline-move-subtree-down)
   ;;(define-key outline-minor-mode-map [M-up]   'outline-move-subtree-up)
   ;;(define-key outline-minor-mode-map [S-tab]    'outline-cycle)
;; If you used python-mode.el you probably will miss auto-indentation
;; when inserting newlines.  To achieve the same behavior you have
;; two options:
;; 1) Use GNU/Emacs' standard binding for `newline-and-indent': C-j.
;; 2) Add the following hook in your .emacs:
;; (add-hook 'python-mode-hook
;;   #'(lambda ()
;;       (define-key python-mode-map "\C-m" 'newline-and-indent)))
   ))


;;deprecated;;(require 'python-mode)
;;deprecated;;(require 'ipython)
;;deprecated;;(py-set-ipython-completion-command-string "ipython.exe")
;;deprecated;;(set-default
;;deprecated;; 'py-python-command-args
;;deprecated;; '("-u" "c:/usr/local/python27/Scripts/ipython-script.py"  "--colors=NoColor"))

(use-package elpy
  :config
  (elpy-enable)
  (elpy-use-ipython "ipython")
  ;; (setq python-shell-interpreter "python.exe"
  ;;       python-shell-interpreter-args "-u c:/usr/local/python27/Scripts/ipython-script.py --colors=NoColor")
  (setq   
   python-check-command "pyflakes"
   python-shell-interpreter "ipython.exe"
   python-shell-interpreter-args "--colors=NoColor"
   python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
   python-shell-prompt-regexp "In \\[[0-9]+\\]: "
   elpy-default-minor-modes '(flycheck-mode yas-minor-mode auto-complete-mode)
  elpy-rpc-backend "rope"
  elpy-rpc-python-command "python")

)


;; http://www.emacswiki.org/emacs/ElDoc
(defun rope-eldoc-function ()
  (interactive)
  (let* ((win-conf (current-window-configuration))
         (resize-mini-windows nil)
         (disable-python-trace t)
         class fun args result-type
         (flymake-message (python-flymake-show-help))
         (initial-point (point))
         (paren-range (let (tmp)
                        (ignore-errors
                          (setq tmp (vimpulse-paren-range 0 ?\( nil t))
                          (if (and tmp (>= (point) (car tmp)) (<= (point) (cadr tmp)))
                              tmp
                            nil))))
         (result (save-excursion
                   ;; check if we on the border of args list - lparen or rparen
                   (if paren-range
                       (goto-char (car paren-range)))
                   (call-interactively 'rope-show-doc)
                   (set-buffer "*rope-pydoc*")
                   (goto-char (point-min))
                   (if (or (equal (point-max) 1)
                           (not (re-search-forward "\\([a-zA-Z_]+[a-zA-Z0-9_]*\\)(.*):" (point-at-eol) t))
                           (and (current-message) (string-match-p "BadIdentifierError" (current-message))))
                       nil
                     (let (result)
                       ;; check if this is class definition
                       (if (looking-at "class \\([a-zA-Z_]+[a-zA-Z0-9_]*\\)(.*):")
                           (progn
                             (goto-char (point-at-eol))
                             (re-search-forward (buffer-substring (match-beginning 1) (match-end 1)))))
                       (goto-char (point-at-bol))
                       (setq result (buffer-substring (point) (point-at-eol)))

                       ;; check if exist better description of function
                       (goto-char (point-at-eol))
                       (string-match "\\([a-zA-Z_]+[a-zA-Z0-9_]*\\)(.*)" result) ;get function name
                       (if (re-search-forward (concat (match-string 1 result) "(.*)") nil t)
                           (progn
                             (goto-char (point-at-bol))
                             (setq result (buffer-substring (point) (point-at-eol)))))

                       ;; return result
                       result
                       ))))
         (arg-position (save-excursion
                         (if paren-range
                             (count-matches "," (car paren-range) (point))))))
    ;; save window configuration
    (set-window-configuration win-conf)
    ;; process main result
    (if result
        (progn
          (setq result-type (nth 1 (split-string result "->")))
          (setq result (nth 0 (split-string result "->")))
          (setq result (split-string result "("))
          (setq fun (nth 1 (split-string (nth 0 result) "\\.")))
          (setq class (nth 0 (split-string (nth 0 result) "\\.")))
          ;; process args - highlight current function argument
          (setq args (nth 0 (split-string (nth 1 result) ")")))

          ;; highlight current argument
          (if args
              (progn
                (setq args (split-string args ","))
                (setq args (let ((num -1))
                             (mapconcat
                              (lambda(x)(progn
                                          (setq num (+ 1 num))
                                          (if (equal num arg-position) (propertize x 'face 'eldoc-highlight-function-argument) x)))
                              args
                              ",")))))

          ;; create string for type signature
          (setq result
                (concat
                 (propertize "Signature: " 'face 'flymake-message-face)

                 (if fun
                     (concat (propertize (org-trim class) 'face 'font-lock-type-face)
                             "."
                             (propertize (org-trim fun) 'face 'font-lock-function-name-face))
                   (propertize (org-trim class) 'face 'font-lock-function-name-face))

                 " (" args ")"

                 (if result-type
                     (concat " -> " (org-trim result-type)))
                 ))))

    ;; create final result
    (if (and (null flymake-message) (null result))
        nil
      (concat flymake-message
              (if (and result flymake-message) "\n")
              result))))

(defvar disable-python-trace nil)

(defadvice message(around message-disable-python-trace activate)
  (if disable-python-trace
      t
    ad-do-it))

(defface flymake-message-face
  '((((class color) (background light)) (:foreground "#b2dfff"))
    (((class color) (background dark))  (:foreground "#b2dfff")))
  "Flymake message face")

(defun python-flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help
          (format (concat (propertize "Error: " 'face 'flymake-message-face) "%s") help)))))



;; http://from-the-cloud.com/en/emacs/2013/01/28_emacs-as-a-django-ide-with-python-djangoel.html

