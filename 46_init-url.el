;; -*- coding: utf-8; -*-
;; http://www.emacswiki.org/emacs/UrlPackage


(defun httpget (url)
  (interactive "sURL: ")
  (let ((url-request-method "GET")
        ;;(arg-stuff (concat "?query=" (url-hexify-string str)
        ;;                   "&filter=" (url-hexify-string type)))
        )
    (url-retrieve url (lambda (status) (switch-to-buffer (current-buffer))))))


