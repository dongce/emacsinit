;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-
;; babel 에서 C-c' (org-edit-src-code 를 사용할 수 있다)
(require 'org)
(require 'org-install)
;; 다음이 DVC 와 충돌 
(require 'ob-tangle)
(require 'org-search-goto)
(require 'evil-org)
;;     #+STARTUP: overview
;;     #+STARTUP: content
;;     #+STARTUP: showall
;; 파일마다 위의 것을 적어서 조절할 수 있다. 전체는 다음과 설정이 같다. 
;;(setq org-startup-folded t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-switchb)

(setq org-export-with-sub-superscripts nil )
;; capture 를 사용한다. 

(if (not (version<= "24.3" emacs-version ));;deprecatedat 24.3
    (org-remember-insinuate))              ;;deprecatedat 24.3

(setq org-default-notes-file  "~/notes.org")
(define-key global-map "\C-cc" 'org-capture)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
;;(global-set-key [(control ?\')]     'org-cycle-agenda-files)

(setq org-log-done t)

(add-hook 'org-mode-hook 'turn-on-font-lock) ; Org buffers only


(defun guide-key-hook-function-for-org-mode ()
  (guide-key/add-local-guide-key-sequence "C-c")
  (guide-key/add-local-guide-key-sequence "C-c C-x")
  (guide-key/add-local-highlight-command-regexp "org-"))

(add-hook 'org-mode-hook 'guide-key-hook-function-for-org-mode)


(fset 'org-insert-heading-origin 'org-insert-heading)
(defun org-insert-heading (&optional force-heading invisible-ok)
  "Insert a new heading or item with same depth at point.
If point is in a plain list and FORCE-HEADING is nil, create a new list item.
If point is at the beginning of a headline, insert a sibling before the
current headline.  If point is not at the beginning, split the line,
create the new headline with the text in the current line after point
\(but see also the variable `org-M-RET-may-split-line').

When INVISIBLE-OK is set, stop at invisible headlines when going back.
This is important for non-interactive uses of the command."
  (interactive "P")
  (if (or (= (buffer-size) 0)
	  (and (not (save-excursion
		      (and (ignore-errors (org-back-to-heading invisible-ok))
			   (org-at-heading-p))))
	       (or force-heading (not (org-in-item-p)))))
      (progn
	(insert "\n* ")
	(run-hooks 'org-insert-heading-hook))
    (when (or force-heading (not (org-insert-item)))
      (let* ((empty-line-p nil)
	     (level nil)
	     (on-heading (org-at-heading-p))
	     (head (save-excursion
		     (condition-case nil
			 (progn
			   (org-back-to-heading invisible-ok)
			   (when (and (not on-heading)
				      (featurep 'org-inlinetask)
				      (integerp org-inlinetask-min-level)
				      (>= (length (match-string 0))
					  org-inlinetask-min-level))
			     ;; Find a heading level before the inline task
			     (while (and (setq level (org-up-heading-safe))
					 (>= level org-inlinetask-min-level)))
			     (if (org-at-heading-p)
				 (org-back-to-heading invisible-ok)
			       (error "This should not happen")))
			   (setq empty-line-p (org-previous-line-empty-p))
			   (match-string 0))
		       (error "*"))))
	     (blank-a (cdr (assq 'heading org-blank-before-new-entry)))
	     (blank (if (eq blank-a 'auto) empty-line-p blank-a))
	     pos hide-previous previous-pos)
	(cond
	 ((and (org-at-heading-p) (bolp)
	       (or (bobp)
		   (save-excursion (backward-char 1) (not (outline-invisible-p)))))
	  ;; insert before the current line
	  (open-line (if blank 2 1)))
	 ((and (bolp)
	       (not org-insert-heading-respect-content)
	       (or (bobp)
		   (save-excursion
		     (backward-char 1) (not (outline-invisible-p)))))
	  ;; insert right here
	  nil)
	 (t
	  ;; somewhere in the line
          (save-excursion
	    (setq previous-pos (point-at-bol))
            (end-of-line)
            (setq hide-previous (outline-invisible-p)))
	  (and org-insert-heading-respect-content (org-show-subtree))
	  (let ((split
		 (and (org-get-alist-option org-M-RET-may-split-line 'headline)
		      (save-excursion
			(let ((p (point)))
			  (goto-char (point-at-bol))
			  (and (looking-at org-complex-heading-regexp)
			       (match-beginning 4)
			       (> p (match-beginning 4)))))))
		tags pos)
	    (cond
	     (org-insert-heading-respect-content
	      (org-end-of-subtree nil t)
	      (when (featurep 'org-inlinetask)
		(while (and (not (eobp))
			    (looking-at "\\(\\*+\\)[ \t]+")
			    (>= (length (match-string 1))
				org-inlinetask-min-level))
		  (org-end-of-subtree nil t)))
	      (or (bolp) (newline))
	      (or (org-previous-line-empty-p)
		  (and blank (newline)))
	      (open-line 1))
	     ((org-at-heading-p)
	      (when hide-previous
		(show-children)
		(org-show-entry))
	      (looking-at ".*?\\([ \t]+\\(:[[:alnum:]_@#%:]+:\\)\\)?[ \t]*$")
	      (setq tags (and (match-end 2) (match-string 2)))
	      (and (match-end 1)
		   (delete-region (match-beginning 1) (match-end 1)))
	      (setq pos (point-at-bol))
	      (or split (end-of-line 1))
	      (delete-horizontal-space)
	      (if (string-match "\\`\\*+\\'"
				(buffer-substring (point-at-bol) (point)))
		  (insert " "))
	      (newline (if blank 2 1))
	      (when tags
		(save-excursion
		  (goto-char pos)
		  (end-of-line 1)
		  (insert " " tags)
		  (org-set-tags nil 'align))))
	     (t
	      (or split (end-of-line 1))
	      (newline (if blank 2 1)))))))
	(insert head) (just-one-space)
	(setq pos (point))
	(end-of-line 1)
	(unless (= (point) pos) (just-one-space) (backward-delete-char 1))
        (when (and org-insert-heading-respect-content hide-previous)
	  (save-excursion
	    (goto-char previous-pos)
	    (hide-subtree)))
	(run-hooks 'org-insert-heading-hook)))))

(defun oheader () 
  (interactive)
  (save-excursion
    (save-restriction
      (narrow-to-region (point-min) (point-min))
      (insert  "#+TITLE: Org Title
#+AUTHOR: 김동일
#+EMAIL: dongce@gmail.com
#+DATE: 
#+DESCRIPTION: 
#+KEYWORDS:
#+LANGUAGE: en
#+OPTIONS: H:3 num:t toc:t \\n:nil @:t ::t |:t ^:t -:t f:t *:t <:t
#+OPTIONS: Tex:t LateX:t skip:nil d:nil todo:t pri:nil tags:not-in-toc
#+INFOJS_OPT: view:nil ltoc:t mouse:unterline bottons:0 path:http://orgmode.org/org-info.js
#+EXPORT_SELECT_TAGS: export
#+EXPORT_EXCLUDE_TAGS: noexport
#+LINK_UP:
#+LINK_HOME:
#+XSLT:")))) 


;;; https://github.com/keelerm84/.emacs.d
; Make sure the code in begin_src blocks is colorized both when
; editing and when exporting.
(require 'ox-latex)
;; (setq org-latex-listings 'minted)
;; (add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-src-fontify-natively t)

(setq org-todo-keywords
      '((sequence "TODO" "WAITING" "STARTED" "|" "DONE" "DELEGATED")))

(setq org-todo-keyword-faces
      (quote (
              ("TODO" :foreground "DarkGoldenRod3" :weight bold)
              ("WAITING" :foreground "chocolate" :weight bold)
              ("STARTED" :foreground "olive drab" :weight bold)
              ("DELEGATED" :foreground "PaleVioletRed3" :weight bold)
              ("DONE" :foreground "gray" :weight bold)
              )))

(setq org-log-done 'time)

;; (setq org-directory "~/Documents/Dropbox/OrgFiles/")
;; (setq org-agenda-files `(,org-directory))
;; (setq org-default-notes-file (concat org-directory "refile.org"))

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))

(set-face-foreground 'org-level-5 "aquamarine4")

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

(defun org-insert-star( &optional arg)
  
  (interactive "^p") 
  (or arg (setq arg 1))
  (move-beginning-of-line nil) 
  (while (looking-at "\\*+") (forward-char)) 

  (while (> arg 0)
    (insert "*")
    (setq arg (1- arg)))
  (if (not  (looking-at " ")) (insert " ")))


;; [[file:t:/usr/local/editor/emacsW32/site-lisp/elpa/org-20151123/ob-calc.el::(defun%20org-babel-execute:calc%20(body%20params)][src from]]

(defun org-babel-execute:calc (body params)
  "Execute a block of calc code with Babel."
  (unless (get-buffer "*Calculator*")
    (save-window-excursion (calc) (calc-quit)))
  (let* ((vars (mapcar #'cdr (org-babel-get-header params :var)))
	 (org--var-syms (mapcar #'car vars))
	 (var-names (mapcar #'symbol-name org--var-syms)))
    (mapc
     (lambda (pair)
       (calc-push-list (list (cdr pair)))
       (calc-store-into (car pair)))
     vars)
    (mapc
     (lambda (line)
       (when (> (length line) 0)
	 (cond
	  ;; simple variable name
	  ((member line var-names) (calc-recall (intern line)))
	  ;; stack operation
	  ((string= "'" (substring line 0 1))
	   (funcall (lookup-key calc-mode-map (substring line 1)) ))
	  ((string= "`" (substring line 0 1))
	   (eval (read  (substring line 1)) ))
	  ;; complex expression
	  (t
	   (calc-push-list
	    (list (let ((res (calc-eval line)))
                    (cond
                     ((numberp res) res)
                     ((math-read-number res) (math-read-number res))
                     ((listp res) (error "Calc error \"%s\" on input \"%s\""
                                         (cadr res) line))
                     (t (replace-regexp-in-string
                         "'" ""
                         (calc-eval
                          (math-evaluate-expr
                           ;; resolve user variables, calc built in
                           ;; variables are handled automatically
                           ;; upstream by calc
                           (mapcar #'org-babel-calc-maybe-resolve-var
                                   ;; parse line into calc objects
                                   (car (math-read-exprs line)))))))))
                  ))))))
     (mapcar #'org-babel-trim
	     (split-string (org-babel-expand-body:calc body params) "[\n\r]"))))
  (save-excursion
    (with-current-buffer (get-buffer "*Calculator*")
      (calc-eval (calc-top 1)))))



;;; [[http://pages.sachachua.com/.emacs.d/Sacha.html#orgheadline13][Sacha Chua's Emacs configuration]]

;;; org helm refile
(defvar my/helm-org-refile-locations nil)
(defvar my/org-refile-last-location nil)

(defun my/helm-org-clock-in-and-track-from-refile (candidate)
  (let ((location (org-refile--get-location candidate my/helm-org-refile-locations)))
    (save-window-excursion
      (org-refile 4 nil location)
      (my/org-clock-in-and-track)
      t)))

(defun my/org-get-todays-items-as-refile-candidates ()
  "Return items scheduled for today, ready for choosing during refiling."
  (delq
   nil
   (mapcar
    (lambda (s)
      (if (get-text-property 0 'org-marker s)
          (list
           s
           (buffer-file-name (marker-buffer (get-text-property 0 'org-marker s)))
           nil
           (marker-position (get-text-property 0 'org-marker s)))))
    (save-window-excursion (my/org-get-entries-fn (calendar-current-date) (calendar-current-date))))))

;; Based on http://emacs.stackexchange.com/questions/4063/how-to-get-the-raw-data-for-an-org-mode-agenda-without-an-agenda-view
(defun my/org-get-entries-fn (begin end)
  "Return org schedule items between BEGIN and END.
USAGE:  (org-get-entries-fn '(6 1 2015) '(6 30 2015))"
  (require 'calendar)
  (require 'org)
  (require 'org-agenda)
  (require 'cl)
  (unless
      (and
       (calendar-date-is-valid-p begin)
       (calendar-date-is-valid-p end))
    (let ((debug-on-quit nil))
      (signal 'quit `("One or both of your gregorian dates are invalid."))))
  (let* (
         result
         (org-agenda-prefix-format "  • ")
         (org-agenda-entry-types '(:scheduled))
         (date-after
          (lambda (date num)
            "Return the date after NUM days from DATE."
            (calendar-gregorian-from-absolute
             (+ (calendar-absolute-from-gregorian date) num))))
         (enumerate-days
          (lambda (begin end)
            "Enumerate date objects between BEGIN and END."
            (when (> (calendar-absolute-from-gregorian begin)
                     (calendar-absolute-from-gregorian end))
              (error "Invalid period : %S - %S" begin end))
            (let ((d begin) ret (cont t))
              (while cont
                (push (copy-sequence d) ret)
                (setq cont (not (equal d end)))
                (setq d (funcall date-after d 1)))
              (nreverse ret)))) )
    (org-agenda-reset-markers)
    (setq org-agenda-buffer
          (when (buffer-live-p org-agenda-buffer)
            org-agenda-buffer))
    (org-compile-prefix-format nil)
    (setq result
          (loop for date in (funcall enumerate-days begin end) append
                (loop for file in (org-agenda-files nil 'ifmode)
                      append
                      (progn
                        (org-check-agenda-file file)
                        (apply 'org-agenda-get-day-entries file date org-agenda-entry-types)))))
    (unless (buffer-live-p (get-buffer org-agenda-buffer-name))
      (get-buffer-create org-agenda-buffer-name))
    (with-current-buffer (get-buffer org-agenda-buffer-name)
      (org-agenda-mode)
      (setq buffer-read-only t)
      (let ((inhibit-read-only t))
        (erase-buffer))
      (mapcar
       (lambda (x)
         (let ((inhibit-read-only t))
           (insert (format "%s" x) "\n")))
       result))
    ;;    (display-buffer org-agenda-buffer-name t)
    result))

(defun my/helm-org-refile-read-location (tbl)
  (setq my/helm-org-refile-locations tbl)
  (helm
   (list
    ;; (helm-build-sync-source "Today's tasks"
    ;;   :candidates (mapcar (lambda (a) (cons (car a) a))
    ;;                       (my/org-get-todays-items-as-refile-candidates))
    ;;   :action '(("Select" . identity)
    ;;             ("Clock in and track" . my/helm-org-clock-in-and-track-from-refile)
    ;;             ("Draw index card" . my/helm-org-prepare-index-card-for-subtree))
    ;;   :history 'org-refile-history)
    (helm-build-sync-source "Refile targets"
      :candidates (mapcar (lambda (a) (cons (car a) a)) tbl)
      :action '(("Select" . identity)
                ("Clock in and track" . my/helm-org-clock-in-and-track-from-refile)
                ("Draw index card" . my/helm-org-prepare-index-card-for-subtree))
      :history 'org-refile-history)
    (helm-build-dummy-source "Create task"
      :action (helm-make-actions
               "Create task"
               'my/helm-org-create-task)))))

(defun my/org-refile-get-location (&optional prompt default-buffer new-nodes no-exclude)
  "Prompt the user for a refile location, using PROMPT.
  PROMPT should not be suffixed with a colon and a space, because
  this function appends the default value from
  `org-refile-history' automatically, if that is not empty.
  When NO-EXCLUDE is set, do not exclude headlines in the current subtree,
  this is used for the GOTO interface."
  (let ((org-refile-targets org-refile-targets)
        (org-refile-use-outline-path org-refile-use-outline-path)
        excluded-entries)
    (when (and (derived-mode-p 'org-mode)
               (not org-refile-use-cache)
               (not no-exclude))
      (org-map-tree
       (lambda()
         (setq excluded-entries
               (append excluded-entries (list (org-get-heading t t)))))))
    (setq org-refile-target-table
          (org-refile-get-targets default-buffer excluded-entries)))
  (unless org-refile-target-table
    (user-error "No refile targets"))
  (let* ((cbuf (current-buffer))
         (partial-completion-mode nil)
         (cfn (buffer-file-name (buffer-base-buffer cbuf)))
         (cfunc (if (and org-refile-use-outline-path
                         org-outline-path-complete-in-steps)
                    'org-olpath-completing-read
                  'org-icompleting-read))
         (extra (if org-refile-use-outline-path "/" ""))
         (cbnex (concat (buffer-name) extra))
         (filename (and cfn (expand-file-name cfn)))
         (tbl (mapcar
               (lambda (x)
                 (if (and (not (member org-refile-use-outline-path
                                       '(file full-file-path)))
                          (not (equal filename (nth 1 x))))
                     (cons (concat (car x) extra " ("
                                   (file-name-nondirectory (nth 1 x)) ")")
                           (cdr x))
                   (cons (concat (car x) extra) (cdr x))))
               org-refile-target-table))
         (completion-ignore-case t)
         cdef
         (prompt (concat prompt
                         (or (and (car org-refile-history)
                                  (concat " (default " (car org-refile-history) ")"))
                             (and (assoc cbnex tbl) (setq cdef cbnex)
                                  (concat " (default " cbnex ")"))) ": "))
         pa answ parent-target child parent old-hist)
    (setq old-hist org-refile-history)
    ;; Use Helm's sources instead
    (setq answ (my/helm-org-refile-read-location tbl))
    (cond
     ((and (stringp answ)
           (setq pa (org-refile--get-location answ tbl)))
      (org-refile-check-position pa)
      (when (or (not org-refile-history)
                (not (eq old-hist org-refile-history))
                (not (equal (car pa) (car org-refile-history))))
        (setq org-refile-history
              (cons (car pa) (if (assoc (car org-refile-history) tbl)
                                 org-refile-history
                               (cdr org-refile-history))))
        (if (equal (car org-refile-history) (nth 1 org-refile-history))
            (pop org-refile-history)))
      (setq my/org-refile-last-location pa)
      pa)
     ((and (stringp answ) (string-match "\\`\\(.*\\)/\\([^/]+\\)\\'" answ))
      (setq parent (match-string 1 answ)
            child (match-string 2 answ))
      (setq parent-target (org-refile--get-location parent tbl))
      (when (and parent-target
                 (or (eq new-nodes t)
                     (and (eq new-nodes 'confirm)
                          (y-or-n-p (format "Create new node \"%s\"? "
                                            child)))))
        (org-refile-new-child parent-target child)))
     ((listp answ) answ) ;; Sacha: Helm returned a refile location
     ((not (equal answ t))
      (user-error "Invalid target location")))))

(fset 'org-refile-get-location 'my/org-refile-get-location)



(use-package elfeed-org
  :commands (elfeed)
  :init
  (elfeed-org)
  ) 


;;; document 
;;; expporting : http://orgmode.org/manual/Exporting.html bk
;;; example    : 
;;;orgexportexample;;#+TITLE:       bzg .emacs.el file
;;;orgexportexample;;#+EMAIL:       bzg AT altern DOT org
;;;orgexportexample;;#+STARTUP:     odd hidestars fold
;;;orgexportexample;;#+LANGUAGE:    fr
;;;orgexportexample;;#+LINK:        guerry http://lumiere.ens.fr/~guerry/%s
;;;orgexportexample;;#+OPTIONS:     skip:nil toc:nil
;;;orgexportexample;;#+INFOJS_OPT:  view:overview toc:nil ltoc:nil mouse:#cccccc buttons:0 path:http://orgmode.org/org-info.js
;;;orgexportexample;;#+HTML_HEAD:   <link rel="publisher" href="https://plus.google.com/103809710979116858042" />
;;;orgexportexample;;#+PROPERTY:    tangle ~/elisp/config/emacs.el
;;;orgexportexample;;# #+PROPERTY:    tangle ~/public_html/org/homepage/u/emacs.el
;;;orgexportexample;;
;;;orgexportexample;;This is my =.emacs.el= file, as a HTMLized =emacs.org= file.
;;;orgexportexample;;
;;;orgexportexample;;You can browse the =.el= file [[http://lumiere.ens.fr/~guerry/u/emacs.el][here]] or clone the =.org= file from [[https://github.com/bzg/dotemacs][github]].
;;;orgexportexample;;
;;;orgexportexample;;Comments and suggestions are welcome! =bzg AT gnu DOT org=
;;;orgexportexample;;
;;;orgexportexample;;* Package initialization
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  ;; I don't use package a lot but don't want to configure the list of
;;;orgexportexample;;  ;; archives each time I do use it.
;;;orgexportexample;;
;;;orgexportexample;;  (require 'package)
;;;orgexportexample;;  (setq package-archives
;;;orgexportexample;;        '(("org" . "http://orgmode.org/elpa/")
;;;orgexportexample;;          ("marmalade". "http://marmalade-repo.org/packages/")
;;;orgexportexample;;          ("gnu" . "http://elpa.gnu.org/packages/")
;;;orgexportexample;;          ;; ("SC" . "http://joseito.republika.pl/sunrise-commander/")
;;;orgexportexample;;          ;; ("ELPA" . "http://tromey.com/elpa/")
;;;orgexportexample;;          ))
;;;orgexportexample;;
;;;orgexportexample;;  (package-initialize)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* General defaults
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq default-major-mode 'org-mode)
;;;orgexportexample;;
;;;orgexportexample;;  (setq debug-on-error t)
;;;orgexportexample;;  (setq byte-compile-debug t)
;;;orgexportexample;;  (setq elp-sort-by-function 'elp-sort-by-average-time)
;;;orgexportexample;;
;;;orgexportexample;;  (setq auto-save-default nil)
;;;orgexportexample;;  (setq make-backup-files nil)
;;;orgexportexample;;  (setq kill-whole-line t)
;;;orgexportexample;;  (setq kill-ring-max 120)
;;;orgexportexample;;  (setq sentence-end-double-space t)
;;;orgexportexample;;  (setq require-final-newline t)
;;;orgexportexample;;  (setq next-screen-context-lines 0)
;;;orgexportexample;;  (setq bidi-display-reordering nil)
;;;orgexportexample;;  (setq enable-local-variables t)
;;;orgexportexample;;  (setq enable-local-eval t)
;;;orgexportexample;;  (setq kill-read-only-ok t)
;;;orgexportexample;;
;;;orgexportexample;;  (fset 'yes-or-no-p 'y-or-n-p)
;;;orgexportexample;;
;;;orgexportexample;;  ;; I find this useful to have a local (i)search ring:
;;;orgexportexample;;  (make-variable-buffer-local 'search-ring)
;;;orgexportexample;;  (make-variable-buffer-local 'isearch-string)
;;;orgexportexample;;
;;;orgexportexample;;  (setenv "EDITOR" "emacsclient")
;;;orgexportexample;;  (setenv "CVS_RSH" "ssh")
;;;orgexportexample;;  (setq completion-use-tooltip nil)
;;;orgexportexample;;  (setq battery-mode-line-format " [%b%p%%,%d째C]")
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Enable/Disable some minor modes
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;;; I love parentheses in *every* mode
;;;orgexportexample;;(show-paren-mode 1)
;;;orgexportexample;;(display-time-mode 1)
;;;orgexportexample;;(auto-compression-mode t)
;;;orgexportexample;;
;;;orgexportexample;;;; Don't clutter the emacs screen
;;;orgexportexample;;(tool-bar-mode -1)
;;;orgexportexample;;(blink-cursor-mode -1)
;;;orgexportexample;;(menu-bar-mode -1)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Set my exec/load paths
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (add-to-list 'exec-path "~/bin/")
;;;orgexportexample;;
;;;orgexportexample;;  (let ((default-directory "~/elisp/"))
;;;orgexportexample;;    (normal-top-level-add-subdirs-to-load-path))
;;;orgexportexample;;
;;;orgexportexample;;  (let ((default-directory "~/install/git/gnus/"))
;;;orgexportexample;;    (normal-top-level-add-subdirs-to-load-path))
;;;orgexportexample;;
;;;orgexportexample;;  (add-to-list 'load-path "~/install/cvs/emacs-w3m/")
;;;orgexportexample;;  (add-to-list 'load-path "~/install/git/helm/")
;;;orgexportexample;;  (add-to-list 'load-path "~/install/git/geiser/elisp/")
;;;orgexportexample;;  (add-to-list 'load-path "~/install/git/nrepl.el/")
;;;orgexportexample;;  (add-to-list 'load-path "~/install/git/magit/" t)
;;;orgexportexample;;  (add-to-list 'load-path "~/install/src/bbdb/lisp/")
;;;orgexportexample;;
;;;orgexportexample;;  (add-to-list 'load-path "~/install/git/org-mode/lisp/")
;;;orgexportexample;;  (add-to-list 'load-path "~/install/git/org-mode/contrib/lisp/")
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Requires
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;
;;;orgexportexample;;;; M-x package-install RET register-list RET
;;;orgexportexample;;(require 'register-list)
;;;orgexportexample;;
;;;orgexportexample;;;; I'm using an old elscreen but there is more recent activity:
;;;orgexportexample;;;; https://github.com/knu/elscreen
;;;orgexportexample;;(require 'elscreen)
;;;orgexportexample;;(setq elscreen-display-tab nil)
;;;orgexportexample;;(setq elscreen-tab-display-control nil)
;;;orgexportexample;;
;;;orgexportexample;;(require 'session)
;;;orgexportexample;;(require 'ibuffer)
;;;orgexportexample;;(require 'nrepl)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Info initialization
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(require 'info)
;;;orgexportexample;;(info-initialize)
;;;orgexportexample;;
;;;orgexportexample;;(setq Info-refill-paragraphs t)
;;;orgexportexample;;(add-to-list 'Info-directory-list "~/install/git/org-mode/doc/")
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Enable some functions
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(put 'erase-buffer 'disabled nil)
;;;orgexportexample;;(put 'narrow-to-page 'disabled nil)
;;;orgexportexample;;(put 'upcase-region 'disabled nil)
;;;orgexportexample;;(put 'narrow-to-region 'disabled nil)
;;;orgexportexample;;(put 'downcase-region 'disabled nil)
;;;orgexportexample;;(put 'scroll-left 'disabled nil)
;;;orgexportexample;;(put 'scroll-right 'disabled nil)
;;;orgexportexample;;(put 'set-goal-column 'disabled nil)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Appearance
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq custom-file "~/elisp/config/emacs-custom.el")
;;;orgexportexample;;  (load custom-file)
;;;orgexportexample;;
;;;orgexportexample;;  (setq initial-frame-alist
;;;orgexportexample;;        '(;; (left-fringe . 180)
;;;orgexportexample;;          ;; (right-fringe . 180)
;;;orgexportexample;;          (menu-bar-lines . 0)
;;;orgexportexample;;          (tool-bar-lines . 0)
;;;orgexportexample;;          (vertical-scroll-bars . nil)
;;;orgexportexample;;          ;; (background-color . "black")
;;;orgexportexample;;          ;; (foreground-color . "#dddddd")
;;;orgexportexample;;          ))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Theme
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(add-to-list 'custom-theme-load-path "~/install/git/cyberpunk-theme.el/")
;;;orgexportexample;;(load-theme 'cyberpunk)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Fonts
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;;; This is my favorite default font:
;;;orgexportexample;;(set-frame-font "Monospace 11")
;;;orgexportexample;;
;;;orgexportexample;;;; I use this sometimes for reading long blog posts:
;;;orgexportexample;;;; (set-frame-font "Inconsolata 13")
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Startup
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq-default line-spacing 0.2)
;;;orgexportexample;;  (setq fill-column 70)
;;;orgexportexample;;  (setq line-move-visual nil)
;;;orgexportexample;;  (setq show-trailing-whitespace t)
;;;orgexportexample;;  (setq initial-scratch-message "")
;;;orgexportexample;;  (setq initial-major-mode 'org-mode)
;;;orgexportexample;;  (setq inhibit-startup-message t)
;;;orgexportexample;;  (setq inhibit-startup-echo-area-message t)
;;;orgexportexample;;  (setq visible-bell t)
;;;orgexportexample;;  (setq spell-command "aspell")
;;;orgexportexample;;  (setq speedbar-use-images nil)
;;;orgexportexample;;  (setq tab-always-indent 'always)
;;;orgexportexample;;  (setq display-time-mail-string "#")
;;;orgexportexample;;  (setq focus-follows-mouse t)
;;;orgexportexample;;  (setq text-mode-hook '(turn-on-auto-fill text-mode-hook-identify))
;;;orgexportexample;;
;;;orgexportexample;;  ;; (mouse-avoidance-mode 'cat-and-mouse)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Printing
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(setq ps-paper-type 'a4
;;;orgexportexample;;      ps-font-size 7.0
;;;orgexportexample;;      ps-print-header nil
;;;orgexportexample;;      ps-print-color-p nil
;;;orgexportexample;;      ps-landscape-mode nil
;;;orgexportexample;;      ps-number-of-columns 1
;;;orgexportexample;;      ps-auto-font-detect nil
;;;orgexportexample;;      ps-default-bg "white"
;;;orgexportexample;;      ps-default-fg "black"
;;;orgexportexample;;      ps-left-margin 56.69291338582677
;;;orgexportexample;;      ps-print-color-p (quote black-white))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Browser
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;    (if window-system
;;;orgexportexample;;        (setq browse-url-browser-function 'browse-url-generic
;;;orgexportexample;;              ;; (setq browse-url-browser-function 'w3m-browse-url
;;;orgexportexample;;              ;;      browse-url-generic-program "conkeror")
;;;orgexportexample;;              ;; browse-url-generic-program "chromium")
;;;orgexportexample;;              browse-url-generic-program "firefox")
;;;orgexportexample;;      (setq browse-url-browser-function 'w3m-browse-url))
;;;orgexportexample;;    (setq browse-url-text-browser "w3m")
;;;orgexportexample;;
;;;orgexportexample;;  (setq browse-url-firefox-new-window-is-tab t)
;;;orgexportexample;;  (setq browse-url-firefox-program "firefox")
;;;orgexportexample;;  (setq browse-url-new-window-flag t)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Define global keys
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (global-set-key (kbd "C-h :") 'find-function)
;;;orgexportexample;;  (global-set-key (kbd "C-x <C-backspace>") 'bzg-find-bzg)
;;;orgexportexample;;  (global-set-key (kbd "<home>") 'beginning-of-buffer)
;;;orgexportexample;;  (global-set-key (kbd "<end>") 'end-of-buffer)
;;;orgexportexample;;  (global-set-key (kbd "<insert>") (lambda() (interactive) (insert-char ?<)))
;;;orgexportexample;;  (global-set-key (kbd "<deletechar>") (lambda() (interactive) (insert-char ?>)))
;;;orgexportexample;;  (global-set-key (quote [f1]) 'gnus)
;;;orgexportexample;;  (global-set-key (quote [f5]) 'edebug-defun)
;;;orgexportexample;;  (global-set-key (quote [f6]) 'w3m)
;;;orgexportexample;;  (global-set-key (quote [f7]) 'auto-fill-mode)
;;;orgexportexample;;  (global-set-key (quote [f8]) 'occur)
;;;orgexportexample;;  (global-set-key [(shift f8)] 'multi-occur)
;;;orgexportexample;;  (global-set-key (quote [f10]) 'calc)
;;;orgexportexample;;  (global-set-key (quote [f11]) 'eshell)
;;;orgexportexample;;  (global-set-key (kbd "C-&")
;;;orgexportexample;;                  (lambda (arg) (interactive "P")
;;;orgexportexample;;                    (if arg (switch-to-buffer "#twitter_bzg2") (switch-to-buffer "&bitlbee"))))
;;;orgexportexample;;  (global-set-key (kbd "M-+") 'text-scale-increase)
;;;orgexportexample;;  (global-set-key (kbd "M--") 'text-scale-decrease)
;;;orgexportexample;;  (global-set-key (kbd "M-0") 'text-scale-adjust)
;;;orgexportexample;;  (global-set-key (kbd "C-M-]") (lambda () (interactive) (org-cycle t)))
;;;orgexportexample;;  (global-set-key (kbd "M-]")
;;;orgexportexample;;                  (lambda () (interactive)
;;;orgexportexample;;                    (ignore-errors (end-of-defun) (beginning-of-defun)) (org-cycle)))
;;;orgexportexample;;  (global-set-key (kbd "C-x r L") 'register-list)
;;;orgexportexample;;
;;;orgexportexample;;  (define-key global-map "\M-n" 'next-word-at-point)
;;;orgexportexample;;  (define-key global-map "\M-n" 'current-word-search)
;;;orgexportexample;;  (define-key global-map "\M-p" 'previous-word-at-point)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Dired
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(require 'dired)
;;;orgexportexample;;(require 'dired-x)
;;;orgexportexample;;(require 'wdired)
;;;orgexportexample;;
;;;orgexportexample;;(define-key dired-mode-map "\C-cb" 'org-ibuffer)
;;;orgexportexample;;(define-key dired-mode-map "\C-cg" 'grep-find)
;;;orgexportexample;;(define-key dired-mode-map "\C-cd" 'dired-clean-tex)
;;;orgexportexample;;
;;;orgexportexample;;(setq directory-free-space-args "-Pkh")
;;;orgexportexample;;(setq list-directory-verbose-switches "-al")
;;;orgexportexample;;(setq dired-listing-switches "-l")
;;;orgexportexample;;(setq dired-dwim-target t)
;;;orgexportexample;;(setq dired-omit-mode nil)
;;;orgexportexample;;(setq dired-recursive-copies 'always)
;;;orgexportexample;;(setq dired-recursive-deletes 'always)
;;;orgexportexample;;
;;;orgexportexample;;(setq dired-guess-shell-alist-user
;;;orgexportexample;;      (list
;;;orgexportexample;;;;       (list "\\.pdf$" "acroread")
;;;orgexportexample;;       (list "\\.pdf$" "mupdf")
;;;orgexportexample;;       (list "\\.docx?$" "libreoffice")
;;;orgexportexample;;       (list "\\.aup?$" "audacity")
;;;orgexportexample;;       (list "\\.pptx?$" "libreoffice")
;;;orgexportexample;;       (list "\\.odf$" "libreoffice")
;;;orgexportexample;;       (list "\\.odt$" "libreoffice")
;;;orgexportexample;;       (list "\\.odt$" "libreoffice")
;;;orgexportexample;;       (list "\\.kdenlive$" "kdenlive")
;;;orgexportexample;;       (list "\\.svg$" "gimp")
;;;orgexportexample;;       (list "\\.csv$" "libreoffice")
;;;orgexportexample;;       (list "\\.sla$" "scribus")
;;;orgexportexample;;       (list "\\.ods$" "libreoffice")
;;;orgexportexample;;       (list "\\.odp$" "libreoffice")
;;;orgexportexample;;       (list "\\.xls$" "libreoffice")
;;;orgexportexample;;       (list "\\.xlsx$" "libreoffice")
;;;orgexportexample;;       (list "\\.txt$" "gedit")
;;;orgexportexample;;       (list "\\.sql$" "gedit")
;;;orgexportexample;;       (list "\\.css$" "gedit")
;;;orgexportexample;;       (list "\\.html$" "w3m")
;;;orgexportexample;;       (list "\\.jpe?g$" "gqview")
;;;orgexportexample;;       (list "\\.psd$" "gimp")
;;;orgexportexample;;       (list "\\.png$" "gqview")
;;;orgexportexample;;       (list "\\.gif$" "gqview")
;;;orgexportexample;;       (list "\\.odt$" "libreoffice")
;;;orgexportexample;;       (list "\\.xo$" "unzip")
;;;orgexportexample;;       (list "\\.3gp$" "vlc")
;;;orgexportexample;;       (list "\\.mp3$" "vlc")
;;;orgexportexample;;       (list "\\.flac$" "vlc")
;;;orgexportexample;;       (list "\\.avi$" "mplayer -fs")
;;;orgexportexample;;       ;; (list "\\.og[av]$" "vlc")
;;;orgexportexample;;       (list "\\.wmv$" "vlc")
;;;orgexportexample;;       (list "\\.flv$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.mov$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.divx$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.mp4$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.mkv$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.mpe?g$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.m4[av]$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.mp2$" "vlc")
;;;orgexportexample;;       (list "\\.pp[st]$" "libreoffice")
;;;orgexportexample;;       (list "\\.ogg$" "vlc")
;;;orgexportexample;;       (list "\\.ogv$" "mplayer -fs")
;;;orgexportexample;;       (list "\\.rtf$" "libreoffice")
;;;orgexportexample;;       (list "\\.ps$" "gv")
;;;orgexportexample;;       (list "\\.mp3$" "play")
;;;orgexportexample;;       (list "\\.wav$" "vlc")
;;;orgexportexample;;       (list "\\.rar$" "unrar x")
;;;orgexportexample;;       ))
;;;orgexportexample;;
;;;orgexportexample;;(setq dired-tex-unclean-extensions
;;;orgexportexample;;  '(".toc" ".log" ".aux" ".dvi" ".out" ".nav" ".snm"))
;;;orgexportexample;;
;;;orgexportexample;;(setq inferior-lisp-program "sbcl")
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Org
;;;orgexportexample;;
;;;orgexportexample;;** Org initialization and hooks
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (require 'org)
;;;orgexportexample;;  (require 'ox-latex)
;;;orgexportexample;;  (require 'ox-koma-letter)
;;;orgexportexample;;
;;;orgexportexample;;  ;; Hook to update all blocks before saving
;;;orgexportexample;;  (add-hook 'org-mode-hook
;;;orgexportexample;;            (lambda() (add-hook 'before-save-hook
;;;orgexportexample;;                                'org-update-all-dblocks t t)))
;;;orgexportexample;;
;;;orgexportexample;;  ;; Hook to display dormant article in Gnus
;;;orgexportexample;;  (add-hook 'org-follow-link-hook
;;;orgexportexample;;            (lambda ()
;;;orgexportexample;;              (if (eq major-mode 'gnus-summary-mode)
;;;orgexportexample;;                  (gnus-summary-insert-dormant-articles))))
;;;orgexportexample;;
;;;orgexportexample;;  (add-hook 'org-mode-hook (lambda () (imenu-add-to-menubar "Imenu")))
;;;orgexportexample;;
;;;orgexportexample;;  (add-hook 'org-follow-link-hook
;;;orgexportexample;;            (lambda () (if (eq major-mode 'gnus-summary-mode)
;;;orgexportexample;;                           (gnus-summary-insert-dormant-articles))))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org keys
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (define-key global-map "\C-cl" 'org-store-link)
;;;orgexportexample;;  (define-key global-map "\C-cL" 'org-occur-link-in-agenda-files)
;;;orgexportexample;;  (define-key global-map "\C-ca" 'org-agenda)
;;;orgexportexample;;  (define-key global-map "\C-cc" 'org-capture)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org babel
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (org-babel-do-load-languages
;;;orgexportexample;;   'org-babel-load-languages
;;;orgexportexample;;   '((emacs-lisp . t)
;;;orgexportexample;;     (sh . t)
;;;orgexportexample;;     (dot . t)
;;;orgexportexample;;     (clojure . t)
;;;orgexportexample;;     (org . t)
;;;orgexportexample;;     (ditaa . t)
;;;orgexportexample;;     (org . t)
;;;orgexportexample;;  ;;   (ledger . t)
;;;orgexportexample;;     (scheme . t)
;;;orgexportexample;;     (plantuml . t)
;;;orgexportexample;;     (R . t)
;;;orgexportexample;;     (gnuplot . t)))
;;;orgexportexample;;
;;;orgexportexample;;  (org-clock-persistence-insinuate)
;;;orgexportexample;;
;;;orgexportexample;;  (appt-activate t)
;;;orgexportexample;;
;;;orgexportexample;;  (setq display-time-24hr-format t)
;;;orgexportexample;;  (setq display-time-day-and-date t)
;;;orgexportexample;;
;;;orgexportexample;;  (setq appt-audible nil
;;;orgexportexample;;        appt-display-interval 10
;;;orgexportexample;;        appt-message-warning-time 120)
;;;orgexportexample;;
;;;orgexportexample;;    (setq org-babel-default-header-args
;;;orgexportexample;;          '((:session . "none")
;;;orgexportexample;;            (:results . "replace")
;;;orgexportexample;;            (:exports . "code")
;;;orgexportexample;;            (:cache . "no")
;;;orgexportexample;;            (:noweb . "yes")
;;;orgexportexample;;            (:hlines . "no")
;;;orgexportexample;;            (:tangle . "no")
;;;orgexportexample;;            (:padnewline . "yes")))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org agenda
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq org-agenda-bulk-mark-char "*")
;;;orgexportexample;;  (setq org-agenda-diary-file "/home/guerry/org/rdv.org")
;;;orgexportexample;;  (setq org-agenda-dim-blocked-tasks nil)
;;;orgexportexample;;  (setq org-agenda-entry-text-maxlines 10)
;;;orgexportexample;;  (setq org-agenda-file-regexp "\\.org\\'")
;;;orgexportexample;;  (setq org-agenda-files '("~/org/org.org" "~/org/rdv.org" "~/org/bzg.org" "~/org/kickhub.org" "~/org/clojure.org"))
;;;orgexportexample;;  (setq org-agenda-files '("~/org/rdv.org" "~/org/bzg.org" "~/org/kickhub.org" "~/org/clojure.org"))
;;;orgexportexample;;  (setq org-agenda-include-diary nil)
;;;orgexportexample;;  (setq org-agenda-prefix-format '((agenda . " %i %-12:c%?-14t%s") (timeline . "  % s") (todo . " %i %-14:c") (tags . " %i %-14:c") (search . " %i %-14:c")))
;;;orgexportexample;;  (setq org-agenda-remove-tags t)
;;;orgexportexample;;  (setq org-agenda-restore-windows-after-quit t)
;;;orgexportexample;;  (setq org-agenda-show-inherited-tags nil)
;;;orgexportexample;;  (setq org-agenda-skip-deadline-if-done t)
;;;orgexportexample;;  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
;;;orgexportexample;;  (setq org-agenda-skip-scheduled-if-done t)
;;;orgexportexample;;  (setq org-agenda-skip-timestamp-if-done t)
;;;orgexportexample;;  (setq org-agenda-sorting-strategy '((agenda time-up) (todo time-up) (tags time-up) (search time-up)))
;;;orgexportexample;;  (setq org-agenda-start-on-weekday 1)
;;;orgexportexample;;  (setq org-agenda-sticky nil)
;;;orgexportexample;;  (setq org-agenda-tags-todo-honor-ignore-options t)
;;;orgexportexample;;  (setq org-agenda-text-search-extra-files '("~/org/clojure.org"))
;;;orgexportexample;;  (setq org-agenda-use-tag-inheritance nil)
;;;orgexportexample;;  (setq org-agenda-window-frame-fractions '(0.0 . 0.5))
;;;orgexportexample;;  (setq org-agenda-deadline-faces
;;;orgexportexample;;        '((1.0001 . org-warning)              ; due yesterday or before
;;;orgexportexample;;          (0.0    . org-upcoming-deadline)))  ; due today or later
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org agenda custom commands
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq org-agenda-custom-commands
;;;orgexportexample;;        `(
;;;orgexportexample;;
;;;orgexportexample;;          ;; list of WP tasks for today
;;;orgexportexample;;          (" " "Aujourd'hui" agenda "List of rendez-vous and tasks for today"
;;;orgexportexample;;           ((org-agenda-span 1)
;;;orgexportexample;;            (org-agenda-files '("~/org/rdv.org" "~/org/bzg.org"))
;;;orgexportexample;;            (org-deadline-warning-days 10)
;;;orgexportexample;;            (org-agenda-sorting-strategy
;;;orgexportexample;;             '(todo-state-up time-up priority-up))))
;;;orgexportexample;;
;;;orgexportexample;;          ;; list of WP tasks for today
;;;orgexportexample;;          ("%" "Rendez-vous" agenda* "Week RDV"
;;;orgexportexample;;           ((org-agenda-span 'week)
;;;orgexportexample;;            (org-agenda-files '("~/org/rdv.org"))
;;;orgexportexample;;            (org-deadline-warning-days 10)
;;;orgexportexample;;            (org-agenda-sorting-strategy
;;;orgexportexample;;             '(todo-state-up time-up priority-up))))
;;;orgexportexample;;
;;;orgexportexample;;          ("n" todo "NEXT|TODO"
;;;orgexportexample;;           (;; (org-agenda-max-tags -1)
;;;orgexportexample;;            (org-agenda-sorting-strategy
;;;orgexportexample;;             '(timestamp-up))
;;;orgexportexample;;            (org-agenda-max-entries 7)
;;;orgexportexample;;            )) ;; todo-state-up time-up priority-up))))
;;;orgexportexample;;
;;;orgexportexample;;          ("x" "Scheduled all" agenda "List of scheduled tasks for today"
;;;orgexportexample;;           ((org-agenda-span 1)
;;;orgexportexample;;            (org-agenda-entry-types '(:timestamp :scheduled))
;;;orgexportexample;;            (org-agenda-sorting-strategy
;;;orgexportexample;;             '(time-up todo-state-up priority-up))))
;;;orgexportexample;;
;;;orgexportexample;;          ;; list of WP tasks for today
;;;orgexportexample;;          ("X" "Upcoming deadlines" agenda "List of past and upcoming deadlines"
;;;orgexportexample;;           ((org-agenda-span 1)
;;;orgexportexample;;            (org-deadline-warning-days 15)
;;;orgexportexample;;            (org-agenda-entry-types '(:deadline))
;;;orgexportexample;;            (org-agenda-sorting-strategy
;;;orgexportexample;;             '(time-up todo-state-up priority-up))))
;;;orgexportexample;;
;;;orgexportexample;;          ;; list of Old deadlines
;;;orgexportexample;;          ("Y" tags-todo "+SCHEDULED<=\"<now>\"")
;;;orgexportexample;;          ("Z" tags-todo "+DEADLINE<=\"<now>\"")
;;;orgexportexample;;
;;;orgexportexample;;          ;; Everything that has a "Read" tag
;;;orgexportexample;;          ("r" . "Read")
;;;orgexportexample;;          ("rr" tags-todo "+Read+TODO={TODO\\|NEXT}" nil)
;;;orgexportexample;;          ("r," tags-todo "+Read/STRT" nil)
;;;orgexportexample;;          ("rF" tags "+Read+@Offline" nil)
;;;orgexportexample;;
;;;orgexportexample;;          ;; Everything that has a "Write" tag
;;;orgexportexample;;          ("w" . "write")
;;;orgexportexample;;          ("ww" tags-todo "+Write/NEXT|TODO|STRT" nil)
;;;orgexportexample;;          ("w," tags-todo "+Write/STRT" nil)
;;;orgexportexample;;          ("wt" tags-tree "+Write/STRT" nil)
;;;orgexportexample;;          ("w;" tags-todo "+Write+@Offline" nil)
;;;orgexportexample;;
;;;orgexportexample;;          ;; Everything that has a "Write" tag
;;;orgexportexample;;          ("c" . "Code")
;;;orgexportexample;;          ("cc" tags-todo "+Code/NEXT|TODO|STRT" nil)
;;;orgexportexample;;          ("c," tags-todo "+Code/STRT" nil)
;;;orgexportexample;;          ))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org capture templates
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq org-capture-templates
;;;orgexportexample;;        ;; for org/rdv.org
;;;orgexportexample;;        '(
;;;orgexportexample;;
;;;orgexportexample;;          ;; for org/rdv.org
;;;orgexportexample;;          ("r" "Bzg RDV" entry (file+headline "~/org/rdv.org" "RDV")
;;;orgexportexample;;           "* %a :RDV:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i%?" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ;; Basement et garden
;;;orgexportexample;;          ("b" "Basement" entry (file+headline "~/org/bzg.org" "Basement")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ;; Basement et garden
;;;orgexportexample;;          ("C" "Coursera" entry (file+headline "~/org/bzg.org" "Coursera")
;;;orgexportexample;;           "* NEXT %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ("g" "Garden" entry (file+headline "~/org/garden.org" "Garden")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ;; Boite (lml) et cours
;;;orgexportexample;;          ("b" "Bo챤te" entry (file+headline "~/org/bzg.org" "Bo챤te")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ("c" "Cours" entry (file+headline "~/org/bzg.org" "Cours")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ("O" "OLPC" entry (file+headline "~/org/libre.org" "OLPC")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ("e" "Emacs" entry (file+headline "~/org/libre.org" "Emacs")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend nil)
;;;orgexportexample;;
;;;orgexportexample;;          ("w" "Wikipedia" entry (file+headline "~/org/libre.org" "Wikipedia")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ("i" "ITIC" entry (file+headline "~/org/libre.org" "itic")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ("k" "Krowdfounding" entry (file+headline "~/org/bzg.org" "Kickhub")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ("s" "Spark" entry (file+headline "~/org/bzg.org" "Spark")
;;;orgexportexample;;           "* TODO %?%a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;
;;;orgexportexample;;          ;; Informations
;;;orgexportexample;;          ("I" "Information")
;;;orgexportexample;;          ("Ir" "Information read" entry (file+headline "~/org/garden.org" "Infos")
;;;orgexportexample;;           "* TODO %?%a :Read:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;          ("IR" "Information read (!)" entry (file+headline "~/org/garden.org" "Infos")
;;;orgexportexample;;           "* TODO %?%a :Read:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t :immediate-finish t)
;;;orgexportexample;;          ("Ic" "Information read (clocking)" entry (file+headline "~/org/garden.org" "Infos")
;;;orgexportexample;;           "* TODO %?%a :Read:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t :clock-in t)
;;;orgexportexample;;          ("IC" "Information read (keep clocking)" entry (file+headline "~/org/garden.org" "Infos")
;;;orgexportexample;;           "* TODO %?%a :Read:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i"
;;;orgexportexample;;           :prepend t :clock-in t :immediate-finish t :clock-keep t :jump-to-captured t)
;;;orgexportexample;;
;;;orgexportexample;;          ("o" "Org")
;;;orgexportexample;;          ("of" "Org FR" entry (file+headline "~/org/org.org" "Current ideas")
;;;orgexportexample;;           "* TODO %?%a :Code:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;          ("ob" "Org Bug" entry (file+headline "~/org/org.org" "Mailing list")
;;;orgexportexample;;           "* NEXT %?%a :Bug:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;          ("op" "Org Patch" entry (file+headline "~/org/org.org" "Mailing list")
;;;orgexportexample;;           "* NEXT [#A] %?%a :Patch:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;          ("ow" "Worg" entry (file+headline "~/org/org.org" "Worg")
;;;orgexportexample;;           "* TODO [#A] %?%a :Worg:\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n%i" :prepend t)
;;;orgexportexample;;          ))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org export
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq org-export-default-language "fr")
;;;orgexportexample;;  (setq org-export-backends '(latex odt icalendar html ascii rss koma-letter))
;;;orgexportexample;;  (setq org-export-highlight-first-table-line t)
;;;orgexportexample;;  (setq org-export-html-extension "html")
;;;orgexportexample;;  (setq org-export-html-with-timestamp nil)
;;;orgexportexample;;  (setq org-export-skip-text-before-1st-heading nil)
;;;orgexportexample;;  (setq org-export-with-LaTeX-fragments t)
;;;orgexportexample;;  (setq org-export-with-archived-trees nil)
;;;orgexportexample;;  (setq org-export-with-drawers '("HIDE"))
;;;orgexportexample;;  (setq org-export-with-section-numbers nil)
;;;orgexportexample;;  (setq org-export-with-sub-superscripts '{})
;;;orgexportexample;;  (setq org-export-with-tags 'not-in-toc)
;;;orgexportexample;;  (setq org-export-with-timestamps t)
;;;orgexportexample;;  (setq org-html-head "")
;;;orgexportexample;;  (setq org-html-head-include-default-style nil)
;;;orgexportexample;;  (setq org-export-with-toc nil)
;;;orgexportexample;;  (setq org-export-with-priority t)
;;;orgexportexample;;  (setq org-export-dispatch-use-expert-ui nil)
;;;orgexportexample;;  (setq org-export-babel-evaluate t)
;;;orgexportexample;;  (setq org-export-taskjuggler-default-project-duration 2000)
;;;orgexportexample;;  (setq org-export-taskjuggler-target-version 3.0)
;;;orgexportexample;;  (setq org-export-latex-listings 'minted)
;;;orgexportexample;;  (setq org-export-allow-BIND-local t)
;;;orgexportexample;;  (setq org-publish-list-skipped-files nil)
;;;orgexportexample;;
;;;orgexportexample;;  (add-to-list 'org-latex-classes
;;;orgexportexample;;               '("my-letter"
;;;orgexportexample;;                 "\\documentclass\{scrlttr2\}
;;;orgexportexample;;          \\usepackage[english,frenchb]{babel}
;;;orgexportexample;;          \[NO-DEFAULT-PACKAGES]
;;;orgexportexample;;          \[NO-PACKAGES]
;;;orgexportexample;;          \[EXTRA]"))
;;;orgexportexample;;
;;;orgexportexample;;  (setq org-fast-tag-selection-single-key 'expert)
;;;orgexportexample;;  (setq org-fontify-done-headline t)
;;;orgexportexample;;  (setq org-fontify-emphasized-text t)
;;;orgexportexample;;  (setq org-footnote-auto-label 'confirm)
;;;orgexportexample;;  (setq org-footnote-auto-adjust t)
;;;orgexportexample;;  (setq org-footnote-define-inline nil)
;;;orgexportexample;;  (setq org-hide-emphasis-markers nil)
;;;orgexportexample;;  (setq org-icalendar-include-todo 'all)
;;;orgexportexample;;  (setq org-list-indent-offset 0)
;;;orgexportexample;;  (setq org-link-frame-setup '((gnus . gnus) (file . find-file-other-window)))
;;;orgexportexample;;  (setq org-link-mailto-program '(browse-url-mail "mailto:%a?subject=%s"))
;;;orgexportexample;;  (setq org-log-note-headings '((done . "CLOSING NOTE %t") (state . "State %-12s %t") (clock-out . "")))
;;;orgexportexample;;  (setq org-priority-start-cycle-with-default nil)
;;;orgexportexample;;  (setq org-refile-targets '((org-agenda-files . (:maxlevel . 3))
;;;orgexportexample;;                                     (("~/org/garden.org") . (:maxlevel . 3))
;;;orgexportexample;;                                     (("~/org/libre.org") . (:maxlevel . 3))))
;;;orgexportexample;;  (setq org-refile-use-outline-path t)
;;;orgexportexample;;  (setq org-refile-use-cache t)
;;;orgexportexample;;  (setq org-return-follows-link t)
;;;orgexportexample;;  (setq org-reverse-note-order t)
;;;orgexportexample;;  (setq org-scheduled-past-days 100)
;;;orgexportexample;;  (setq org-show-following-heading '((default nil) (occur-tree t)))
;;;orgexportexample;;  (setq org-show-hierarchy-above '((default nil) (tags-tree . t)))
;;;orgexportexample;;  (setq org-special-ctrl-a/e 'reversed)
;;;orgexportexample;;  (setq org-special-ctrl-k t)
;;;orgexportexample;;  (setq org-stuck-projects '("+LEVEL=1" ("NEXT" "TODO" "DONE")))
;;;orgexportexample;;  (setq org-tag-alist
;;;orgexportexample;;        '((:startgroup . nil)
;;;orgexportexample;;          ("Write" . ?w) ("Trad" . ?t) ("Read" . ?r) ("RDV" . ?R) ("View" . ?v) ("Listen" . ?l)
;;;orgexportexample;;          (:endgroup . nil)
;;;orgexportexample;;          (:startgroup . nil) ("@Online" . ?O) ("@Offline" . ?F)
;;;orgexportexample;;          (:endgroup . nil)
;;;orgexportexample;;          ("Print" . ?P) ("Code" . ?c) ("Patch" . ?p) ("Bug" . ?b) ("Twit" . ?i) ("Tel" . ?T) ("Buy" . ?B) ("Doc" . ?d) ("Mail" . ?@)))
;;;orgexportexample;;  (setq org-tags-column -74)
;;;orgexportexample;;  (setq org-tags-match-list-sublevels t)
;;;orgexportexample;;  (setq org-todo-keywords '((type "NEXT" "TODO" "STRT" "WAIT" "|" "DONE" "DELEGATED" "CANCELED")))
;;;orgexportexample;;  (setq org-use-property-inheritance t)
;;;orgexportexample;;  (setq org-clock-persist t)
;;;orgexportexample;;  (setq org-clock-history-length 35)
;;;orgexportexample;;  (setq org-clock-in-resume t)
;;;orgexportexample;;  (setq org-clock-out-remove-zero-time-clocks t)
;;;orgexportexample;;  (setq org-clock-sound t)
;;;orgexportexample;;  (setq org-insert-heading-respect-content t)
;;;orgexportexample;;  (setq org-id-method 'uuidgen)
;;;orgexportexample;;  (setq org-combined-agenda-icalendar-file "~/org/bzg.ics")
;;;orgexportexample;;  (setq org-icalendar-combined-name "Bastien Guerry ORG")
;;;orgexportexample;;  (setq org-icalendar-use-scheduled '(todo-start event-if-todo event-if-not-todo))
;;;orgexportexample;;  (setq org-icalendar-use-deadline '(todo-due event-if-todo event-if-not-todo))
;;;orgexportexample;;  (setq org-icalendar-timezone "Europe/Paris")
;;;orgexportexample;;  (setq org-icalendar-store-UID t)
;;;orgexportexample;;  (setq org-timer-default-timer 20)
;;;orgexportexample;;  (setq org-confirm-babel-evaluate nil)
;;;orgexportexample;;  (setq org-archive-default-command 'org-archive-to-archive-sibling)
;;;orgexportexample;;  (setq org-clock-idle-time 15)
;;;orgexportexample;;  (setq org-id-uuid-program "uuidgen")
;;;orgexportexample;;  (setq org-modules '(org-bbdb org-bibtex org-docview org-gnus org-id org-protocol org-info org-jsinfo org-irc org-w3m org-taskjuggler org-learn))
;;;orgexportexample;;  (setq org-use-speed-commands
;;;orgexportexample;;        (lambda nil
;;;orgexportexample;;          (and (looking-at org-outline-regexp-bol)
;;;orgexportexample;;               (not (org-in-src-block-p t)))))
;;;orgexportexample;;  (setq org-src-tab-acts-natively t)
;;;orgexportexample;;  (setq org-hide-block-startup t)
;;;orgexportexample;;  (setq org-highlight-latex-and-related '(latex))
;;;orgexportexample;;  (setq org-log-into-drawer "LOGBOOK")
;;;orgexportexample;;  (setq org-goto-auto-isearch nil)
;;;orgexportexample;;  (setq org-beamer-outline-frame-title "Survol")
;;;orgexportexample;;  (setq org-image-actual-width 600)
;;;orgexportexample;;  (setq org-refile-allow-creating-parent-nodes t)
;;;orgexportexample;;  (setq org-src-fontify-natively t)
;;;orgexportexample;;  (setq org-todo-keyword-faces '(("STRT" . "lightgoldenrod1")
;;;orgexportexample;;                                 ("NEXT" . "Cyan3")
;;;orgexportexample;;                                 ("WAIT" . "lightgoldenrod3")))
;;;orgexportexample;;
;;;orgexportexample;;  (setq org-plantuml-jar-path "~/bin/plantuml.jar")
;;;orgexportexample;;  (setq org-link-abbrev-alist
;;;orgexportexample;;        '(("bugzilla" . "http://10.1.2.9/bugzilla/show_bug.cgi?id=")
;;;orgexportexample;;          ("google"   . "http://www.google.com/search?q=%s")
;;;orgexportexample;;          ("gmap"     . "http://maps.google.com/maps?q=%s")
;;;orgexportexample;;          ("omap"     . "http://nominatim.openstreetmap.org/search?q=%s&polygon=1")
;;;orgexportexample;;          ("ads"      . "http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?author=%s&db_key=AST")))
;;;orgexportexample;;
;;;orgexportexample;;  (setq org-attach-directory "~/org/data/")
;;;orgexportexample;;  (setq org-link-display-descriptive nil)
;;;orgexportexample;;  (setq org-loop-over-headlines-in-active-region t)
;;;orgexportexample;;  (setq org-create-formula-image-program 'dvipng) ;; imagemagick
;;;orgexportexample;;  (setq org-allow-promoting-top-level-subtree t)
;;;orgexportexample;;  (setq org-description-max-indent 5)
;;;orgexportexample;;  (setq org-gnus-prefer-web-links nil)
;;;orgexportexample;;  (setq org-html-head-include-default-style nil)
;;;orgexportexample;;  (setq org-html-head-include-scripts nil)
;;;orgexportexample;;  (setq org-blank-before-new-entry '((heading . auto) (plain-list-item . auto)))
;;;orgexportexample;;  (setq org-contacts-files '("~/org/contacts.org"))
;;;orgexportexample;;  (setq org-crypt-key "Bastien Guerry")
;;;orgexportexample;;  (setq org-enforce-todo-dependencies t)
;;;orgexportexample;;  (setq org-mobile-directory "~/Dropbox/org/")
;;;orgexportexample;;  (setq org-mobile-files '("~/Dropbox/org/" "~/org/from-mobile.org"))
;;;orgexportexample;;  (setq org-fontify-whole-heading-line t)
;;;orgexportexample;;  (setq org-file-apps
;;;orgexportexample;;    '((auto-mode . emacs)
;;;orgexportexample;;      ("\\.mm\\'" . default)
;;;orgexportexample;;      ("\\.x?html?\\'" . default)
;;;orgexportexample;;      ("\\.pdf\\'" . "mupdf %s")))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org publish project alist
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(setq org-publish-project-alist
;;;orgexportexample;;      `(
;;;orgexportexample;;	("cours"
;;;orgexportexample;;	 :base-directory "~/install/git/CoursCreationSiteWeb/"
;;;orgexportexample;;	 :base-extension "org"
;;;orgexportexample;;	 :publishing-directory "~/public_html/org/homepage/cours-creation-site-web/"
;;;orgexportexample;;	 :publishing-function org-html-publish-to-html
;;;orgexportexample;;	 :auto-sitemap nil
;;;orgexportexample;;	 :makeindex t
;;;orgexportexample;;	 :section-numbers nil
;;;orgexportexample;;	 :with-toc nil
;;;orgexportexample;;	 :html-head "<link rel=\"stylesheet\" href=\"http://lumiere.ens.fr/~guerry/u/org.css\" type=\"text/css\" />"
;;;orgexportexample;;	 :html-preamble nil
;;;orgexportexample;;	 :html-postamble
;;;orgexportexample;;	 "<div id=\"disqus_thread\"></div>
;;;orgexportexample;;<script type=\"text/javascript\">
;;;orgexportexample;;    var disqus_shortname = 'coursdecrationdesitewebscriptparis7';
;;;orgexportexample;;    (function() {
;;;orgexportexample;;        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
;;;orgexportexample;;        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
;;;orgexportexample;;        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
;;;orgexportexample;;    })();
;;;orgexportexample;;</script>")
;;;orgexportexample;;	("cours-images"
;;;orgexportexample;;	 :base-directory "~/install/git/CoursCreationSiteWeb/images/"
;;;orgexportexample;;	 :base-extension "png\\|jpg\\|gif"
;;;orgexportexample;;	 :publishing-directory "~/public_html/org/homepage/cours-creation-site-web/images/"
;;;orgexportexample;;	 :publishing-function org-publish-attachment)
;;;orgexportexample;;
;;;orgexportexample;;	("dotemacs"
;;;orgexportexample;;	 :base-directory "~/install/git/dotemacs/"
;;;orgexportexample;;	 :html-extension "html"
;;;orgexportexample;;	 :base-extension "org"
;;;orgexportexample;;	 :publishing-directory "/home/guerry/public_html/org/homepage/"
;;;orgexportexample;;	 :publishing-function (org-html-publish-to-html)
;;;orgexportexample;;	 :auto-sitemap nil
;;;orgexportexample;;	 :recursive t
;;;orgexportexample;;	 :makeindex nil
;;;orgexportexample;;	 :preserve-breaks nil
;;;orgexportexample;;	 :sitemap-sort-files chronologically
;;;orgexportexample;;	 :section-numbers nil
;;;orgexportexample;;	 :with-toc nil
;;;orgexportexample;;	 :html-head-extra "<link rel=\"stylesheet\" href=\"http://lumiere.ens.fr/~guerry/u/org.css\" type=\"text/css\" />"
;;;orgexportexample;;	 :html-preamble "<script src=\"http://www.google-analytics.com/urchin.js\" type=\"text/javascript\">
;;;orgexportexample;;</script>
;;;orgexportexample;;<script type=\"text/javascript\">
;;;orgexportexample;;_uacct = \"UA-2658857-1\";
;;;orgexportexample;;urchinTracker();
;;;orgexportexample;;</script>"
;;;orgexportexample;;	 :htmlized-source t
;;;orgexportexample;;	 :html-postamble nil)
;;;orgexportexample;;
;;;orgexportexample;;	("homepage"
;;;orgexportexample;;	 :base-directory "~/install/git/homepage/"
;;;orgexportexample;;	 :html-extension "html"
;;;orgexportexample;;	 :base-extension "org"
;;;orgexportexample;;	 :publishing-directory "/home/guerry/public_html/org/homepage/"
;;;orgexportexample;;	 :publishing-function (org-html-publish-to-html)
;;;orgexportexample;;	 :auto-sitemap nil
;;;orgexportexample;;	 :recursive t
;;;orgexportexample;;	 :makeindex t
;;;orgexportexample;;	 :preserve-breaks nil
;;;orgexportexample;;	 :sitemap-sort-files chronologically
;;;orgexportexample;;	 :section-numbers nil
;;;orgexportexample;;	 :with-toc nil
;;;orgexportexample;;	 :html-head-extra "<link rel=\"stylesheet\" href=\"http://lumiere.ens.fr/~guerry/u/org.css\" type=\"text/css\" />"
;;;orgexportexample;;	 :html-preamble "<script src=\"http://www.google-analytics.com/urchin.js\" type=\"text/javascript\">
;;;orgexportexample;;</script>
;;;orgexportexample;;<script type=\"text/javascript\">
;;;orgexportexample;;_uacct = \"UA-2658857-1\";
;;;orgexportexample;;urchinTracker();
;;;orgexportexample;;</script>"
;;;orgexportexample;;	 :htmlized-source t
;;;orgexportexample;;	 :html-postamble nil)
;;;orgexportexample;;	("homepagerss"
;;;orgexportexample;;	 :base-directory "~/install/git/homepage/"
;;;orgexportexample;;	 :base-extension "org"
;;;orgexportexample;;	 :html-link-home "http://lumiere.ens.fr/~guerry/"
;;;orgexportexample;;	 :publishing-directory "/home/guerry/public_html/org/homepage/"
;;;orgexportexample;;	 :publishing-function (org-rss-publish-to-rss)
;;;orgexportexample;;	 :section-numbers nil
;;;orgexportexample;;	 :exclude ".*"
;;;orgexportexample;;	 :include ("blog.org")
;;;orgexportexample;;	 :with-toc nil)
;;;orgexportexample;;        ("homepage-attachments"
;;;orgexportexample;;	 :base-directory "~/install/git/homepage"
;;;orgexportexample;;	 :base-extension "png\\|jpg\\|gif\\|atom"
;;;orgexportexample;;	 :publishing-directory "/home/guerry/public_html/org/homepage/u/"
;;;orgexportexample;;	 :publishing-function org-publish-attachment)
;;;orgexportexample;;
;;;orgexportexample;;	("dll"
;;;orgexportexample;;	 :base-directory "~/install/git/dunlivrelautre/"
;;;orgexportexample;;	 :html-extension "html"
;;;orgexportexample;;	 :base-extension "org"
;;;orgexportexample;;	 :publishing-directory "/home/guerry/public_html/org/dunlivrelautre/"
;;;orgexportexample;;	 :publishing-function (org-html-publish-to-html)
;;;orgexportexample;;	 :auto-sitemap nil
;;;orgexportexample;;	 :recursive t
;;;orgexportexample;;	 :makeindex t
;;;orgexportexample;;	 :preserve-breaks nil
;;;orgexportexample;;	 :sitemap-sort-files chronologically
;;;orgexportexample;;	 :section-numbers nil
;;;orgexportexample;;	 :with-toc nil
;;;orgexportexample;;	 :html-head-extra "<link rel=\"stylesheet\" href=\"http://lumiere.ens.fr/~guerry/u/org.css\" type=\"text/css\" />"
;;;orgexportexample;;	 :html-preamble nil
;;;orgexportexample;;	 :htmlized-source t
;;;orgexportexample;;	 :html-postamble nil)
;;;orgexportexample;;	("dllrss"
;;;orgexportexample;;	 :base-directory "~/install/git/dunlivrelautre/"
;;;orgexportexample;;	 :base-extension "org"
;;;orgexportexample;;	 :html-link-home "http://lumiere.ens.fr/~guerry/"
;;;orgexportexample;;	 :publishing-directory "/home/guerry/public_html/org/dunlivrelautre/"
;;;orgexportexample;;	 :publishing-function (org-rss-publish-to-rss)
;;;orgexportexample;;	 :section-numbers nil
;;;orgexportexample;;	 :exclude ".*"
;;;orgexportexample;;	 :include ("blog.org")
;;;orgexportexample;;	 :with-toc nil)
;;;orgexportexample;;        ("dll-attachments"
;;;orgexportexample;;	 :base-directory "~/install/git/dunlivrelautre"
;;;orgexportexample;;	 :base-extension "png\\|jpg\\|gif\\|atom"
;;;orgexportexample;;	 :publishing-directory "/home/guerry/public_html/org/dunlivrelautre/u/"
;;;orgexportexample;;	 :publishing-function org-publish-attachment)
;;;orgexportexample;;
;;;orgexportexample;;	;; Meta projects
;;;orgexportexample;;	("hp" :components ("homepage" "homepage-attachments" "homepagerss" "homepage_articles"))
;;;orgexportexample;;	("dll" :components ("dll" "dll-attachments" "dllrss" "dll_articles"))
;;;orgexportexample;;	("CoursWeb" :components ("cours" "cours-images"))
;;;orgexportexample;;	))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Org other variables
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  ;; Generic / unsorted
;;;orgexportexample;;  (setq org-global-properties
;;;orgexportexample;;        '(("Effort_ALL" . "0 0:10 0:20 0:30 0:40 0:50 1:00 1:30 2:00 2:30 3:00 4:00 5:00 6:00 7:00 8:00")
;;;orgexportexample;;          ("Progress_ALL" . "10% 20% 30% 40% 50% 60% 70% 80% 90%")
;;;orgexportexample;;          ("Status_ALL" . "Work Leisure GTD WOT")))
;;;orgexportexample;;
;;;orgexportexample;;  (setq org-confirm-elisp-link-function nil)
;;;orgexportexample;;  (setq org-confirm-shell-link-function nil)
;;;orgexportexample;;  (setq org-context-in-file-links t)
;;;orgexportexample;;  (setq org-cycle-include-plain-lists nil)
;;;orgexportexample;;  (setq org-deadline-warning-days 7)
;;;orgexportexample;;  (setq org-default-notes-file "~/org/notes.org")
;;;orgexportexample;;  (setq org-directory "~/org/")
;;;orgexportexample;;  (setq org-ellipsis nil)
;;;orgexportexample;;  (setq org-email-link-description-format "%c: %.50s")
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Gnus
;;;orgexportexample;;
;;;orgexportexample;;** Gnus general
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(require 'message)
;;;orgexportexample;;(require 'gnus)
;;;orgexportexample;;(require 'bbdb-config)
;;;orgexportexample;;(require 'starttls)
;;;orgexportexample;;(require 'epg)
;;;orgexportexample;;(require 'epa)
;;;orgexportexample;;(setq epa-popup-info-window nil)
;;;orgexportexample;;
;;;orgexportexample;;(require 'smtpmail)
;;;orgexportexample;;(require 'spam)
;;;orgexportexample;;
;;;orgexportexample;;(setq spam-use-spamassassin t)
;;;orgexportexample;;(setq spam-spamassassin-path "/usr/bin/spamassassin")
;;;orgexportexample;;(setq spam-use-spamassassin-headers t)
;;;orgexportexample;;(setq smiley-style 'medium)
;;;orgexportexample;;
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Set sendmail function and Gnus methods
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (require 'boxquote)
;;;orgexportexample;;
;;;orgexportexample;;  (setq send-mail-function 'sendmail-send-it)
;;;orgexportexample;;  (setq message-send-mail-function 'message-send-mail-with-sendmail)
;;;orgexportexample;;
;;;orgexportexample;;  (setq use-dialog-box nil)
;;;orgexportexample;;  (setq user-full-name "Bastien Guerry")
;;;orgexportexample;;  (setq user-mail-address "bzg@altern.org")
;;;orgexportexample;;
;;;orgexportexample;;  (setq mail-header-separator "----")
;;;orgexportexample;;  (setq mail-source-delete-incoming nil)
;;;orgexportexample;;  (setq mail-specify-envelope-from t)
;;;orgexportexample;;  (setq mail-use-rfc822 nil)
;;;orgexportexample;;
;;;orgexportexample;;  (setq message-cite-function (quote message-cite-original-without-signature))
;;;orgexportexample;;  (setq message-default-charset (quote utf-8))
;;;orgexportexample;;  (setq message-generate-headers-first t)
;;;orgexportexample;;
;;;orgexportexample;;  ;; Attachments
;;;orgexportexample;;  (setq mm-content-transfer-encoding-defaults
;;;orgexportexample;;        (quote
;;;orgexportexample;;         (("text/x-patch" 8bit)
;;;orgexportexample;;          ("text/.*" 8bit)
;;;orgexportexample;;          ("message/rfc822" 8bit)
;;;orgexportexample;;          ("application/emacs-lisp" 8bit)
;;;orgexportexample;;          ("application/x-emacs-lisp" 8bit)
;;;orgexportexample;;          ("application/x-patch" 8bit)
;;;orgexportexample;;          (".*" base64))))
;;;orgexportexample;;  (setq mm-default-directory "~/attachments/")
;;;orgexportexample;;  (setq mm-url-program (quote w3m))
;;;orgexportexample;;  (setq mm-url-use-external nil)
;;;orgexportexample;;
;;;orgexportexample;;  (setq nnmail-extra-headers
;;;orgexportexample;;        '(X-Diary-Time-Zone X-Diary-Dow X-Diary-Year
;;;orgexportexample;;          X-Diary-Month X-Diary-Dom X-Diary-Hour X-Diary-Minute To Newsgroups Cc))
;;;orgexportexample;;
;;;orgexportexample;;  ;; Sources and methods
;;;orgexportexample;;  (setq mail-sources '((file :path "/var/mail/guerry")
;;;orgexportexample;;                       (maildir :path "~/Maildir/" :subdirs ("cur" "new")))
;;;orgexportexample;;        mail-source-delete-incoming nil
;;;orgexportexample;;        gnus-select-method '(nnmaildir "Bastien" (directory "~/Maildir/"))
;;;orgexportexample;;        gnus-secondary-select-methods
;;;orgexportexample;;        '((nnml "")
;;;orgexportexample;;          ;; (nntp "news" (nntp-address "news.gmane.org"))
;;;orgexportexample;;          ;; (nntp "news" (nntp-address "news.gwene.org"))
;;;orgexportexample;;          (nnimap "imap.cnam.fr")
;;;orgexportexample;;          (nnimap "obm-front.u-paris10.fr")
;;;orgexportexample;;          ))
;;;orgexportexample;;
;;;orgexportexample;;  (setq gnus-check-new-newsgroups nil)
;;;orgexportexample;;  (setq gnus-read-active-file 'some)
;;;orgexportexample;;  (setq gnus-agent t)
;;;orgexportexample;;  (setq gnus-agent-consider-all-articles t)
;;;orgexportexample;;    (setq gnus-agent-enable-expiration 'disable)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Set basics
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(setq read-mail-command 'gnus
;;;orgexportexample;;      message-mail-user-agent 'gnus-user-agent
;;;orgexportexample;;      message-kill-buffer-on-exit t
;;;orgexportexample;;      user-mail-address "bzg@altern.org"
;;;orgexportexample;;      mail-envelope-from "bzg@altern.org"
;;;orgexportexample;;      mail-user-agent 'gnus-user-agent
;;;orgexportexample;;      mail-specify-envelope-from nil
;;;orgexportexample;;      gnus-directory "~/News/"
;;;orgexportexample;;      gnus-novice-user nil
;;;orgexportexample;;      gnus-inhibit-startup-message t
;;;orgexportexample;;      gnus-play-startup-jingle nil
;;;orgexportexample;;      gnus-interactive-exit nil
;;;orgexportexample;;      gnus-no-groups-message "No news, good news."
;;;orgexportexample;;      gnus-show-all-headers nil
;;;orgexportexample;;      gnus-use-correct-string-widths nil
;;;orgexportexample;;      gnus-use-cross-reference nil
;;;orgexportexample;;      gnus-asynchronous t
;;;orgexportexample;;      gnus-interactive-catchup nil
;;;orgexportexample;;      gnus-inhibit-user-auto-expire t
;;;orgexportexample;;      gnus-gcc-mark-as-read t
;;;orgexportexample;;      gnus-verbose 6
;;;orgexportexample;;      gnus-backup-startup-file t
;;;orgexportexample;;      gnus-use-tree t
;;;orgexportexample;;      gnus-use-header-prefetch t
;;;orgexportexample;;      gnus-large-newsgroup 10000
;;;orgexportexample;;      nnmail-expiry-wait 'never
;;;orgexportexample;;      nnimap-expiry-wait 'never
;;;orgexportexample;;      nnmail-crosspost nil
;;;orgexportexample;;      nnmail-expiry-target "nnml:expired"
;;;orgexportexample;;      nnmail-split-methods 'nnmail-split-fancy
;;;orgexportexample;;      nnmail-treat-duplicates 'delete
;;;orgexportexample;;      nnml-marks nil
;;;orgexportexample;;      gnus-nov-is-evil nil
;;;orgexportexample;;      nnml-marks-is-evil t
;;;orgexportexample;;      nntp-marks-is-evil t)
;;;orgexportexample;;
;;;orgexportexample;;(setq gnus-ignored-from-addresses
;;;orgexportexample;;      (regexp-opt '("Bastien.Guerry@ens.fr"
;;;orgexportexample;;		    "bastien.guerry@free.fr"
;;;orgexportexample;;		    "bastien.guerry@cnam.fr"
;;;orgexportexample;;		    "bastien.guerry@wikimedia.fr"
;;;orgexportexample;;		    "bastien@olpc-france.org"
;;;orgexportexample;;		    "bastienguerry@gmail.com"
;;;orgexportexample;;		    "bastienguerry@googlemail.com"
;;;orgexportexample;;		    "bastien1@free.fr"
;;;orgexportexample;;		    "bzg@altern.org"
;;;orgexportexample;;		    "bzg@gnu.org"
;;;orgexportexample;;		    "bzg@laptop.org"
;;;orgexportexample;;		    "bastien.guerry@u-paris10.fr"
;;;orgexportexample;;		    "bastienguerry@hotmail.com"
;;;orgexportexample;;		    "bastienguerry@yahoo.fr"
;;;orgexportexample;;		    "b.guerry@philosophy.bbk.ac.uk"
;;;orgexportexample;;		    "castle@philosophy.bbk.ac.uk"
;;;orgexportexample;;		    "guerry@lumiere.ens.fr")))
;;;orgexportexample;;
;;;orgexportexample;;(setq message-dont-reply-to-names gnus-ignored-from-addresses)
;;;orgexportexample;;
;;;orgexportexample;;;; Start the topic view
;;;orgexportexample;;(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
;;;orgexportexample;;
;;;orgexportexample;;;; Levels and subscription
;;;orgexportexample;;(setq gnus-subscribe-newsgroup-method 'gnus-subscribe-interactively
;;;orgexportexample;;      gnus-group-default-list-level 3
;;;orgexportexample;;      gnus-level-default-subscribed 3
;;;orgexportexample;;      gnus-level-default-unsubscribed 7
;;;orgexportexample;;      gnus-level-subscribed 6
;;;orgexportexample;;      gnus-level-unsubscribed 7
;;;orgexportexample;;      gnus-activate-level 5)
;;;orgexportexample;;
;;;orgexportexample;;;; Archives
;;;orgexportexample;;(setq gnus-message-archive-group
;;;orgexportexample;;      '((if (message-news-p)
;;;orgexportexample;;	    (concat "nnfolder+archive:" (format-time-string "%Y-%m")
;;;orgexportexample;;		    "-divers-news")
;;;orgexportexample;;	  (concat "nnfolder+archive:" (format-time-string "%Y-%m")
;;;orgexportexample;;		  "-divers-mail"))))
;;;orgexportexample;;
;;;orgexportexample;;;; Delete mail backups older than 3 days
;;;orgexportexample;;(setq mail-source-delete-incoming 3)
;;;orgexportexample;;
;;;orgexportexample;;;; Select the first mail when entering a group
;;;orgexportexample;;(setq gnus-auto-select-first t)
;;;orgexportexample;;
;;;orgexportexample;;;; Group sorting
;;;orgexportexample;;(setq gnus-group-sort-function
;;;orgexportexample;;      '(gnus-group-sort-by-unread
;;;orgexportexample;;	gnus-group-sort-by-alphabet
;;;orgexportexample;;	gnus-group-sort-by-score
;;;orgexportexample;;	gnus-group-sort-by-level))
;;;orgexportexample;;
;;;orgexportexample;;;; Thread sorting
;;;orgexportexample;;(setq gnus-thread-sort-functions
;;;orgexportexample;;      '(gnus-thread-sort-by-number))
;;;orgexportexample;;
;;;orgexportexample;;;; Display the thread by default
;;;orgexportexample;;(setq gnus-thread-hide-subtree nil)
;;;orgexportexample;;
;;;orgexportexample;;;; Headers we wanna see:
;;;orgexportexample;;(setq gnus-visible-headers
;;;orgexportexample;;      "^From:\\|^Subject:\\|^X-Mailer:\\|^X-Newsreader:\\|^Date:\\|^To:\\|^Cc:\\|^User-agent:\\|^Newsgroups:\\|^Comments:")
;;;orgexportexample;;
;;;orgexportexample;;;;; [En|de]coding
;;;orgexportexample;;(setq mm-body-charset-encoding-alist
;;;orgexportexample;;      '((utf-8 . 8bit)
;;;orgexportexample;;        (iso-8859-1 . 8bit)
;;;orgexportexample;;        (iso-8859-15 . 8bit)))
;;;orgexportexample;;
;;;orgexportexample;;(setq mm-coding-system-priorities
;;;orgexportexample;;      '(iso-8859-1 iso-8859-9 iso-8859-15 utf-8
;;;orgexportexample;;		   iso-2022-jp iso-2022-jp-2 shift_jis))
;;;orgexportexample;;
;;;orgexportexample;;;; bbdb
;;;orgexportexample;;(setq gnus-use-generic-from t
;;;orgexportexample;;      gnus-use-bbdb t
;;;orgexportexample;;      bbdb/gnus-split-crosspost-default nil
;;;orgexportexample;;      bbdb/gnus-split-default-group nil
;;;orgexportexample;;      bbdb/gnus-split-myaddr-regexp gnus-ignored-from-addresses
;;;orgexportexample;;      bbdb-user-mail-names gnus-ignored-from-addresses
;;;orgexportexample;;      bbdb/gnus-split-nomatch-function nil
;;;orgexportexample;;      bbdb/gnus-summary-known-poster-mark "+"
;;;orgexportexample;;      bbdb/gnus-summary-mark-known-posters t)
;;;orgexportexample;;
;;;orgexportexample;;(defalias 'bbdb-y-or-n-p '(lambda (prompt) t))
;;;orgexportexample;;
;;;orgexportexample;;;;; Trier les mails
;;;orgexportexample;;(setq nnmail-split-abbrev-alist
;;;orgexportexample;;      '((any . "From\\|To\\|Cc\\|Sender\\|Apparently-To\\|Delivered-To\\|X-Apparently-To\\|Resent-From\\|Resent-To\\|Resent-Cc")
;;;orgexportexample;;	(mail . "Mailer-Daemon\\|Postmaster\\|Uucp")
;;;orgexportexample;;	(to . "To\\|Cc\\|Apparently-To\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
;;;orgexportexample;;	(from . "From\\|Sender\\|Resent-From")
;;;orgexportexample;;	(nato . "To\\|Cc\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
;;;orgexportexample;;	(naany . "From\\|To\\|Cc\\|Sender\\|Resent-From\\|Resent-To\\|Delivered-To\\|X-Apparently-To\\|Resent-Cc")))
;;;orgexportexample;;
;;;orgexportexample;;;; Load nnmail-split-fancy (private)
;;;orgexportexample;;(load "~/elisp/config/gnus_.el")
;;;orgexportexample;;
;;;orgexportexample;;;; Simplify the subject lines
;;;orgexportexample;;(setq gnus-simplify-subject-functions
;;;orgexportexample;;      '(gnus-simplify-subject-re
;;;orgexportexample;;	gnus-simplify-whitespace))
;;;orgexportexample;;
;;;orgexportexample;;;; Display faces
;;;orgexportexample;;(setq gnus-treat-display-face 'head)
;;;orgexportexample;;
;;;orgexportexample;;;; Thread by Xref, not by subject
;;;orgexportexample;;(setq gnus-thread-ignore-subject t)
;;;orgexportexample;;(setq gnus-summary-thread-gathering-function
;;;orgexportexample;;      'gnus-gather-threads-by-references)
;;;orgexportexample;;
;;;orgexportexample;;;; Dispkay a button for MIME parts
;;;orgexportexample;;(setq gnus-buttonized-mime-types '("multipart/alternative"))
;;;orgexportexample;;
;;;orgexportexample;;;; Use w3m to display HTML mails
;;;orgexportexample;;(setq mm-text-html-renderer 'gnus-w3m
;;;orgexportexample;;      mm-inline-text-html-with-images t
;;;orgexportexample;;      mm-inline-large-images nil
;;;orgexportexample;;      mm-attachment-file-modes 420)
;;;orgexportexample;;
;;;orgexportexample;;;; Avoid spaces when saving attachments
;;;orgexportexample;;(setq mm-file-name-rewrite-functions
;;;orgexportexample;;      '(mm-file-name-trim-whitespace
;;;orgexportexample;;	mm-file-name-collapse-whitespace
;;;orgexportexample;;	mm-file-name-replace-whitespace))
;;;orgexportexample;;
;;;orgexportexample;;(setq gnus-user-date-format-alist
;;;orgexportexample;;      '(((gnus-seconds-today) . "     %k:%M")
;;;orgexportexample;;	((+ 86400 (gnus-seconds-today)) . "hier %k:%M")
;;;orgexportexample;;	((+ 604800 (gnus-seconds-today)) . "%a  %k:%M")
;;;orgexportexample;;	((gnus-seconds-month) . "%a  %d")
;;;orgexportexample;;	((gnus-seconds-year) . "%b %d")
;;;orgexportexample;;	(t . "%b %d '%y")))
;;;orgexportexample;;
;;;orgexportexample;;;; Add a time-stamp to a group when it is selected
;;;orgexportexample;;(add-hook 'gnus-select-group-hook 'gnus-group-set-timestamp)
;;;orgexportexample;;
;;;orgexportexample;;;; Format group line
;;;orgexportexample;;(setq gnus-group-line-format
;;;orgexportexample;;      ;;      "%M\%S\%p\%P\%5T>%5y: %(%-40,40g%) %ud\n")
;;;orgexportexample;;      ;;      "%M\%S\%p\%P\%y: %(%-40,40g%) %T/%i\n")
;;;orgexportexample;;      ;;      "%M\%S\%p\%P %(%-30,30G%) %-3y %-3T %-3I\n")
;;;orgexportexample;;      "%M\%S\%p\%P %(%-40,40G%)\n")
;;;orgexportexample;;
;;;orgexportexample;;(setq gnus-topic-indent-level 3)
;;;orgexportexample;;
;;;orgexportexample;;(defun bzg-gnus-toggle-group-line-format ()
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (if (equal gnus-group-line-format
;;;orgexportexample;;	     "%M\%S\%p\%P %(%-40,40G%) %-3y %-3T %-3I\n")
;;;orgexportexample;;      (setq gnus-group-line-format
;;;orgexportexample;;	     "%M\%S\%p\%P %(%-40,40G%)\n")
;;;orgexportexample;;    (setq gnus-group-line-format
;;;orgexportexample;;	  "%M\%S\%p\%P %(%-40,40G%) %-3y %-3T %-3I\n")))
;;;orgexportexample;;
;;;orgexportexample;;(defun bzg-gnus-add-gmane ()
;;;orgexportexample;;  (add-to-list 'gnus-secondary-select-methods '(nntp "news" (nntp-address "news.gmane.org"))))
;;;orgexportexample;;
;;;orgexportexample;;(define-key gnus-group-mode-map "x"
;;;orgexportexample;;  (lambda () (interactive) (bzg-gnus-toggle-group-line-format) (gnus)))
;;;orgexportexample;;
;;;orgexportexample;;(define-key gnus-group-mode-map "X"
;;;orgexportexample;;  (lambda () (interactive) (bzg-gnus-add-gmane) (gnus)))
;;;orgexportexample;;
;;;orgexportexample;;(define-key gnus-summary-mode-map "$" 'gnus-summary-mark-as-spam)
;;;orgexportexample;;
;;;orgexportexample;;;; Scoring
;;;orgexportexample;;(setq gnus-use-adaptive-scoring 'line
;;;orgexportexample;;      ;; gnus-score-expiry-days 14
;;;orgexportexample;;      gnus-default-adaptive-score-alist
;;;orgexportexample;;      '((gnus-dormant-mark (from 20) (subject 100))
;;;orgexportexample;;	(gnus-ticked-mark (subject 30))
;;;orgexportexample;;	(gnus-read-mark (subject 30))
;;;orgexportexample;;	(gnus-del-mark (subject -150))
;;;orgexportexample;;	(gnus-catchup-mark (subject -150))
;;;orgexportexample;;	(gnus-killed-mark (subject -1000))
;;;orgexportexample;;	(gnus-expirable-mark (from -1000) (subject -1000)))
;;;orgexportexample;;      gnus-score-decay-constant 1    ;default = 3
;;;orgexportexample;;      gnus-score-decay-scale 0.03    ;default = 0.05
;;;orgexportexample;;      gnus-decay-scores t)           ;(gnus-decay-score 1000)
;;;orgexportexample;;
;;;orgexportexample;;(setq gnus-face-0 '((t (:foreground "grey60"))))
;;;orgexportexample;;(setq gnus-face-1 '((t (:foreground "grey30"))))
;;;orgexportexample;;(setq gnus-face-2 '((t (:foreground "grey90"))))
;;;orgexportexample;;
;;;orgexportexample;;;; Prompt for the right group
;;;orgexportexample;;(setq gnus-group-jump-to-group-prompt
;;;orgexportexample;;      '((0 . "nnml:mail.")
;;;orgexportexample;;	(1 . "nnfolder+archive:2013-")
;;;orgexportexample;;	(2 . "nnfolder+archive:2012-")
;;;orgexportexample;;	(3 . "nntp+news:gmane.")))
;;;orgexportexample;;
;;;orgexportexample;;(setq gnus-summary-line-format
;;;orgexportexample;;      (concat "%*%0{%U%R%z%}"
;;;orgexportexample;;	      "%0{ %}(%2t)"
;;;orgexportexample;; 	      "%2{ %}%-23,23n"
;;;orgexportexample;;	      "%1{ %}%1{%B%}%2{%-102,102s%}%-140="
;;;orgexportexample;;	      "\n"))
;;;orgexportexample;;
;;;orgexportexample;;(require 'ecomplete)
;;;orgexportexample;;(setq message-mail-alias-type 'ecomplete)
;;;orgexportexample;;
;;;orgexportexample;;(add-hook 'message-mode-hook 'turn-on-orgstruct++)
;;;orgexportexample;;(add-hook 'message-mode-hook 'turn-on-orgtbl)
;;;orgexportexample;;
;;;orgexportexample;;(require 'gnus-gravatar)
;;;orgexportexample;;
;;;orgexportexample;;;; Hack to store Org links upon sending Gnus messages
;;;orgexportexample;;
;;;orgexportexample;;(defun bzg-message-send-and-org-gnus-store-link (&optional arg)
;;;orgexportexample;;  "Send message with `message-send-and-exit' and store org link to message copy.
;;;orgexportexample;;If multiple groups appear in the Gcc header, the link refers to
;;;orgexportexample;;the copy in the last group."
;;;orgexportexample;;  (interactive "P")
;;;orgexportexample;;    (save-excursion
;;;orgexportexample;;      (save-restriction
;;;orgexportexample;;	(message-narrow-to-headers)
;;;orgexportexample;;	(let ((gcc (car (last
;;;orgexportexample;;			 (message-unquote-tokens
;;;orgexportexample;;			  (message-tokenize-header
;;;orgexportexample;;			   (mail-fetch-field "gcc" nil t) " ,")))))
;;;orgexportexample;;	      (buf (current-buffer))
;;;orgexportexample;;	      (message-kill-buffer-on-exit nil)
;;;orgexportexample;;	      id to from subject desc link newsgroup xarchive)
;;;orgexportexample;;        (message-send-and-exit arg)
;;;orgexportexample;;        (or
;;;orgexportexample;;         ;; gcc group found ...
;;;orgexportexample;;         (and gcc
;;;orgexportexample;;              (save-current-buffer
;;;orgexportexample;;                (progn (set-buffer buf)
;;;orgexportexample;;                       (setq id (org-remove-angle-brackets
;;;orgexportexample;;                                 (mail-fetch-field "Message-ID")))
;;;orgexportexample;;                       (setq to (mail-fetch-field "To"))
;;;orgexportexample;;                       (setq from (mail-fetch-field "From"))
;;;orgexportexample;;                       (setq subject (mail-fetch-field "Subject"))))
;;;orgexportexample;;              (org-store-link-props :type "gnus" :from from :subject subject
;;;orgexportexample;;                                    :message-id id :group gcc :to to)
;;;orgexportexample;;              (setq desc (org-email-link-description))
;;;orgexportexample;;              (setq link (org-gnus-article-link
;;;orgexportexample;;                          gcc newsgroup id xarchive))
;;;orgexportexample;;              (setq org-stored-links
;;;orgexportexample;;                    (cons (list link desc) org-stored-links)))
;;;orgexportexample;;         ;; no gcc group found ...
;;;orgexportexample;;         (message "Can not create Org link: No Gcc header found."))))))
;;;orgexportexample;;
;;;orgexportexample;;(define-key message-mode-map [(control c) (control meta c)]
;;;orgexportexample;;  'bzg-message-send-and-org-gnus-store-link)
;;;orgexportexample;;
;;;orgexportexample;;;; (defun gnus-thread-sort-by-length (h1 h2)
;;;orgexportexample;;;;   "Sort threads by the sum of all articles in the thread."
;;;orgexportexample;;;;   (> (gnus-thread-length h1)
;;;orgexportexample;;;;      (gnus-thread-length h2)))
;;;orgexportexample;;
;;;orgexportexample;;;; (defun gnus-thread-length (thread)
;;;orgexportexample;;;;   "Find the total number of articles in THREAD."
;;;orgexportexample;;;;   (cond
;;;orgexportexample;;;;    ((null thread) 0)
;;;orgexportexample;;;;    ((listp thread) (length thread))))
;;;orgexportexample;;
;;;orgexportexample;;(setq message-fill-column 70)
;;;orgexportexample;;(setq message-use-mail-followup-to nil)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* ERC
;;;orgexportexample;;
;;;orgexportexample;;** ERC variables
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(require 'erc)
;;;orgexportexample;;(require 'erc-services)
;;;orgexportexample;;
;;;orgexportexample;;(setq erc-modules '(autoaway autojoin irccontrols log netsplit noncommands notify pcomplete completion ring services stamp track truncate)
;;;orgexportexample;;      erc-keywords nil
;;;orgexportexample;;      erc-prompt-for-nickserv-password nil
;;;orgexportexample;;      erc-hide-timestamps t
;;;orgexportexample;;      erc-log-insert-log-on-open nil
;;;orgexportexample;;      erc-log-channels t
;;;orgexportexample;;      erc-log-write-after-insert nil
;;;orgexportexample;;      erc-save-buffer-on-part t
;;;orgexportexample;;      erc-input-line-position 0
;;;orgexportexample;;      ;; erc-fill-function (quote erc-fill-static)
;;;orgexportexample;;      ;; erc-fill-mode t
;;;orgexportexample;;      erc-insert-timestamp-function 'erc-insert-timestamp-left
;;;orgexportexample;;      erc-insert-away-timestamp-function 'erc-insert-timestamp-left
;;;orgexportexample;;      erc-notify-list nil
;;;orgexportexample;;      erc-whowas-on-nosuchnick t
;;;orgexportexample;;      erc-public-away-p nil
;;;orgexportexample;;      erc-save-buffer-on-part t
;;;orgexportexample;;      erc-echo-notice-always-hook '(erc-echo-notice-in-minibuffer)
;;;orgexportexample;;      erc-autoaway-message "%i seconds out..."
;;;orgexportexample;;      erc-away-nickname "bz_g"
;;;orgexportexample;;      erc-kill-queries-on-quit nil
;;;orgexportexample;;      erc-kill-server-buffer-on-quit t
;;;orgexportexample;;      erc-log-channels-directory "~/.erc_log"
;;;orgexportexample;;      erc-query-on-unjoined-chan-privmsg t
;;;orgexportexample;;      erc-auto-query 'window-noselect
;;;orgexportexample;;      erc-server-coding-system '(utf-8 . utf-8)
;;;orgexportexample;;      erc-encoding-coding-alist '(("#emacs" . utf-8)
;;;orgexportexample;;				  ("#frlab" . iso-8859-1)
;;;orgexportexample;;				  ("&bitlbee" . utf-8)))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** ERC connect to bitlbee
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(defun bzg-erc-connect-bitlbee ()
;;;orgexportexample;;  "Connect to &bitlbee channel with ERC."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (erc-select :server "bzg.ath.cx"
;;;orgexportexample;;	      :port 6667
;;;orgexportexample;;	      :nick "bz_g"
;;;orgexportexample;;	      :full-name "Bastien"))
;;;orgexportexample;;
;;;orgexportexample;;(defun bzg-erc-connect-bitlbee-2 ()
;;;orgexportexample;;  "Connect to &bitlbee channel with ERC."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (erc-select :server "bzg.ath.cx"
;;;orgexportexample;;	      :port 6667
;;;orgexportexample;;	      :nick "lml"
;;;orgexportexample;;	      :full-name "Le_ Mus챕e_ Libre_"))
;;;orgexportexample;;
;;;orgexportexample;;(defun bzg-erc-connect-freenode ()
;;;orgexportexample;;  "Connect to Freenode server with ERC."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (erc-select :server "irc.freenode.net"
;;;orgexportexample;;	      :port 6666
;;;orgexportexample;;	      :nick "bz_g"
;;;orgexportexample;;	      :full-name "Bastien"))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** ERC hooks
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(add-hook 'erc-mode-hook
;;;orgexportexample;;          '(lambda ()
;;;orgexportexample;;	     (auto-fill-mode 0)
;;;orgexportexample;;             (pcomplete-erc-setup)
;;;orgexportexample;;	     (erc-completion-mode 1)
;;;orgexportexample;;	     (erc-ring-mode 1)
;;;orgexportexample;;	     (erc-log-mode 1)
;;;orgexportexample;;	     (erc-netsplit-mode 1)
;;;orgexportexample;;	     (erc-button-mode -1)
;;;orgexportexample;;	     (erc-match-mode 1)
;;;orgexportexample;;	     (erc-autojoin-mode 1)
;;;orgexportexample;;	     (erc-nickserv-mode 1)
;;;orgexportexample;;	     (erc-timestamp-mode 1)
;;;orgexportexample;;	     (erc-services-mode 1)))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** ERC bot (disabled)
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;;; (add-hook 'erc-server-PRIVMSG-functions 'erc-bot-remote t)
;;;orgexportexample;;;; (add-hook 'erc-send-completed-hook 'erc-bot-local t)
;;;orgexportexample;;;; (add-hook 'erc-server-PRIVMSG-functions 'erc-warn-me-PRIVMSG t)
;;;orgexportexample;;
;;;orgexportexample;;;; (defun erc-warn-me-PRIVMSG (proc parsed)
;;;orgexportexample;;;;   (let* ((nick (car (erc-parse-user (erc-response.sender parsed))))
;;;orgexportexample;;;;          (msg (erc-response.contents parsed)))
;;;orgexportexample;;;;     ;; warn me if I'm in bitlbee or #org-mode
;;;orgexportexample;;;;     (when (string-match "bitlbee\\|org-mode"
;;;orgexportexample;;;; 			(buffer-name (window-buffer)))
;;;orgexportexample;;;;       (let ((minibuffer-message-timeout 3))
;;;orgexportexample;;;; 	(minibuffer-message (format "%s: %s" nick msg))))))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** ERC passwords
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(load "~/elisp/config/erc_.el")
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* w3m
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(setq w3m-accept-languages '("fr;" "q=1.0" "en;"))
;;;orgexportexample;;(setq w3m-antenna-sites '(("http://eucd.info" "EUCD.INFO" time)))
;;;orgexportexample;;(setq w3m-broken-proxy-cache t)
;;;orgexportexample;;(setq w3m-confirm-leaving-secure-page nil)
;;;orgexportexample;;(setq w3m-cookie-accept-bad-cookies t)
;;;orgexportexample;;(setq w3m-cookie-accept-domains t)
;;;orgexportexample;;(setq w3m-cookie-file "/home/guerry/.w3m/cookie")
;;;orgexportexample;;(setq w3m-fill-column 70)
;;;orgexportexample;;(setq w3m-form-textarea-edit-mode 'org-mode)
;;;orgexportexample;;(setq w3m-icon-directory nil)
;;;orgexportexample;;(setq w3m-key-binding 'info)
;;;orgexportexample;;(setq w3m-use-cookies t)
;;;orgexportexample;;(setq w3m-use-tab t)
;;;orgexportexample;;(setq w3m-use-toolbar nil)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;* Buffer length goal
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(defvar buffer-length-goal nil)
;;;orgexportexample;;(defvar buffer-length-to-goal nil)
;;;orgexportexample;;(make-variable-buffer-local 'buffer-length-goal)
;;;orgexportexample;;(make-variable-buffer-local 'buffer-length-to-goal)
;;;orgexportexample;;
;;;orgexportexample;;(defun bzg-set-buffer-length-goal ()
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (setq buffer-length-goal
;;;orgexportexample;;	(string-to-number (read-from-minibuffer "Buffer length goal: ")))
;;;orgexportexample;;  (setq buffer-length-to-goal (bzg-update-buffer-length-goal))
;;;orgexportexample;;  (add-to-list 'global-mode-string 'buffer-length-to-goal t)
;;;orgexportexample;;  (run-at-time nil 3 'bzg-update-buffer-length-goal))
;;;orgexportexample;;
;;;orgexportexample;;(defun bzg-update-buffer-length-goal ()
;;;orgexportexample;;  (setq buffer-length-to-goal
;;;orgexportexample;;	(concat " Done: "
;;;orgexportexample;;		(number-to-string
;;;orgexportexample;;		 (round
;;;orgexportexample;;		  (- 100
;;;orgexportexample;;		     (* 100
;;;orgexportexample;;			(/ (float (- buffer-length-goal (buffer-size)))
;;;orgexportexample;;			   buffer-length-goal))))) "%"))
;;;orgexportexample;;  (force-mode-line-update))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Calendar and diary
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (global-set-key (quote [f12]) 'calendar)
;;;orgexportexample;;
;;;orgexportexample;;  (setq diary-file "~/.diary")
;;;orgexportexample;;
;;;orgexportexample;;  (setq french-holiday
;;;orgexportexample;;        '((holiday-fixed 1 1 "Jour de l'an")
;;;orgexportexample;;          (holiday-fixed 5 8 "Victoire 45")
;;;orgexportexample;;          (holiday-fixed 7 14 "F챗te nationale")
;;;orgexportexample;;          (holiday-fixed 8 15 "Assomption")
;;;orgexportexample;;          (holiday-fixed 11 1 "Toussaint")
;;;orgexportexample;;          (holiday-fixed 11 11 "Armistice 18")
;;;orgexportexample;;          (holiday-easter-etc 1 "Lundi de P창ques")
;;;orgexportexample;;          (holiday-easter-etc 39 "Ascension")
;;;orgexportexample;;          (holiday-easter-etc 50 "Lundi de Pentec척te")
;;;orgexportexample;;          (holiday-fixed 1 6 "횋piphanie")
;;;orgexportexample;;          (holiday-fixed 2 2 "Chandeleur")
;;;orgexportexample;;          (holiday-fixed 2 14 "Saint Valentin")
;;;orgexportexample;;          (holiday-fixed 5 1 "F챗te du travail")
;;;orgexportexample;;          (holiday-fixed 5 8 "Comm챕moration de la capitulation de l'Allemagne en 1945")
;;;orgexportexample;;          (holiday-fixed 6 21 "F챗te de la musique")
;;;orgexportexample;;          (holiday-fixed 11 2 "Comm챕moration des fid챔les d챕funts")
;;;orgexportexample;;          (holiday-fixed 12 25 "No챘l")
;;;orgexportexample;;          ;; f챗tes 횪 date variable
;;;orgexportexample;;          (holiday-easter-etc 0 "P창ques")
;;;orgexportexample;;          (holiday-easter-etc 49 "Pentec척te")
;;;orgexportexample;;          (holiday-easter-etc -47 "Mardi gras")
;;;orgexportexample;;          (holiday-float 6 0 3 "F챗te des p챔res") ;; troisi챔me dimanche de juin
;;;orgexportexample;;          ;; F챗te des m챔res
;;;orgexportexample;;          (holiday-sexp
;;;orgexportexample;;           '(if (equal
;;;orgexportexample;;                 ;; Pentec척te
;;;orgexportexample;;                 (holiday-easter-etc 49)
;;;orgexportexample;;                 ;; Dernier dimanche de mai
;;;orgexportexample;;                 (holiday-float 5 0 -1 nil))
;;;orgexportexample;;                ;; -> Premier dimanche de juin si co챦ncidence
;;;orgexportexample;;                (car (car (holiday-float 6 0 1 nil)))
;;;orgexportexample;;              ;; -> Dernier dimanche de mai sinon
;;;orgexportexample;;              (car (car (holiday-float 5 0 -1 nil))))
;;;orgexportexample;;           "F챗te des m챔res")))
;;;orgexportexample;;
;;;orgexportexample;;  (setq calendar-date-style 'european
;;;orgexportexample;;        calendar-holidays (append french-holiday)
;;;orgexportexample;;        calendar-mark-holidays-flag t
;;;orgexportexample;;        calendar-week-start-day 1
;;;orgexportexample;;        calendar-mark-diary-entries-flag nil)
;;;orgexportexample;;
;;;orgexportexample;;  (setq TeX-master 'dwim)
;;;orgexportexample;;  (setq doc-view-scale-internally nil)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Various functions
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(defun bzg-find-bzg nil
;;;orgexportexample;;  "Find the bzg.org file."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (find-file "~/org/bzg.org"))
;;;orgexportexample;;
;;;orgexportexample;;(defun org-ibuffer ()
;;;orgexportexample;;  "Open an `ibuffer' window showing only `org-mode' buffers."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (ibuffer nil "*Org Buffers*" '((used-mode . org-mode))))
;;;orgexportexample;;
;;;orgexportexample;;(defun kill-line-save (&optional arg)
;;;orgexportexample;;  "Save the rest of the line as if killed, but don't kill it."
;;;orgexportexample;;  (interactive "P")
;;;orgexportexample;;  (let ((buffer-read-only t))
;;;orgexportexample;;    (kill-line arg)
;;;orgexportexample;;    (message "Line(s) copied to the kill ring")))
;;;orgexportexample;;
;;;orgexportexample;;(defun copy-line (&optional arg)
;;;orgexportexample;;  "Copy the current line."
;;;orgexportexample;;  (interactive "P")
;;;orgexportexample;;  (copy-region-as-kill
;;;orgexportexample;;   (point-at-bol)
;;;orgexportexample;;   (+ (if kill-whole-line 1 0) (point-at-eol arg))))
;;;orgexportexample;;
;;;orgexportexample;;(defun racket-enter! ()
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (comint-send-string (scheme-proc)
;;;orgexportexample;;        (format "(enter! (file \"%s\") #:verbose)\n" buffer-file-name))
;;;orgexportexample;;  (switch-to-scheme t))
;;;orgexportexample;;
;;;orgexportexample;;(defun unfill-paragraph ()
;;;orgexportexample;;  "Takes a multi-line paragraph and makes it into a single line of text."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (let ((fill-column (point-max)))
;;;orgexportexample;;    (fill-paragraph nil)))
;;;orgexportexample;;;; Handy key definition
;;;orgexportexample;;(define-key global-map "\M-Q" 'unfill-paragraph)
;;;orgexportexample;;
;;;orgexportexample;;(defun uniquify-all-lines-region (start end)
;;;orgexportexample;;  "Find duplicate lines in region START to END keeping first occurrence."
;;;orgexportexample;;  (interactive "*r")
;;;orgexportexample;;  (save-excursion
;;;orgexportexample;;    (let ((end (copy-marker end)))
;;;orgexportexample;;      (while
;;;orgexportexample;;	  (progn
;;;orgexportexample;;	    (goto-char start)
;;;orgexportexample;;	    (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
;;;orgexportexample;;	(replace-match "\\1\n\\2")))))
;;;orgexportexample;;
;;;orgexportexample;;(defun uniquify-all-lines-buffer ()
;;;orgexportexample;;  "Delete duplicate lines in buffer and keep first occurrence."
;;;orgexportexample;;  (interactive "*")
;;;orgexportexample;;  (uniquify-all-lines-region (point-min) (point-max)))
;;;orgexportexample;;
;;;orgexportexample;;(defun my-copy-rectangle-to-primary ()
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (when (region-active-p)
;;;orgexportexample;;    (let ((text (mapconcat 'identity
;;;orgexportexample;;                           (extract-rectangle
;;;orgexportexample;;                            (region-beginning)
;;;orgexportexample;;                            (region-end)) "\n")))
;;;orgexportexample;;      (deactivate-mark) ;; lost 30mn because of this
;;;orgexportexample;;      (x-set-selection 'PRIMARY text)
;;;orgexportexample;;      (message "%s" text))))
;;;orgexportexample;;
;;;orgexportexample;;
;;;orgexportexample;;(defun org-dblock-write:amazon (params)
;;;orgexportexample;;  "Dynamic block for inserting the cover of a book."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (let* ((asin (plist-get params :asin))
;;;orgexportexample;;	 (tpl "<a href=\"http://www.amazon.fr/gp/product/%s/ref=as_li_qf_sp_asin_il?ie=UTF8&tag=bastguer-21&linkCode=as2&camp=1642&creative=6746&creativeASIN=%s\"><img border=\"0\" src=\"http://ws.assoc-amazon.fr/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=%s&MarketPlace=FR&ID=AsinImage&WS=1&tag=bastguer-21&ServiceVersion=20070822\" ></a><img src=\"http://www.assoc-amazon.fr/e/ir?t=bastguer-21&l=as2&o=8&a=%s\" width=\"1\" height=\"1\" border=\"0\" alt=\"\" style=\"border:none !important; margin:0px !important;\" />")
;;;orgexportexample;;	 (str (format tpl asin asin asin asin)))
;;;orgexportexample;;    (insert "#+begin_html\n" str "\n#+end_html")))
;;;orgexportexample;;
;;;orgexportexample;;(defun benchmark-two-defuns (defa defb)
;;;orgexportexample;;  (interactive
;;;orgexportexample;;   (list (intern (completing-read "First function: " obarray))
;;;orgexportexample;;	 (intern (completing-read "Second function: " obarray))))
;;;orgexportexample;;  (message "%d"
;;;orgexportexample;;	   (/ (/ (car (benchmark-run 10 (funcall defa))) 10)
;;;orgexportexample;;	      (/ (car (benchmark-run 10 (funcall defb))) 10))))
;;;orgexportexample;;
;;;orgexportexample;;(defun next-word-at-point (previous)
;;;orgexportexample;;  "Jump to the next occurrence of the word at point."
;;;orgexportexample;;  (interactive "P")
;;;orgexportexample;;  (let* ((w (thing-at-point 'word))
;;;orgexportexample;;	 (w (mapconcat
;;;orgexportexample;;	     (lambda(c) (if (eq (char-syntax c) ?w)
;;;orgexportexample;;			    (char-to-string c))) w ""))
;;;orgexportexample;;	 (wre (concat "\\<" w "\\>"))
;;;orgexportexample;;	 (s (if previous #'re-search-backward #'re-search-forward)))
;;;orgexportexample;;    (unless previous (forward-word 1))
;;;orgexportexample;;    (funcall s wre nil t)
;;;orgexportexample;;    (unless previous (re-search-backward wre nil t))))
;;;orgexportexample;;
;;;orgexportexample;;(defun previous-word-at-point ()
;;;orgexportexample;;  "Jump to the previous occurrence of the word at point."
;;;orgexportexample;;  (interactive)
;;;orgexportexample;;  (next-word-at-point t))
;;;orgexportexample;;
;;;orgexportexample;;(defun current-word-search ()
;;;orgexportexample;;    "search forward for word under cursor"
;;;orgexportexample;;    (interactive)
;;;orgexportexample;;    (word-search-forward (current-word)))
;;;orgexportexample;;
;;;orgexportexample;;(defun increase-srt (n)
;;;orgexportexample;;  "Increase srt timestamp by N seconds."
;;;orgexportexample;;  (interactive "p")
;;;orgexportexample;;  (goto-char (point-min))
;;;orgexportexample;;  (while (re-search-forward "\\([0-9]+:[0-9]+:[0-9]+\\)," nil t)
;;;orgexportexample;;    (let ((s (save-match-data (org-hh:mm:ss-string-to-seconds (match-string 1)))))
;;;orgexportexample;;      (replace-match (save-match-data (org-format-seconds "%.2h:%.2m:%.2s," (+ s n))) t t))))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Start the server
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(server-start)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;* Customize modes
;;;orgexportexample;;** Emacs lisp
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(add-hook 'emacs-lisp-mode-hook 'turn-on-orgstruct++)
;;;orgexportexample;;(add-hook 'emacs-lisp-mode-hook 'fontify-todo)
;;;orgexportexample;;(add-hook 'emacs-lisp-mode-hook 'fontify-headline)
;;;orgexportexample;;
;;;orgexportexample;;;; (add-hook 'emacs-lisp-mode-hook 'electric-pair-mode)
;;;orgexportexample;;;; (add-hook 'emacs-lisp-mode-hook 'electric-indent-mode)
;;;orgexportexample;;;; (add-hook 'emacs-lisp-mode-hook 'electric-layout-mode)
;;;orgexportexample;;
;;;orgexportexample;;(defvar todo-comment-face 'todo-comment-face)
;;;orgexportexample;;(defvar headline-face 'headline-face)
;;;orgexportexample;;
;;;orgexportexample;;;; Fontifying todo items outside of org-mode
;;;orgexportexample;;(defface todo-comment-face
;;;orgexportexample;;  '((t (:background "#3f3f3f"
;;;orgexportexample;;	:foreground "white"
;;;orgexportexample;;	:weight bold
;;;orgexportexample;;	:bold t)))
;;;orgexportexample;;  "Face for TODO in code buffers."
;;;orgexportexample;;  :group 'org-faces)
;;;orgexportexample;;
;;;orgexportexample;;(defface headline-face
;;;orgexportexample;;  '((t (:foreground "white"
;;;orgexportexample;;	:background "#3f3f3f"
;;;orgexportexample;;	:weight bold
;;;orgexportexample;;	:bold t)))
;;;orgexportexample;;  "Face for headlines."
;;;orgexportexample;;  :group 'org-faces)
;;;orgexportexample;;
;;;orgexportexample;;(defun fontify-todo ()
;;;orgexportexample;;  (font-lock-add-keywords
;;;orgexportexample;;   nil '((";;.*\\(TODO\\|FIXME\\)"
;;;orgexportexample;;	  (1 todo-comment-face t)))))
;;;orgexportexample;;
;;;orgexportexample;;(defun fontify-headline ()
;;;orgexportexample;;  (font-lock-add-keywords
;;;orgexportexample;;   nil '(("^;;;;* ?\\(.*\\)\\>"
;;;orgexportexample;;	  (1 headline-face t)))))
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Geiser
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(setq geiser-active-implementations '(racket))
;;;orgexportexample;;(setq geiser-repl-startup-time 20000)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;** Magit
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;(require 'magit)
;;;orgexportexample;;
;;;orgexportexample;;(global-set-key (quote [f9]) 'magit-status)
;;;orgexportexample;;
;;;orgexportexample;;(setq magit-save-some-buffers 'dontask)
;;;orgexportexample;;(setq magit-commit-all-when-nothing-staged 'ask)
;;;orgexportexample;;#+END_SRC
;;;orgexportexample;;
;;;orgexportexample;;
;;;orgexportexample;;
;;;orgexportexample;;** doc-view-mode
;;;orgexportexample;;
;;;orgexportexample;;#+BEGIN_SRC emacs-lisp
;;;orgexportexample;;  (setq doc-view-continuous t)
;;;orgexportexample;;  (set-frame-parameter nil 'fullscreen 'fullboth)
;;;orgexportexample;;#+END_SRC


