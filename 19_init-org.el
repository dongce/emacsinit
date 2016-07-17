;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-
;; babel 에서 C-c' (org-edit-src-code 를 사용할 수 있다)

(require 'org)
(require 'calendar)
(require 'org-agenda)
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

(setq org-log-done t)

(add-hook 'org-mode-hook 'turn-on-font-lock) ; Org buffers only

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
;;(require 'ox-latex)
;; (setq org-latex-listings 'minted)
;; (add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-src-fontify-natively t)


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
;;(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode nil)

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

(use-package os-fs-tree :commands org-fs-tree-dump )


(defun my/save-all-agenda-buffers ()
  "Function used to save all agenda buffers that are
currently open, based on `org-agenda-files'."
  (interactive)
  (save-current-buffer
    (dolist (buffer (buffer-list t))
      (set-buffer buffer)
      (when (member (buffer-file-name)
                    (mapcar 'expand-file-name (org-agenda-files t)))
        (save-buffer)))))

;; save all the agenda files after each capture
(add-hook 'org-capture-after-finalize-hook 'my/save-all-agenda-buffers)


(use-package cal-korea-x)



(defun  org-link-copy-image ()
  (interactive)
  (copy-image-file (org-element-property :path (org-element-context) )))

(defun  org-link-copy-file ()
  (interactive)
  (copy-files (org-element-property :path (org-element-context) )))



;; http://nadeausoftware.com/articles/2007/11/latency_friendly_customized_bullets_using_unicode_characters
;; (eval-after-load 'org-bullets '(setq org-bullets-bullet-list '("✺" "✹" "✸" "✷" "✶" "✭" "✦" "■" "▲" "●" )))
;; "✺" "✹" "✸" "✷" "✶" "✭" "✦" "■" "▲" "●"


;; (use-package org-bullets
;;   :config
;;   (setq org-bullets-bullet-list '( "✸" "✷" "✶" "★"  "☆" "⚝" "✦" "■" "▲" "●" ))
;; ;; "✺" "✹"
;;   )

