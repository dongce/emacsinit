;; -*- coding: utf-8; -*-
;; https://github.com/skeeto/skewer-mode


(use-package httprepl)
(use-package skewer-mode
  :config
  ( skewer-setup ))


(defun httpget (url)
  (interactive "sURL: ")
  (let ((url-request-method "GET")
        ;;(arg-stuff (concat "?query=" (url-hexify-string str)
        ;;                   "&filter=" (url-hexify-string type)))
        )
    (url-retrieve url (lambda (status) (switch-to-buffer (current-buffer))))))



(use-package  google-contacts :commands google-contacts)
