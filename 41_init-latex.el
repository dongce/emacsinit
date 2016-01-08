;;;_ attach-file 

;;; http://jkitchin.github.io/blog/2013/09/30/Attaching-code-blocks-to-a-pdf-file-during-export/
;; * Attaching code blocks to a pdf file during export
;;   :PROPERTIES:
;;   :categories: org-mode
;;   :date:     2013/09/30 21:58:52
;;   :updated:  2013/09/30 21:58:52
;;   :END:
;; This post is a further exploration of using the export filters to modify construction of content exported from org-mode. In this post we look at some code that will save all of the code-blocks in an org-buffer to systematically named files, and then attach the files to an exported pdf file. We will use the [[http://www.ctan.org/tex-archive/macros/latex/contrib/attachfile][attachfile]] LaTeX package to attach the scripts. We will build off of [[http://jkitchin.github.io/blog/2013/09/28/Customizing-export-of-code-blocks-in-HTML/][this post]] for the filters.

;; First, let us put in a gratuitous code block. In the rendered pdf, this script will be embedded in the pdf. I am not quite ready to build a filter that supports multiple backends, so in this post we just modify the latex export.

;; #+BEGIN_SRC python
;; name = 'John'
;; print 'Hello {0}'.format(name)
;; #+END_SRC

;; #+RESULTS:
;; : Hello John

;; We are only going to attach the python code blocks in this example, and ignore all the other blocks. We will basically use the same kind strategy we have used before. We will initially parse the buffer to get a list of all the code blocks. Then we create a filter for the src-blocks that keeps a counter of src-blocks, and depending on the type of the nth src-block, we will save the file, and modify the text for that block. Here is our code for the list of code blocks.

;; #+BEGIN_SRC emacs-lisp
;; (setq src-block-list 
;;       (org-element-map (org-element-parse-buffer) 'src-block 
;;         (lambda (src-block) src-block)))
;; #+END_SRC

;; #+RESULTS:

;; Now we create the filter. 

;; #+BEGIN_SRC emacs-lisp
;; (defun ox-mrkup-filter-src-block (text back-end info)
;;   (catch 'return text)
;;   (let ((src-block (nth counter src-block-list)))
;;     (if (string= (org-element-property :language src-block) "python")
;;         (progn 
;;           (setq scriptname (format "py-%d.py" counter))
;;           ;; save code block
;;           (with-temp-buffer
;;             (insert (org-element-property :value src-block))
;;             (write-region (point-min) (point-max) scriptname ))
         
;;           (setq output (format "%s\n\\attachfile{%s} Double click me to open" text scriptname)))
;;       ;; else
;;       (setq output text)))
;;   ;; increment counter no matter what so next block is processed
;;   (setq counter (+ counter 1))
;;   ;; return output
;;   output)
;; #+END_SRC

;; #+RESULTS:

;; Finally, we export the document to LaTeX, and run pdflatex on it to generate the pdf.

;; #+BEGIN_SRC emacs-lisp
;; (let ((counter 0)
;;       ;; these packages are loaded in the latex file
;;       (org-latex-default-packages-alist 
;;        '(("utf8" "inputenc" nil)
;; 	 ("T1" "fontenc" nil)
;; 	 ("" "fixltx2e" nil)
;;          ("" "lmodern" nil)
;;          ("" "minted" nil) ;; for code syntax highlighting
;;          ;; customize how pdf links look
;;          ("linktocpage,
;;            pdfstartview=FitH,
;;            colorlinks,
;;            linkcolor=blue,
;;            anchorcolor=blue,
;;            citecolor=blue,
;;            filecolor=blue,
;;            menucolor=blue,
;;            urlcolor=blue" "hyperref" nil)))
;;       (org-export-filter-src-block-functions '(ox-mrkup-filter-src-block))
;;       (async nil)
;;       (subtreep nil)
;;       (visible-only nil)
;;       (body-only nil)
;;       (ext-plist '()))
;;   (org-latex-export-to-pdf async subtreep visible-only body-only ext-plist))
;; #+END_SRC

;; #+RESULTS:

;; Check out the result: file:attaching-code-blocks-to-a-pdf.pdf. This text won't show up in the pdf. I had some difficulty including the link via org-links. The export engine wanted to embed it as a pdf in itself! That does not seem to work. 



;;;_ djcb-org-article
;;;_ MATH 

;;; http://en.wikibooks.org/wiki/LaTeX/Mathematics 


;; -------------------------------------
;; -- PDF
;; -------------------------------------
;; 'djcb-org-article' for export org documents to the LaTex 'article', using
;; XeTeX and some fancy fonts; requires XeTeX (see org-latex-to-pdf-process)
;; -----------------------------------------------------------------------------
;; http://emacs-fu.blogspot.com/2011/04/nice-looking-pdfs-with-org-mode-and.html
;; http://comments.gmane.org/gmane.emacs.orgmode/40221
;; -----------------------------------------------------------------------------
;; Install Packages:
;; + texlive-all  
;; + texlive-xetex
;; + ttf-sil-gentium
;; + ttf-sil-gentium-basic
;; + ttf-sil-charis
;; + ttf-dejavu
;; -----------------------------------------------------------------------------
;; Make sure to include the latex class in you header:
;; #+LaTeX_CLASS: djcb-org-article
;; -----------------------------------------------------------------------------
(eval-after-load 'org-latex
  '(progn
     (add-to-list 'org-latex-classes
          '("minted-org-article"
            "\\documentclass[11pt,a4paper]{article}
             \\usepackage{minted}
             \\usemintedstyle{emacs}
             \\newminted{common-lisp}{fontsize=10}
                     \\usepackage[T1]{fontenc}
                     \\usepackage{hyperref}
                     \\usepackage{fontspec}
                     \\usepackage{graphicx}
                     \\defaultfontfeatures{Mapping=tex-text}
                     \\setromanfont{Gentium}
                     \\setromanfont [BoldFont={Gentium Basic Bold},
                                     ItalicFont={Gentium Basic Italic}]{Gentium Basic}
                     \\setmonofont[Scale=0.8]{DejaVu Sans Mono}
                     \\usepackage{geometry}
                     \\geometry{a4paper, textwidth=6.5in, textheight=10in,
                                 marginparsep=7pt, marginparwidth=.6in}
                     \\pagestyle{empty}
                     \\title{}
                           [NO-DEFAULT-PACKAGES]
                           [NO-PACKAGES]"
            ("\\section{%s}" . "\\section*{%s}")
            ("\\subsection{%s}" . "\\subsection*{%s}")
            ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
            ("\\paragraph{%s}" . "\\paragraph*{%s}")
            ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))))

                     ;; \\setsansfont{Charis SIL}

;;; http://orgmode.org/worg/org-contrib/babel/examples/article-class.html

;; -----------------------------------------------------------------------------
;; Added Syntax Highlighting Support
;; http://orgmode.org/worg/org-tutorials/org-latex-export.html
;; #+LaTeX_HEADER: \usepackage{minted}
;; #+LaTeX_HEADER: \usemintedstyle{emacs}
;; #+LaTeX_HEADER: \newminted{common-lisp}{fontsize=\footnotesize}
;; -----------------------------------------------------------------------------
;; Install Packages:
;; + python-pygments
;; -----------------------------------------------------------------------------
;; (setq org-latex-listings 'minted)
;; (setq org-latex-custom-lang-environments
;;       '(
;;     (emacs-lisp "common-lispcode")
;;        ))
;; (setq org-latex-minted-options
;;       '(("frame" "lines")
;;         ("fontsize" "\\scriptsize")
;;     ("linenos" "")
;; ))
;; (setq org-latex-to-pdf-process
;;       '("xelatex --shell-escape -interaction nonstopmode %f"
;;     "xelatex --shell-escape -interaction nonstopmode %f")) ;; for multiple passes
;; ;; Not sure if this is actually setting the export class correctly.
;; (setq org-export-latex-class "djcb-org-article")
;;
;;
