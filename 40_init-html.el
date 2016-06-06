;;; https://github.com/skeeto/impatient-mode


;; Impatient Mode

;; See the effect of your HTML as you type it.

;;     YouTube demo

;; Installation through MELPA

;; The easiest way to get up and running with impatient-mode is to install it through MELPA. If you're not already using MELPA, it's quite easy to setup.
;; Installation from Source

;; If you are installing from source, please note that this package requires both simple-httpd and htmlize in order to operate. The simple-httpd webserver runs within emacs to serve up your buffers as you edit them. htmlize is used to send font lock highlighting to clients for non-HTML buffers.

;; simple-httpd can be installed through MELPA or directly from GitHub.

;;     http://melpa.milkbox.net/
;;     https://github.com/skeeto/emacs-http-server

;; htmlize is also available through MELPA.

;; Once you have installed simple-httpd and htmlize and you've cloned impatient-mode, you can add impatient-mode to your load path and require it:

;; (add-to-list 'load-path "~/.emacs.d/impatient-mode")
;; (require 'impatient-mode)

;; Using impatient-mode

;; Enable the web server provided by simple-httpd:

;; M-x httpd-start

;; Publish buffers by enabling the minor mode impatient-mode.

;; M-x impatient-mode

;; And then point your browser to http://localhost:8080/imp/, select a buffer, and watch your changes appear as you type!

;; If you are editing HTML that references resources in other files (like CSS) you can enable impatient-mode on those buffers as well. This will cause your browser to live refresh the page when you edit a referenced resources.

;; Except for html-mode buffers, buffer contents will be run through htmlize before sending to clients. This can be toggled at any time with imp-toggle-htmlize.

;; M-x imp-toggle-htmlize
(require 'impatient-mode)
(add-hook 'xah-html-mode-hook #'imp-toggle-htmlize)


(use-package rng-loc
  :config
  (add-to-list 'rng-schema-locating-files (fullpath "../html5-el/schemas.xml")))

(require 'whattf-dt)

