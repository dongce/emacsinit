;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-

(leaf consult-selectrum
  :require t
  :bind (((kbd "<f9>") . selectrum-repeat)
         ((kbd "<S-f9>") . hangul-to-hanja-conversion))
  :config 
   (selectrum-mode +1))


(defun consult-jump-in-buffer ()
  "Jump in buffer with `counsel-imenu' or `counsel-org-goto' if in org-mode"
  (interactive)
  (call-interactively
   (cond
    ((or (eq major-mode 'org-mode)
         (member 'outline-mode minor-mode-list)) 
     'consult-outline)
    (t 'consult-imenu))))

(defun consult-thing-at-point ()
  "`consult' with `thing-at-point'."
  (interactive)
  (let ((thing (ivy-thing-at-point)))
    (when (use-region-p)
      (dectivate-mark))
    (consult-line (regexp-quote thing))))

(leaf selectrum-prescient
  :ensure t
  :config 
  (selectrum-prescient-mode +1))


(leaf ivy-prescient
  :ensure t
  :config 
  (ivy-prescient-mode +1))

(leaf company-prescient
  :ensure t
  :config 
  (company-prescient-mode +1))

(leaf embark
  :ensure t
  :bind (("S-<home>" . embark-act)))
