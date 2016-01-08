(defalias 'yes-or-no-p 'y-or-n-p) ; y or n is enough
(defalias 'list-buffers 'ibuffer) ; always use ibuffer
(defalias 'perl-mode 'cperl-mode) ; always use cperl-mode


;; make frequently used commands short
(defalias 'qrr 'query-replace-regexp)
(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'dnml 'delete-non-matching-lines)
(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'sl 'sort-lines)
(defalias 'rr 'reverse-region)
(defalias 'rs 'replace-string)

(defalias 'g 'grep)
(defalias 'gf 'grep-find)
(defalias 'fd 'find-dired)

(defalias 'rb 'revert-buffer)

(defalias 'sh 'shell)
(defalias 'ps 'powershell)
(defalias 'fb 'flyspell-buffer)
(defalias 'sbc 'set-background-color)
(defalias 'rof 'recentf-open-files)
(defalias 'lcd 'list-colors-display)
(defalias 'cc 'calc)

; elisp
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ed 'eval-defun)
(defalias 'eis 'elisp-index-search)
(defalias 'lf 'load-file)

; major modes
(defalias 'hm 'html-mode)
(defalias 'tm 'text-mode)
(defalias 'elm 'emacs-lisp-mode)
(defalias 'om 'org-mode)
(defalias 'ssm 'shell-script-mode)
(defalias 'html6-mode 'xah-html6-mode)

; minor modes
(defalias 'wsm 'whitespace-mode)
(defalias 'gwsm 'global-whitespace-mode)
(defalias 'dsm 'desktop-save-mode)
(defalias 'acm 'auto-complete-mode)
(defalias 'vlm 'visual-line-mode)
(defalias 'glm 'global-linum-mode)



;; xah personal
(defalias '8w 'xwe-new-word-entry)
(defalias '8d 'xwe-add-definition)
(defalias '8s 'xwe-add-source)

(defalias 'c 'xah-cite)
(defalias 'z 'amazon-linkify)

(defalias '~ 'make-backup)
(defalias '& 'replace-html-chars-region)
(defalias '\\ 'escape-quotes-region)
(defalias '\[ 'remove-square-brackets)
(defalias '\" 'replace-straight-quotes)

;; ;; major modes, use easy-to-remember names
;; (defalias 'ahk-mode 'xahk-mode)
;; (defalias 'bbcode-mode 'xbbcode-mode)
;; (defalias 'lsl-mode 'xlsl-mode)
;; (defalias 'ocaml-mode 'tuareg-mode)
;; (defalias 'math-symbol-input-mode 'xmsi-mode)



;; ;; xah personal
;; (defalias '8w 'xwe-new-word-entry)
;; (defalias '8d 'xwe-add-definition)
;; (defalias '8s 'xwe-add-source)

;; (defalias 'c 'xah-cite)
;; (defalias 'z 'amazon-linkify)

;; (defalias '~ 'make-backup)
;; (defalias '& 'replace-html-chars)
;; (defalias '\\ 'escape-quotes-region)
;; (defalias '\[ 'remove-square-brackets)
;; (defalias '\" 'replace-straight-quotes)


(defalias 'ppush 'point-stack-push)
(defalias 'ppop 'point-stack-pop)
(defalias 'pfsp 'point-stack-forwrad-stack-pop)
(defalias 'cfp  'clip-file-position)
