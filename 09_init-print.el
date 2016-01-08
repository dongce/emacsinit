;; -*-mode: emacs-lisp; coding: utf-8; buffer-read-only: t; lexical-binding: t; -*-

(setq ps-lpr-switches '("-query"))
(setq ps-printer-name t)

;; 헤더가 붙지 않도록 설정한다. 
(setq ps-print-header nil )

(w32-unix-eval
 (
  ;; WIN32 설정 
  (setq ps-lpr-command "t:/usr/local/postscript/gsview/gsview/gsprint.exe")
  (setq preview-gs-command "t:/usr/local/postscript/gs910/bin/gswin32c.exe")
  )
 (
  ;; 다음을 이용하용 ENSCRIPT 사용 가능
  ;; 언어에 때라 특정한 옵션 사용가능
  (defvar *enscript-syntax* 
    '( (c++-mode . "-Ecpp")
       (c-mode . "-Ecpp" )
       (ada-mode . "-Eada" )
       (sh-mode . "-Ebash" )
       (diff-mode . "-Ediff" )
       (emacs-lisp-mode ."-Eelisp" )
       (idl-mode . "-Eidl")
       (makefile-mode ."-Emakefile")
       (python-mode ."-Epython") ) )

  (defun enscript()
    (interactive)
    (print 
     (with-output-to-string
       (call-process-region 
        (point-min) 
        (point-max)
        "/opt/sfw/bin/enscript"  
        nil 
        standard-output
        nil
        "-Plplpx"
        (cdr (assoc major-mode *enscript-syntax* ) ) ) ) )  )

  (defun enscript-region()
    (interactive)
    (print 
     (with-output-to-string
       (call-process-region 
        (region-beginning) 
        (region-end) 
        "enscript"  
        nil 
        standard-output
        nil
        "-Plplpx"
        (cdr (assoc major-mode *enscript-syntax* ) ) ) ) )  )))

;; 한글 프린팅이 가능하다. 
(require 'ps-print)
(require 'ps-mule)
(require 'ps-bdf)
(require 'ps2pdf)


;; latex listings 를 이용합니다. 
;; http://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings

;; Supported languages
;; It supports the following programming languages:
;; ABAP2,4 	IDL4 	PL/I
;; ACSL 	inform 	Plasm
;; Ada4 	Java4 	POV
;; Algol4 	JVMIS 	Prolog
;; Ant 	ksh 	Promela
;; Assembler2,4 	Lisp4 	Python
;; Awk4 	Logo 	R
;; bash 	make4 	Reduce
;; Basic2,4 	Mathematica1,4 	Rexx
;; C4 	Matlab 	RSL
;; C++4 	Mercury 	Ruby
;; Caml4 	MetaPost 	S4
;; Clean 	Miranda 	SAS
;; Cobol4 	Mizar 	Scilab
;; Comal 	ML 	sh
;; csh 	Modelica3 	SHELXL
;; Delphi 	Modula-2 	Simula4
;; Eiffel 	MuPAD 	SQL
;; Elan 	NASTRAN 	tcl4
;; erlang 	Oberon-2 	TeX4
;; Euphoria 	OCL4 	VBScript
;; Fortran4 	Octave 	Verilog
;; GCL 	Oz 	VHDL4
;; Gnuplot 	Pascal4 	VRML
;; Haskell 	Perl 	XML
;; HTML 	PHP 	XSLT


;; breakindent=0em,
;; language=XML,
;; basicstyle=\\footnotesize,
;; numbers=left,
;; numberstyle=\\footnotesize,
;; stepnumber=2,
;; numbersep=5pt,
;; backgroundcolor=\\color{white},
;; showspaces=false,
;; showstringspaces=false,
;; showtabs=false,
;; frame=single,
;; tabsize=2,
;; captionpos=b,
;; escapeinside={\\%*}{*)},
;; linewidth=\\textwidth
;; http://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings
;; http://www.personal.ceu.hu/tex/docclass.htm
;; http://stackoverflow.com/questions/1965702/how-to-mark-line-breaking-of-long-lines 
;; http://en.wikibooks.org/wiki/LaTeX/Page_Layout
;; http://stackoverflow.com/questions/1116266/listings-in-latex-with-utf-8-or-at-least-german-umlauts kim dong il 


;; \documentclass [10pt ,a4paper, oneside]{article}

;; \usepackage{listings}   %per la stampa del codice

;; \newenvironment{C}
;; {\lstset{language=[ANSI]C++,
;; basicstyle=\small\ttfamily,
;; %numbers=left,
;; showspaces=false,
;; numberstyle=\tiny,
;; stepnumber=2,
;; tabsize=2,
;; numbersep=5pt,
;; numberfirstline = false,
;; framexleftmargin=5mm, frame=shadowbox,
;; breaklines = true}
;; }
;; {}

;; \begin{document}

;; \begin{C}
;; \begin{lstlisting}
;; void initIrqVectors(void) {    
;;    // IVPR = address base used with IVOR's
;;    asm ("lis r5, IV_ADDR@h");
;;    for (int i = 0; i < 5 ; i++) { ... }
;; }
;; \end{lstlisting}
;; \end{C}
;; \end{document}


(defcustom lstlngnames 
  '((python-mode . python)
                     (c++-mode . c++)
                     (c-mode . c++)
                     (sh-mode . sh)
                     (idl-mode . idl)
                     (emacs-lisp-mode . lisp)
                     (lisp-mode . lisp)
                     (ruby-mode . ruby)
                     (web-mode . html)
                     (java-mode . java)
                     )
  "latex listings 언어 목록" 
  )


(defmacro listing-template (fontsize &rest forms)
  `(progn
      ;; http://en.wikibooks.org/wiki/LaTeX/Page_Layout
      ;; (insert-line "\\documentclass[a4paper, landscape, 11pt]{article}")
      ;; http://texblog.org/2012/08/29/changing-the-font-size-in-latex/
     ;; http://tex.stackexchange.com/questions/33685/set-the-font-family-for-lstlisting
  (insert-line (format "\\documentclass[a4paper, %dpt]{extarticle}" (if (member ,fontsize '(8 9 10 11 12 14 17 20)) ,fontsize 10 )))
  (insert-line "\\usepackage{extsizes}") ;http://texblog.org/2012/08/29/changing-the-font-size-in-latex/
  (insert-line "\\usepackage[utf8]{inputenc}")
  (insert-line "\\usepackage{fullpage}")
  (insert-line "\\usepackage{courier}")
  (insert-line "\\usepackage{listings}")
  (insert-line "\\usepackage{color}")
  (insert-line "\\usepackage{MnSymbol}")
  (insert-line "\\usepackage[hangul]{kotex}")
  ;; http://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings
  ;; http://stackoverflow.com/questions/981020/how-to-force-line-wrapping-in-listings-package
  (insert  "\\lstset{
%inputencoding=utf8
%showspaces=false,
showstringspaces=false,
extendedchars=\\true,
breaklines=true,
breakatwhitespace=true,
breakautoindent=false,
basicstyle=\\footnotesize\\ttfamily,
}
")
  ;; http://stackoverflow.com/questions/1965702/how-to-mark-line-breaking-of-long-lines
  (insert "
\\lstset{prebreak=\\raisebox{0ex}[0ex][0ex]
        {\\ensuremath{\\rhookswarrow}}}
\\lstset{postbreak=\\raisebox{0ex}[0ex][0ex]
        {\\ensuremath{\\rcurvearrowse\\space}}}\n" )
  (mapcar #'insert-line '("\\usepackage {fancyhdr}" "\\pagestyle{fancy}")) 


  ,@forms
))

(defmacro verbatim-template (fontsize &rest forms)
  `(progn
  (insert-line (format "\\documentclass[a4paper, %dpt]{extarticle}" (if (member ,fontsize '(8 9 10 11 12 14 17 20)) ,fontsize 10 )))
  (insert-line "\\usepackage{extsizes}") ;http://texblog.org/2012/08/29/changing-the-font-size-in-latex/
  (insert-line "\\usepackage[utf8]{inputenc}")
  (insert-line "\\usepackage{fullpage}")
  (insert-line "\\usepackage{courier}")
  (insert-line "\\usepackage{lmodern}")
  (insert-line "\\usepackage{spverbatim}")
  (insert-line "\\usepackage{listings}")
  (insert-line "\\usepackage{color}")
  (insert-line "\\usepackage{MnSymbol}")
  (insert-line "\\usepackage[hangul]{kotex}")
  (mapcar #'insert-line '("\\usepackage {fancyhdr}" "\\pagestyle{fancy}")) 
  ,@forms))

(defun listings (&optional  fontsize)
  (interactive "p")
  (save-some-buffers)
  (let* ((fname (file-truename  (make-temp-file "listings")))
         (lexical-binding t)
         (language (symbol-name  (cdr  (assoc major-mode lstlngnames ))))
         (inputlisting (format  "\\lstinputlisting[language=%s]{%s}" language (buffer-file-name)))
         (filename  (buffer-file-name))
         (jobname (file-name-base filename))
         )
    (with-temp-file fname
      (listing-template 
       fontsize 
       (insert-line (format  "\\markboth{%s}{%s}"   language   (file-name-nondirectory  filename)))

       (insert-line "\\begin{document}")
       (insert-line "\\newline")
       (insert-line "\\newline")
       (insert-line "\\newline")
       (insert-line inputlisting)
       (insert-line "\\end{document}")

       ))

    ;; (async-start-process "pdflatex" "pdflatex" (lambda (p) (message "pdflatex 완료")) "-no-file-line-error" "-shell-escape" "-interaction" "nonstopmode" "-jobname" jobname fname)
    (async-start-process "pdflatex" "pdflatexwrap" (lambda (p) (w32-shell-execute "" (file-truename  (format "%s.pdf" jobname)) ))     jobname fname)  
    )) 



(defun listing-region (b e &optional  fontsize)
  (interactive "r\np")
  (save-some-buffers)
  (let* ((fname (file-truename  (make-temp-file "listings")))
         (lexical-binding t)
         (language (symbol-name  (cdr  (assoc major-mode lstlngnames ))))
         (bufstring (buffer-substring b e ))
         (filename  (buffer-file-name))
         (jobname (file-name-base filename))
         )
    (with-temp-file fname
      (set-buffer-file-coding-system 'utf-8) 
      (listing-template 
       fontsize 
       (insert-line (format  "\\markboth{%s}{%s}"   language   (file-name-nondirectory  filename)))
       ;; (insert-line "\\lstset{language=}")
       (insert-line "\\begin{document}")
       (insert-line "\\newline")
       (insert-line "\\begin{lstlisting}"  )
       (insert bufstring)
       (insert-line "\\end{lstlisting}")
       (insert-line "\\end{document}")))

    ;; (async-start-process "pdflatex" "pdflatex" (lambda (p) (message "pdflatex 완료")) "-shell-escape" "-interaction" "nonstopmode" "-jobname" jobname fname)
    (async-start-process "pdflatex" "pdflatexwrap" (lambda (p) (w32-shell-execute "" (file-truename  (format "%s.pdf" jobname)) ))     jobname fname)  
))




(defun verbatim-region (b e &optional  fontsize)
  (interactive "r\np")
  (save-some-buffers)
  (let* ((fname (file-truename  (make-temp-file "verbatim")))
         (lexical-binding t)
         (language (symbol-name  (cdr  (assoc major-mode lstlngnames ))))
         (bufstring (buffer-substring b e ))
         (filename  (buffer-file-name))
         (jobname (file-name-base filename))
         )
    (with-temp-file fname
      (set-buffer-file-coding-system 'utf-8) 
      (verbatim-template 
       fontsize 
       (insert-line (format  "\\markboth{%s}{%s}"   language   (file-name-nondirectory  filename)))

       (insert-line "\\begin{document}")
       (insert-line "\\newline")
       (insert-line "\\begin{spverbatim}" )
       (insert bufstring)
       (insert-line "\\end{spverbatim}")
       (insert-line "\\end{document}")))

    ;; (async-start-process "pdflatex" "pdflatex" (lambda (p) (message "pdflatex 완료")) "-shell-escape" "-interaction" "nonstopmode" "-jobname" jobname fname)
    (async-start-process "pdflatex" "pdflatexwrap" (lambda (p) (w32-shell-execute "" (file-truename  (format "%s.pdf" jobname)) ))     jobname fname)  
))
(defmacro pytex-template (fontsize &rest forms)
  `(progn
  (insert-line (format "\\documentclass[a4paper, %dpt]{extarticle}" (if (member ,fontsize '(8 9 10 11 12 14 17 20)) ,fontsize 10 )))
  (insert-line "\\usepackage{extsizes}") ;http://texblog.org/2012/08/29/changing-the-font-size-in-latex/
  (insert-line "\\usepackage[margin=2cm]{geometry}")
  (insert-line "\\usepackage{courier}")
  (insert-line "\\usepackage{kotex}")
  (mapcar #'insert-line '("\\usepackage {fancyhdr}" "\\pagestyle{fancy}")) 
  (insert "
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{pythontex}
")


  ,@forms
))

(defun pytex-region (b e &optional  fontsize)
  (interactive "r\np")
  (save-some-buffers)
  (let* ((fname (file-truename  (make-temp-file "pytex")))
         (lexical-binding t)
         (language (symbol-name  (cdr  (assoc major-mode lstlngnames ))))
         (bufstring (buffer-substring b e ))
         (filename  (buffer-file-name))
         (jobname (file-name-base filename))
         )
    (with-temp-file fname
      (set-buffer-file-coding-system 'utf-8) 
      (pytex-template 
       fontsize 
       (insert-line (format  "\\markboth{%s}{%s}"   language   (file-name-nondirectory  filename)))

       (insert-line "\\begin{document}")
       (insert-line (format  "\\begin{pygments}{%s}" language))
       (insert-line bufstring)
       (insert-line "\\end{pygments}")
       (insert-line "\\end{document}")))

    ;; (async-start-process "pdflatex" "pdflatex" (lambda (p) (message "pdflatex 완료")) "-shell-escape" "-interaction" "nonstopmode" "-jobname" jobname fname)
    (async-start-process "pytex" "pytexwrap" (lambda (p) (w32-shell-execute "" (file-truename  (format "%s.pdf" jobname)) ))     jobname fname)  
))

(require 'w32-winprint)
