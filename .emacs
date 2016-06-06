;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t;-*-

()
;;
;;;
;;; ※ 보이는 모양 설정
;;;
;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-fit-frame-flag nil)
 '(ac-auto-start nil)
 '(ac-trigger-key "C-o")
 '(ack-arguments nil)
 '(ack-executable (executable-find "ack.bat"))
 '(after-save-hook
   (quote
    (byte-compile-current-buffer svn-status-after-save-hook gtags-auto-update)))
 '(ansi-color-names-vector
   ["#313131" "#D9A0A0" "#8CAC8C" "#FDECBC" "#99DDE0" "#E090C7" "#A0EDF0" "#DCDCCC"])
 '(autofit-frames-flag nil)
 '(better-registers-use-C-r nil)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(bookmark-version-control t)
 '(browse-url-firefox-program "C:\\Program Files (x86)\\Mozilla Firefox\\firefox.exe")
 '(c-default-style "gnu")
 '(calendar-month-name-array
   ["1월 January" "2월 February" "3월 March" "4월 April" "5월 May" "6월 June" "7월 July" "8월 August" "9월 September" "10월 October" "11월 November" "12월 December"])
 '(case-fold-search t)
 '(column-number-mode t)
 '(company-global-modes (quote (not gdb-mode)))
 '(cua-mode nil nil (cua-base))
 '(current-language-environment "Korean")
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes
   (quote
    ("40f6a7af0dfad67c0d4df2a1dd86175436d79fc69ea61614d668a635c2cd94ab" "bcc6775934c9adf5f3bd1f428326ce0dcd34d743a92df48c128e6438b815b44f" "877530ef4d4423b5b184daff52953d398bb3533ec5e7393c238ac732b19135dd" "a444b2e10bedc64e4c7f312a737271f9a2f2542c67caa13b04d525196562bf38" "6a9606327ecca6e772fba6ef46137d129e6d1888dcfc65d0b9b27a7a00a4af20" "e80932ca56b0f109f8545576531d3fc79487ca35a9a9693b62bf30d6d08c9aaf" "de538b2d1282b23ca41ac5d8b69c033b911521fe27b5e1f59783d2eb20384e1f" "d7f1c86b425e148be505c689fc157d96323682c947b29ef00cf57b4e4e46e6c7" "dedecec68626c17a40f7cd4e41383348d232676b95ab92486157bc4d38c877ce" "4e1a057fe9a9981e886bd0673d131da904e3306c884715b8bee333ef95303e39" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "28b17dbb4ff2013db0f007a35e06653ad386a607341f5d72e69ee91e8bbcb96c" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "e3e2db3b5acd2028f7f83581f9609e1e7369df20414ab53c9b2161e2eca08675" "5a9d695ac1393edaa37da361bf3031baa976d279f915b8d24a7be41ac762d9ea" "89c3ee72f6fd2661c5167d1478a6703498d2e04d65a5d45dd26ad60f2962f83b" "100c4fb6c4da73ec1fd1d5700e1bc21dc6828401e1b6a9472d7c9bf93cb0f217" "090082e0782b07ed8124acf695a31990d7890f58af08531e462c14b7a6a8aecb" "79feb7bee77d6d0b8fdc40525a492ff428486d628f34f6e36461eb2c7ee13669" "77ca2fccd375519b5afa64775917c08b1d8cc9f41c720c4aa05d0f01a96acea5" "8f05205f2254cbd129e0e16d4f3826ddded3e1230c21023b341d94a5293e3617" "4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "b40cca5bcb41103a07637a09d0697234a3cd8047e154c5b96c771ce4f5b03435" "3d6b08cd1b1def3cc0bc6a3909f67475e5612dba9fa98f8b842433d827af5d30" "c9d00d43bd5ad4eb7fa4c0e865b666216dfac4584eede68fbd20d7582013a703" "ea0c5df0f067d2e3c0f048c1f8795af7b873f5014837feb0a7c8317f34417b04" "c7cad44416a49280f42edeffb226302568e6608702861b04f434da82f8996f88" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "117284df029007a8012cae1f01c3156d54a0de4b9f2f381feab47809b8a1caef" "5debeb813b180bd1c3756306cd8c83ac60fda55f85fb27249a0f2d55817e3cab" "5600dc0bb4a2b72a613175da54edb4ad770105aa" "0174d99a8f1fdc506fa54403317072982656f127" default)))
 '(cycbuf-dont-show-regexp (quote ("^ " "^\\*")))
 '(default-input-method "korean-hangul3f")
 '(delete-by-moving-to-trash t)
 '(describe-char-unidata-list
   (quote
    (name old-name general-category decomposition decimal-digit-value)))
 '(desktop-load-locked-desktop t)
 '(diary-file "u:/orgdir/diary")
 '(dired-sort-menu-saved-config
   (quote
    ((dired-actual-switches . "-alt")
     (ls-lisp-ignore-case)
     (ls-lisp-dirs-first))))
 '(diredp-hide-details-initially-flag t)
 '(diredp-w32-local-drives
   (quote
    (("C:" "Local disk")
     ("D:" "사외비")
     ("E:" "일반-개발환경")
     ("F:" "개인")
     ("G:" "사내한")
     ("H:" "일반-매뉴얼")
     ("T:" "사내한-소스코드"))))
 '(dvc-read-project-tree-mode (quote always))
 '(dynamic-fonts-preferred-monospace-fonts
   (quote
    ("DejaVu Sans Mono" "Consolas" "Menlo" "Monaco" "Droid Sans Mono Pro" "Droid Sans Mono" "Inconsolata" "Source Code Pro" "Lucida Console" "Envy Code R" "Andale Mono" "Lucida Sans Typewriter" "Lucida Typewriter" "Panic Sans" "Bitstream Vera Sans Mono" "Excalibur Monospace" "Courier New" "Courier" "Cousine" "Lekton" "Ubuntu Mono" "Liberation Mono" "BPmono" "Anonymous Pro" "ProFontWindows")))
 '(dynamic-fonts-preferred-monospace-point-size 9)
 '(dynamic-fonts-preferred-proportional-fonts
   (quote
    ("Tahoma" "Segoe UI" "DejaVu Sans" "Bitstream Vera" "Lucida Grande" "Verdana" "Helvetica" "Arial Unicode MS" "Arial")))
 '(ecb-auto-update-methods-after-save nil)
 '(ecb-compilation-buffer-names
   (quote
    (("*Calculator*")
     ("*vc*")
     ("*vc-diff*")
     ("*Apropos*")
     ("*Occur*")
     ("*shell*")
     ("\\*[cC]ompilation.*\\*" . t)
     ("\\*i?grep.*\\*" . t)
     ("*JDEE Compile Server*")
     ("*Help*")
     ("*Completions*")
     ("*Backtrace*")
     ("*Compile-log*")
     ("*bsh*")
     ("*swbuff*")
     ("*cycbuf*"))))
 '(ecb-compile-window-height 20)
 '(ecb-compile-window-temporally-enlarge (quote both))
 '(ecb-enlarged-compilation-window-max-height (quote half))
 '(ecb-layout-name "left14")
 '(ecb-layout-window-sizes nil)
 '(ecb-major-modes-show-or-hide (quote (nil *)))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-show-sources-in-directories-buffer (quote ("left7" "left13" "left14" "left15" "right2")))
 '(ecb-source-path
   (quote
    (("g:/svndir/emacs-home" "HOME")
     ("c:/FFX" "FFX")
     ("g:/svndir/IIDS/src" "IIDS")
     ("g:/svndir/유용한스크립트" "유용한스크립트")
     ("g:/svndir/테마과제" "테마과제")
     ("g:/svndir/형상관리" "형상관리")
     ("g:/svndir/서버관리" "서버관리")
     ("g:/svndir/실적관리" "실적관리")
     ("C:/Documents and Settings/dongil.SAMSUNG-BC5B83A/바탕 화면" "바탕화면")
     ("c:" "c:"))))
 '(ecb-tip-of-the-day nil)
 '(ecb-tree-buffer-style (quote ascii-guides))
 '(ecb-windows-hidden t t)
 '(elpy-default-minor-modes (quote (flycheck-mode yas-minor-mode auto-complete-mode)) t)
 '(elpy-modules
   (quote
    (elpy-module-eldoc elpy-module-pyvenv elpy-module-highlight-indentation elpy-module-yasnippet elpy-module-sane-defaults)))
 '(elpy-rpc-backend nil)
 '(elpy-rpc-ignored-buffer-size 10240)
 '(elpy-rpc-python-command "python3")
 '(epg-gpg-program "t:/usr/local/gpg2/gpg2.exe")
 '(evil-cross-lines t)
 '(evil-emacs-state-modes
   (quote
    (archive-mode bbdb-mode bookmark-bmenu-mode bookmark-edit-annotation-mode browse-kill-ring-mode bzr-annotate-mode calc-mode cfw:calendar-mode completion-list-mode Custom-mode debugger-mode delicious-search-mode desktop-menu-blist-mode desktop-menu-mode doc-view-mode dvc-bookmarks-mode dvc-diff-mode dvc-info-buffer-mode dvc-log-buffer-mode dvc-revlist-mode dvc-revlog-mode dvc-status-mode dvc-tips-mode ediff-mode ediff-meta-mode efs-mode Electric-buffer-menu-mode emms-browser-mode emms-mark-mode emms-metaplaylist-mode emms-playlist-mode etags-select-mode fj-mode gc-issues-mode gdb-breakpoints-mode gdb-disassembly-mode gdb-frames-mode gdb-locals-mode gdb-memory-mode gdb-registers-mode gdb-threads-mode gist-list-mode gnus-article-mode gnus-browse-mode gnus-group-mode gnus-server-mode gnus-summary-mode google-maps-static-mode jde-javadoc-checker-report-mode magit-commit-mode magit-key-mode magit-show-branches-mode magit-branch-manager-mode magit-wazzup-mode mh-folder-mode monky-mode notmuch-hello-mode notmuch-search-mode notmuch-show-mode occur-mode org-agenda-mode package-menu-mode proced-mode rcirc-mode rebase-mode reftex-select-bib-mode reftex-toc-mode sldb-mode slime-inspector-mode slime-thread-control-mode slime-xref-mode sr-buttons-mode sr-mode sr-tree-mode sr-virtual-mode tar-mode tetris-mode tla-annotate-mode tla-archive-list-mode tla-bconfig-mode tla-bookmarks-mode tla-branch-list-mode tla-browse-mode tla-category-list-mode tla-changelog-mode tla-follow-symlinks-mode tla-inventory-file-mode tla-inventory-mode tla-lint-mode tla-logs-mode tla-revision-list-mode tla-revlog-mode tla-tree-lint-mode tla-version-list-mode twittering-mode urlview-mode vc-annotate-mode vc-dir-mode vc-git-log-view-mode vc-svn-log-view-mode vm-mode vm-summary-mode w3m-mode wab-compilation-mode xgit-annotate-mode xgit-changelog-mode xgit-diff-mode xgit-revlog-mode xhg-annotate-mode xhg-log-mode xhg-mode xhg-mq-mode xhg-mq-sub-mode xhg-status-extra-mode svn-status-mode dvc-log-edit-mode project-buffer-mode gtags-selection-mode speedbar-mode diff-mode)))
 '(evil-emacs-state-msg "이멕스")
 '(evil-extra-operator-eval-modes-alist
   (quote
    ((ruby-mode ruby-send-region)
     (enh-ruby-mode ruby-send-region)
     (python-mode python-shell-send-region))))
 '(evil-extra-operator-highlight-key [103 (shift 104)])
 '(evil-insert-state-msg "입력")
 '(evil-leader/leader "SPC")
 '(evil-lisp-state-global t)
 '(evil-lisp-state-leader-prefix "q")
 '(evil-mode-line-color
   (quote
    ((normal . "green4")
     (insert . "#575735")
     (replace . "#575735")
     (operator . "DarkSeaGreen4")
     (visual . "SteelBlue4")
     (emacs . "#8c5353"))))
 '(evil-motion-state-modes
   (quote
    (apropos-mode Buffer-menu-mode calendar-mode color-theme-mode command-history-mode compilation-mode dictionary-mode ert-results-mode help-mode Info-mode Man-mode speedbar-mode undo-tree-visualizer-mode view-mode woman-mode grep-mode occur-mode)))
 '(evil-move-cursor-back nil)
 '(evil-mu4e-state (quote normal))
 '(evil-normal-state-msg "명령")
 '(evil-replace-state-msg "교체")
 '(evil-search-highlight-persist t t)
 '(evil-track-eol nil)
 '(evil-want-C-u-scroll t)
 '(evil-want-fine-undo t)
 '(evil-want-visual-char-semi-exclusive t)
 '(expand-region-preferred-python-mode (quote fgallina-python))
 '(eyebrowse-mode t)
 '(fci-rule-color "#5E5E5E")
 '(fic-highlighted-words (quote ("FIXME" "TODO" "BUG" "KLUDGE" "ticket")))
 '(geiser-active-implementations (quote (guile racket winprojcd)))
 '(geiser-default-implementation nil)
 '(global-evil-search-highlight-persist t)
 '(global-font-lock-mode t nil (font-lock))
 '(global-hl-line-sticky-flag t)
 '(global-page-break-lines-mode t)
 '(global-smartscan-mode t)
 '(global-undo-tree-mode t)
 '(gnutls-min-prime-bits 512)
 '(grep-command "grep -rni ")
 '(grep-use-null-device nil)
 '(guide-key-mode t)
 '(guide-key/guide-key-sequence
   (quote
    ("C-x r" "C-x p" "C-c p" "<SPC> p" "C-c C-o" "<SPC> h" "C-x <RET>" "C-x v" "<SPC> s" "<SPC> y" "<SPC> r" "<SPC> o")))
 '(helm-case-fold-search (quote smart))
 '(helm-dash-docsets-path "t:/usr/local/editor/emacsw32/dashdocset")
 '(helm-dictionary-online-dicts
   (quote
    (("translate.reference.com de->eng" . "http://translate.reference.com/translate?query=%s&src=de&dst=en")
     ("translate.reference.com eng->de" . "http://translate.reference.com/translate?query=%s&src=en&dst=de")
     ("Leo eng<->de" . "http://dict.leo.org/ende?lp=ende&lang=de&search=%s")
     ("en.wiktionary.org" . "http://en.wiktionary.org/wiki/%s")
     ("de.wiktionary.org" . "http://de.wiktionary.org/wiki/%s")
     ("Linguee eng<->de" . "http://www.linguee.de/deutsch-englisch/search?sourceoverride=none&source=auto&query=%s")
     ("ko.wiktionary.org" . "http://ko.wiktionary.org/wiki/%s"))))
 '(helm-github-stars-username "dongce@gmail.com")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-sexp-background-color "blue4")
 '(ido-enable-flex-matching t)
 '(ido-mode (quote buffer) nil (ido))
 '(iflipb-wrap-around t)
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inferior-js-program-command "t:/usr/local/nodejs/node.exe --interactive")
 '(init-loader-byte-compile t)
 '(initial-frame-alist (quote ((tool-bar-lines . 0) (fullscreen . maxmized))))
 '(js-indent-level 2)
 '(load-home-init-file t t)
 '(ls-lisp-dirs-first t)
 '(ls-lisp-use-insert-directory-program nil)
 '(magit-auto-revert-mode nil)
 '(magit-diff-options (quote ("--ignore-space-at-eol")))
 '(magit-diff-use-overlays nil)
 '(magit-git-global-arguments nil)
 '(magit-git-standard-options nil)
 '(magit-process-connection-type t)
 '(magit-use-overlays nil)
 '(max-specpdl-size 134000)
 '(message-send-mail-function (quote message-send-mail-with-sendmail))
 '(message-sendmail-extra-arguments (quote ("--read-envelope-from" "-a" "dongil")))
 '(message-sendmail-f-is-evil t)
 '(modelinepos-column-limit 100)
 '(mouse-drag-copy-region t)
 '(mu4e-headers-results-limit -1)
 '(mu4e-maildir "f:/MYSINGLE20130416")
 '(mu4e-my-email-addresses (quote ("di7979.kim@samsung.com" "dongce@gmail.com")))
 '(nodejs-repl-command "t:/usr/local/nodejs/node.exe")
 '(nxml-heading-element-name-regexp "title\\|head\\|글")
 '(nxml-section-element-name-regexp
   "article\\|\\(sub\\)*section\\|chapter\\|div\\|appendix\\|part\\|preface\\|reference\\|simplesect\\|bibliography\\|bibliodiv\\|glossary\\|glossdiv\\|제목[0-9]+")
 '(nxml-slash-auto-complete-flag t)
 '(on-screen-global-mode t)
 '(org-agenda-files "~/orgdir/agenda.txt")
 '(org-agenda-include-diary t)
 '(org-agenda-start-with-follow-mode t)
 '(org-attach-screenshot-command-line
   "t:/usr/local/editor/emacsW32/iview441_x64/i_view64.exe /capture=4 /convert=%f")
 '(org-attach-screenshot-relative-links nil)
 '(org-babel-load-languages
   (quote
    ((python . t)
     (scheme . t)
     (emacs-lisp . t)
     (C . t)
     (calc . t)
     (shell . t)
     (js . t)
     (plantuml . t))))
 '(org-babel-scheme-cmd "winprojcd")
 '(org-babel-shell-names
   (quote
    ("sh" "bash" "csh" "ash" "dash" "ksh" "mksh" "posh" "bc")))
 '(org-capture-templates
   (quote
    (("t" "할 일" entry
      (file+headline "" "할 일")
      "* TODO %a %? 
TIMESTAMP: %T ")
     ("u" "긴 급" entry
      (file+headline "" "할 일")
      "* TODO %a %?
DEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))")
     ("i" "정 보" entry
      (file+headline "u:/orgdir/info.org" "정보")
      "* %?
  TIMESTAMP: %T 
%a
")
     ("w" "사 업" entry
      (file+headline "u:/orgdir/info.org" "사업")
      "* %a %? ")
     ("s" "일 정" entry
      (file+headline "u:/orgdir/info.org" "일정")
      "* %a %? "))))
 '(org-confirm-babel-evaluate nil)
 '(org-default-notes-file "u:/orgdir/notes.org")
 '(org-directory "u:/orgdir/")
 '(org-export-with-section-numbers nil)
 '(org-export-with-smart-quotes t)
 '(org-export-with-toc nil)
 '(org-file-apps
   (quote
    ((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . default)
     ("\\.png\\'" . "mspaint \"%s\"")
     ("\\.xls[x]\\'" . system)
     ("\\.doc[x]\\'" . system))))
 '(org-html-head-include-default-style nil)
 '(org-html-infojs-options
   (quote
    ((path . "http://orgmode.org/org-info.js")
     (view . "content")
     (toc . :with-toc)
     (ftoc . "0")
     (tdepth . "max")
     (sdepth . "max")
     (mouse . "underline")
     (buttons . "0")
     (ltoc . "1")
     (up . :html-link-up)
     (home . :html-link-home))))
 '(org-html-mathjax-options
   (quote
    ((path "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML")
     (scale "100")
     (align "left")
     (font "Neo-Euler")
     (linebreaks "false")
     (autonumber "AMS")
     (indent "0em")
     (multlinewidth "85%")
     (tagindent ".8em")
     (tagside "right"))))
 '(org-html-postamble nil)
 '(org-html-toplevel-hlevel 2)
 '(org-latex-default-packages-alist
   (quote
    (("AUTO" "inputenc" t)
     ("T1" "fontenc" t)
     ("" "fixltx2e" nil)
     ("margin=2cm" "geometry" nil)
     ("" "extsize" nil)
     ("" "graphicx" t)
     ("" "longtable" nil)
     ("" "float" nil)
     ("" "wrapfig" nil)
     ("" "rotating" nil)
     ("normalem" "ulem" t)
     ("" "amsmath" t)
     ("" "textcomp" t)
     ("" "marvosym" t)
     ("" "wasysym" t)
     ("" "amssymb" t)
     ("unicode" "hyperref" nil)
     "\\tolerance=1000"
     ("" "kotex" nil)
     ("" "spverbatim" nil))))
 '(org-latex-pdf-process
   (quote
    ("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f" "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")))
 '(org-log-done (quote time))
 '(org-plantuml-jar-path
   "T:\\usr\\local\\editor\\emacsW32\\site-lisp\\thirdparty\\plantuml\\plantuml.jar")
 '(org-refile-use-outline-path (quote file))
 '(org-reverse-note-order t)
 '(org-structure-template-alist
   (quote
    (("s" "#+BEGIN_SRC ?

#+END_SRC")
     ("e" "#+BEGIN_EXAMPLE
?
#+END_EXAMPLE")
     ("q" "#+BEGIN_QUOTE
?
#+END_QUOTE")
     ("v" "#+BEGIN_VERSE
?
#+END_VERSE")
     ("V" "#+BEGIN_VERBATIM
?
#+END_VERBATIM")
     ("c" "#+BEGIN_CENTER
?
#+END_CENTER")
     ("l" "#+BEGIN_LaTeX
?
#+END_LaTeX")
     ("L" "#+LaTeX: ")
     ("h" "#+BEGIN_HTML
?
#+END_HTML")
     ("H" "#+HTML: ")
     ("a" "#+BEGIN_ASCII
?
#+END_ASCII")
     ("A" "#+ASCII: ")
     ("i" "#+INDEX: ?")
     ("I" "#+INCLUDE: %file ?")
     ("w" "#+BEGIN_WARNING
? 
#+END_WARNING")
     ("f" "#+BEGIN_INFO 
? 
#+END_INFO")
     ("t" "#+BEGIN_TIP
? 
#+END_TIP"))))
 '(org-todo-keyword-faces
   (quote
    (("TODO" :foreground "DarkGoldenRod3" :weight bold)
     ("WAITING" :foreground "chocolate" :weight bold)
     ("STARTED" :foreground "olive drab" :weight bold)
     ("DELEGATED" :foreground "PaleVioletRed3" :weight bold)
     ("DONE" :foreground "gray" :weight bold)
     ("RESOLVED" :foreground "sea green" :weight bold))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t!)" "REVIEW(v!)" "STARTED(s!)" "RESOLVED(r!)" "|" "DONE(d!)" "DELEGATED(l!)" "CANCELED(c!)" "PENDING(p!)"))))
 '(package-archives
   (quote
    (("org" . "http://orgmode.org/elpa/")
     ("ELPA" . "http://tromey.com/elpa/")
     ("gnu" . "http://elpa.gnu.org/packages/")
     ("MELPA" . "http://melpa.org/packages/"))))
 '(package-check-signature nil)
 '(package-selected-packages
   (quote
    (eval-in-repl window-purpose ranger magit-svn modern-cpp-font-lock yankpad datetime datetime-format 0blayout resize-window smartwin evil-extra-operator evil-embrace org-fstree dired-quick-sort which-key smart-mark smart-comment evil-lisp-state ob-translate workgroups2 evil-mu4e bog logview spinner helm-grepint company-math ox-html5slide persistent-scratch hl-line+ second-sel highline browse-kill-ring browse-kill-ring+ window-numbering elfeed-org org-eww org-attach-screenshot dired-narrow org-cliplink esup string-edit dom defproject xmlunicode better-defaults better-registers sicp unicode-fonts shut-up epl git commander orgit helm-mu evil-vimish-fold undo-tree zygospore yafolding xah-replace-pairs xah-lookup xah-get-thing world-time-mode winpoint win-switch wikidoc wiki-nav wiki whole-line-or-region wgrep w3 visual-regexp-steroids virtualenv vc-fossil uuid unfill tracwiki-mode tagedit swoop swbuff sr-speedbar sqlite spray smooth-scroll smartscan smart-shift slime-js simpleclip simp shadchen sass-mode ruby-electric repl-toggle regex-tool redo+ recursive-narrow rdp rainbow-delimiters quack pyvirtualenv python-pylint python-pep8 pymacs pydoc-info pycomplete project-explorer phi-search-mc phi-rectangle passthword parse-csv parenface-reversion palimpsest page-break-lines owdriver outlined-elisp-mode outline-magic org-ehtml org-bullets oauth2 nzenburn-theme nrepl-tracing nose mysql2sqlite mwe-log-commands mustang-theme multi moz-controller mode-compile mo-git-blame mark-multiple manage-minor-mode magit-push-remote magit-commit-training-wheels macro-utils macro-math list-processes+ less-css-mode launch key-combo jsshell-bundle json-mode jedi-direx irfc iregister ipython ioccur interaction-log init-loader impatient-mode image-dired+ iflipb idomenu http-post-simple hjkl-mode historyf highlight-numbers hideshowvis hide-lines helm-w32-launcher helm-proc helm-helm-commands helm-google helm-github-stars helm-git-files helm-flycheck helm-dired-recent-dirs helm-dictionary helm-css-scss helm-bm helm-bind-key hardhat goto-last-change gitconfig-mode fuzzy fringe-current-line free-keys frame-tag font-utils fold-this fold-dwim-org flymake fic-mode fic-ext-mode fastnav evil-visualstar evil-visual-mark-mode evil-surround evil-paredit evil-org evil-numbers evil-args evil-anzu elnode eldoc-extension el-autoyas eimp ecb dpaste_de download-region dirtree-prosjekt dired-toggle dired-sort-menu+ dired-single dired-imenu dired-details+ dictionary dash-at-point cycbuf csv-mode css-mode colorsarenice-theme color-theme-sanityinc-solarized color-theme-heroku color-theme clippy chess cedit cdnjs busybee-theme bufshow buffer-utils buffer-move bs-ext browse-url-dwim bpe bison-mode bbdb-vcard bbdb-ext back-button awk-it auto-indent-mode auctex-latexmk ascope asciidoc ascii annotate ada-mode ack ace-jump-mode ac-helm abl-mode)))
 '(package-user-dir "/opt/emacs/site-lisp/elpa")
 '(page-break-lines-char 8250)
 '(paradox-github-token t)
 '(paste-host "10.239.12.181:8000/dpaste")
 '(prettify-symbols-unprettify-at-point (quote right-edge))
 '(preview-image-type (quote dvipng))
 '(printer-name "IP_10.239.12.81")
 '(proced-filter-alist
   (quote
    ((user)
     (user-running
      (state . "\\`[Rr]\\'"))
     (all)
     (all-running
      (state . "\\`[Rr]\\'"))
     (emacs
      (fun-all lambda
               (list)
               (proced-filter-children list 1632))))))
 '(projectile-buffers-filter-function (quote projectile-buffers-with-file))
 '(projectile-completion-system (quote grizzl))
 '(projectile-enable-caching t)
 '(projectile-indexing-method (quote native))
 '(ps-lpr-switches (quote ("-query")))
 '(ps-multibyte-buffer (quote non-latin-printer))
 '(ps2pdf-gs-program
   "t:\\usr\\local\\postscript\\ghostscript\\bin\\gswin32c.exe")
 '(python-check-command "pyflakes")
 '(python-shell-interpreter "ipython.exe")
 '(python-shell-interpreter-args "--colors=NoColor")
 '(python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: ")
 '(python-shell-prompt-regexp "In \\[[0-9]+\\]: ")
 '(quack-programs
   (quote
    ("t:/usr/local/guile/bin/winprojcd.exe" "c:/usr" "c:\\icms\\CFCS\\DLPLINK11\\DLPLINK11\\proj\\winproj2005\\Debug\\winproj.exe" ".\\winproj.exe" "MFC_TDL_ISDL_GEN_CTRL" "bigloo" "c:/icms/CFCS/DLPLINK11/DLPLINK11/proj/winproj2005/Debug/winproj.exe" "c:/usr/local/guile/bin/winprojcd.exe" "c:\\ffx\\CFCS\\ICU_KNCCS\\ProjWin\\Debug\\icuknccs_win.exe" "codes" "csi" "csi -hygienic" "gosh" "gsi" "gsi ~~/syntax-case.scm -" "guile" "icuknccs_win.exe" "isdlcd" "isdlcde" "kawa" "mit-scheme" "mred -z" "mzscheme" "mzscheme -M errortrace" "rs" "rs232" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi" "tinyscheme" "win" "winprocd" "winproj.exe" "winprojcd" "winprojcdc" "winrpojcd" "winsigconv" "winsigconv.exe")))
 '(recentf-max-saved-items 1000)
 '(recentf-mode t)
 '(rmh-elfeed-org-files (quote ("u:/orgdir/feed.org")))
 '(rtog/mode-repl-alist
   (quote
    ((emacs-lisp-mode . ielm)
     (python-mode . python-shell-switch-to-shell)
     (dos-mode . shell)
     (sql-mode . sql-mysql)
     (js2-mode lambda nil
               (run-js inferior-js-program-command))
     (js2-mode . slime-connect)
     (js2-mode . jsshell)
     (scheme-mode lambda nil
                  (run-scheme scheme-program-name)))))
 '(safe-local-variable-values
   (quote
    ((eval when
           (require
            (quote rainbow-mode)
            nil t)
           (rainbow-mode 1))
     (eval set-variable
           (quote geiser-guile-binary)
           "t:/gitdir/dlp_link11/proj/testgen/testgen.out")
     (eval set-variable
           (quote geiser-guile-binary)
           "/gitdir/dlplink11/proj/testgen/testgen.out")
     (auto-fill-monde)
     (eval font-lock-add-keywords nil
           (\`
            (((\,
               (concat "("
                       (regexp-opt
                        (quote
                         ("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl"))
                        t)
                       "\\_>"))
              1
              (quote font-lock-variable-name-face)))))
     (mangle-whitespace . t)
     (eval when
           (fboundp
            (quote rainbow-mode))
           (rainbow-mode 1))
     (eval setq orgstruct-heading-prefix-regexp ";;;;")
     (eval orgstruct-mode t)
     (eval if
           (fboundp
            (quote pretty-symbols-mode))
           (pretty-symbols-mode -1))
     (major-mode . org-mode)
     (eval allout-hide-bodies)
     (eval progn
           (allout-minor-mode)
           (allout-hide-bodies))
     (Eval allout-hide-bodies)
     (buffer-file-coding-system . utf-8))))
 '(save-place-mode t)
 '(savehist-additional-variables (quote (kill-ring)))
 '(savehist-mode t)
 '(scheme-compile-exp-command "%s")
 '(scheme-program-name "winprojcd")
 '(sendmail-program "t:/usr/local/editor/emacsW32/mumailindexer/bin/msmtp.exe")
 '(setq ecb-tip-of-the-day)
 '(show-paren-mode t nil (paren))
 '(shr-width nil)
 '(simpleclip-mode t)
 '(smartparens-global-mode nil)
 '(smex-auto-update t)
 '(smtpmail-default-smtp-server "127.0.0.1")
 '(smtpmail-smtp-server "127.0.0.1")
 '(smtpmail-smtp-service 587)
 '(sp-base-key-bindings (quote paredit))
 '(speedbar-use-images nil)
 '(sql-mysql-options (quote ("-C" "-t" "-f" "-n")))
 '(sql-mysql-program "t:\\usr\\local\\mysql\\bin\\mysql.exe")
 '(sql-sqlite-program "sqlite3")
 '(sublimity-global-mode t)
 '(syslog-debug-face
   (quote
    ((t :background unspecified :foreground "#2aa198" :weight bold))))
 '(syslog-error-face
   (quote
    ((t :background unspecified :foreground "#dc322f" :weight bold))))
 '(syslog-hour-face (quote ((t :background unspecified :foreground "#859900"))))
 '(syslog-info-face
   (quote
    ((t :background unspecified :foreground "#268bd2" :weight bold))))
 '(syslog-ip-face (quote ((t :background unspecified :foreground "#b58900"))))
 '(syslog-su-face (quote ((t :background unspecified :foreground "#d33682"))))
 '(syslog-warn-face
   (quote
    ((t :background unspecified :foreground "#cb4b16" :weight bold))))
 '(tab-width 2)
 '(tabkey2-alternate-key [pause])
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tramp-adb-sdk-dir "c:/usr/local/androidsdk/")
 '(tramp-default-host "k3client")
 '(tramp-default-method "pscp")
 '(tramp-default-user-alist
   (quote
    (("\\`smb\\'" nil nil)
     ("\\`\\(?:fcp\\|krlogin\\|nc\\|r\\(?:cp\\|emcp\\|sh\\)\\|telnet\\)\\'" nil "dongil")
     ("\\`\\(?:ksu\\|su\\(?:do\\)?\\)\\'" nil "root")
     ("\\`\\(?:socks\\|tunnel\\)\\'" nil "dongil")
     ("\\`synce\\'" nil nil)
     ("plink" "nil" "buildadmin"))))
 '(transient-mark-mode t)
 '(undo-tree-auto-save-history t)
 '(unicode-fonts-block-font-mapping
   (quote
    (("Aegean Numbers"
      ("Aegean" "Quivira"))
     ("Alchemical Symbols"
      ("Symbola" "Quivira"))
     ("Alphabetic Presentation Forms"
      ("DejaVu Sans:width=condensed" "Arial Unicode MS" "Quivira"))
     ("Ancient Greek Musical Notation"
      ("Musica" "Symbola" "Quivira"))
     ("Ancient Greek Numbers"
      ("Apple Symbols" "Aegean" "Quivira"))
     ("Ancient Symbols"
      ("Aegean" "Quivira"))
     ("Arabic Presentation Forms-A"
      ("Geeza Pro" "Arial Unicode MS" "Microsoft Sans Serif" "Tahoma" "Kufi Standard GK" "Andalus" "Arabic Typesetting" "Adobe Arabic" "DecoType Naskh" "Al Bayan" "DejaVu Sans Mono" "DejaVu Sans:width=condensed" "MPH 2B Damase" "Code2000"))
     ("Arabic Presentation Forms-B"
      ("DejaVu Sans Mono" "Geeza Pro" "Adobe Arabic" "Arial Unicode MS" "Microsoft Sans Serif" "Kufi Standard GK" "DejaVu Sans:width=condensed" "DecoType Naskh"))
     ("Arabic Supplement"
      ("Courier New" "Simplified Arabic Fixed" "Simplified Arabic" "Geeza Pro" "Damascus" "Andalus" "Arabic Typesetting" "Traditional Arabic" "Adobe Arabic" "Scheherazade" "Tahoma" "Microsoft Sans Serif" "MPH 2B Damase"))
     ("Arabic"
      ("Courier New" "Simplified Arabic Fixed" "Simplified Arabic" "Adobe Arabic" "Geeza Pro" "Baghdad" "Damascus" "Al Bayan" "Andalus" "Arabic Typesetting" "Traditional Arabic" "Scheherazade" "DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Arial Unicode MS" "Nadeem" "Tahoma" "Microsoft Sans Serif" "MPH 2B Damase" "Kufi Standard GK" "DecoType Naskh" "Koodak"))
     ("Armenian"
      ("Mshtakan" "Sylfaen" "DejaVu Sans:width=condensed" "Quivira" "MPH 2B Damase" "Arial Unicode MS"))
     ("Arrows"
      ("DejaVu Sans Mono" "Apple Symbols" "Cambria Math" "DejaVu Sans:width=condensed" "Arial Unicode MS" "Symbola" "Quivira"))
     ("Avestan"
      ("Ahuramzda"))
     ("Balinese"
      ("Aksara Bali"))
     ("Basic Latin"
      ("DejaVu Sans Mono"))
     ("Bengali"
      ("Bangla Sangam MN" "Vrinda" "Mukti Narrow" "Akaash" "Arial Unicode MS" "Code2000"))
     ("Block Elements"
      ("DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Apple Symbols" "Symbola" "Quivira"))
     ("Bopomofo Extended"
      ("MingLiU" "SimHei" "FangSong" "SimSun" "DFKai-SB" "Microsoft JhengHei" "BabelStone Han"))
     ("Bopomofo"
      ("Lantinghei TC" "MingLiU" "SimHei" "LiSong Pro" "FangSong" "SimSun" "DFKai-SB" "WenQuanYi Zen Hei Mono" "Microsoft JhengHei" "Microsoft YaHei" "Lantinghei SC" "Arial Unicode MS" "BabelStone Han"))
     ("Box Drawing"
      ("DejaVu Sans Mono" "DejaVu Sans" "Symbola" "Quivira"))
     ("Braille Patterns"
      ("Quivira" "DejaVu Sans:width=condensed" "Apple Symbols" "Symbola"))
     ("Buginese"
      ("MPH 2B Damase"))
     ("Buhid"
      ("Quivira"))
     ("Byzantine Musical Symbols"
      ("Musica" "Symbola"))
     ("CJK Compatibility Forms"
      ("WenQuanYi Zen Hei Mono" "Lantinghei SC" "SimHei" "FangSong" "SimSun" "LiSong Pro" "Baoli SC" "Microsoft YaHei" "Lantinghei TC" "BabelStone Han" "MingLiU" "Microsoft JhengHei" "Symbola" "Xingkai SC" "DFKai-SB"))
     ("CJK Compatibility Ideographs Supplement"
      ("WenQuanYi Zen Hei Mono" "SimHei" "FangSong" "SimSun" "MingLiU" "HanaMinA" "Hiragino Kaku Gothic Pro" "Hiragino Maru Gothic Pro" "Hiragino Mincho Pro" "Microsoft JhengHei" "LiSong Pro"))
     ("CJK Compatibility Ideographs"
      ("SimHei" "FangSong" "SimSun" "Microsoft YaHei" "WenQuanYi Zen Hei Mono" "BabelStone Han" "UnBatang" "MingLiU" "Microsoft JhengHei" "Arial Unicode MS" "Lantinghei SC" "HanaMinA"))
     ("CJK Compatibility"
      ("SimHei" "FangSong" "SimSun" "MingLiU" "Microsoft JhengHei" "Lantinghei SC" "Lantinghei TC" "Arial Unicode MS" "WenQuanYi Zen Hei Mono" "HanaMinA" "BabelStone Han"))
     ("CJK Radicals Supplement"
      ("WenQuanYi Zen Hei Mono" "SimHei" "FangSong" "SimSun" "Microsoft YaHei" "HanaMinA" "BabelStone Han" "MingLiU" "Microsoft JhengHei" "DFKai-SB" "Apple Symbols"))
     ("CJK Strokes"
      ("WenQuanYi Zen Hei Mono" "HanaMinA" "BabelStone Han"))
     ("CJK Symbols and Punctuation"
      ("Lantinghei SC" "SimHei" "FangSong" "SimSun" "HanaMinA" "WenQuanYi Zen Hei Mono" "LiSong Pro" "ST Fangsong" "Microsoft YaHei" "Lantinghei TC" "MingLiU" "Arial Unicode MS" "PC Myungjo" "BabelStone Han" "Osaka:spacing=m"))
     ("CJK Unified Ideographs Extension A"
      ("SimHei" "FangSong" "ST Fangsong" "SimSun" "Songti SC" "Microsoft YaHei" "MingLiU" "Microsoft JhengHei" "Code2000" "DFKai-SB" "BabelStone Han" "GB18030 Bitmap"))
     ("CJK Unified Ideographs Extension B"
      ("SimHei" "FangSong" "SimSun" "LiSong Pro" "Microsoft YaHei" "HanaMinB" "Code2002" "MingLiU" "Microsoft JhengHei" "BabelStone Han" "DFKai-SB"))
     ("CJK Unified Ideographs Extension C"
      ("HanaMinB" "BabelStone Han"))
     ("CJK Unified Ideographs Extension D"
      ("HanaMinB" "BabelStone Han"))
     ("CJK Unified Ideographs"
      ("WenQuanYi Zen Hei Mono" "Lantinghei SC" "Songti SC" "SimHei" "FangSong" "ST Fangsong" "SimSun" "LiSong Pro" "Baoli SC" "HanaMinA" "BabelStone Han" "Apple LiGothic" "Lantinghei TC" "MingLiU" "Microsoft JhengHei" "DFKai-SB" "Arial Unicode MS" "Xingkai SC" "GB18030 Bitmap" "UnBatang"))
     ("Carian"
      ("Aegean" "Quivira"))
     ("Cham"
      ("Code2000"))
     ("Cherokee"
      ("Plantagenet Cherokee" "MPH 2B Damase" "Quivira"))
     ("Combining Diacritical Marks Supplement"
      ("Consolas" "Courier New" "Doulos SIL" "DejaVu Sans:width=condensed" "Segoe UI" "Tahoma" "Code2000"))
     ("Combining Diacritical Marks for Symbols"
      ("Cambria Math" "Symbola"))
     ("Combining Diacritical Marks"
      ("Monaco" "Consolas" "Cambria Math" "Courier New" "DejaVu Sans:width=condensed" "DejaVu Sans Mono" "Tahoma" "Microsoft Sans Serif" "Arial" "Quivira"))
     ("Combining Half Marks"
      ("Monaco" "Consolas" "Symbola"))
     ("Common Indic Number Forms"
      ("Siddhanta"))
     ("Control Pictures"
      ("Apple Symbols" "Arial Unicode MS" "Symbola" "Quivira"))
     ("Counting Rod Numerals"
      ("WenQuanYi Zen Hei Mono" "Apple Symbols" "Symbola" "Quivira" "Code2001"))
     ("Cuneiform Numbers and Punctuation"
      ("Akkadian"))
     ("Cuneiform"
      ("Akkadian"))
     ("Currency Symbols"
      ("Monaco" "Consolas" "DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Apple Symbols" "Symbola" "Quivira"))
     ("Cypriot Syllabary"
      ("Aegean" "Code2001"))
     ("Cyrillic Extended-A"
      ("Quivira"))
     ("Cyrillic Extended-B"
      ("Quivira"))
     ("Cyrillic Supplement"
      ("Consolas" "Courier New" "Calibri" "DejaVu Sans:width=condensed" "Doulos SIL" "Symbola" "Quivira"))
     ("Cyrillic"
      ("Consolas" "Monaco" "DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Courier New" "Calibri" "Microsoft Sans Serif" "Code2000" "Arial Unicode MS" "Doulos SIL" "Symbola" "Charcoal CY" "Geneva CY"))
     ("Deseret"
      ("Apple Symbols" "Analecta" "Code2001"))
     ("Devanagari Extended"
      ("Siddhanta"))
     ("Devanagari"
      ("Devanagari Sangam MN" "Devanagari MT" "Mangal" "Samyak Devanagari" "Samyak" "Siddhanta" "Arial Unicode MS"))
     ("Dingbats"
      ("DejaVu Sans Mono" "Zapf Dingbats" "DejaVu Sans:width=condensed" "Arial Unicode MS" "Code2000" "Symbola" "Quivira"))
     ("Domino Tiles"
      ("DejaVu Sans:width=condensed" "Symbola" "Quivira"))
     ("Egyptian Hieroglyphs"
      ("Aegyptus"))
     ("Emoticons"
      ("Symbola" "Quivira"))
     ("Enclosed Alphanumeric Supplement"
      ("Quivira" "BabelStone Han"))
     ("Enclosed Alphanumerics"
      ("Arial Unicode MS" "Quivira" "BabelStone Han"))
     ("Enclosed CJK Letters and Months"
      ("WenQuanYi Zen Hei Mono" "SimHei" "FangSong" "MingLiU" "Arial Unicode MS" "HanaMinA" "BabelStone Han" "Quivira" "UnBatang"))
     ("Enclosed Ideographic Supplement"
      ("HanaMinA" "BabelStone Han"))
     ("Ethiopic Extended"
      ("Kefa" "Abyssinica SIL" "Code2000"))
     ("Ethiopic Extended-A"
      ("Kefa" "Abyssinica SIL" "Code2000"))
     ("Ethiopic Supplement"
      ("Kefa" "Abyssinica SIL" "Code2000"))
     ("Ethiopic"
      ("Kefa" "Nyala" "Abyssinica SIL" "Ethiopia Jiret" "Ethiopia WashRa SemiBold" "Ethopic Yebse" "Code2000"))
     ("General Punctuation"
      ("Monaco" "Apple Symbols" "Cambria Math" "DejaVu Sans:width=condensed" "Symbola" "Quivira"))
     ("Geometric Shapes"
      ("DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Arial Unicode MS" "Symbola" "Quivira"))
     ("Georgian Supplement"
      ("DejaVu Serif:width=condensed" "MPH 2B Damase" "Quivira"))
     ("Georgian"
      ("DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Arial Unicode MS" "Code2000" "Quivira" "Sylfaen" "MPH 2B Damase"))
     ("Glagolitic"
      ("MPH 2B Damase" "Quivira"))
     ("Gothic"
      ("Analecta" "Quivira" "Code2001"))
     ("Greek Extended"
      ("Consolas" "DejaVu Sans Mono" "Courier New" "DejaVu Sans:width=condensed" "Microsoft Sans Serif" "Gentium Plus Compact" "Gentium Plus" "Arial Unicode MS" "Arial" "Tahoma" "Doulos SIL" "Quivira"))
     ("Greek and Coptic"
      ("Consolas" "DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Calibri" "Microsoft Sans Serif" "Gentium Plus Compact" "Gentium Plus" "Lucida Console" "Arial Unicode MS" "Symbola" "Quivira"))
     ("Gujarati"
      ("Gujarati Sangam MN" "Gujarati MT" "Shruti" "Samyak Gujarati" "Samyak" "Arial Unicode MS"))
     ("Gurmukhi"
      ("Gurmukhi Sangam MN" "Gurmukhi MN" "Raavi" "Arial Unicode MS" "AnmolUni"))
     ("Halfwidth and Fullwidth Forms"
      ("Meiryo" "Arial Unicode MS" "Microsoft JhengHei" "BabelStone Han" "Apple Symbols" "Code2000"))
     ("Hangul Compatibility Jamo"
      ("PC Myungjo" "Malgun Gothic" "Gulim" "Dotum" "Batang" "Gungsuh" "Apple Myungjo" "UnBatang" "WenQuanYi Zen Hei Mono" "Arial Unicode MS" "Code2000" "HeadLineA"))
     ("Hangul Jamo Extended-A"
      ("UnBatang"))
     ("Hangul Jamo"
      ("UnBatang" "WenQuanYi Zen Hei Mono" "PC Myungjo" "Malgun Gothic" "Gulim" "Dotum" "Batang" "Gungsuh" "Arial Unicode MS" "Code2000"))
     ("Hangul Syllables"
      ("Apple Gothic" "Malgun Gothic" "Gulim" "Dotum" "Batang" "Gungsuh" "UnBatang" "WenQuanYi Zen Hei Mono" "Arial Unicode MS" "Code2000"))
     ("Hanunoo"
      ("MPH 2B Damase" "Quivira"))
     ("Hebrew"
      ("Miriam Fixed" "Arial Hebrew" "Raanana" "New Peninim MT" "Aharoni" "David" "FrankRuehl" "Gisha" "Levenim MT" "Narkisim" "Rod" "Courier New" "Adobe Hebrew" "Microsoft Sans Serif" "Tahoma" "Lucida Sans Unicode" "Arial Unicode MS" "Arial" "Quivira"))
     ("Hiragana"
      ("Osaka:spacing=m" "MS Gothic" "MS Mincho" "MingLiU" "Hiragino Kaku Gothic Pro" "Meiryo" "Arial Unicode MS" "HanaMinA" "BabelStone Han"))
     ("IPA Extensions"
      ("Monaco" "Consolas" "DejaVu Sans Mono" "Courier New" "Arial Unicode MS" "Arial" "Tahoma" "Microsoft Sans Serif" "Symbola" "Quivira"))
     ("Ideographic Description Characters"
      ("SimHei" "FangSong" "SimSun" "Microsoft YaHei" "BabelStone Han" "MingLiU" "Microsoft JhengHei" "Apple Myungjo" "HanaMinA" "Quivira" "DFKai-SB"))
     ("Imperial Aramaic"
      ("Quivira"))
     ("Inscriptional Pahlavi"
      ("WenQuanYi Zen Hei"))
     ("Inscriptional Parthian"
      ("WenQuanYi Zen Hei"))
     ("Javanese"
      ("Tuladha Jejeg"))
     ("Kana Supplement"
      ("HanaMinA" "BabelStone Han"))
     ("Kanbun"
      ("SimHei" "FangSong" "SimSun" "Meiryo" "Arial Unicode MS" "WenQuanYi Zen Hei Mono" "HanaMinA" "BabelStone Han" "MingLiU"))
     ("Kangxi Radicals"
      ("WenQuanYi Zen Hei Mono" "SimHei" "FangSong" "SimSun" "Microsoft YaHei" "BabelStone Han" "HanaMinA" "MingLiU" "Microsoft JhengHei" "DFKai-SB" "Apple Myungjo" "Apple Symbols"))
     ("Kannada"
      ("Kannada Sangam MN" "Tunga" "Akshar Unicode" "Arial Unicode MS" "Kedage" "Code2000"))
     ("Katakana Phonetic Extensions"
      ("MS Gothic" "MingLiU" "Meiryo" "HanaMinA" "BabelStone Han"))
     ("Katakana"
      ("Osaka:spacing=m" "MS Gothic" "MingLiU" "Meiryo" "HanaMinA" "Arial Unicode MS" "BabelStone Han"))
     ("Kayah Li"
      ("Code2000"))
     ("Kharoshthi"
      ("MPH 2B Damase"))
     ("Khmer Symbols"
      ("Khmer Sangam MN" "Khmer Mondulkiri" "Khmer Busra" "Code2000"))
     ("Khmer"
      ("Khmer Sangam MN" "DaunPenh" "Code2000" "MoolBoran" "Khmer Mondulkiri" "Khmer Busra"))
     ("Lao"
      ("DejaVu Sans Mono" "Lao Sangam MN" "DokChampa" "Arial Unicode MS" "Saysettha MX" "DejaVu Sans:width=condensed"))
     ("Latin Extended-C"
      ("DejaVu Sans:width=condensed" "Cambria Math" "Quivira"))
     ("Latin Extended-D"
      ("Quivira" "Code2000"))
     ("Letterlike Symbols"
      ("Apple Symbols" "Cambria Math" "DejaVu Sans:width=condensed" "Arial Unicode MS" "Code2000" "Symbola" "Quivira"))
     ("Limbu"
      ("MPH 2B Damase"))
     ("Linear B Ideograms"
      ("Aegean" "Code2001"))
     ("Linear B Syllabary"
      ("Aegean" "Code2001"))
     ("Lisu"
      ("Quivira"))
     ("Lycian"
      ("Aegean" "Quivira"))
     ("Lydian"
      ("Aegean" "Quivira"))
     ("Mahjong Tiles"
      ("Symbola" "Quivira"))
     ("Malayalam"
      ("Malayalam Sangam MN" "Kartika" "Samyak Malayalam" "Samyak" "Akshar Unicode" "Arial Unicode MS"))
     ("Mathematical Alphanumeric Symbols"
      ("Cambria Math" "Code2001" "Symbola" "Quivira"))
     ("Mathematical Operators"
      ("DejaVu Sans Mono" "Apple Symbols" "Cambria Math" "DejaVu Sans:width=condensed" "Arial Unicode MS" "Code2000" "Symbola" "Quivira"))
     ("Meetei Mayek"
      ("Eeyek Unicode" "Meetei Mayek"))
     ("Meroitic Cursive"
      ("Aegyptus"))
     ("Meroitic Hieroglyphs"
      ("Aegyptus"))
     ("Miscellaneous Mathematical Symbols-A"
      ("Apple Symbols" "Symbola" "Quivira" "Cambria Math"))
     ("Miscellaneous Mathematical Symbols-B"
      ("Apple Symbols" "Cambria Math" "Code2000" "Symbola" "Quivira"))
     ("Miscellaneous Symbols and Pictographs"
      ("Symbola" "Quivira"))
     ("Miscellaneous Symbols and Arrows"
      ("Symbola" "Quivira"))
     ("Miscellaneous Symbols"
      ("Apple Symbols" "Arial Unicode MS" "Symbola" "Quivira"))
     ("Miscellaneous Technical"
      ("Apple Symbols" "Cambria Math" "Symbola" "Quivira"))
     ("Modifier Tone Letters"
      ("Apple Myungjo" "Apple Symbols" "Doulos SIL" "Code2000" "Quivira"))
     ("Mongolian"
      ("ST Fangsong" "ST Heiti" "ST Kaiti" "ST Song" "Mongolian Baiti" "Daicing Xiaokai" "Code2000"))
     ("Musical Symbols"
      ("Musica" "Symbola" "Quivira"))
     ("Myanmar Extended-A"
      ("Myanmar Sangam MN" "Padauk"))
     ("Myanmar"
      ("Myanmar Sangam MN" "Myanmar MN" "Padauk" "Code2000"))
     ("NKo"
      ("Conakry" "DejaVu Sans:width=condensed" "Code2000"))
     ("New Tai Lue"
      ("Dai Banna SIL Book" "Dai Banna SIL Book:style=Regular"))
     ("Number Forms"
      ("DejaVu Sans:width=condensed" "Arial Unicode MS" "Symbola" "Quivira" "Code2000"))
     ("Ogham"
      ("DejaVu Sans:width=condensed" "Quivira"))
     ("Ol Chiki"
      ("Code2000"))
     ("Old Italic"
      ("Aegean" "Quivira" "Code2001"))
     ("Old Persian"
      ("Aegean" "Code2001"))
     ("Old South Arabian"
      ("Qataban" "Quivira"))
     ("Old Turkic"
      ("Quivira"))
     ("Optical Character Recognition"
      ("Apple Symbols" "Arial Unicode MS" "Symbola" "Quivira"))
     ("Oriya"
      ("Oriya Sangam MN" "Kalinga" "Samyak Oriya" "Samyak" "Arial Unicode MS"))
     ("Osmanya"
      ("MPH 2B Damase" "Code2001"))
     ("Phags-pa"
      ("Microsoft PhagsPa" "BabelStone Phags-pa Book" "BabelStone Phags-pa Book:style=Regular" "Code2000"))
     ("Phaistos Disc"
      ("Aegean" "Code2001"))
     ("Phoenician"
      ("Aegean" "Quivira" "Code2001"))
     ("Phonetic Extensions Supplement"
      ("Consolas" "Calibri" "Courier New" "Quivira" "DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Code2000"))
     ("Phonetic Extensions"
      ("Monaco" "Consolas" "Calibri" "Quivira" "Courier New" "DejaVu Sans:width=condensed"))
     ("Playing Cards"
      ("DejaVu Sans:width=condensed" "Symbola" "Quivira"))
     ("Rejang"
      ("Code2000"))
     ("Runic"
      ("Quivira"))
     ("Samaritan"
      ("Quivira"))
     ("Saurashtra"
      ("Code2000" "Sourashtra"))
     ("Shavian"
      ("Apple Symbols" "MPH 2B Damase" "Code2001"))
     ("Sinhala"
      ("Sinhala Sangam MN" "Iskoola Pota" "Akshar Unicode"))
     ("Small Form Variants"
      ("Apple Symbols" "Arial Unicode MS" "WenQuanYi Zen Hei Mono" "Code2000"))
     ("Specials"
      ("Apple Symbols" "Arial Unicode MS" "DejaVu Sans Mono" "DejaVu Sans:width=condensed" "Symbola" "Quivira" "BabelStone Han"))
     ("Sundanese"
      ("Sundanese Unicode" "Hacen Sudan"))
     ("Superscripts and Subscripts"
      ("Cambria Math" "Consolas" "Symbola" "Quivira"))
     ("Supplemental Arrows-A"
      ("Apple Symbols" "Cambria Math" "DejaVu Sans:width=condensed" "Symbola" "Quivira"))
     ("Supplemental Arrows-B"
      ("Apple Symbols" "Cambria Math" "Symbola" "Quivira"))
     ("Supplemental Mathematical Operators"
      ("Apple Symbols" "Cambria Math" "Symbola" "Quivira"))
     ("Supplemental Punctuation"
      ("Symbola" "Quivira" "Code2000"))
     ("Syloti Nagri"
      ("MPH 2B Damase"))
     ("Syriac"
      ("Estrangelo Edessa" "Estrangelo Nisibin" "Code2000"))
     ("Tagalog"
      ("Quivira"))
     ("Tagbanwa"
      ("Quivira"))
     ("Tags"
      ("BabelStone Han"))
     ("Tai Le"
      ("Microsoft Tai Le" "MPH 2B Damase"))
     ("Tai Tham"
      ("Lanna Alif"))
     ("Tai Viet"
      ("Tai Heritage Pro"))
     ("Tai Xuan Jing Symbols"
      ("Apple Symbols" "WenQuanYi Zen Hei Mono" "BabelStone Han" "DejaVu Sans:width=condensed" "Symbola" "Quivira" "Code2001"))
     ("Tamil"
      ("Tamil Sangam MN" "InaiMathi" "Latha" "Maduram" "Akshar Unicode" "Samyak Tamil" "Samyak" "Arial Unicode MS"))
     ("Telugu"
      ("Telugu Sangam MN" "Gautami" "Akshar Unicode" "Code2000" "Arial Unicode MS"))
     ("Thaana"
      ("MV Boli" "MPH 2B Damase"))
     ("Thai"
      ("Ayuthaya" "Silom" "Krungthep" "Sathu" "Thonburi" "DokChampa" "Angsana New" "Tahoma" "Arial Unicode MS" "Quivira"))
     ("Tibetan"
      ("Kailasa" "Kokonor" "Microsoft Himalaya" "Jomolhari" "Monlam Uni Sans Serif" "Arial Unicode MS"))
     ("Tifinagh"
      ("DejaVu Sans:width=condensed" "Quivira"))
     ("Transport and Map Symbols"
      ("Symbola"))
     ("Ugaritic"
      ("Aegean" "Code2001"))
     ("Unified Canadian Aboriginal Syllabics Extended"
      ("Euphemia UCAS" "Euphemia" "Quivira"))
     ("Unified Canadian Aboriginal Syllabics"
      ("Euphemia UCAS" "Euphemia" "Quivira"))
     ("Vai"
      ("Quivira"))
     ("Variation Selectors Supplement"
      ("BabelStone Han"))
     ("Variation Selectors"
      ("BabelStone Han"))
     ("Vedic Extensions"
      ("Siddhanta"))
     ("Vertical Forms"
      ("Symbola"))
     ("Yi Radicals"
      ("ST Fangsong" "PC Myungjo" "Microsoft Yi Baiti" "Nuosu SIL"))
     ("Yi Syllables"
      ("ST Fangsong" "Apple Myungjo" "Microsoft Yi Baiti" "Nuosu SIL"))
     ("Yijing Hexagram Symbols"
      ("Apple Symbols" "DejaVu Sans:width=condensed" "WenQuanYi Zen Hei Mono" "BabelStone Han" "Symbola" "Quivira")))))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(url-queue-timeout 30)
 '(user-mail-address "di7979.kim@hanwha.com")
 '(vc-annotate-background "#202020")
 '(vc-annotate-color-map
   (quote
    ((20 . "#C99090")
     (40 . "#D9A0A0")
     (60 . "#ECBC9C")
     (80 . "#DDCC9C")
     (100 . "#EDDCAC")
     (120 . "#FDECBC")
     (140 . "#6C8C6C")
     (160 . "#8CAC8C")
     (180 . "#9CBF9C")
     (200 . "#ACD2AC")
     (220 . "#BCE5BC")
     (240 . "#CCF8CC")
     (260 . "#A0EDF0")
     (280 . "#79ADB0")
     (300 . "#89C5C8")
     (320 . "#99DDE0")
     (340 . "#9CC7FB")
     (360 . "#E090C7"))))
 '(vc-annotate-very-old-color "#E090C7")
 '(visible-bell nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(which-func-maxout 1000)
 '(which-func-modes t)
 '(which-func-non-auto-modes (quote (python-mode)))
 '(which-function-mode nil)
 '(xah-find-file-background-color "tomato")
 '(xah-find-file-separator
   "══════════════════════════════════════════════════════════════════════
")
 '(xah-find-match-background-color "blue1"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-mode-line ((((class color) (min-colors 89)) (:foreground "#d33682" :weight bold))))
 '(bm-persistent-face ((t (:background "medium purple" :foreground "#fdf6e3"))))
 '(cursor ((t (:background "green yellow" :foreground "#DCDCCC"))))
 '(error ((((class color) (min-colors 89)) (:foreground "#cb4b16"))))
 '(guide-key/key-face ((((class color) (min-colors 89)) (:foreground "#93a1a1"))))
 '(helm-selection ((t (:background "firebrick" :underline nil))))
 '(helm-selection-line ((t (:background "RoyalBlue4"))))
 '(highline-face ((t (:background "tomato"))))
 '(hl-line ((t (:background "SlateBlue4"))))
 '(mode-line ((t (:background "#8c5353" :foreground "alice blue" :box (:line-width -1 :style released-button)))))
 '(mode-line-buffer-id ((t (:foreground "moccasin"))))
 '(modelinepos-column-warning ((t (:foreground "IndianRed1"))))
 '(py-builtins-face ((t (:foreground "#23d7d7" :weight normal))) t)
 '(quack-pltish-paren-face ((t (:foreground "DeepSkyBlue2"))) t)
 '(region ((((class color) (min-colors 89)) (:foreground "#fdf6e3" :background "#586e75"))))
 '(which-func ((t (:foreground "goldenrod" :weight bold)))))

;;deprecated;;'(hl-line ((t (:background "sienna"))))
;;deprecated;;'(quack-pltish-paren-face ((t (:foreground "gold"))))
;;deprecated;;'(match ((t (:background "dark slate gray" :foreground "#DFAF8F" :weight bold))))
;;deprecated;;'(show-paren-match ((t (:background "snow" :foreground "midnight blue" :weight bold))))
;;deprecated;;'(diff-added ((((background dark)) (:foreground "#FFFF9B9BFFFF")) (t (:foreground "DarkGreen"))))
;;deprecated;;'(diff-changed ((((background dark)) (:foreground "Yellow")) (t (:foreground "MediumBlue"))))
;;deprecated;;'(diff-context ((((background dark)) (:foreground "White")) (t (:foreground "Black"))))
;;deprecated;;'(diff-file-header ((((background dark)) (:foreground "Cyan" :background "Black")) (t (:foreground "Red" :background "White"))))
;;deprecated;;'(diff-header ((((background dark)) (:foreground "Cyan")) (t (:foreground "Red"))))
;;deprecated;;'(diff-hunk-header ((((background dark)) (:foreground "Black" :background "#05057F7F8D8D")) (t (:foreground "White" :background "Salmon"))))
;;deprecated;;'(diff-index ((((background dark)) (:foreground "Magenta")) (t (:foreground "Green"))))
;;deprecated;;'(diff-nonexistent ((((background dark)) (:foreground "#FFFFFFFF7474")) (t (:foreground "DarkBlue"))))
;;deprecated;;'(diff-removed ((((background dark)) (:foreground "#7474FFFF7474")) (t (:foreground "DarkMagenta"))))
;;deprecated;;'(dired-directory ((t (:foreground "snow"))))
 
;;(defvar emacsw32-home (file-truename (concat exec-directory "../../../../../")))
(defvar emacsw32-home "/opt/emacs")
;; (defvar emacsw32-home "t:/usr/local/editor/emacsW32/")
(let (( default-directory  (file-truename (concat emacsw32-home "/site-lisp/"))))
  (normal-top-level-add-subdirs-to-load-path))

(add-to-list 'load-path (file-truename (concat emacsw32-home "/site-lisp/")))

(add-to-list 'load-path (concat emacsw32-home "/global/share/gtags/"))

(add-to-list 'load-path (concat emacsw32-home "/ergoemacs/packages"))


(require 'cl)

(require 'package)
(package-initialize)
(require 's)
(require 'init-loader)
(init-loader-load (concat emacsw32-home "/site-lisp/init"))

;; (with-package* (eide)
;;   (eide-start))

(server-start)

 ;; '(org-latex-default-packages-alist
 ;;   (quote
 ;;    (("AUTO" "inputenc" t)
 ;;     ("T1" "fontenc" t)
 ;;     ("" "fixltx2e" nil)
 ;;     ("" "graphicx" t)
 ;;     ("" "longtable" nil)
 ;;     ("" "float" nil)
 ;;     ("" "wrapfig" nil)
 ;;     ("" "soul" t)
 ;;     ("" "textcomp" t)
 ;;     ("" "marvosym" t)
 ;;     ("" "wasysym" t)
 ;;     ("" "latexsym" t)
 ;;     ("" "amssymb" t)
 ;;     ("" "amstext" nil)
 ;;     ("" "kotex" nil)
 ;;     ("" "listings" nil)
 ;;     ("" "minted" nil)
 ;;     "\\tolerance=1000")))
 ;; '(org-latex-listings nil)
 ;; '(org-latex-minted-options (quote (("frame" "lines"))))
 ;; '(org-latex-packages-alist (quote (("" "minted" nil) ("" "hyperref" nil))))

 ;; '(elpy-default-minor-modes (quote (yas-minor-mode auto-complete-mode)))



