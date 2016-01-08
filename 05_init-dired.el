;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

(w32-unix-eval
 ;; 윈도우 시스템의 경우
 ;; emacs 에서 FIND 가능
 (;;(color-theme-parus)
  ;;  (color-theme-vim-colors)
  ;;  (color-theme-blue2)
  ;;  (color-theme-emacs-21)
  (require 'find-dired )
  (require 'w32-find-dired )
  (require 'w32-winprint )
  (let ((lisp-dir (expand-file-name (concat emacsw32-home "/EmacsW32/lisp/"))))
    (unless (file-accessible-directory-p lisp-dir)
      (lwarn "Can't find %s" lisp-dir)
      (sit-for 10))
    (when (file-accessible-directory-p lisp-dir)
      (message "Adding %s to load-path" lisp-dir)
      (add-to-list 'load-path lisp-dir))
    (require 'emacsw32 nil t)
    (unless (featurep 'emacsw32)
      (lwarn '(emacsw32) :error "Could not find emacsw32.el")))


  ;; 프린팅 관련 변수
  (define-key dired-mode-map "o" 'w32-dired-open-explorer)
  (define-key dired-mode-map "," 'w32-dired-open-explorer-marked)
  (define-key dired-mode-map "\\" 'w32-dired-copy-file-name)
  (define-key dired-mode-map "["  'w32shell-cmd-here)
  ;; 윈도우에서 유용하게 사용할 수 있는 방법
  (defun w32-dired-open-explorer ()
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive)
    (let ((file-name (replace-regexp-in-string "/" "\\" (dired-get-file-for-visit) nil t)))
      ;;(message (replace-regexp-in-string "/" "\\" file-name nil t) )
      (if (file-exists-p file-name)
          (w32-shell-execute nil  file-name nil 1))))

  (defun w32-dired-print ()
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive)
    (let ((file-name (replace-regexp-in-string "/" "\\" (dired-get-file-for-visit) nil t)))
      ;;(message (replace-regexp-in-string "/" "\\" file-name nil t) )
      (if (file-exists-p file-name)
          (w32-shell-execute "print"  file-name nil 1))))

  (defun w32-dired-open-explorer-marked()
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive)
    (let ((file-names (dired-get-marked-files)))
      (mapcar
       (lambda ( x )
         (if (file-exists-p x )
             (w32-shell-execute nil x nil 1)))
       file-names )))

  (defun w32-execute-line ()
    (interactive)
    (w32-shell-execute nil (buffer-substring (point) (point-at-eol)) nil 1))

  (defun w32-dired-copy-file-name(&optional arg)
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive "P")
    ;;emacs와 상관없이 동작 ;;(w32-set-clipboard-data (replace-regexp-in-string "/" "\\" (file-truename (dired-get-filename nil t))nil t)))
    (let ((pathname (file-truename (dired-get-filename nil t))))
      (if arg
          (kill-new pathname)
        (kill-new (replace-regexp-in-string "/" "\\" pathname nil t))
        )))

  (require 'sml-modeline)
  (sml-modeline-mode)

  (require 'init-external)

  (let ((default-directory (fullpath "../../mumailindexer/share/emacs/site-lisp")))
    (normal-top-level-add-subdirs-to-load-path))
  
  )
 ()
)


;; 23 버젼 관련 설정입니다.

(setq ls-lisp-verbosity '(uid))


(defun mrc-dired-do-command (command)
    "Run COMMAND on marked files. Any files not already open will be opened.
After this command has been run, any buffers it's modified will remain
open and unsaved."
    (interactive "CRun on marked files M-x ")
    (save-window-excursion
      (mapc (lambda (filename)
              (find-file filename)
              (call-interactively command))
            (dired-get-marked-files))))

(toggle-diredp-find-file-reuse-dir 1)
;; writable-dired
;;【Ctrl+x Ctrl+q】 (emacs 23.1)	wdired-change-to-wdired-mode	Start rename by editing
;;【Ctrl+c Ctrl+c】	wdired-finish-edit	Commit changes
;;【Ctrl+c Esc】	wdired-abort-changes	Abort changes

;;(with-package* (tramp)
;;  (setq tramp-default-method "ftp")
;;  (setq ange-ftp-default-user "user1")
;;  ;; (setq ange-ftp-ftp-program-name "ftp.exe")
;;  (setq ange-ftp-ftp-program-name (fullpath "../../EmacsW32/gnuwin32/bin/ftp.exe")) ;ftp passive mode 
;;  )

(use-package hl-line+
  :config
(add-hook 'dired-mode-hook (lambda () (interactive) (hl-line-mode t))))
