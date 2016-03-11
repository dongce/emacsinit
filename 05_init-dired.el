;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

(w32-unix-eval
 ;; 윈도우 시스템의 경우
 ;; emacs 에서 FIND 가능
 (;;(color-theme-parus)
  ;;  (color-theme-vim-colors)
  ;;  (color-theme-blue2)
  ;;  (color-theme-emacs-21)
  (require 'find-dired )
  (require 'w32-find-dired )
  (require 'w32-winprint )
  (let ((lisp-dir (expand-file-name (concat emacsw32-home "/EmacsW32/lisp/"))))
    (unless (file-accessible-directory-p lisp-dir)
      (lwarn "Can't find %s" lisp-dir)
      (sit-for 10))
    (when (file-accessible-directory-p lisp-dir)
      (message "Adding %s to load-path" lisp-dir)
      (add-to-list 'load-path lisp-dir))
    (require 'emacsw32 nil t)
    (unless (featurep 'emacsw32)
      (lwarn '(emacsw32) :error "Could not find emacsw32.el")))


  ;; 프린팅 관련 변수
  (define-key dired-mode-map "o" 'w32-dired-open-explorer)
  (define-key dired-mode-map "," 'w32-dired-open-explorer-marked)
  (define-key dired-mode-map "\\" 'w32-dired-copy-file-name)
  (define-key dired-mode-map "["  'w32shell-cmd-here)
  ;; 윈도우에서 유용하게 사용할 수 있는 방법
  (defun w32open (fname)
    (let ((file-name (replace-regexp-in-string "/" "\\"  fname nil t)))
      ;;(message (replace-regexp-in-string "/" "\\" file-name nil t) )
      (if (file-exists-p file-name)
          (w32-shell-execute nil  file-name nil 1))))
  (defun w32-dired-open-explorer ()
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive)
    (w32open (dired-get-file-for-visit) )
    )

  (defun w32-dired-print ()
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive)
    (let ((file-name (replace-regexp-in-string "/" "\\" (dired-get-file-for-visit) nil t)))
      ;;(message (replace-regexp-in-string "/" "\\" file-name nil t) )
      (if (file-exists-p file-name)
          (w32-shell-execute "print"  file-name nil 1))))

  (defun w32-dired-open-explorer-marked()
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive)
    (let ((file-names (dired-get-marked-files)))
      (mapcar
       (lambda ( x )
         (if (file-exists-p x )
             (w32-shell-execute nil x nil 1)))
       file-names )))

  (defun w32-execute-line ()
    (interactive)
    (w32-shell-execute nil (buffer-substring (point) (point-at-eol)) nil 1))

  (defun w32-dired-copy-file-name(&optional arg)
    "Open a file in dired mode by explorer.exe as you double click it."
    (interactive "P")
    ;;emacs와 상관없이 동작 ;;(w32-set-clipboard-data (replace-regexp-in-string "/" "\\" (file-truename (dired-get-filename nil t))nil t)))
    (let ((pathname (file-truename (dired-get-filename nil t))))
      (if arg
          (kill-new pathname)
        (kill-new (replace-regexp-in-string "/" "\\" pathname nil t))
        )))

  (require 'sml-modeline)
  (sml-modeline-mode)

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
                        "-reuse -dir \"%home%\" -cmd set MSYSTEM=MINGW64&&e:\\msys264\\usr\\bin\\sh --login -i")
          (conemul ,(fullpath  "../../conemul/conemu64.exe") "-reuse")
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
    (shell-command (format "assoc %s=EmacsFile" ext)))

  
  )
 ()
 )


;; 23 버젼 관련 설정입니다.

(setq ls-lisp-verbosity '(uid))


(defun mrc-dired-do-command (command)
  "Run COMMAND on marked files. Any files not already open will be opened.
After this command has been run, any buffers it's modified will remain
open and unsaved."
  (interactive "CRun on marked files M-x ")
  (save-window-excursion
    (mapc (lambda (filename)
            (find-file filename)
            (call-interactively command))
          (dired-get-marked-files))))

(toggle-diredp-find-file-reuse-dir 1)
;; writable-dired
;;【Ctrl+x Ctrl+q】 (emacs 23.1)	wdired-change-to-wdired-mode	Start rename by editing
;;【Ctrl+c Ctrl+c】	wdired-finish-edit	Commit changes
;;【Ctrl+c Esc】	wdired-abort-changes	Abort changes

;;(with-package* (tramp)
;;  (setq tramp-default-method "ftp")
;;  (setq ange-ftp-default-user "user1")
;;  ;; (setq ange-ftp-ftp-program-name "ftp.exe")
;;  (setq ange-ftp-ftp-program-name (fullpath "../../EmacsW32/gnuwin32/bin/ftp.exe")) ;ftp passive mode 
;;  )

(use-package hl-line+
  :config
  (add-hook 'dired-mode-hook (lambda () (interactive) (hl-line-mode t))))
