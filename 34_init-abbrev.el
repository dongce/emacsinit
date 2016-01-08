;; -*- coding: utf-8; -*-
(define-abbrev-table 'global-abbrev-table '(

    ;; math/unicode symbols
    ("8in" "∈")
    ("8nin" "∉")
    ("8inf" "∞")
    ("8luv" "♥")
    ("8smly" "☺")

    ;; email
    ("8wdy" "wordy-english@yahoogroups.com")

    ;; computing tech
    ("8wp" "Wikipedia")
    ("8ms" "Microsoft")
    ("8g" "Google")
    ("8qt" "QuickTime")
    ("8it" "IntelliType")
    ("8msw" "Microsoft Windows")
    ("8win" "Windows")
    ("8ie" "Internet Explorer")
    ("8ahk" "AutoHotkey")
    ("8pr" "POV-Ray")
    ("8ps" "PowerShell")
    ("8mma" "Mathematica")
    ("8js" "javascript")
    ("8vb" "Visual Basic")
    ("8yt" "YouTube")
    ("8ge" "Google Earth")
    ("8ff" "Firefox")
    ("8sl" "Second Life")
    ("8ll" "Linden Labs")
    ("8ee" "ErgoEmacs")

    ;; normal english words
    ("8alt" "alternative")
    ("8char" "character")
    ("8def" "definition")
    ("8bg" "background")
    ("8kb" "keyboard")
    ("8ex" "example")
    ("8kbd" "keybinding")
    ("8env" "environment")
    ("8var" "variable")
    ("8ev" "environment variable")
    ("8cp" "computer")

    ;; sig
    ("8xl" "Xah Lee")
    ("8xs" " Xah ∑ xahlee.org ☄")

    ;; url
    ("8uxl" "http://xahlee.org/")
    ("8uxp" "http://xahporn.org/")
    ("8uee" "http://ergoemacs.org/")
    ("8uvmm" "http://VirtualMathMuseum.org/")
    ("8u3dxm" "http://3D-XplorMath.org/")

    ;; emacs regex
    ("8num" "\\([0-9]+?\\)")
    ("8str" "\\([^\"]+?\\)\"")
    ("8curly" "“\\([^”]+?\\)”")

    ;; shell commands
    ("8ditto" "ditto -ck --sequesterRsrc --keepParent src dest")
    ("8im" "convert -quality 85% ")
    ("8ims" "convert -size  -quality 85% ")
    ("8im256" "convert +dither -colors 256 ")
    ("8imf" "find . -name \"*png\" | xargs -l -i basename \"{}\" \".png\" | xargs -l -i  convert -quality 85% \"{}.png\" \"{}.jpg\"")

    ("8f0" "find . -type f -empty")
    ("8f00" "find . -type f -size 0 -exec rm {} ';'")
    ("8chmod" "find . -type f -exec chmod 644 {} ';'")
    ("8chmod2" "find . -type d -exec chmod 755 {} ';'")

    ("8unison" "unison -servercmd /usr/bin/unison c:/Users/xah/web ssh://xah@example.com//Users/xah/web")
    ("8sftp" "sftp xah@xahlee.org")
    ("8ssh" "ssh xah@xahlee.org")
    ("8rsync" "rsync -z -r -v -t --exclude=\"*~\" --exclude=\".DS_Store\" --exclude=\".bash_history\" --exclude=\"**/xx_xahlee_info/*\"  --exclude=\"*/_curves_robert_yates/*.png\" --exclude=\"logs/*\"  --exclude=\"xlogs/*\" --delete --rsh=\"ssh -l xah\" ~/web/ xah@example.com:~/")

    ("8rsync2" "rsync -r -v -t --delete --rsh=\"ssh -l xah\" ~/web/ xah@example.com:~/web/")
    ("8rsync3" "rsync -r -v -t --delete --exclude=\"**/My *\" --rsh=\"ssh -l xah\" ~/Documents/ xah@example.com:~/Documents/")
    ))

;; stop asking whether to save newly added abbrev when quitting emacs
;;(setq save-abbrevs nil)

;; turn on abbrev mode globally
;;(setq-default abbrev-mode t)

