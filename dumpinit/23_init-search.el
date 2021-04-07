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

(defun embark-append-action ()
  "Run the default action on the current target.
The target of the action is chosen by `embark-target-finders'.

If the target comes from minibuffer completion, then the default
action is the command that opened the minibuffer in the first
place, unless overidden by `embark-default-action-overrides'.

For targets that do not come from minibuffer completion
\(typically some thing at point in a regular buffer) and whose
type is not listed in `embark-default-action-overrides', the
default action is given by whatever binding RET has in the action
keymap for the target's type."
  (interactive)
  (pcase-let* ((`(,type ,target ,original) (embark--target)))
    (if original
        (embark--act #'xah-append-to-register target)
      (user-error "No target found"))))
    (leaf embark
      :ensure t
      :custom ((embark-quit-after-action . nil))
      :bind (("S-<home>" . embark-act)
             ("S-<end>" . embark-bindings) 
             ("<f12>" . embark-append-action) 
             ))
