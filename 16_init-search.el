;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-
(defun link11-grep (word &optional case-senstive )
  "현제커서 위치의 단어를 검색한다."
  (interactive
   (list (read-string "찾을 단어: " (current-word)) current-prefix-arg ))

  (set-buffer (dired-noselect "c:/FFX/CFCS/DLP_LINK11"))
  (grep (if case-senstive 
	    (format "%s \"%s\" *" grep-command word )
	  (format "%s --smart-case   \"%s\" *" grep-command word ))))

(defun isdl-grep (word &optional case-senstive )
  "현제커서 위치의 단어를 검색한다."
  (interactive
   (list (read-string "찾을 단어: " (current-word)) current-prefix-arg ))

  (set-buffer (dired-noselect "c:/FFX/CFCS/DLP_ISDL"))
  (grep (if case-senstive 
	    (format "%s \"%s\" *" grep-command word )
	  (format "%s  \"%s\" *" grep-command word ))))

(defun dlp-grep (word &optional case-senstive )
  "현제커서 위치의 단어를 검색한다."
  (interactive
   (list (read-string "찾을 단어: " (current-word)) current-prefix-arg ))
  (if (not (eq nil (string-match "isdl" (buffer-file-name))))
      (set-buffer (dired-noselect "c:/FFX/CFCS/DLP_ISDL"))
      (if (not (eq nil (string-match "link11" (buffer-file-name))))
          (set-buffer (dired-noselect "c:/FFX/CFCS/DLP_LINK11"))))
  (grep (if case-senstive (format " \"%s\" *" grep-command word ) (format "%s  \"%s\" *" grep-command word ))))

  

(global-set-key "\C-cu" 'dlp-grep)

(autoload 'ioccur "ioccur"
  "점진적 occur" t)


(defun grep-word (word &optional case-senstive )
  "현제커서 위치의 단어를 검색한다."
  (interactive
   (list (read-string "grep 찾을 단어: " (current-word)) current-prefix-arg ))
  
  (let ((directory-name-backup default-directory))

    (if case-senstive 
        (setq default-directory 
              (mapconcat (lambda (x) x ) (reverse (cdr (nthcdr case-senstive (reverse (split-string default-directory "/"))))) "/")))
    (grep (format "%s  -E \"%s\" " grep-command word ))
    (setq default-directory directory-name-backup)))
  


(defun woccur (word &optional nlines )
  "현제커서 위치의 단어를 OCCUR한다."
  (interactive
   (list (read-string "occur 찾을 단어: " (current-word)) 
	 (prefix-numeric-value current-prefix-arg) ))
  (occur word nlines ))

(defun occur-region( beg end &optional lines )
 "Check occurence of string which is selected by markejr."
 (interactive "r\nP")
 (occur (buffer-substring-no-properties beg end) lines ))
(defun occur-compile-region( beg end &optional lines )
 "Check occurence of string which is selected by marker."
 (interactive "r\nP")
 (occur-compile (buffer-substring-no-properties beg end) lines ))


(defun occur-xml ( regexp &optional nlines)
  "Show all lines matching REGEXP in buffers specified by BUFREGEXP.
Normally BUFREGEXP matches against each buffer's visited file name,
but if you specify a prefix argument, it matches against the buffer name.
See also `multi-occur'."
  (interactive (occur-read-primary-args))
  (occur-1 regexp nlines
           (delq nil (mapcar 
                      (lambda (buf) 
                        (when (and 
                               (buffer-file-name buf) 
                               (string-match ".*xml" (buffer-file-name buf))) buf)) 
                      (buffer-list)))))

(global-set-key "\C-co" 'occur)

;; 쓰기 좋은 키 바인딩 입니다. 
;;(global-set-key "\C-ci" 'isdl-grep)
;;(global-set-key (kbd "C-M-,") '(lambda ()  (interactive) (run-scheme "winprojcd")))



;; dictionary 
(autoload 'dictionary-search "dictionary"
  "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary"
  "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary-lookup-definition "dictionary"
  "Unconditionally lookup the word at point." t)
(autoload 'dictionary "dictionary"
  "Create a new dictionary buffer" t)
(autoload 'dictionary-mouse-popup-matching-words "dictionary"
  "Display entries matching the word at the cursor" t)
(autoload 'dictionary-popup-matching-words "dictionary"
  "Display entries matching the word at the point" t)
(autoload 'dictionary-tooltip-mode "dictionary"
  "Display tooltips for the current word" t)
(autoload 'global-dictionary-tooltip-mode "dictionary"
  "Enable/disable dictionary-tooltip-mode for all buffers" t)
;; 사전기능을 사용
(require 'dictionary)

(global-set-key "\C-ci" 'woccur)
(global-set-key "\C-cu" 'grep-word)
(global-set-key "\C-cs" 'dictionary-search)
(global-set-key "\C-cm" 'dictionary-match-words)


(require 'misearch)

(defun misearch-next-buffer (buffer wrap)
  (catch 'found
    (let ((mode (buffer-local-value 'major-mode buffer)))
      (dolist (next-buffer (if isearch-forward
                               (cdr (buffer-list))
                             (reverse (cdr (buffer-list)))))
        (when (eq mode (buffer-local-value 'major-mode next-buffer))
          (throw 'found next-buffer))))))

(defun toggle-misearch ()
  (interactive)
  (if (equal multi-isearch-next-buffer-function nil)
      (setq multi-isearch-next-buffer-function 'misearch-next-buffer)
    (setq multi-isearch-next-buffer-function nil)))



;;ISEARCH HOOK;;(require 'thingatpt)
;;ISEARCH HOOK;;
;;ISEARCH HOOK;;(defun my-isearch-yank-word-or-char-from-beginning ()
;;ISEARCH HOOK;;  "Move to beginning of word before yanking word in isearch-mode."
;;ISEARCH HOOK;;  (interactive)
;;ISEARCH HOOK;;  ;; Making this work after a search string is entered by user
;;ISEARCH HOOK;;  ;; is too hard to do, so work only when search string is empty.
;;ISEARCH HOOK;;  (if (= 0 (length isearch-string))
;;ISEARCH HOOK;;      (beginning-of-thing 'word))
;;ISEARCH HOOK;;  (isearch-yank-word-or-char)
;;ISEARCH HOOK;;  ;; Revert to 'isearch-yank-word-or-char for subsequent calls
;;ISEARCH HOOK;;  (substitute-key-definition 'my-isearch-yank-word-or-char-from-beginning 
;;ISEARCH HOOK;;			     'isearch-yank-word-or-char
;;ISEARCH HOOK;;			     isearch-mode-map))
;;ISEARCH HOOK;;
;;ISEARCH HOOK;;(add-hook 'isearch-mode-hook
;;ISEARCH HOOK;; (lambda ()
;;ISEARCH HOOK;;   "Activate my customized Isearch word yank command."
;;ISEARCH HOOK;;   (substitute-key-definition 'isearch-yank-word-or-char 
;;ISEARCH HOOK;;			      'my-isearch-yank-word-or-char-from-beginning
;;ISEARCH HOOK;;			      isearch-mode-map)))


;;; GNU GLOBAL incremental update It’s possible to use GNU GLOBAL
;;; incremental update feature in after-save-hook in order to keep
;;; synchronized the changes you made in source code and gtags
;;; database:

(append-path (fullpath "../../global/bin/"))
(append-path (fullpath "../../cscope-15.8a/"))

(require 'gtags)
(require 'xcscope) 

(setq gtags-global-command (file-truename (fullpath "../../global/bin/global.exe")))

(defun gtag ()
  (interactive)
  (let ((default-directory (read-directory-name "GTAG를 생성·갱신 할 폴더 :")))
    (if (file-exists-p "GTAGS")
        (async-shell-command  (concat gtags-global-command " -u"))
      (async-shell-command "gtags"))))

(defun ww-next-gtag ()
  "Find next matching tag, for GTAGS."
  (interactive)
  (let ((latest-gtags-buffer
         (car (delq nil  (mapcar (lambda (x) (and (string-match "GTAGS SELECT" (buffer-name x)) (buffer-name x)) )
                                 (buffer-list)) ))))
    (cond (latest-gtags-buffer
           (switch-to-buffer latest-gtags-buffer)
           (forward-line)
           (gtags-select-it nil))
          ) ))


(defun find-tag-dwim(&optional prefix)
  "union of `find-tag' alternatives. decides upon major-mode"
  (interactive "P")
  (if (and (boundp 'gtags-mode)
           gtags-mode)
      (progn
        (ring-insert find-tag-marker-ring (point-marker))
        (call-interactively (if prefix   'ww-next-gtag 'gtags-find-tag)))
    (if (and (boundp 'cscope-minor-mode)
             cscope-minor-mode)
        (progn
          (ring-insert find-tag-marker-ring (point-marker))
          (call-interactively
           (if prefix
               'cscope-find-this-symbol
             'cscope-find-global-definition-no-prompting
             )))
      (call-interactively 'find-tag))))

(substitute-key-definition 'find-tag 'find-tag-dwim  global-map)

(global-set-key 
 (kbd "H-.") 
 '(lambda (&optional prefix)
    (interactive "P")
    (call-interactively (if prefix  'gtags-find-tag ;; H-, find all usages of symbol.
                          'ww-next-gtag)) ;; H-. find all references of tag
    ))

(global-set-key 
 (kbd "H-,") 
 '(lambda (&optional prefix)
    (interactive "P")
   (call-interactively (if prefix  'gtags-find-symbol ;; H-, find all usages of symbol.
                         'gtags-find-rtag)) ;; H-. find all references of tag
   )) 


;;deprecatedby-gtag.el gtag-mode;;(defun gtags-root-dir ()
;;deprecatedby-gtag.el gtag-mode;;  "Returns GTAGS root directory or nil if doesn't exist."
;;deprecatedby-gtag.el gtag-mode;;  (with-temp-buffer
;;deprecatedby-gtag.el gtag-mode;;    (if (zerop (call-process gtags-global-command nil t nil "-pr"))
;;deprecatedby-gtag.el gtag-mode;;        (buffer-substring (point-min) (1- (point-max)))
;;deprecatedby-gtag.el gtag-mode;;      nil)))
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;(defun gtags-update ()
;;deprecatedby-gtag.el gtag-mode;;  "Make GTAGS incremental update"
;;deprecatedby-gtag.el gtag-mode;;  (call-process gtags-global-command nil nil nil "-u"))
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;(defun gtags-update-hook ()
;;deprecatedby-gtag.el gtag-mode;;  (when (gtags-root-dir)
;;deprecatedby-gtag.el gtag-mode;;    (gtags-update)))
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;;;(add-hook 'after-save-hook #'gtags-update-hook)
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;;;;GNU GLOBAL update for a single file
;;deprecatedby-gtag.el gtag-mode;;;;;
;;deprecatedby-gtag.el gtag-mode;;;;;For projects with a huge amount of files, “global -u” can take a
;;deprecatedby-gtag.el gtag-mode;;;;;very long time to complete. For changes in a single file, we can
;;deprecatedby-gtag.el gtag-mode;;;;;update the tags with “gtags --single-update” and do it in the
;;deprecatedby-gtag.el gtag-mode;;;;;background:
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;(defun gtags-update-single(filename)  
;;deprecatedby-gtag.el gtag-mode;;  "Update Gtags database for changes in a single file"
;;deprecatedby-gtag.el gtag-mode;;  (interactive)
;;deprecatedby-gtag.el gtag-mode;;  (start-process "update-gtags" "update-gtags" "bash" "-c" (concat "cd " (gtags-root-dir) " ; gtags --single-update " filename )))
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;(defun gtags-update-current-file()
;;deprecatedby-gtag.el gtag-mode;;  (interactive)
;;deprecatedby-gtag.el gtag-mode;;  (defvar filename)
;;deprecatedby-gtag.el gtag-mode;;  (setq filename (replace-regexp-in-string (gtags-root-dir) "." (buffer-file-name (current-buffer))))
;;deprecatedby-gtag.el gtag-mode;;  (gtags-update-single filename)
;;deprecatedby-gtag.el gtag-mode;;  (message "Gtags updated for %s" filename))
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;(defun gtags-update-hook()
;;deprecatedby-gtag.el gtag-mode;;  "Update GTAGS file incrementally upon saving a file"
;;deprecatedby-gtag.el gtag-mode;;  (when gtags-mode
;;deprecatedby-gtag.el gtag-mode;;    (when (gtags-root-dir)
;;deprecatedby-gtag.el gtag-mode;;      (gtags-update-current-file))))
;;deprecatedby-gtag.el gtag-mode;;
;;deprecatedby-gtag.el gtag-mode;;;;(add-hook 'after-save-hook 'gtags-update-hook)





;; I-search with initial contents.
;; original source: http://platypope.org/blog/2007/8/5/a-compendium-of-awesomeness
(defvar isearch-initial-string nil)

(defun isearch-set-initial-string ()
  (remove-hook 'isearch-mode-hook 'isearch-set-initial-string)
  (setq isearch-string isearch-initial-string)
  (isearch-search-and-update))

(defun isearch-forward-at-point (&optional regexp-p no-recursive-edit)
  "Interactive search forward for the symbol at point."
  (interactive "P\np")
  (if regexp-p (isearch-forward regexp-p no-recursive-edit)
    (let* ((end (progn (skip-syntax-forward "w_") (point)))
           (begin (progn (skip-syntax-backward "w_") (point))))
      (if (eq begin end)
          (isearch-forward regexp-p no-recursive-edit)
        (setq isearch-initial-string (buffer-substring begin end))
        (add-hook 'isearch-mode-hook 'isearch-set-initial-string)
        (isearch-forward regexp-p no-recursive-edit)))))

;; (use-package company
;;   :config
;;   (add-hook 'after-init-hook (lambda () (global-company-mode '(not gud-mode))))
;;   (delete 'company-semantic company-backends)
;;   (define-key c-mode-map    (kbd "<backtab>"  ) 'company-complete)
;;   (define-key c++-mode-map  (kbd "<backtab>"  ) 'company-complete))


(helm-flx-mode +1)

(use-package smartscan
  :defer t
  :config (global-smartscan-mode t)
  (unbind-key "M-n" smartscan-map)
  (unbind-key "M-p" smartscan-map)
  )



;; Uncomment the below line to use eww (Emacs Web Wowser)
;; (setq xah-lookup-browser-function 'eww)

(req-package xah-lookup
  :force t
  :config 
  (defun xah-lookup-cppreference (&optional word)
    "Lookup definition of current word or text selection in URL."
    (interactive)
    (xah-lookup-word-on-internet
     word
     ;; Use � as a placeholder in the query URL.
     "http://en.cppreference.com/mwiki/index.php?search=�"
     xah-lookup-browser-function)))
