
;;(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us") ; US

(add-to-list 'load-path (fullpath  "../../ergoemacs/packages/"))
(add-to-list 'load-path (fullpath  "../../ergoemacs/ergoemacs/ergoemacs-keybindings"))

;;(load-file 
;; (concat (file-name-directory (or load-file-name buffer-file-name)) "../../../ergoemacs/site-lisp/site-start.el"))

;;(require 'xah_file_util)


(require 'ergoemacs-functions)
(global-set-key (kbd "<M-left>")  'ergoemacs-backward-open-bracket) ; Alt+←
(global-set-key (kbd "<M-right>") 'ergoemacs-forward-close-bracket) ; Alt+→
(global-set-key (kbd "<M-up>")    'scroll-up-command) ; 
(global-set-key (kbd "<M-down>")  'scroll-down-command) ; 
