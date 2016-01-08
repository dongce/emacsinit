;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-
;; 재미있는 함수 
(defun create-scratch-buffer nil
  "create a new scratch buffer to work in. (could be *scratch* - *scratchX*)"
  (interactive)
  (let ((n 0)
	bufname)
    (while (progn
	     (setq bufname (concat "*scratch" (if (= n 0) "" (int-to-string n)) "*"))
	     (setq n (1+ n))
	     (get-buffer bufname)))
    (switch-to-buffer (get-buffer-create bufname))
    (if (= n 1) (lisp-interaction-mode))))  ; 1, because n was incremented))

(defun tmpscratch ()
  (interactive)
  (let ((b (get-buffer "*scratch*"))) 
    (if (equal nil b ) (create-scratch-buffer) (switch-to-buffer b ))))

(global-set-key 
 (kbd  "M-<pause>") 
 #'tmpscratch
 )



(defun bury-scratch ()
  "Bury scratch buffer and return nil. Intended to be added to
kill-buffer-query-functions in order to prevent the scratch
buffer being killed."
  (if (or  (string= (buffer-name) "*scratch*")
           (string-match "^\*new" (buffer-name)))
      (progn (bury-buffer) nil)
    t))

(add-to-list 'kill-buffer-query-functions 'bury-scratch)

(defun new-scratch ()
  "open up a guaranteed new scratch buffer"
  (interactive)
  (switch-to-buffer (make-temp-file "kim")))

;; (loop for num from 0 
;; for name = (format "blah-%03i" num) while (get-buffer name) finally return name))) 
