;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

(use-package project-buffer-mode
  :config
  (require 'project-buffer-mode+)
  (project-buffer-mode-p-setup)
  (require 'project-buffer-occur)
  (define-key project-buffer-mode-map [(?O)] 'project-buffer-occur))

;;(autoload 'find-sln "sln-mode" "" t)

(require 'sln-mode )

;; 함수를 재정의 합니다. 
(defun sln-action-handler-2005 (action project-name project-path platform configuration)
  (let ((sln-cmd (cond ((eq action 'build) "")
                       ((eq action 'clean) "/clean")
                       ((eq action 'run)   "")
                       ((eq action 'debug) ""))))
    (when (or (not (eq action 'clean))
              (funcall project-buffer-confirm-function (format "Clean the project %s " project-name)))
      (compile (format "vcbuild /platform:%s %s %s" platform sln-cmd project-path)))))


(defun open-sln (f)
  (if (file-exists-p f )  (find-sln f )))

;;(require 'project-persist)

(require 'iproject)
(iproject-key-binding)

(require 'fsproject)

(defun make-action-handler(action project-name project-path platform configuration)
  "project action handler."
  (let ((make-cmd (cond ((eq action 'build) "")
                        ((eq action 'clean) "clean")
                        ((eq action 'run)   "run")
                        ((eq action 'debug) "debug"))))
    (compile 
     (concat "make -j16 -C " (file-name-directory project-path) 
                      " -f " (file-name-nondirectory project-path) 
                         " " make-cmd))))

;;(autoload 'fsproject-create-project "fsproject")
;;(defun fsproject-new(root-folder)
;;  (interactive "sRoot folder: ")
;;  (let ((regexp-project-name  "[Mm]akefile")
;;        (regexp-file-filter   '("\\.cpp$" "\\.h$" "\\.inl$" "\\.mak$" "Makefile"))
;;        (ignore-folders       '("build" "docs" "bin"))
;;        (pattern-modifier     nil)
;;        (build-configurations '("debug" "release"))
;;        (platforms            '("Linux")))
;;    (fsproject-create-project root-folder
;;                              regexp-project-name
;;                              regexp-file-filter
;;                              'make-action-handler
;;                              ignore-folders
;;                              pattern-modifier
;;                              build-configurations
;;                              platforms)))
;;


;;(autoload 'fsproject-create-project "fsproject")
(defun fsproject-new(root-folder)
  (interactive "sRoot folder: ")
  (let ((regexp-project-name  "[Mm]akefile")
        (regexp-file-filter   '("\\.cpp$" "\\.h$" "\\.inl$" "\\.mak$" "Makefile"))
        (ignore-folders       '("build" "docs" "bin"))
        (pattern-modifier     '(("^\\(?:.*/\\)?\\([a-zA-Z0-9_]*\\.cpp\\)$" . "source/\\1")
                                ("^\\(?:.*/\\)?\\([a-zA-Z0-9_]*\\.\\(?:h\\|inl\\)\\)$" . "include/\\1")))
        (build-configurations '("debug" "release"))
        (platforms            '("Linux")))
    (fsproject-create-project root-folder
                              regexp-project-name
                              regexp-file-filter
                              'make-action-handler
                              ignore-folders
                              pattern-modifier
                              build-configurations
                              platforms)))
(with-package*
  (projectile)
 (defun projectile-serialize (data filename)
  "Serialize DATA to FILENAME.

The saved data can be restored with `projectile-unserialize'."
  (when (file-writable-p filename)
    (with-temp-file filename
      (set-buffer-file-coding-system 'utf-8) ;계속 물어봐서 고정하였음. 
      (insert (let (print-length) (prin1-to-string data))))))

(defun projectile-unserialize (filename)
  "Read data serialized by `projectile-serialize' from FILENAME."
  (when (file-exists-p filename)
    (with-temp-buffer
      (set-buffer-file-coding-system 'utf-8) ;계속 물어봐서 고정하였음. 
      (insert-file-contents filename)
      (read (buffer-string))))))


;; check following
(with-package* (projectile project-explorer grep )
  ;;conflict-pscp-tramp;; (projectile-global-mode)
  (setq projectile-enable-caching t)

  (defun project-explorer-close ()
    (interactive)
    (save-excursion
      (save-restriction

        (dolist (buf (buffer-list))
          (with-current-buffer buf
            (if (eq 'project-explorer-mode major-mode)
                (kill-buffer))))
        (kill-buffer  "*project-explorer*"))))
  (defun projectile-grep ()
    "Perform rgrep in the project."
    (interactive)
    (let ((roots (projectile-get-project-directories))
          (search-regexp (if (and transient-mark-mode mark-active)
                             (buffer-substring (region-beginning) (region-end))
                           (read-string (projectile-prepend-project-name "Grep for: ")
                                        (projectile-symbol-at-point)))))
      (dolist (root-dir roots)
        ;; paths for find-grep should relative and without trailing /
        (let ((default-directory root-dir))
          (grep (concat grep-command "\"" search-regexp "\"")))))))


;;(add-hook 'ruby-mode-hook 'projectile-on)

;;If you don't like ido you can use regular completion as well:

;;(setq projectile-completion-system 'default)

;;You might want to combine default completion with icomplete-mode for optimum results.

;;Here's a list of the interactive Emacs Lisp functions, provided by projectile:
;;Command 	Key
;;projectile-find-file 	C-c p f
;;projectile-grep 	C-c p g
;;projectile-switch-to-buffer 	C-c p b
;;projectile-multi-occur 	C-c p o
;;projectile-replace 	C-c p r
;;projectile-invalidate-cache 	C-c p i
;;projectile-regenerate-tags 	C-c p t
;;projectile-kill-buffers 	C-c p k
;;projectile-dired 	C-c p d
;;projectile-recentf 	C-c p e
;;projectile-ack 	C-c p a
;;projectile-compile-project 	C-c p l
;;projectile-test-project 	C-c p p
;;
;;If you ever forget any of Projectile's keybindings just do a:

;;C-c p C-h

(with-package* (helm helm-config))
;;(global-set-key (kbd "C-c h") 'helm-mini)
;;(helm-mode 1)
;; https://github.com/emacs-helm/helm/wiki


(add-hook 'isearch-mode-hook
          (function
           (lambda ()
             (define-key isearch-mode-map "\C-h" 'isearch-mode-help)
             (define-key isearch-mode-map "\C-t" 'isearch-toggle-regexp)
             (define-key isearch-mode-map "\C-c" 'isearch-toggle-case-fold)
             (define-key isearch-mode-map "\C-j" 'isearch-edit-string))))

;;(add-to-list 'minor-mode-alist '(case-fold-search " CFS"))

;; (require 'xmsi-math-symbols-input)
(use-package xah-math-input)
;;; 관련 변수 확인 
;;; major-mode       -> buffer local 
;;; minor-mode-list  -> buffer local 
;;; minor-mode-alist -> global  
(add-hook 'prog-mode-hook 'fic-mode)
(add-hook 'prog-mode-hook 'yafolding-mode)

;;notworks;;(require 'jfold-mode)
;;notworks;;(add-hook 'nxml-mode-hook 'jfold-mode)


(require 'hideshow)
(require 'sgml-mode)
(require 'nxml-mode)

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))

(add-hook 'nxml-mode-hook 'hs-minor-mode)

;; optional key bindings, easier than hs defaults
(define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)


;;conflict-tramp;;(add-hook 
;;conflict-tramp;; 'term-mode-hook 
;;conflict-tramp;; (lambda () 
;;conflict-tramp;;   (setq comint-use-prompt-regexp t )
;;conflict-tramp;;   (define-key term-raw-map [backspace] 'term-send-right)
;;conflict-tramp;;   (define-key term-raw-map "\C-c\C-y" 'term-paste)
;;conflict-tramp;;   (setq term-prompt-regexp "^->")))

;;; https://github.com/leoliu/easy-kill

;; w -> word at point
;; s -> sexp at point
;; f -> file at point
;; l -> list at point
;; d -> defun at point
;; b -> buffer-file-name or default-directory
;; @ -> append selection to previous kill
;; C-w -> kill selection
;; +, - and 0..9 -> expand/shrink selection
;; SPC -> turn selection into an active region
;; C-g -> abort

;; (with-package* (phi-rectangle easy-kill)
;;   (defun phi-rectangle-kill-ring-save (&optional n)
;;     "when region is active, copy region as usual. when rectangle-region is
;; active, copy rectangle. otherwise, copy whole line."
;;     (interactive "p")
;;     (cond (phi-rectangle-mark-active
;;            (phi-rectangle--copy-rectangle (region-beginning) (region-end))
;;            (phi-rectangle--delete-trailing-whitespaces (region-beginning) (region-end)))
;;           (t (easy-kill n))))
;;   (phi-rectangle-mode)
;;   ;; (define-key phi-rectangle-mode-map [remap phi-rectangle-kill-ring-save] 'easy-kill)
;;   )

(global-anzu-mode t)


(require 'loccur)
;; http://www.ispl.jp/~oosaki/research/linux-tips/outline/
(add-hook 
 'diff-mode-hook 
 (lambda ()
   (setq outline-regexp "^\\(diff\\|@@\\|===\\) ")
   (setq 
    outline-level 
    (lambda ()
      (cond ((looking-at "diff") 1) 
            ((looking-at "===") 1) 
            ((looking-at "@@") 2)
            (t 1000)
            )))
   (outline-minor-mode t)
   ))

(require 'nxml-mode)
(require 'nxml-util)
