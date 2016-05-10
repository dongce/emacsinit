
(w32-unix-eval
 (

  (setenv "BZR_PLUGIN_PATH"      "t:/usr/local/bazaar/plugins"      t )
  (setenv "GUILE_HOME"      "t:/usr/local/guile"      t )
  (setenv "PYTHONUNBUFFERED"      "x" t )
  (setenv "WORKON_HOME"      "t:/usr/local/pyvenv" t )
  (setenv "GRAPHVIZ_DOT"      "t:/usr/local/graphviz/bin/dot.exe" t )


  (append-path (fullpath "../../cmdutils/"))
  (append-path (fullpath "../../xz/bin_i486"))

  (append-path (concat  (getenv "GUILE_HOME") "/default/bin"))

  (append-path  "t:/usr/texlive2013/bin/win32")
  ;; (append-path  (fullpath "../../../../python27/scripts"))
  ;; (append-path  (fullpath "../../../../python27/"))
  (append-path  "c:/usr/local/python35/scripts")
  (append-path  "c:/usr/local/python35/")

  (append-path  (fullpath "../../../..//mingwdevkit/bin"))
  (append-path  (fullpath "../../../..//mingwdevkit/mingw/bin"))
  (append-path  (fullpath "../../EmacsW32/bin"))
  (append-path  (fullpath "../../EmacsW32/codesearch"))
  (append-path  (fullpath "../../EmacsW32/gnuwin32/bin"))
  (append-path  (fullpath "../../gnutls/bin"))
  (append-path  (fullpath "../../bc/bin/"))
  (append-path  (fullpath "../../processhacker/x86"))
  (append-path  (fullpath "../../imagemagick/"))
  (append-path  (fullpath "../../zeal-20131109/"))
  (append-path  (fullpath "../../../../postscript/ghostscript/bin/"))
  (append-path  (fullpath "../../../../sqlite/"))
  (append-path  (fullpath "../../../../llvmclang/bin/"))
  (prepend-path  (fullpath "../../../../msysgit/libexec/git-core/"))
  (prepend-path  (fullpath "../../../../msysgit/cmd/"))
  (append-path  (fullpath "../../putty"))

  (append-path  "t:/usr/local/graphviz/bin")
  (append-path  "c:/usr/local/gnupg")
  (append-path "c:/usr/local/7zip")
  (append-path  "c:/usr/local/gpg4win")

  )

 ())
