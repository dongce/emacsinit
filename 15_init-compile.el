;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

;; compile 확장 버젼
(use-package compile-
  :commands (compile))
(use-package compile)
;;(require 'compile+)

;; 특정파일만 컴파일 할 수 있습니다. 
(defun compile-file (option-file)
  (interactive)
  (compile 
   (format "cl %s %s" (with-temp-buffer (insert-file-contents option-file) (replace-string "\n" " " ) (buffer-substring (point-min) (point-max))) 
           (replace-regexp-in-string "\\.h" ".cpp" (buffer-file-name) ))))





(defun build-link11 (&optional vxworks) 
  (interactive
   (list current-prefix-arg))
  (if vxworks
      (progn
        (dired "c:/FFX/CFCS/DLP_LINK11/proj/makeproj")
        (compile "c:/vxworks/tornado/host/x86-win32/bin/torVars.bat & make -f makefile.vxworks all "))
      (compile "vcbuild C:\\FFX\\CFCS\\DLP_LINK11\\proj\\winproj\\winproj.vcproj  Debug")))


(defun build-isdl (&optional vxworks) 
  (interactive
   (list current-prefix-arg))
  (if vxworks
      (progn
        (dired "c:/FFX/CFCS/DLP_ISDL/proj/makeproj")
        (compile "c:/vxworks/tornado/host/x86-win32/bin/torVars.bat & make -f makefile.vxworks all "))
      (compile "vcbuild  C:\\FFX\\CFCS\\DLP_ISDL\\proj\\winproj\\winproj.vcproj  Debug")))


(defun build-dlp (&optional vxworks)
  (interactive
   (list current-prefix-arg))

  (if (not (null (scheme-get-process)))
      (comint-send-string (scheme-proc) "(quit)\n"))
  (if (eq nil (buffer-file-name)) (build-isdl vxworks)
    (if (eq nil (string-match "isdl" (buffer-file-name)))
        (build-link11 vxworks)
      (build-isdl vxworks))))


;;(global-set-key (kbd "C-,") 'build-dlp)

(global-set-key [(f2)] 'project-compile-file )


(define-key global-map [(f4)] 'next-error)
(define-key global-map [(shift f4)] 'previous-error)

;; 특정 변수를 버퍼에게 종속적으로 만드는 함수
;;(make-variable-buffer-local 'next-error-function)


;; Command to point VS.NET at our current file & line
(defun my-current-line ()
  "Return the current buffer line at point.  The first line is 0."
  (save-excursion
    (beginning-of-line)
    (count-lines (point-min) (point))))
(defun devenv-cmd (&rest args)
  "Send a command-line to a running VS.NET process.  'devenv' comes from devenv.exe"
  (call-process "DevEnvCommand" nil nil nil (apply 'concat args)))
(defun switch-to-devenv ()
  "Jump to VS.NET, at the same file & line as in emacs"
  (interactive)
  (save-some-buffers)
  (let ((val1
	   (devenv-cmd "File.OpenFile \"" (buffer-file-name (current-buffer)) "\""))
	(val2
	   (devenv-cmd "Edit.GoTo " (int-to-string (+ (my-current-line) 1)))))
    (cond ((zerop (+ val1 val2))
	      ;(iconify-frame)  ;; what I really want here is to raise the VS.NET window
	         t)
	    ((or (= val1 1) (= val2 1))
	        (error "command failed"))  ;; hm, how do I get the output of the command?
	      (t
	          (error "couldn't run DevEnvCommand")))))

;; Command to toggle a VS.NET breakpoint at the current line.
(defun devenv-toggle-breakpoint ()
  "Toggle a breakpoint at the current line"
  (interactive)
  (switch-to-devenv)
  (devenv-cmd "Debug.ToggleBreakpoint"))
(global-set-key [f9] 'devenv-toggle-breakpoint)

;; Run the debugger.
(defun devenv-debug ()
  "Run the debugger in VS.NET"
  (interactive)
  (devenv-cmd "Debug.Start"))

;;(global-set-key [(f2)] (lambda () (interactive) (switch-to-devenv) (devenv-cmd "Edit.GoToDefinition")))

(global-set-key [(f3)] 'switch-to-devenv)
(global-set-key [(shift f3)] (lambda () (interactive) (switch-to-devenv) (devenv-cmd "Build.Compile")))
(global-set-key [(shift f5)] (lambda () (interactive) (devenv-cmd "Debug.AttachtoProcess")))
(global-set-key [(M f4)] (lambda () (interactive) (devenv-cmd "Window.CloseAllDocuments")))


;;(global-set-key [shift f3] (lambda () (interactive) (switch-to-dev) (devenv-cmd "Build.Compile")))
;;(global-set-key [shift f5] (lambda () (interactive) (devenv-cmd "Debug.AttachtoProcess")))


(defun recompile-quietly ()
  "Re-compile without changing the window configuration."
  (interactive)
  (save-window-excursion
    (recompile)))

(defun eval-env (x) 
  (let ((result x))
    (setf result  (s-replace "$(GUILE_HOME)" "t:\\\\usr\\\\local\\\\guile\\\\" result  ))
    (setf result  (s-replace "$(NDDS_HOME)"  "t:\\\\rti\\\\waveworks\\\\ndds.4.5c\\\\" result ))
    (setf result  (s-replace "$(DSFHOME)"  "t:\\\\kss\\\\devenv\\\\util\\\\dsf\\\\" result ))
    (if (not result) x result )))

(defun project-compile-file ()
  (interactive)
  (let ((file (buffer-file-name)))
    (with-current-buffer (project-buffer-mode-p-get-attached-project-buffer)  
      (let ((coption 
             (cadr (find-if                   ;첫번째 ELEMENT 만 리턴합니다. 
                    (lambda (x) 
                      (string-equal "VCCLCompilerTool" (cdr (assoc 'Name (cadr x ))))) 
                    (edom-by-tag-name (car (xml-parse-file (project-buffer-get-project-path (car project-buffer-master-project)))) 'Tool )))))
        (compile 
         (eval-env (format 
                    "cl /c %s %s %s"
                    (concat "-I" (string-replace-match ";" (cdr (assoc 'AdditionalIncludeDirectories coption)) " -I" nil t ))
                    (concat "-D" (string-replace-match ";" (cdr (assoc 'PreprocessorDefinitions coption)) " -D" nil t ))
                    file)))))))

;; F6 에 의해서 파일을 찾을 때 디렉토리를 찾습니다. 
(setq 
 cc-search-directories 
      '(
        "." 
"c:/FFX/CFCS/DLP_LINK11/src/bridge"  
"c:/FFX/CFCS/DLP_LINK11/src/common"  
"c:/FFX/CFCS/DLP_LINK11/src/include"  
"c:/FFX/CFCS/DLP_LINK11/src/track_input"  
"c:/FFX/CFCS/DLP_LINK11/src/dts_controller"  
"c:/FFX/CFCS/DLP_LINK11/src/db_access_main"  
"c:/FFX/CFCS/DLP_LINK11/src/db_access_main/cache"  
"c:/FFX/CFCS/DLP_LINK11/src/remote_control"  
"c:/FFX/CFCS/DLP_LINK11/src/db_access_main/DLRL"  
"c:/FFX/CFCS/DLP_LINK11/src/general_in_out"  
"c:/FFX/CFCS/DLP_LINK11/src/network_tx"  
"c:/FFX/CFCS/DLP_LINK11/src/track_output"  
"c:/FFX/CFCS/DLP_LINK11/src/parameter_adapt"  
"c:/FFX/CFCS/DLP_LINK11/src/status_checker"
"c:/FFX/CFCS/DLP_LINK11/src/network_rx"  
"c:/FFX/CFCS/DLP_LINK11/DLP_L11_L11IP_COMMON"  
"c:/FFX/CFCS/DLP_ISDL/common" 
"c:/FFX/CFCS/DLP_ISDL/src" 
"c:/FFX/CFCS/DLP_ISDL/common/cache" 
"c:/usr/local/guile/include" 
"c:/usr/local/guile/include/vxwrap"  
"c:/FFX/devenv/ndds/csds/include"  
"c:/FFX/devenv/ndds/include" 
"c:/FFX/devenv/ndds/include/ndds" 
"c:/FFX/devenv/ffxlib/include" 

))


;; QAC 
(add-to-list 
 'compilation-error-regexp-alist
 '("^\\([^,\n\t]+\\),\\([0-9]+\\),\\([0-9]+\\)," 1 2 3))

;; tcf 와 CPP 파일을 연결합니다. 
(setf cc-other-file-alist (cons '("\\.tcf\\'" (".cpp" )) cc-other-file-alist))


(defun release ()
  (interactive)
  (switch-to-buffer "*compilation*")
  (compile "release.cmd"))


(defun next-error-buffer-hl-line ()
  "Turn on `hl-line-mode' in buffer `next-error-last-buffer'.
To turn it off: `M-x hl-line-mode' in the compilation/grep buffer."
  (when (and next-error-last-buffer  (buffer-live-p next-error-last-buffer))
    (with-current-buffer next-error-last-buffer
      (hl-line-mode 1)
      (recenter-top-bottom)
      )))

(add-hook 'next-error-hook 'next-error-buffer-hl-line)

;;; * compile environment 
(defun vs2005env ()
  (interactive)
  (setenv "VSINSTALLDIR"     "c:\\usr\\microsoft\\vs2005\\IDE" t )
  (setenv "VCINSTALLDIR"     "c:\\usr\\microsoft\\vs2005\\IDE\\VC" t )
  (setenv "FrameworkDir"     "C:\\Windows\\Microsoft.NET\\Framework" t )
  (setenv "FrameworkVersion" "v2.0.50727" t )
  (setenv "FrameworkSDKDir"  "c:\\usr\\microsoft\\vs2005\\IDE\\SDK\\v2.0" t )
  (setenv "DevEnvDir" "c:\\usr\\microsoft\\vs2005\\IDE\\Common7\\IDE" t )
  (setenv  "PATH" "c:\\usr\\microsoft\\vs2005\\IDE\\Common7\\IDE;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\BIN;c:\\usr\\microsoft\\vs2005\\IDE\\Common7\\Tools;c:\\usr\\microsoft\\vs2005\\IDE\\Common7\\Tools\\bin;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\PlatformSDK\\bin;c:\\usr\\microsoft\\vs2005\\IDE\\SDK\\v2.0\\bin;C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\VCPackages;$PATH" t )
  (setenv "INCLUDE" "c:\\usr\\microsoft\\vs2005\\IDE\\VC\\ATLMFC\\INCLUDE;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\INCLUDE;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\PlatformSDK\\include;c:\\usr\\microsoft\\vs2005\\IDE\\SDK\\v2.0\\include;$INCLUDE" t )
  (setenv "LIB" "c:\\usr\\microsoft\\vs2005\\IDE\\VC\\ATLMFC\\LIB;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\LIB;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\PlatformSDK\\lib;c:\\usr\\microsoft\\vs2005\\IDE\\SDK\\v2.0\\lib;$LIB" t )
  (setenv "LIBPATH" "C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727;c:\\usr\\microsoft\\vs2005\\IDE\\VC\\ATLMFC\\LIB" t ))


(defun vs2008env ()
  (interactive)
  (setenv "VSINSTALLDIR"     "c:\\usr\\microsoft\\vs2008\\IDE" t )
  (setenv "VCINSTALLDIR"     "c:\\usr\\microsoft\\vs2008\\IDE\\VC" t )
  (setenv "FrameworkDir"     "C:\\Windows\\Microsoft.NET\\Framework" t )
  (setenv "FrameworkVersion" "v2.0.50727" t )
  (setenv "Framework35Version" "v3.5" t )
  (setenv "FrameworkSDKDir"  "c:\\usr\\microsoft\\vs2008\\IDE\\SDK\\v3.5" t )
  (setenv "DevEnvDir" "c:\\usr\\microsoft\\vs2008\\IDE\\Common7\\IDE" t )
  (setenv  "PATH" "c:\\usr\\microsoft\\vs2008\\IDE\\Common7\\IDE;c:\\usr\\microsoft\\vs2008\\IDE\\VC\\BIN;c:\\usr\\microsoft\\vs2008\\IDE\\Common7\\Tools;c:\\usr\\microsoft\\vs2008\\IDE\\Common7\\Tools\\bin;C:\\Program Files\\Microsoft SDKs\\Windows\\v6.0A\\bin;c:\\usr\\microsoft\\vs2008\\IDE\\SDK\\v3.5\\bin;C:\\Windows\\Microsoft.NET\\Framework\\v3.5.50727;c:\\usr\\microsoft\\vs2008\\IDE\\VC\\VCPackages;$PATH" t )
  (setenv "INCLUDE" "c:\\usr\\microsoft\\vs2008\\IDE\\VC\\ATLMFC\\INCLUDE;c:\\usr\\microsoft\\vs2008\\IDE\\VC\\INCLUDE;C:\\Program Files\\Microsoft SDKs\\Windows\\v6.0A\\include;c:\\usr\\microsoft\\vs2008\\IDE\\SDK\\v3.5\\include;$INCLUDE" t )
  (setenv "LIB" "c:\\usr\\microsoft\\vs2008\\IDE\\VC\\ATLMFC\\LIB;c:\\usr\\microsoft\\vs2008\\IDE\\VC\\LIB;C:\\Program Files\\Microsoft SDKs\\Windows\\v6.0A\\lib;c:\\usr\\microsoft\\vs2008\\IDE\\SDK\\v3.5\\lib;$LIB" t )
  (setenv "LIBPATH" "C:\\Windows\\Microsoft.NET\\Framework\\v3.5;c:\\usr\\microsoft\\vs2008\\IDE\\VC\\ATLMFC\\LIB" t ))



(defun torEnv ()
  (interactive)
  (setenv "WIND_HOST_TYPE" "x86-win32"                                    t )
  (setenv "WIND_BASE"      "T:\\T22PPC"                                   t )
  (setenv "PATH"           "$WIND_BASE\\host\\$WIND_HOST_TYPE\\bin;$PATH" t )
  (setenv "DIABLIB"        "$WIND_BASE\\host\\diab"                       t )
  (setenv "PATH"           "$DIABLIB\\WIN32\\bin;$PATH"                   t ))
