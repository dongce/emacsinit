;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-
;;; the following functions use the program nircmd found at http://www.nirsoft.net 

(defvar nircmdexe 
  (concat (getenv "GUILE_HOME") "/nircmd/nircmd.exe"))

(defun nircmd (cmd) 
  (interactive "MCmd " cmd) 
  (w32-shell-execute nil nircmdexe cmd))

(defun cdeject () 
  "Eject the cd in drive d:" 
  (interactive) (nircmd "cdrom open z:"))


(defun screensaver () 
  "Start the default screensaver" 
  (interactive) (nircmd "screensaver"))

(defun lock () 
  "Lock the workstation" 
  (interactive) (nircmd "lockws"))


(defun prkill (p)
  (interactive "M프로세스 : " p)
  (nircmd (concat "killprocess "  p)))




;;각종윈도우프로그램;;* Component Services: %windir%/system32/comexp.msc
;;각종윈도우프로그램;;* Computer Management: %windir%/system32/compmgmt.msc /s
;;각종윈도우프로그램;;* Data Sources (ODBC): %windir%/system32/odbcad32.exe
;;각종윈도우프로그램;;* Event Viewer: %windir%/system32/eventvwr.msc /s
;;각종윈도우프로그램;;* iSCSI Initiator: %windir%/system32/iscsicpl.exe
;;각종윈도우프로그램;;* Performance Monitor: %windir%/system32/perfmon.msc /s
;;각종윈도우프로그램;;* Services: %windir%/system32/services.msc
;;각종윈도우프로그램;;* System Configuration: %windir%/system32/msconfig.exe
;;각종윈도우프로그램;;* Task Scheduler: %windir%/system32/taskschd.msc /s
;;각종윈도우프로그램;;* Windows Firewall with Advanced Security: %windir%/system32/WF.msc
;;각종윈도우프로그램;;* Windows Memory Diagnostic: %windir%/system32/MdSched.exe
;;각종윈도우프로그램;;* Windows PowerShell Modules: %SystemRoot%/system32/WindowsPowerShell/v1.0/powershell.exe -NoExit -ImportSystemModules

(setf static-winexe-cmdlist 
  `(
    (squid ,(fullpath  "../../conemul/conemu64.exe") "-reuse -dir \"c:\\squid\\sbin\" -cmd .\\squid.exe -D")
    (tscproxy ,(fullpath  "../../conemul/conemu64.exe")
              "-reuse -dir \"t:\\misc\\pytcpproxy\" -cmd c:\\usr\\local\\python35\\python.exe tscproxy.py")
    (msys2conemul ,(fullpath  "../../conemul/conemu64.exe")
                  "-reuse -dir \"%home%\" -cmd e:\\msys264\\usr\\bin\\bash --login -i")
    (conemul ,(fullpath  "../../conemul/conemu64.exe"))
    (filezilla  "t:/usr/local/FileZilla-3.7.1.1/filezilla.exe") 
    (processhacker ,(fullpath  "../../processhacker/x64/ProcessHacker.exe"))
    (processexplorer ,(fullpath  "../../processhacker/procexp.exe"))
    (apt ,(fullpath  "../../advpsterm/apt.exe"))
    (picpick ,(fullpath  "../../../../picpick/picpick.exe"))
    (opencapture "d:/usr/local/opencapture/pOpenCapture.exe")
    (qdir        "t:/usr/local/qdir/Q-Dir.exe")
    (explorer    "c:/WINDOWS/explorer.exe")
    (msys2       "e:/msys264/mingw64_shell.bat")
    ;;(mingw       "t:/usr/local/mingwDevKit/msys.bat")
    ;;(mingw          "e:/mingw/msys/1.0/bin/mintty.exe"                      "/bin/bash -l"                           )
    (mingw          "e:/mingw/msys/1.0/msys.bat"                           )
    (ComponentServices     "c:/windows/system32/comexp.msc"                                                          )
    (ComputerManagement    "c:/windows/system32/compmgmt.msc"                "/s"                                    )
    (DataSources           "c:/windows/system32/odbcad32.exe"                                                        )
    (EventViewer           "c:/windows/system32/eventvwr.msc"                "/s"                                    )
    (iSCSIInitiator        "c:/windows/system32/iscsicpl.exe"                                                        )
    (PerformanceMonitor    "c:/windows/system32/perfmon.msc"                 "/s"                                    )
    (Services              "c:/windows/system32/services.msc"                                                        )
    (SystemConfiguration   "c:/windows/system32/msconfig.exe"                                                        )
    (msconfig              "c:/windows/system32/msconfig.exe"                                                        )
    (TaskScheduler         "c:/windows/system32/taskschd.msc"                 "/s"                                   )
    (WindowsFirewall       "c:/windows/system32/WF.msc"                                                              )
    (WindowsMemory         "c:/windows/system32/MdSched.exe"                                                         )
    (rhapsody              "c:/usr/IBM/rhapsody76/rhapsody.exe"             "-lang=cpp"                            )
    (WindowsPowerShell     "c:/windows/system32/WindowsPowerShell/v1.0/powershell.exe" "-NoExit -ImportSystemModules")
    (FileSystem     "c:/windows/system32/fsmgmt.msc"                                                          )
    (mstsc     "C:/Windows/System32/mstsc.exe")
    (msconfig     "C:/Windows/System32/msconfig.exe")
    (dkw2005   ,(fullpath "../../cmdutils/dkwVS2005.vbs"))
    (dkw2008   ,(fullpath "../../cmdutils/dkwVS2008.vbs"))
    (dkwGUILE   ,(fullpath "../../cmdutils/dkwguile.vbs"))
    (dkwtor    ,(fullpath "../../cmdutils/dkwTORARDO.vbs"))
    (tops      ,(fullpath "../../cmdutils/tops.vbs"))
    (alzip "c:/usr/local/altools/alzip/ALZip.exe")
    (alcapture "c:/usr/local/altools/alcapture/ALCapture.exe")
    (virtualbox "c:/usr/local/virtualbox/VirtualBox.exe")
    (ftp "t:/usr/local/FileZilla-3.7.1.1/filezilla.exe")
    (gimp  "t:/usr/local/gimp2/bin/gimp-2.8.exe")
    (xming  "t:/usr/local/editor/emacsW32/cmdutils/LPXDEVENV.xlaunch")
    (dtterm   "t:/MISC/telnetcmd/tcmd.pyw" )
    (depends "t:/usr/local/depends/depends.exe")
    (magicdisc"c:/usr/local/magicdisc/MagicDisc.exe")
    (foxit  "t:/usr/local/foxit/FoxitReader.exe")
    (vimtut  "t:/usr/local/editor/emacsW32/doc/image/vi-vim-cheat-sheet.gif")
    (jsonview  "t:/usr/local/editor/emacsW32/JsonViewerPackage/JsonView/JsonView.exe")    
    (sourcetree  "t:/usr/local/sourcetree/SourceTree.exe")
    (vncviewer ,(fullpath "../../cmdutils/vncviewer.exe  "))
    (fax  "d:/kicom/e2fax/Fax2006.exe")
    (zeal  "t:/usr/local/editor/emacsW32/zeal-20131109/zeal.exe" )
    (gitk  ,(fullpath "../../cmdutils/gitk.vbs"))
    (wxdemo "c:/usr/local/python27/pythonw.exe" "\"C:/Program Files/wxPython2.9 Docs and Demos/demo/demo.pyw\"")
    (epydoc "c:/usr/local/python27/pythonw.exe" "c:/usr/local/python27/Scripts/epydocgui")
    (pinta "c:/Program Files/Pinta/Pinta.exe")
    (putty "t:/usr/local/editor/emacsW32/iputty/putty.exe")
    (eclipsejee "t:/usr/local/eclipsejee/eclipse.exe")
  (filesplit   "t:/usr/local/filesplitter/Free-File-Splitter-v5.0.1189.exe")))

(defun winexe ()
  (interactive)
  (let* ((winexe-cmdlist (cons `(gitbash  "t:/usr/local/msysgit/msys.bat" ,default-directory) static-winexe-cmdlist))
         (cmd 
          (ido-completing-read 
           "명령을 입력하세요: "
           ;;completing-read;;(mapcar (function (lambda (x) (list (car x) t))) winexe-cmdlist)
           (mapcar (lambda (x) (symbol-name (car x))) winexe-cmdlist)
                   nil t nil nil 'qdir)))
         (apply 
          'w32-shell-execute 
          (cons nil (cdr (assoc (intern cmd) winexe-cmdlist))  ))))


(global-set-key "\C-cx" 'winexe)

(defun opencapture ()
  (interactive)
  (w32-shell-execute nil "d:/usr/local/opencapture/pOpenCapture.exe" nil))

(defun qdir ()
  (interactive)
  (w32-shell-execute nil "c:/usr/local/qdir/Q-Dir.exe" nil))

(defun mingw ()
  (interactive)
  (w32-shell-execute nil "c:/usr/local/mingwDevKit/msys.bat" nil))

;;deprecatedbynext;;(defun toggle-full-screen () 
;;deprecatedbynext;;  (interactive) 
;;deprecatedbynext;;  (shell-command "emacs_fullscreen.exe"))

;; (toggle-frame-fullscreen)
;; (toggle-frame-maximized)


(defun run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call “perl x.pl” in a shell.
The file can be PHP, Perl, Python, Ruby, javascript, Bash, ocaml, vb, elisp.
File suffix is used to determine what program to run."
  (interactive)
  (let (suffixMap fName suffix progName cmdStr)

    ;; a keyed list of file suffix to comand-line program path/name
    (setq suffixMap 
          '(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("rb" . "ruby")
            ("js" . "js")
            ("sh" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            ("bat" . "cmd /c"))
          )

    (setq fName (buffer-file-name))
    (setq suffix (file-name-extension fName))
    (setq progName (cdr (assoc suffix suffixMap)))
    (setq cmdStr (concat progName " \""   fName "\""))

    (if (string-equal suffix "el") ; special case for emacs lisp
        (load-file fName) 
      (if progName
          (progn
            (message "Running…")
            (shell-command cmdStr "*run-current-file output*" )
            )
        (message "No recognized program file suffix for this file.")
        )
      )))

(defun msys-shell (&optional arg)
  "Run MSYS shell (sh.exe).  It's like a Unix Shell in Windows.
A numeric prefix arg switches to the specified session, creating
it if necessary."
  (interactive "P")
  (let ((buf-name (cond ((numberp arg)
			 (format "*msys<%d>*" arg))
			(arg
			 (generate-new-buffer-name "*msys*"))
			(t
			 "*msys*")))
	(explicit-shell-file-name "c:/usr/local/mingwDevKit/bin/bash.exe"))
    (shell buf-name)))


(with-package* (async))

;;thisisimpossible;;(defun async-start-process-reuse-buffer (name program finish-func &rest program-args)
;;thisisimpossible;;  "Start the executable PROGRAM asynchronously.  See `async-start'.
;;thisisimpossible;;PROGRAM is passed PROGRAM-ARGS, calling FINISH-FUNC with the
;;thisisimpossible;;process object when done.  If FINISH-FUNC is nil, the future
;;thisisimpossible;;object will return the process object when the program is
;;thisisimpossible;;finished."
;;thisisimpossible;;  (let* ((buf (get-buffer-create (concat "*" name "*")))
;;thisisimpossible;;         (proc (let ((process-connection-type nil))
;;thisisimpossible;;                 (apply #'start-process name buf program program-args))))
;;thisisimpossible;;    (with-current-buffer buf
;;thisisimpossible;;      (set (make-local-variable 'async-callback) finish-func)
;;thisisimpossible;;      (set-process-sentinel proc #'async-when-done)
;;thisisimpossible;;      (unless (string= name "emacs")
;;thisisimpossible;;        (set (make-local-variable 'async-callback-for-process) t))
;;thisisimpossible;;      proc)))
;;thisisimpossible;;
;;thisisimpossible;;)

;;(async-shell-command "net use \\\\10.239.12.87  02902774   /user:김동일")
;;(async-shell-command "net use \\\\10.239.12.103 jangbogo3* /user:kss3")
;;(async-shell-command "net use \\\\10.239.12.180 buildadmin /user:buildadmin")
;;(async-shell-command "net use \\\\10.239.12.181 buildadmin /user:buildadmin")

;;deprecated;;(defun w32-context-menu (filename)
;;deprecated;;  (start-process-shell-command "context" "*context*" "context" filename))
;;deprecated;;
;;deprecated;;(defun w32-context-menu-dired-get-filename (event)
;;deprecated;;  (interactive "e")
;;deprecated;;  ;; moves point to clicked row
;;deprecated;;  (mouse-set-point event)
;;deprecated;;  (w32-context-menu (concat "\"" (dired-get-filename) "\"")))
;;deprecated;;
;;deprecated;;(defun w32-context-menu-current-buffer ()
;;deprecated;;    (interactive)
;;deprecated;;    (w32-context-menu (concat "\"" buffer-file-name "\"")))
;;deprecated;;(defun w32-context-menu (filename)
;;deprecated;;  (async-start-process 
;;deprecated;;   "contextmenu"
;;deprecated;;   "c:/usr/local/editor/emacsW32/cmdutils/Context.exe"   
;;deprecated;;   nil
;;deprecated;;   filename))

;;; XP 에서만 동작한다. 
;; (defvar contextcmdexe (fullpath "../../cmdutils/Context.exe"))


;; (defun w32-context-menu (filename)
;;   (start-process-shell-command "context" "*context*" (format "%s %s" contextcmdexe filename)))

;; (defun w32-context-menu-dired-get-filename ()
;;   (interactive)
;;   (let ((file (dired-get-file-for-visit)))
;;     (if (file-exists-p file)
;;           (w32-context-menu (concat "\"" file "\"") ))))



;; (defun w32-context-menu-current-buffer ()
;;     (interactive)
;;     (w32-context-menu buffer-file-name ))


;;(define-key dired-mode-map ";"  'w32-context-menu-dired-get-filename)


(add-to-list 'load-path (fullpath  "../../wincontextmenu/lisp/"))

(load "wincontextmenu.el")

(setq win-context-menu-program (fullpath  "../../wincontextmenu/bin/wincontextmenu.exe"))

(require 'w32-browser)

;; redefine M-!
;;(require 'execute)
;;(define-key dired-mode-map "\M-;" 'execute-program)

(defun assocemacs ( ext) 
  (interactive "M확장자 :")
  
  ;;(shell-command "ftype EmacsFile=emacsclientw.exe -na runemacs.exe \"\%1\"" )
  (shell-command (format "assoc %s=EmacsFile" ext))

)
