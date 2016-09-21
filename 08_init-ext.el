;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-

(use-package calc-ext)
(use-package sqlite
  :config
  (setq  sqlite-program "t:/usr/local/sqlite/sqlite3.exe"))


;;; http://www.mikusa.com/python-mysql-docs/index.html
;;; pymacs 등을 이용하여 emacs -> sql 이 가능하다. 



(require 'cmuscheme )
(defun socket-scheme ()
  "Run an inferior Scheme process, input and output via buffer `*scheme*'.
If there is a process already running in `*scheme*', switch to that buffer.
With argument, allows you to edit the command line (default is value
of `scheme-program-name').
If the file `~/.emacs_SCHEMENAME' or `~/.emacs.d/init_SCHEMENAME.scm' exists,
it is given as initial input.
Note that this may lose due to a timing error if the Scheme processor
discards input when it starts up.
Runs the hook `inferior-scheme-mode-hook' \(after the `comint-mode-hook'
is run).
\(Type \\[describe-mode] in the process buffer for a list of commands.)"

  (interactive )
  (if (not (comint-check-proc "*scheme*"))
      (progn (set-buffer (make-comint "scheme" (cons "localhost" 7979 )))
             (inferior-scheme-mode)))
  (setq scheme-buffer "*scheme*")
  (pop-to-buffer "*scheme*"))


;;한글을 사용하는데 어려움이 전혀 없음을 알 수 있다. 

;; package auto load next line 
;;(require 'slime)
;;(slime-setup)

;;; SMILE 설정
;;(setq inferior-lisp-program "clisp")
(setq slime-multiprocessing t )
(setq inferior-lisp-program "c:\\usr\\local\\lisp\\allegro\\mlisp.exe")
(setq *slime-lisp* "c:\\usr\\local\\lisp\\allegro\\mlisp.exe")
(setq *slime-port* 4006 )
(defun aslime ()
  (print "Allegro slime...")
  (interactive)
  (shell-command
   (format 
    "%s +B +cm -L %s\\slime.lisp -- -p %s --ef %s &"
    *slime-lisp*
    (getenv "HOME")
    *slime-port*
    slime-net-coding-system))
  (delete-other-windows)
  (while (not (ignore-errors ( slime-connect "localhost" *slime-port*)))
    (sleep-for 0.2 )))

;;(require 'dedicated) 
;; (require 'quack)

;;(require 'comint-popup)  
;;(setq comint-popup-idle-threshold -1)
;; (add-hook 'comint-mode-hook (lambda () (dedicated-mode )))
;;(add-hook 'comint-output-filter-functions 'comint-popup-buffer)

(require 'telnet)

(defun start-telnet (host)
  "Open a network login connection to host named HOST (a string).
   Communication with HOST is recorded in a buffer `*termx*'.
   Normally input is edited in Emacs and sent a line at a time."
  (interactive "sOpen telnet connection to host: ")
  (let* ((comint-delimiter-argument-list '(?\  ?\t))
         (name "termx")
         (buffer (get-buffer "*termx*"))
         process)
    (setq telnet-new-line (char-to-string 13))

    (if (and buffer (get-buffer-process buffer))
        (pop-to-buffer buffer)
      (pop-to-buffer (make-comint name "c:\\usr\\local\\guile\\bin\\plink.exe" nil "-telnet" host))
      (setq process (get-buffer-process (current-buffer)))
      (set-process-filter process 'telnet-initial-filter)
      (accept-process-output process)
      (telnet-mode)
      (setq comint-input-sender 'telnet-simple-send)
      (setq telnet-count telnet-initial-count))))

(defun start-rs232 (host)
  "Open a network login connection to host named HOST (a string).
   Communication with HOST is recorded in a buffer `*termx*'.
   Normally input is edited in Emacs and sent a line at a time."
  (interactive "sOpen telnet connection to host: ")
  (let* ((comint-delimiter-argument-list '(?\  ?\t))
         (buffer (get-buffer "*rs232-term*"))
         process)
    (setq telnet-new-line (char-to-string 13))

    (if (and buffer (get-buffer-process buffer))
        (pop-to-buffer buffer)
      (pop-to-buffer (make-comint "rs232-term" "c:\\usr\\local\\guile\\bin\\plink.exe" nil "-load" host))
      (setq process (get-buffer-process (current-buffer)))
      ;;(set-process-filter process 'telnet-initial-filter)
      (telnet-mode)
      (setq comint-input-sender 'telnet-simple-send)
      ;;(setq telnet-count telnet-initial-count)
      )))



(defun num-list (start end  )
  (interactive)
  (let ((result '()))
    (while 
        (not (= start end ))
      (setq result (cons start result))
      (setq start (+ start 1 )))
    (reverse result)))


(setf comint-input-sender-no-newline t )
