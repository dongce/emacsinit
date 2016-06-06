;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-
;;암호화 기능을 사용할 수 있습니다. 
(require 'epg-config)
(require 'epa)
(require 'epa-file)

(epa-file--file-name-regexp-set 'epa-file-name-regexp "\\.gpg\\(~\\|\\.~[0-9]+~\\)?\\'\\|암호화\\|cipher-folder")

(defun epa-file-decode-and-insert (string file visit beg end replace)
  (insert (epa-file--decode-coding-string string 'cp949)))


(defun epg--start (context args)
  "Start `epg-gpg-program' in a subprocess with given ARGS."
  (if (and (epg-context-process context)
	   (eq (process-status (epg-context-process context)) 'run))
      (error "%s is already running in this context"
	     (epg-context-program context)))
  (let* ((agent-info (getenv "GPG_AGENT_INFO"))
	 (args (append (list "--no-tty"
			     "--status-fd" "1"
			     "--yes")
		       (if (and (not (eq (epg-context-protocol context) 'CMS))
				(string-match ":" (or agent-info "")))
			   '("--use-agent"))
		       (if (and (not (eq (epg-context-protocol context) 'CMS))
				(epg-context-progress-callback context))
			   '("--enable-progress-filter"))
		       (if (epg-context-home-directory context)
			   (list "--homedir"
				 (epg-context-home-directory context)))
		       (unless (eq (epg-context-protocol context) 'CMS)
			 '("--command-fd" "0"))
		       (if (epg-context-armor context) '("--armor"))
		       (if (epg-context-textmode context) '("--textmode"))
		       (if (epg-context-output-file context)
			   (list "--output" (epg-context-output-file context)))
		       (if (epg-context-pinentry-mode context)
			   (list "--pinentry-mode"
				 (symbol-name (epg-context-pinentry-mode
					       context))))
		       args))
	 (process-environment process-environment)
	 (buffer (generate-new-buffer " *epg*"))
	 error-process
	 process
	 terminal-name
	 agent-file
	 (agent-mtime '(0 0 0 0)))
    ;; Set GPG_TTY and TERM for pinentry-curses.  Note that we can't
    ;; use `terminal-name' here to get the real pty name for the child
    ;; process, though /dev/fd/0" is not portable.
    (unless (memq system-type '(ms-dos windows-nt))
      (with-temp-buffer
	(condition-case nil
	    (when (= (call-process "tty" "/dev/fd/0" t) 0)
	      (delete-char -1)
	      (setq terminal-name (buffer-string)))
	  (file-error))))
    (when terminal-name
      (setq process-environment
	    (cons (concat "GPG_TTY=" terminal-name)
		  (cons "TERM=xterm" process-environment))))
    ;; Start the Emacs Pinentry server if allow-emacs-pinentry is set
    ;; in ~/.gnupg/gpg-agent.conf.
    (when (and (fboundp 'pinentry-start)
	       (executable-find epg-gpgconf-program)
	       (with-temp-buffer
		 (when (= (call-process epg-gpgconf-program nil t nil
					"--list-options" "gpg-agent")
			  0)
		   (goto-char (point-min))
		   (re-search-forward
                    "^allow-emacs-pinentry:\\(?:.*:\\)\\{8\\}1"
                    nil t))))
      (pinentry-start))
    (setq process-environment
	  (cons (format "INSIDE_EMACS=%s,epg" emacs-version)
		process-environment))
    ;; Record modified time of gpg-agent socket to restore the Emacs
    ;; frame on text terminal in `epg-wait-for-completion'.
    ;; See
    ;; <http://lists.gnu.org/archive/html/emacs-devel/2007-02/msg00755.html>
    ;; for more details.
    (when (and agent-info (string-match "\\(.*\\):[0-9]+:[0-9]+" agent-info))
      (setq agent-file (match-string 1 agent-info)
	    agent-mtime (or (nth 5 (file-attributes agent-file)) '(0 0 0 0))))
    (if epg-debug
	(save-excursion
	  (unless epg-debug-buffer
	    (setq epg-debug-buffer (generate-new-buffer " *epg-debug*")))
	  (set-buffer epg-debug-buffer)
	  (goto-char (point-max))
	  (insert (if agent-info
		      (format "GPG_AGENT_INFO=%s\n" agent-info)
		    "GPG_AGENT_INFO is not set\n")
		  (format "%s %s\n"
			  (epg-context-program context)
			  (mapconcat #'identity args " ")))))
    (with-current-buffer buffer
      (if (fboundp 'set-buffer-multibyte)
	  (set-buffer-multibyte nil))
      (make-local-variable 'epg-last-status)
      (setq epg-last-status nil)
      (make-local-variable 'epg-read-point)
      (setq epg-read-point (point-min))
      (make-local-variable 'epg-process-filter-running)
      (setq epg-process-filter-running nil)
      (make-local-variable 'epg-pending-status-list)
      (setq epg-pending-status-list nil)
      (make-local-variable 'epg-key-id)
      (setq epg-key-id nil)
      (make-local-variable 'epg-context)
      (setq epg-context context)
      (make-local-variable 'epg-agent-file)
      (setq epg-agent-file agent-file)
      (make-local-variable 'epg-agent-mtime)
      (setq epg-agent-mtime agent-mtime))
    (setq error-process
	  (make-pipe-process :name "epg-error"
			     :buffer (generate-new-buffer " *epg-error*")
			     ;; Suppress "XXX finished" line.
			     :sentinel #'ignore
			     :noquery t))
    (setf (epg-context-error-buffer context) (process-buffer error-process))
    (with-file-modes 448
      (setq process (make-process :name "epg"
				  :buffer buffer
				  :command (cons (epg-context-program context)
						 args)
				  :connection-type 'pipe
				  :coding '(cp949 . cp949)
				  :filter #'epg--process-filter
				  :stderr error-process
				  :noquery t)))
    (setf (epg-context-process context) process)))





