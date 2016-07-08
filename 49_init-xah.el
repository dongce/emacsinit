(setq minibuffer-prompt-properties
      (quote (read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)))

;; http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html

(defvar xah-switch-buffer-ignore-dired t "If t, ignore dired buffer when calling `xah-next-user-buffer' or `xah-previous-user-buffer'")
(setq xah-switch-buffer-ignore-dired t)

(defun xah-next-user-buffer ()
  "Switch to the next user buffer.
 “user buffer” is a buffer whose name does not start with “*”.
If `xah-switch-buffer-ignore-dired' is true, also skip directory buffer.
2015-01-05 URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (or
           (string-equal "*" (substring (buffer-name) 0 1))
           (if (string-equal major-mode "dired-mode")
               xah-switch-buffer-ignore-dired
             nil
             ))
          (progn (next-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-previous-user-buffer ()
  "Switch to the previous user buffer.
 “user buffer” is a buffer whose name does not start with “*”.
If `xah-switch-buffer-ignore-dired' is true, also skip directory buffer.
2015-01-05 URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (or
           (string-equal "*" (substring (buffer-name) 0 1))
           (if (string-equal major-mode "dired-mode")
               xah-switch-buffer-ignore-dired
             nil
             ))
          (progn (previous-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-next-emacs-buffer ()
  "Switch to the next emacs buffer.
 (buffer name that starts with “*”)"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (next-buffer))))

(defun xah-previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
 (buffer name that starts with “*”)"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (previous-buffer))))



(defun xah-replace-BOM-mark-etc ()
  "Query replace some invisible Unicode chars.
The chars to be searched are:
 ZERO WIDTH NO-BREAK SPACE (codepoint 65279, #xfeff)
 RIGHT-TO-LEFT MARK (codepoint 8207, #x200f)
 RIGHT-TO-LEFT OVERRIDE (codepoint 8238, #x202e)

Search begins at buffer beginning (respects `narrow-to-region').

This is useful for text copied from twitter or Google Plus, because they often contain BOM mark. See URL `http://xahlee.info/comp/unicode_BOM_byte_orde_mark.html'

URL `http://ergoemacs.org/emacs/elisp_unicode_replace_invisible_chars.html'
Version 2015-10-11"
  (interactive)
  (progn
    (goto-char (point-min))
    (query-replace-regexp "\u200f\\|\u202e\\|\ufeff" "")))






(defun xah-replace-BOM-mark-dir ()
  "temp hack. replace some invisible Unicode chars.
see `xah-replace-BOM-mark-etc'
Version 2015-10-11"
  (interactive)
  (require 'xah-find)
  (let (ξdir)
    (setq ξdir (ido-read-directory-name "Directory: " default-directory default-directory "MUSTMATCH"))
    (xah-find-replace-text (char-to-string 65279) "" ξdir "\\.html\\'" t t t t)))



;;(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us") ; US

(add-to-list 'load-path (fullpath  "../../ergoemacs/packages/"))
(add-to-list 'load-path (fullpath  "../../ergoemacs/ergoemacs/ergoemacs-keybindings"))

;;(load-file 
;; (concat (file-name-directory (or load-file-name buffer-file-name)) "../../../ergoemacs/site-lisp/site-start.el"))

;;(require 'xah_file_util)


(use-package ergoemacs-functions
  :config
  (global-set-key (kbd "<M-left>")  'ergoemacs-backward-open-bracket) ; Alt+←
  (global-set-key (kbd "<M-right>") 'ergoemacs-forward-close-bracket) ; Alt+→
  (global-set-key (kbd "<M-up>")    'scroll-up-command) ; 
  (global-set-key (kbd "<M-down>")  'scroll-down-command)) ; 

(use-package xah-math-input
  :config
  (define-key xah-math-input-keymap "\C-\\"  'xah-math-input-change-to-symbol)
  (define-key xah-math-input-keymap (kbd "S-SPC") 'toggle-korean-input-method))

(defun xah-search-current-word ()
  "Call `isearch' on current word or text selection.
“word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of syntax table.
URL `http://ergoemacs.org/emacs/modernization_isearch.html'
Version 2015-04-09"
  (interactive)
  (let ( ξp1 ξp2 )
    (if (use-region-p)
        (progn
          (setq ξp1 (region-beginning))
          (setq ξp2 (region-end)))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq ξp1 (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq ξp2 (point))))
    (setq mark-active nil)
    (when (< ξp1 (point))
      (goto-char ξp1))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties ξp1 ξp2))))


(progn
  ;; set arrow keys in isearch. left/right is backward/forward, up/down is history. press Return to exit
  (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat )
  (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance )
  (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward) ; single key, useful
  (define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward) ; single key, useful
 )




(defvar xah-recently-closed-buffers nil "alist of recently closed buffers. Each element is (buffer name, file path). The max number to track is controlled by the variable `xah-recently-closed-buffers-max'.")

(defvar xah-recently-closed-buffers-max 40 "The maximum length for `xah-recently-closed-buffers'.")


(defun xah-close-current-buffer ()
  "Close the current buffer.

Similar to `kill-buffer', with the following addition:

• Prompt user to save if the buffer has been modified even if the buffer is not associated with a file.
• If the buffer is editing a source file in an org-mode file, prompt the user to save before closing.
• If the buffer is a file, add the path to the list `xah-recently-closed-buffers'.
• If it is the minibuffer, exit the minibuffer

URL `http://ergoemacs.org/emacs/elisp_close_buffer_open_last_closed.html'
Version 2016-06-19"
  (interactive)
  (let (ξemacs-buff-p
        (ξorg-p (string-match "^*Org Src" (buffer-name))))

    (setq ξemacs-buff-p (if (string-match "^*" (buffer-name)) t nil))

    (if (string= major-mode "minibuffer-inactive-mode")
        (minibuffer-keyboard-quit) ; if the buffer is minibuffer
      (progn
        ;; offer to save buffers that are non-empty and modified, even for non-file visiting buffer. (because kill-buffer does not offer to save buffers that are not associated with files)
        (when (and (buffer-modified-p)
                   (not ξemacs-buff-p)
                   (not (string-equal major-mode "dired-mode"))
                   (if (equal (buffer-file-name) nil)
                       (if (string-equal "" (save-restriction (widen) (buffer-string))) nil t)
                     t))
          (if (y-or-n-p (format "Buffer %s modified; Do you want to save? " (buffer-name)))
              (save-buffer)
            (set-buffer-modified-p nil)))
        (when (and (buffer-modified-p)
                   ξorg-p)
          (if (y-or-n-p (format "Buffer %s modified; Do you want to save? " (buffer-name)))
              (org-edit-src-save)
            (set-buffer-modified-p nil)))

        ;; save to a list of closed buffer
        (when (buffer-file-name)
          (setq xah-recently-closed-buffers
                (cons (cons (buffer-name) (buffer-file-name)) xah-recently-closed-buffers))
          (when (> (length xah-recently-closed-buffers) xah-recently-closed-buffers-max)
            (setq xah-recently-closed-buffers (butlast xah-recently-closed-buffers 1))))

        ;; close
        (kill-buffer (current-buffer))))))


(defun xah-open-last-closed ()
  "Open the last closed file.
URL `http://ergoemacs.org/emacs/elisp_close_buffer_open_last_closed.html'
Version 2016-06-19"
  (interactive)
  (if (> (length xah-recently-closed-buffers) 0)
      (find-file (cdr (pop xah-recently-closed-buffers)))
    (progn (message "No recently close buffer in this session."))))

(defun xah-open-recently-closed ()
  "Open recently closed file.
Prompt for a choice.
URL `http://ergoemacs.org/emacs/elisp_close_buffer_open_last_closed.html'
Version 2016-06-19"
  (interactive)
  (find-file (ido-completing-read "open:" (mapcar (lambda (f) (cdr f)) xah-recently-closed-buffers))))

(defun xah-list-recently-closed ()
  "List recently closed file.
URL `http://ergoemacs.org/emacs/elisp_close_buffer_open_last_closed.html'
Version 2016-06-19"
  (interactive)
  (let ((ξbuf (generate-new-buffer "*recently closed*")))
    (switch-to-buffer ξbuf)
    (mapc (lambda (ξf) (insert (cdr ξf) "\n"))
          xah-recently-closed-buffers)))
