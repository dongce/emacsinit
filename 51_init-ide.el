(require  'company)
(setq company-backends (delete 'company-semantic company-backends))
(add-hook 'after-init-hook 'global-company-mode)
(define-key c-mode-map  [(backtab)] 'company-complete)
(define-key c++-mode-map  [(backtab)] 'company-complete)


;; (with-package*
;;   (perspective)
;;   (persp-mode)
;;   (require 'persp-projectile)
;;   )

(with-package*
  (window-purpose window-purpose-x)
  (purpose-mode)
  (add-to-list 'purpose-user-mode-purposes '(python-mode . py))
  (add-to-list 'purpose-user-mode-purposes '(inferior-python-mode . py-repl))
  (add-to-list 'purpose-user-mode-purposes '(prog-mode . prog))
  (add-to-list 'purpose-user-mode-purposes '(compilation-mode . comp))
  (add-to-list 'purpose-user-mode-purposes '(org-mode . org))
  (add-to-list 'purpose-user-mode-purposes '(dos-mode . dos))
  (add-to-list 'purpose-user-mode-purposes '(shell-mode . shell))

  (add-to-list 'purpose-user-mode-purposes '(mu4e-headers-mode . mu4e-header))
  (add-to-list 'purpose-user-mode-purposes '(mu4e-view-mode  . mu4e-view))

  (purpose-compile-user-configuration)


  (purpose-x-kill-setup)
  )
