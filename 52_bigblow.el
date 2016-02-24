;; -*- coding: utf-8; -*-



(require 'org-mu4e)
(setq org-mu4e-convert-to-html t)
(require 'org)
(require 'ox-html)

;;; POLY-MODE is works but not good
;;deprecated;;(with-package
;;deprecated;;  (poly-mode)
;;deprecated;;
;;deprecated;;  (defun pm--bigblow-tail-matcher (ahead)
;;deprecated;;    (when (< ahead 0)
;;deprecated;;      (error "backwards tail match not implemented"))
;;deprecated;;    (let ((end (buffer-end 1)))
;;deprecated;;      (cons (max 1 (- end 1)) end)))
;;deprecated;;
;;deprecated;;  (defcustom pm-host/bigblow
;;deprecated;;    (pm-bchunkmode "bigblow-message" :mode 'message-mode)
;;deprecated;;    "message host chunkmode"
;;deprecated;;    :group 'hostmodes
;;deprecated;;    :type 'object
;;deprecated;;    )
;;deprecated;;
;;deprecated;;  (defcustom pm-inner/bigblow
;;deprecated;;    (pm-hbtchunkmode "bigblow-org"
;;deprecated;;                     :mode 'poly-org-mode
;;deprecated;;                     :head-reg mail-header-separator
;;deprecated;;                     :tail-reg 'pm--bigblow-tail-matcher)
;;deprecated;;    "bigblow typical chunk"
;;deprecated;;    :group 'innermodes
;;deprecated;;    :type 'object
;;deprecated;;    )
;;deprecated;;
;;deprecated;;  (defcustom pm-poly/bigblow
;;deprecated;;    (pm-polymode-one "bigblow"
;;deprecated;;                     :hostmode 'pm-host/bigblow
;;deprecated;;                     :innermode 'pm-inner/bigblow)
;;deprecated;;    "Noweb typical polymode."
;;deprecated;;    :group 'polymodes
;;deprecated;;    :type 'object)
;;deprecated;;
;;deprecated;;  (define-polymode poly-bigblow-mode pm-poly/bigblow)
;;deprecated;;  )


(defun hinfojs ()
  (interactive) 
  (save-excursion
    (save-restriction
      (narrow-to-region (point) (point))
      (insert "#+INFOJS_OPT: view:showall toc:nil ltoc:nil\n")
      )))


(defun bigblow ()
  "DOCSTRING"
  (interactive )
  (let ((content
         (if (region-active-p)
             (concat
              (format  "#+begin_src %s\n"
                       (cdr  (assoc  (intern  (s-replace "-mode" ""  (symbol-name  major-mode)))
                                     (mapcar (lambda (x) (cons  (cdr x) (car x))) org-src-lang-modes))))
              (s-trim (buffer-substring-no-properties (region-beginning) (region-end)))))))
    (mu4e-compose-new)
    (save-excursion
      (save-restriction
        (goto-char (point-min))
        (search-forward mail-header-separator)
        (next-line)
        (org~mu4e-mime-switch-headers-or-body)
        (narrow-to-region (point) (point))
        (insert-line "#+TITLE: 무제")
        (insert-line "#+OPTIONS: toc:nil num:nil p:t ^:{} <:t \\n:t H:6")
        (insert-line "#+STARTUP: showeverything")
        (insert-line "#+HTML_HEAD_EXTRA: <script type=\"text/javascript\"> var HS_SHOW_ALL_OPEN_DONE_TREES = false; </script> ")
        (if content
            (progn
              
              (insert-line content)
              (insert-line "#+end_src")))
        
        ))))

(defun orgmail ()
  "DOCSTRING"
  (interactive )
  (let* ((content
         (if (region-active-p)
             (buffer-substring-no-properties (region-beginning) (region-end))
           (buffer-substring-no-properties (point-min) (point-max)))
         )
         (proptitle (car (plist-get (org-export-get-environment ) ':title)))
         (title
          (if (stringp proptitle)
              (substring-no-properties proptitle)
            nil
            ))
         (subregion (region-active-p))
         )
    (mu4e-compose-new)
    (save-excursion
      (save-restriction
        ;; (goto-char (point-min))
        ;; (end-of-line 2)
        (message-goto-to )
        (insert "di7979.kim@hanwha.com")
        (message-goto-subject )
        (if title (insert title) (insert "무제"))
        ;; (search-forward mail-header-separator)
        ;; (next-line)
        (message-goto-body)
        (org~mu4e-mime-switch-headers-or-body)
        (narrow-to-region (point) (point))
        (if (and  title subregion)
            (insert-line (format  "#+TITLE: %s" title))
          (if (not title ) ( insert-line "#+TITLE: 무제"  ))
          )
        (insert-line "#+OPTIONS: toc:nil num:nil p:t ^:{} <:t \\n:t H:6")
        (insert-line "#+STARTUP: showeverything")
        (insert-line "#+HTML_HEAD_EXTRA: <script type=\"text/javascript\"> var HS_SHOW_ALL_OPEN_DONE_TREES = false; </script> ")
        (insert-line content)
        ))))


(require 'xah-replace-pairs)
(defun xah-css-compact-css-region (φbegin φend)
  "Remove unnecessary whitespaces of CSS source code in region.
WARNING: not robust.
URL `http://ergoemacs.org/emacs/elisp_css_compressor.html'
Version 2015-04-29"
  (interactive "r")
  (save-restriction
    (narrow-to-region φbegin φend)
    (xah-replace-regexp-pairs-region
     (point-min)
     (point-max)
     '(["  +" " "]))
    (xah-replace-pairs-region
     (point-min)
     (point-max)
     '(
       ["\n" ""]
       [" /* " "/*"]
       [" */ " "*/"]
       [" {" "{"]
       ["{ " "{"]
       ["; " ";"]
       [": " ":"]
       [";}" "}"]
       ["}" "}\n"]
       ))))



(defun xah-css-compact-css-string (φstr)
  "Remove unnecessary whitespaces of CSS source code in region.
WARNING: not robust.
URL `http://ergoemacs.org/emacs/elisp_css_compressor.html'
Version 2015-04-29"
  (xah-replace-pairs-region
   (xah-replace-regexp-pairs-in-string φstr '(["  +" " "]))
   '(
     ["\n" ""]
     [" /* " "/*"]
     [" */ " "*/"]
     [" {" "{"]
     ["{ " "{"]
     ["; " ";"]
     [": " ":"]
     [";}" "}"]
     ["}" "}\n"]
     )))



(setq
 org-html-head
 (mapconcat
  (lambda (x)
    (if (symbolp x)
        (get-string-from-file (symbol-name x ))
      x
      ))
  `(
    "<script type=\"text/javascript\" src=\"http://code.jquery.com/jquery-latest.min.js\"></script>"
    "<script type=\"text/javascript\">"
    ;; /usr/local/emacs/site-lisp/orghtmltheme/styles/bigblow/js/hideshow.min.js
    ,(intern (fullpath "../thirdparty/orghtmltheme/styles/bigblow/js/hideshow.js"))
    "$(document).ready(function() {hsInit();});"
    "</script>"
    
    "<style type=\"text/css\">"
    ;; /usr/local/emacs/site-lisp/orghtmltheme/styles/bigblow/css/bigblow.min.css
    ;; /usr/local/emacs/site-lisp/orghtmltheme/styles/bigblow/css/hideshow.min.css
    ,(intern (fullpath "../thirdparty/orghtmltheme/styles/bigblow/css/bigblow.css"))
    ,(intern (fullpath "../thirdparty/orghtmltheme/styles/bigblow/css/hideshow.css"))

    ;http://dinoegg.co.kr/_font-family/
    ;; "body, h1, h2, h3, h4, h5 , h6{ font-family: \'Consolas\', \'Malgun Gothic\';}"
    "body, h1, h2, h3, h4, h5 , h6{ font-family: \'Malgun Gothic\';}"
    "h1 { font-size:1.2em;}"
    "h2 { font-size:1.1em;}"
    "h3, h4, h5 { font-size:1.0em;}"
    "p { font-size:0.9em;max-width: 50em}"
    ;; "body {max-width: 60em}"
    "pre {"
    "  border: 1px solid #ccc;"
    "  box-shadow: 3px 3px 3px #eee;"
    "  padding: 8pt;"
    "  font-family: monospace;"
    "  overflow: auto;"
    "  margin: 1.2em;"
    "}"
    "pre.src {"
    "  position: relative;"
    "  overflow: visible;"
    "  padding-top: 1.2em;"
    "}"
    "pre.src:before {"
    "  display: none;"
    "  position: absolute;"
    "  background-color: white;"
    "  top: -10px;"
    "  right: 10px;"
    "  padding: 3px;"
    "  border: 1px solid black;"
    "}"
    "pre.src:hover:before { display: inline;}"
    "pre.src-sh:before    { content: 'sh'; }"
    "pre.src-bash:before  { content: 'sh'; }"
    "pre.src-emacs-lisp:before { content: 'Emacs Lisp'; }"
    "pre.src-elisp:before { content: 'Emacs Lisp'; }"
    "pre.src-R:before     { content: 'R'; }"
    "pre.src-perl:before  { content: 'Perl'; }"
    "pre.src-java:before  { content: 'Java'; }"
    "pre.src-sql:before   { content: 'SQL'; }"
    "pre.src-cpp:before   { content: 'C/C++'; }"

    ;; pygmentize -S default -f html
    ;; ".hll { background-color: #ffffcc }"
    ;; ".c { color: #408080; font-style: italic } "
    ;; ".err { border: 1px solid #FF0000 } "
    ;; ".k { color: #008000; font-weight: bold } "
    ;; ".o { color: #666666 } "
    ;; ".cm { color: #408080; font-style: italic } "
    ;; ".cp { color: #BC7A00 } "
    ;; ".c1 { color: #408080; font-style: italic } "
    ;; ".cs { color: #408080; font-style: italic } "
    ;; ".gd { color: #A00000 } "
    ;; ".ge { font-style: italic } "
    ;; ".gr { color: #FF0000 } "
    ;; ".gh { color: #000080; font-weight: bold } "
    ;; ".gi { color: #00A000 } "
    ;; ".go { color: #888888 } "
    ;; ".gp { color: #000080; font-weight: bold } "
    ;; ".gs { font-weight: bold } "
    ;; ".gu { color: #800080; font-weight: bold } "
    ;; ".gt { color: #0044DD } "
    ;; ".kc { color: #008000; font-weight: bold } "
    ;; ".kd { color: #008000; font-weight: bold } "
    ;; ".kn { color: #008000; font-weight: bold } "
    ;; ".kp { color: #008000 } "
    ;; ".kr { color: #008000; font-weight: bold } "
    ;; ".kt { color: #B00040 } "
    ;; ".m { color: #666666 } "
    ;; ".s { color: #BA2121 } "
    ;; ".na { color: #7D9029 } "
    ;; ".nb { color: #008000 } "
    ;; ".nc { color: #0000FF; font-weight: bold } "
    ;; ".no { color: #880000 } "
    ;; ".nd { color: #AA22FF } "
    ;; ".ni { color: #999999; font-weight: bold } "
    ;; ".ne { color: #D2413A; font-weight: bold } "
    ;; ".nf { color: #0000FF } "
    ;; ".nl { color: #A0A000 } "
    ;; ".nn { color: #0000FF; font-weight: bold } "
    ;; ".nt { color: #008000; font-weight: bold } "
    ;; ".nv { color: #19177C } "
    ;; ".ow { color: #AA22FF; font-weight: bold } "
    ;; ".w { color: #bbbbbb } "
    ;; ".mb { color: #666666 } "
    ;; ".mf { color: #666666 } "
    ;; ".mh { color: #666666 } "
    ;; ".mi { color: #666666 } "
    ;; ".mo { color: #666666 } "
    ;; ".sb { color: #BA2121 } "
    ;; ".sc { color: #BA2121 } "
    ;; ".sd { color: #BA2121; font-style: italic } "
    ;; ".s2 { color: #BA2121 } "
    ;; ".se { color: #BB6622; font-weight: bold } "
    ;; ".sh { color: #BA2121 } "
    ;; ".si { color: #BB6688; font-weight: bold } "
    ;; ".sx { color: #008000 } "
    ;; ".sr { color: #BB6688 } "
    ;; ".s1 { color: #BA2121 } "
    ;; ".ss { color: #19177C } "
    ;; ".bp { color: #008000 } "
    ;; ".vc { color: #19177C } "
    ;; ".vg { color: #19177C } "
    ;; ".vi { color: #19177C } "
    ;; ".il { color: #666666 } "


    ;; pygmentize -S colorful -f html
    ".hll { background-color: #ffffcc }"
    ".c { color: #888888 }"
    ".err { color: #FF0000; background-color: #FFAAAA }"
    ".k { color: #008800; font-weight: bold }"
    ".o { color: #333333 }"
    ".cm { color: #888888 }"
    ".cp { color: #557799 }"
    ".c1 { color: #888888 }"
    ".cs { color: #cc0000; font-weight: bold }"
    ".gd { color: #A00000 }"
    ".ge { font-style: italic }"
    ".gr { color: #FF0000 }"
    ".gh { color: #000080; font-weight: bold }"
    ".gi { color: #00A000 }"
    ".go { color: #888888 }"
    ".gp { color: #c65d09; font-weight: bold }"
    ".gs { font-weight: bold }"
    ".gu { color: #800080; font-weight: bold }"
    ".gt { color: #0044DD }"
    ".kc { color: #008800; font-weight: bold }"
    ".kd { color: #008800; font-weight: bold }"
    ".kn { color: #008800; font-weight: bold }"
    ".kp { color: #003388; font-weight: bold }"
    ".kr { color: #008800; font-weight: bold }"
    ".kt { color: #333399; font-weight: bold }"
    ".m { color: #6600EE; font-weight: bold }"
    ".s { background-color: #fff0f0 }"
    ".na { color: #0000CC }"
    ".nb { color: #007020 }"
    ".nc { color: #BB0066; font-weight: bold }"
    ".no { color: #003366; font-weight: bold }"
    ".nd { color: #555555; font-weight: bold }"
    ".ni { color: #880000; font-weight: bold }"
    ".ne { color: #FF0000; font-weight: bold }"
    ".nf { color: #0066BB; font-weight: bold }"
    ".nl { color: #997700; font-weight: bold }"
    ".nn { color: #0e84b5; font-weight: bold }"
    ".nt { color: #007700 }"
    ".nv { color: #996633 }"
    ".ow { color: #000000; font-weight: bold }"
    ".w { color: #bbbbbb }"
    ".mb { color: #6600EE; font-weight: bold }"
    ".mf { color: #6600EE; font-weight: bold }"
    ".mh { color: #005588; font-weight: bold }"
    ".mi { color: #0000DD; font-weight: bold }"
    ".mo { color: #4400EE; font-weight: bold }"
    ".sb { background-color: #fff0f0 }"
    ".sc { color: #0044DD }"
    ".sd { color: #DD4422 }"
    ".s2 { background-color: #fff0f0 }"
    ".se { color: #666666; font-weight: bold; background-color: #fff0f0 }"
    ".sh { background-color: #fff0f0 }"
    ".si { background-color: #eeeeee }"
    ".sx { color: #DD2200; background-color: #fff0f0 }"
    ".sr { color: #000000; background-color: #fff0ff }"
    ".s1 { background-color: #fff0f0 }"
    ".ss { color: #AA6600 }"
    ".bp { color: #007020 }"
    ".vc { color: #336699 }"
    ".vg { color: #dd7700; font-weight: bold }"
    ".vi { color: #3333BB }"
    ".il { color: #0000DD; font-weight: bold }"
;;; this is my setting
    "pre * {font-family:'Consolas', \'Malgun Gothic\';font-size:0.9em;}"
    "#content{text-align:left;max-width:70em}"
    "</style>"
    )
  "\n"
  ))

(setq org-html-head (s-replace "100px" "2em" org-html-head))


(setq mu4e-debug nil)

;; https://lists.gnu.org/archive/html/emacs-orgmode/2015-08/msg00947.html
(setq  org-element-use-cache nil)







;; https://github.com/jwiegley/org-mode/issues/14

;; Use pygments highlighting for code
(defun pygmentize (lang code)
  "Use Pygments to highlight the given code and return the output"
  (with-temp-buffer
    (insert code)
    (let ((lang (or (cdr (assoc lang org-pygments-language-alist)) "text")))
      (shell-command-on-region (point-min) (point-max)
                               (format "t:\\usr\\local\\python35\\Scripts\\pygmentize.exe -f html -l %s" lang)
                               (buffer-name)
                               t
                               ))
    (message (buffer-name))                               
    (goto-char 0 )
    (search-forward "<pre>")
    (save-excursion
      (save-restriction 
        (narrow-to-region (point) (point-max))
        (goto-char (point-max))
        (buffer-substring-no-properties (point-min) (line-end-position -1))))))

  ;add whatever you want
(defconst org-pygments-language-alist
  '(
    ("asymptote" . "asymptote")
    ("awk" . "awk")
    ("C" . "c")
    ("cpp" . "cpp")
    ("clojure" . "clojure")
    ("css" . "css")
    ("D" . "d")
    ("emacs-lisp" . "scheme")
    ("F90" . "fortran")
    ("gnuplot" . "gnuplot")
    ("groovy" . "groovy")
    ("html" . "html")
    ("haskell" . "haskell")
    ("java" . "java")
    ("js" . "js")
    ("julia" . "julia")
    ("latex" . "latex")
    ("lisp" . "newlisp")
    ("makefile" . "makefile")
    ("matlab" . "matlab")
    ("mscgen" . "mscgen")
    ("ocaml" . "ocaml")
    ("octave" . "octave")
    ("perl" . "perl")
    ("picolisp" . "scheme")
    ("python" . "python")
    ("R" . "r")
    ("ruby" . "ruby")
    ("sass" . "sass")
    ("scala" . "scala")
    ("scheme" . "scheme")
    ("sh" . "sh")
    ("sql" . "sql")
    ("sqlite" . "sqlite3")
    ("tcl" . "tcl")
    ("diff" . "diff")
    ("patch" . "diff")
    )
  "Alist between org-babel languages and Pygments lexers.
See: http://orgmode.org/worg/org-contrib/babel/languages.html and
http://pygments.org/docs/lexers/ for adding new languages to the
mapping. ")

;; Override the html export function to use pygments

(defun org-html-src-block (src-block contents info)
  "Transcode a SRC-BLOCK element from Org to HTML.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (if (org-export-read-attribute :attr_html src-block :textarea)
      (org-html--textarea-block src-block)
    (let ((lang (org-element-property :language src-block))
          (caption (org-export-get-caption src-block))
          ;; (code (org-html-format-code src-block info))
          (label (let ((lbl (and (org-element-property :name src-block)
                                 (org-export-get-reference src-block info))))
                   (if lbl (format " id=\"%s\"" lbl) ""))))
      (if (not lang) (format "<pre class=\"example\"%s>\n%s</pre>" label (org-html-format-code src-block info))
        (format
         "<div class=\"org-src-container\">\n%s%s\n</div>"
         (if (not caption) ""
           (format "<label class=\"org-src-name\">%s</label>"
                   (org-export-data caption info)))
         (format "\n<pre class=\"src src-%s\"%s>%s</pre>" lang label (org-html-src-format-code src-block info)))))))



(defun org-html-do-src-format-code
    (code &optional lang refs retain-labels num-start)
  "Format CODE string as source code.
Optional arguments LANG, REFS, RETAIN-LABELS and NUM-START are,
respectively, the language of the source code, as a string, an
alist between line numbers and references (as returned by
`org-export-unravel-code'), a boolean specifying if labels should
appear in the source code, and the number associated to the first
line of code."
  (let* ((code-lines (org-split-string code "\n"))
         (code-length (length code-lines))
         (num-fmt
          (and num-start
               (format "%%%ds: "
                       (length (number-to-string (+ code-length num-start))))))
         (code code));;;
    (org-export-format-code
     code
     (lambda (loc line-num ref)
       (setq loc
             (concat
              ;; Add line number, if needed.
              (when num-start
                (format "%s"
                        (format num-fmt line-num)))
              ;; Transcoded src line.
              loc
              ;; Add label, if needed.
              (when (and ref retain-labels) (format " (%s)" ref))))
       ;; Mark transcoded line as an anchor, if needed.
       (if (not ref) loc
         (format "%s"
                 ref loc)))
     num-start refs)))

(defun org-html-src-format-code (element info)
  "Format contents of ELEMENT as source code.
ELEMENT is either an example block or a src block.  INFO is
a plist used as a communication channel."
  (let* ((lang (org-element-property :language element))
         ;; Extract code and references.
         (code-info (org-export-unravel-code element))
         (code (car code-info))
         (refs (cdr code-info))
         ;; Does the src block contain labels?
         (retain-labels (org-element-property :retain-labels element))
         ;; Does it have line numbers?
         (num-start (case (org-element-property :number-lines element)
                      (continued (org-export-get-loc element info))
                      (new 0))))

    (with-temp-buffer
      (insert  (org-html-do-src-format-code code lang refs retain-labels nil))
      (let ((lang (or (cdr (assoc lang org-pygments-language-alist)) "text")))
        (shell-command-on-region (point-min) (point-max)
                                 (if (numberp num-start )
                                     (format "t:\\usr\\local\\python35\\Scripts\\pygmentize.exe -f html -O linenos=inline,linenostart=%d -l %s" (+ 1  num-start) lang)
                                   (format "t:\\usr\\local\\python35\\Scripts\\pygmentize.exe -f html -l %s" lang))
                                 (buffer-name)
                                 t
                                 ))
      (goto-char 0 )
      (progn
        (search-forward "<pre>")
        (save-excursion
          (save-restriction 
            (narrow-to-region (point) (point-max))
            (goto-char (point-max))
            (buffer-substring-no-properties (point-min) (line-end-position -1))))))))



(defun oh ()
  (interactive)
  (let* ((fs (or (org-agenda-files t)
		 (user-error "No agenda files")))
      (ntag (helm-comp-read "성명을 입력하세요 : " fs)))
      (find-file ntag)
      (if (buffer-base-buffer) (org-pop-to-buffer-same-window (buffer-base-buffer)))))


(defun oa ()
  (interactive)
  (switch-to-buffer "*Org Agenda*"))

(defun om ()
  (interactive)
  (switch-to-buffer "*mu4e-headers*"))

(defun org-buffer ()
  "Open a new empty buffer.
URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
Version 2015-06-12"
  (interactive)
  (let ((ξbuf (generate-new-buffer "untitled")))
    (switch-to-buffer ξbuf)
    (org-mode)
    (setq buffer-offer-save t)
    (setq default-directory "t:/orgdir/")
    (write-file "" t)
    ))

(setq org-agenda-custom-commands
      `(

        ("d" . "마감기한")
        ,@(mapcar 
           (lambda (x)
             `(,(car x) ,(cadr x ) agenda ""
               ((org-agenda-entry-types '(:deadline))
                ;; a slower way to do the same thing
                ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'notdeadline))
                (org-agenda-span ,(caddr x))
                (org-deadline-warning-days 5)
                ;; (org-agenda-time-grid nil)
                )))
           '(
             ("dd" "일 마감" 'day)
             ("dw" "주 마감" 'week)
             ("dm" "월 마감" 'month)
             ("dy" "년 마감" 'year)))

        

        ("h" . "예약작업")
        ,@(mapcar 
           (lambda (x)
             `(,(car x) ,(cadr x ) agenda ""
               ((org-agenda-entry-types '(:scheduled))
                ;; a slower way to do the same thing
                ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'notdeadline))
                (org-agenda-span ,(caddr x))
                (org-agenda-repeating-timestamp-show-all ,(cadddr x)) 
                ;; (org-agenda-time-grid nil)
                )))
           '(
             ("hw" "일간 예약작업" 'day t)
             ("hw" "주간 예약작업" 'week t)
             ("hm" "월간 예약작업" 'month nil)
             ("hy" "년간 예약작업" 'year nil)))

        

        ;; ...other commands here
        

        ("p" . "우선순위")
        ("pa" "우선순위 A" tags-todo "+PRIORITY=\"A\"")
        ("pb" "우선순위 B" tags-todo "+PRIORITY=\"B\"")
        ("pc" "우선순위 C" tags-todo "+PRIORITY=\"C\"")))
