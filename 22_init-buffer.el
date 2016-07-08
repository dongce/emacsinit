;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

(require 'dired+)
(require 'filecache)

;;(setq bookmark-default-file "~/bookmarks")

;; 윈도우 쪼개지는 방향을 결정합니다.
;; 다음을 이용하여 쪼개지는 방향이 가로입니다. 
(setf split-width-threshold 20480 )

(global-set-key "\C-f" 'ibuffer )

(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*Pymacs\\*")

(setq 
 ibuffer-saved-filter-groups
 '(("default"
    ("북마크"   (or
                 (mode   . bookmark-edit-annotation-mode)
                 (name   . "^\\*Bookmark Annotation.*")
                 (name   . "^\\*Bookmark List\\*$")
                 (name   . "^\\*bm-bookmarks\\*$")))
    ("디렉토리" (mode   . dired-mode))
    ("파이썬" (or
               (mode     . python-mode)
               (name . "^\\*Python\\*$")))
    ("랩소디" (or
               (name . "\\.sbs$")
               (name . "\\.rpw$")))
    ("형상관리" (or
             (mode . dvc-diff)
             (name . "^\\*dvc")
             (name . "^\\*svn")
             (name . "^\\*git")
             (name . "^\\*magit")
             (name . "^\\*bzr")))
    ("C/C++" (or
              (mode     . c++-mode)
              (mode     . c-mode)
              (mode     . idl-mode)
              (mode     . cc-mode)))
    ("프로젝트" (mode   . project-buffer-mode))
    ("ORG"   (or
              (name . "^\\*Calendar\\*$")
              (name . "^\\*Remember\\*$")
              (mode . org-mode)))
    ("텍스트" (or
              (mode   . text-mode)))
    ("배치파일" (or
                 (mode   . dos-mode)))
    ("이멕스" (or
              (mode   . emacs-lisp-mode)
              (name . "^\\*scratch\\*$")
              (name . "^\\*Messages\\*$")))
    ("scheme" (or 
               (mode   . scheme-mode)
               (name   . "^\\*scheme\\*$")))
    ("SQL" (or 
               (mode   . sql-mode)
               (name   . "^\\*SQL\\*$")))
    ("이메일"  (or
                (mode . mu4e-main-mode )
                (mode . mu4e-view-mode )
                (mode . mu4e-headers-mode)))
    ("컴파일" (or
              (mode   . grep-mode)
              (mode   . occur-mode)
              (mode   . compilation-mode)))
    )))

(add-hook 'ibuffer-hook
    (lambda ()
      ;; (ibuffer-projectile-set-filter-groups)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic))))

;;deprecated;;(open-sln "c:/ffx/CFCS/DLP_LINK11/proj/winproj/winproj.sln")
;;deprecated;;(open-sln "c:/ffx/CFCS/DLP_ISDL/proj/winproj/winproj.sln")
;;deprecated;;(open-sln "c:/ffx/CFCS/SIGCONV/proj/winproj/winproj.sln")
;;(global-set-key (kbd "<C-tab>") 'iflipb-next-buffer)
;;(require 'iflipb)
;;;;(global-set-key (kbd "M-n") 'iflipb-next-buffer)
;;;;(global-set-key (kbd "M-N") 'iflipb-previous-buffer)
;;deprecated;;(require 'cycle-buffer)
;;deprecated;;(global-set-key (kbd "<C-tab>") 'cycle-buffer)
;;(require 'swbuff)
;;(global-set-key (kbd "<C-tab>") 'swbuff-switch-to-next-buffer)
;;(global-set-key (kbd "<C-tab>") 'bs-cycle-next)

;;(require 'cycbuf)
;;(global-set-key (kbd "<C-tab>") '(aif  (cycbuf-switch-to-next-buffer)))

;;(require 'tabbar)
;;(tabbar-mode)

(global-set-key "\C-b" 'switch-to-buffer )


(defun dir-personal ()
  (interactive)
  (dired "w:/dongil"))

(defun dir-date ()
  (interactive)
  (dired "g:/svndir/정리/"))
  
(defun dir-add ()
  (interactive)
  (dired "//10.239.12.87/system psr/FFX/SW/SW구조설계자료/FFX_SW구조설계_20090220/"))

(defun dir-ffx ()
  (interactive)
  (dired "\\10.239.12.38\ffx-i\FFX\FFX 산출물 Data"))

(defun dir-guile ()
  (interactive)
  (dired "c:/usr/local/guile/site-guile/"))

(defun dirf()
  (interactive)
  (dired "c:/ffx/cfcs")) 

(defun dir-desktop()
  (interactive)
  (dired "c:/Documents and Settings/dongil/바탕 화면/")) 


(defun download ()
  (interactive)
  (dired "h:/FIREFOX"))

(defun switch-to-buffer-and-back (buf)
  "Toggle between given buffer and the current buffer."
  (interactive)
  (if (equal (buffer-name) buf)
      (bury-buffer)
    (switch-to-buffer buf 'NORECORD)))


;;(global-set-key [(control c) ?l] (aif (switch-to-buffer-and-back "BUFFER-NAME-HERE")))
;;(global-set-key [(hyper s)] (aif (switch-to-buffer-and-back "BUFFER-NAME-HERE")))

;; (global-set-key [(control ?\')]     'recentf-open-most-recent-file)
;; (global-set-key [(control ?\")]     'recentf-open-files)

(require 'recentf-ext)

(define-key dired-mode-map "V" 
  (aif (mapcar (lambda (x) (find-file-other-frame x )) (dired-get-marked-files))))


;;(define-key dired-mode-map "V" 
;;  (aif (mapcar (lambda (x) (find-file-other-window x )) (dired-get-marked-files)) (balance-windows)))









;; https://plus.google.com/113859563190964307534/posts
;; dired 관련 사항 

(setq dired-dwim-target t)


;;NORECURSIVE;;(setq dired-recursive-copies (quote always))
;;NORECURSIVE;;(setq dired-recursive-deletes (quote top))


;;WHATCHAR;;you can find out the decimal/hex/name of a unicode char by calling “describe-char”.
;;WHATCHAR;;Or call “what-cursor-position” with a universal argument. e.g. type: 【ctrl+u ctrl+x =】.
;;WHATCHAR;;better is just to assign a key to “describe-char”. I use 【Ctrl+h c】.

;; 윈도우 숫자를 부여 
(require 'window-numbering)
(window-numbering-mode 1)


(defun next-user-buffer ()
  "Switch to the next user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(defun previous-user-buffer ()
  "Switch to the previous user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

(defun next-emacs-buffer ()
  "Switch to the next emacs buffer.
Emacs buffers are those whose name starts with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (not (string-match "^*" (buffer-name))) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(defun previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
Emacs buffers are those whose name starts with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (not (string-match "^*" (buffer-name))) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

(require 'buffer-utils)

;;; most-positive-fixnum
;; (require 'vlf)


;; (use-package smartwin :config (smartwin-mode 1))


(use-package resize-window)

(use-package ivy)
