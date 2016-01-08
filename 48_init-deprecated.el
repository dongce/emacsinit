(fset 'shell-quote-argument-origin #'shell-quote-argument)       ;원본버젼 )
(defun shell-quote-argument (argument)
  "Quote ARGUMENT for passing as argument to an inferior shell."
  (cond
   ((or (eq system-type 'ms-dos) (and (eq system-type 'windows-nt) (w32-shell-dos-semantics)));;(eq system-type 'ms-dos)
    
    ;; Quote using double quotes, but escape any existing quotes in
    ;; the argument with backslashes.
    (let ((result "")
          (start 0)
          end)
      (if (or (null (string-match "[^\"]" argument))
              (< (match-end 0) (length argument)))
          (while (string-match "[\"]" argument start)
            (setq end (match-beginning 0)
                  result (concat result (substring argument start end)
                                 "\\" (substring argument end (1+ end)))
                  start (1+ end))))
      (concat "\"" result (substring argument start) "\"")))

   ((and (eq system-type 'windows-nt) (w32-shell-dos-semantics))

    ;; First, quote argument so that CommandLineToArgvW will
    ;; understand it.  See
    ;; http://msdn.microsoft.com/en-us/library/17w5ykft%28v=vs.85%29.aspx
    ;; After we perform that level of quoting, escape shell
    ;; metacharacters so that cmd won't mangle our argument.  If the
    ;; argument contains no double quote characters, we can just
    ;; surround it with double quotes.  Otherwise, we need to prefix
    ;; each shell metacharacter with a caret.

    (setq argument
          ;; escape backslashes at end of string
          (replace-regexp-in-string
           "\\(\\\\*\\)$"
           "\\1\\1"
           ;; escape backslashes and quotes in string body
           (replace-regexp-in-string
            "\\(\\\\*\\)\""
            "\\1\\1\\\\\""
            argument)))

    (if (string-match "[%!\"]" argument)
        (concat
         "^\""
         (replace-regexp-in-string
          "\\([%!()\"<>&|^]\\)"
          "^\\1"
          argument)
         "^\"")
      (concat "\"" argument "\"")))

   (t
    (if (equal argument "")
        "''"
      ;; Quote everything except POSIX filename characters.
      ;; This should be safe enough even for really weird shells.
      (replace-regexp-in-string
       "\n" "'\n'"
       (replace-regexp-in-string "[^-0-9a-zA-Z_./\n]" "\\\\\\&" argument))))
   ))


(if (not (fboundp 'read-only-mode))
    (defalias 'read-only-mode 'toggle-read-only))
