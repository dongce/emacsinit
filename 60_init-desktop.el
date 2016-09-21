
;; desktop 
(setq desktop-enable t )
(desktop-load-default)
(desktop-read)
(defun desktop-clear-not-modified ()
  "Empty the Desktop.
desktop-clear ����߿��� ������� ���� ���ϸ��� �ݴ´�."
  (interactive)
  (desktop-lazy-abort)
  (dolist (var desktop-globals-to-clear)
    (if (symbolp var)
      (eval `(setq-default ,var nil))
      (eval `(setq-default ,(car var) ,(cdr var)))))
  (let ((buffers (buffer-list))
        (preserve-regexp (concat "^\\("
                                 (mapconcat (lambda (regexp)
                                              (concat "\\(" regexp "\\)"))
                                            desktop-clear-preserve-buffers
                                            "\\|")
                                 "\\)$")))
    (while buffers
      (let ((bufname (buffer-name (car buffers))))
         (or
           (null bufname)
           (string-match preserve-regexp bufname)
           ;; Don't kill buffers made for internal purposes.
           (and (not (equal bufname "")) (eq (aref bufname 0) ?\s))
           (if (not (buffer-modified-p (car buffers))) (kill-buffer (car buffers)))))
      (setq buffers (cdr buffers))))
  (delete-other-windows))

(define-key Buffer-menu-mode-map "c" 'desktop-clear-not-modified)
