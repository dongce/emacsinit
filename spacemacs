;; -*- mode: emacs-lisp; lexical-binding: t; encoding:utf-8-*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(windows-scripts
     vimscript
     ;;php
     graphviz
     sql
     html
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;; auto-completion
     better-defaults
     emacs-lisp
     (gtags :variables gtags-enable-by-default nil)
     ;; git
     ;; lsp
     ;; markdown
     (auto-completion :variables
                      auto-completion-return-key-behavior 'complete
                      auto-completion-tab-key-behavior    'complete
                      auto-completion-complete-with-key-sequence nil
                      ;;auto-completion-private-snippets-directory nil
                      )
     ibuffer
     emacs-lisp
     git

     ;; multiple-cursors
     ivy
     org
     csv
     dap
     (python :variables python-backend 'lsp )
     ;; org
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     (syntax-checking :variables syntax-checking-enable-tooltips nil)
     treemacs
     version-control
     ;;lsp
     ;; version-control
     (shell :variables shell-default-shell 'vterm)
     (mu4e :variables
           mu4e-installation-path "/opt/local/share/emacs/site-lisp/mu4e/"))

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '()

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(ido undo-tree flycheck-package flycheck-elsa savehist helm)

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-but-keep-unused))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=~/.emacs.d/.cache/dumps/spacemacs.pdmp
   ;; (default spacemacs.pdmp)
   dotspacemacs-emacs-dumper-dump-file "spacemacs.pdmp"

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'random

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(nord
                         gruvbox
                         spacemacs-dark
                         modus-vivend
                         spacemacs-light
                         )

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts.
   dotspacemacs-default-font '("Cascadia Mono PL"
                               :size 10.0
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 3

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."


  ;;(add-to-list 'custom-theme-load-path "/opt/site-lisp/elpa/modus-vivendi-theme-20201030.631")
  ;;(add-to-list 'custom-theme-load-path "/opt/site-lisp/elpa/gruvbox-theme-20200807.855")
  ;;(add-to-list 'load-path "/opt/site-lisp/elpa/gruvbox-theme-20200807.855")
  ;;(require  'gruvbox-theme)
  ;;(load "/opt/site-lisp/elpa/gruvbox-theme-20200807.855/gruvbox.el")
  ;;(load "/opt/site-lisp/elpa/gruvbox-theme-20200807.855/gruvbox-dark-sort-theme.el")
  ;;uselink;;(setq  package-user-dir "/opt/site-lisp/elpa") 

  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."


  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."

  
;;  (setq configuration-layer-elpa-archives
;;        '(("MELPAmirror" . "/opt/elpa-mirror/melpa")
;;          ("ORGmirror" . "/opt/elpa-mirror/org/")
;;          ("GNUmirror" . "/opt/elpa-mirror/gnu")
;;          ))

  (defvar emacsw32-home "/opt/")
  (let (( default-directory  (file-truename (concat emacsw32-home "/site-lisp/thirdparty"))))
    (normal-top-level-add-subdirs-to-load-path)
    (add-to-list 'package-directory-list default-directory ))

  (add-to-list 'load-path (file-truename (concat emacsw32-home "/site-lisp/misc")))

  (defun evil-paste-after-from-0 ()
    (interactive)
    (let ((evil-this-register ?0))
      (call-interactively 'evil-paste-after)))
  
  ;; (define-key evil-visual-state-map "p" 'evil-paste-after-from-0)
  ;; (define-key evil-normal-state-map "p" 'evil-paste-after-from-0)
  
  (remove-hook 'find-file-hook #'vc-refresh-state)
  (remove-hook 'find-file-hook #'git-gutter+-turn-on)
  (remove-hook 'find-file-hook #'git-commit-setup-check-buffer)

  ;; (setq comp-bootstrap-deny-list
  ;;       '("\\.*powerline\\.*" ))
  ;; (setq comp-deferred-compilation-deny-list comp-bootstrap-deny-list ) 
  
 
  (require 'cl-lib)
  (require 'package)
  (package-initialize)
  (require 's)
  (require 'init-loader)
  ;;(require 'init-loader-org)
  (require 'ob-tangle)

  (defun init-loader-tangle-files (dir )
    (cl-loop for ofile in (directory-files dir t)
             if (string-match "org\\'" ofile)
             do (let*  ((lfile (concat (file-name-sans-extension ofile) ".el") ))
               (if (or  (not  lfile) (and ofile  (file-newer-than-file-p ofile lfile)))
                   (org-babel-tangle-file ofile lfile "emacs-lisp")))))

  (init-loader-tangle-files (concat emacsw32-home "/site-lisp/init/dumpinit"))
  (init-loader-tangle-files (concat emacsw32-home "/site-lisp/init/userinit"))

  (let ((load-suffixes '(".el" ".elc"))
        ;;(file-name-handler-alist nil)
        (load-file-rep-suffixes '("")))
    (init-loader-load (concat emacsw32-home "/site-lisp/init/dumpinit"))
    (init-loader-load (concat emacsw32-home "/site-lisp/init/userinit")))

  ;; spacemacs patch
  (define-key ivy-minibuffer-map (kbd "S-SPC") 'toggle-korean-input-method)
  (define-key ivy-minibuffer-map (kbd "C-\\") 'ivy-restrict-to-matches)

  (spacemacs/set-leader-keys "hh"   'helm-mini))

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-fit-frame-flag nil)
 '(ac-auto-start nil t)
 '(ac-trigger-key "C-o")
 '(ack-arguments nil)
 '(ack-executable (executable-find "ack.bat"))
 '(ada-process-parse-exec
   "/opt/site-lisp/elpa/ada-mode-7.1.4/ada_mode_wisi_lr1_parse")
 '(ag-executable "/opt/local/bin/ag")
 '(ansi-color-names-vector
   ["#3c3836" "#fb4934" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c" "#ebdbb2"])
 '(async-shell-command-buffer 'new-buffer)
 '(autofit-frames-flag nil)
 '(better-registers-use-C-r nil)
 '(bmkp-last-as-first-bookmark-file "c:/usr/local/editor/emacsW32/spacemacs/.cache/bookmarks")
 '(bookmark-version-control t)
 '(browse-url-firefox-program "t:/usr/local/firefox/firefox.exe")
 '(c-default-style "gnu")
 '(calendar-month-name-array
   ["1월 January" "2월 February" "3월 March" "4월 April" "5월 May" "6월 June" "7월 July" "8월 August" "9월 September" "10월 October" "11월 November" "12월 December"])
 '(case-fold-search t)
 '(column-number-mode t)
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-ignore-case nil)
 '(company-global-modes '(not gdb-mode))
 '(company-math-allow-latex-symbols-in-faces t)
 '(compilation-message-face 'default)
 '(completion-styles '(basic partial-completion substring initials))
 '(consult-preview-key [end])
 '(csv-separators '("," "	"))
 '(custom-safe-themes
   '("e38279929e9ff949b572b4f9c45d4e6e4a22a4db120b1d4425e843b6b47a8272" "37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" "a06658a45f043cd95549d6845454ad1c1d6e24a99271676ae56157619952394a" "4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb" "f2c35f8562f6a1e5b3f4c543d5ff8f24100fae1da29aeb1864bbc17758f52b70" "8efeb311fa1da9808bba1cc5b55b5c4cb6f162d9fa1e3768ff2759424cb8d9ca" "aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default))
 '(cycbuf-dont-show-regexp '("^ " "^\\*"))
 '(default-input-method "korean-hangul3f")
 '(delete-by-moving-to-trash t)
 '(describe-char-unidata-list
   '(name old-name general-category decomposition decimal-digit-value))
 '(desktop-load-locked-desktop t)
 '(diary-file "/mnt/develop/orgdir/diary")
 '(dired-omit-files
   "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^.~$\\|^.projectile$\\|^.~$\\|^.projectile$\\|^~")
 '(dired-sort-menu-saved-config
   '((dired-actual-switches . "-alt")
     (ls-lisp-ignore-case)
     (ls-lisp-dirs-first)))
 '(dired-use-ls-dired t)
 '(diredp-hide-details-initially-flag t)
 '(diredp-w32-local-drives
   '(("C:" "Local disk")
     ("D:" "사외비")
     ("E:" "일반-개발환경")
     ("F:" "개인")
     ("G:" "사내한")
     ("H:" "일반-매뉴얼")
     ("T:" "사내한-소스코드")))
 '(display-buffer-alist
   '(("^\\*Ilist\\*$" imenu-list-display-buffer)
     ("^ \\*alarm notify.*" display-buffer-no-window
      (nil))))
 '(dumb-jump-max-find-time 5)
 '(dvc-read-project-tree-mode 'always)
 '(dynamic-fonts-preferred-monospace-fonts
   '("DejaVu Sans Mono" "Consolas" "Menlo" "Monaco" "Droid Sans Mono Pro" "Droid Sans Mono" "Inconsolata" "Source Code Pro" "Lucida Console" "Envy Code R" "Andale Mono" "Lucida Sans Typewriter" "Lucida Typewriter" "Panic Sans" "Bitstream Vera Sans Mono" "Excalibur Monospace" "Courier New" "Courier" "Cousine" "Lekton" "Ubuntu Mono" "Liberation Mono" "BPmono" "Anonymous Pro" "ProFontWindows"))
 '(dynamic-fonts-preferred-monospace-point-size 9)
 '(dynamic-fonts-preferred-proportional-fonts
   '("Tahoma" "Segoe UI" "DejaVu Sans" "Bitstream Vera" "Lucida Grande" "Verdana" "Helvetica" "Arial Unicode MS" "Arial"))
 '(ecb-auto-update-methods-after-save nil)
 '(ecb-compilation-buffer-names
   '(("*Calculator*")
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
     ("*cycbuf*")))
 '(ecb-compile-window-height 20)
 '(ecb-compile-window-temporally-enlarge 'both)
 '(ecb-enlarged-compilation-window-max-height 'half)
 '(ecb-layout-name "left14")
 '(ecb-layout-window-sizes nil)
 '(ecb-major-modes-show-or-hide '(nil *))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons 'mouse-1--mouse-2)
 '(ecb-show-sources-in-directories-buffer '("left7" "left13" "left14" "left15" "right2"))
 '(ecb-source-path
   '(("g:/svndir/emacs-home" "HOME")
     ("c:/FFX" "FFX")
     ("g:/svndir/IIDS/src" "IIDS")
     ("g:/svndir/유용한스크립트" "유용한스크립트")
     ("g:/svndir/테마과제" "테마과제")
     ("g:/svndir/형상관리" "형상관리")
     ("g:/svndir/서버관리" "서버관리")
     ("g:/svndir/실적관리" "실적관리")
     ("C:/Documents and Settings/dongil.SAMSUNG-BC5B83A/바탕 화면" "바탕화면")
     ("c:" "c:")))
 '(ecb-tip-of-the-day nil)
 '(ecb-tree-buffer-style 'ascii-guides)
 '(ecb-windows-hidden t t)
 '(elfeed-use-curl t)
 '(elpy-default-minor-modes '(flycheck-mode yas-minor-mode auto-complete-mode) t)
 '(elpy-modules
   '(elpy-module-eldoc elpy-module-pyvenv elpy-module-yasnippet elpy-module-sane-defaults))
 '(elpy-rpc-backend nil)
 '(elpy-rpc-ignored-buffer-size 10240)
 '(elpy-rpc-python-command "python3")
 '(epg-gpg-program "gpg")
 '(evil-collection-setup-minibuffer t)
 '(evil-cross-lines t)
 '(evil-emacs-state-msg "이멕스")
 '(evil-extra-operator-eval-modes-alist nil)
 '(evil-extra-operator-fold-key "gz")
 '(evil-insert-state-msg "입력")
 '(evil-leader/leader "SPC")
 '(evil-lion-left-align-key [103 92])
 '(evil-lion-right-align-key [103 124])
 '(evil-lisp-state-global t)
 '(evil-lisp-state-leader-prefix "q")
 '(evil-mode-line-color
   '((normal . "green4")
     (insert . "#575735")
     (replace . "#575735")
     (operator . "DarkSeaGreen4")
     (visual . "SteelBlue4")
     (emacs . "#8c5353")))
 '(evil-move-cursor-back nil)
 '(evil-mu4e-state 'normal)
 '(evil-normal-state-msg "명령")
 '(evil-replace-state-msg "교체")
 '(evil-search-highlight-persist t t)
 '(evil-surround-pairs-alist
   '((40 "(" . ")")
     (91 "[" . "]")
     (123 "{" . "}")
     (41 "(" . ")")
     (93 "[" . "]")
     (125 "{" . "}")
     (35 "#{" . "}")
     (98 "(" . ")")
     (66 "{" . "}")
     (62 "<" . ">")
     (116 . evil-surround-read-tag)
     (60 . evil-surround-read-tag)
     (102 . evil-surround-function)))
 '(evil-undo-system 'undo-fu)
 '(evil-want-C-u-scroll t)
 '(evil-want-Y-yank-to-eol nil)
 '(evil-want-fine-undo t)
 '(evil-want-visual-char-semi-exclusive t)
 '(excorporate-configuration
   '("di7979.kim@hanwhasystems.com" . "https://autodiscover.hanwhasystems.com/autodiscover/Services.wsdl"))
 '(expand-region-preferred-python-mode 'fgallina-python)
 '(fci-rule-color "#383838" t)
 '(ff-always-try-to-create nil)
 '(fic-highlighted-words '("FIXME" "TODO" "BUG" "KLUDGE" "ticket"))
 '(gc-cons-percentage 0.9)
 '(gc-cons-threshold 800000000000)
 '(geiser-active-implementations '(guile racket winprojcd))
 '(geiser-default-implementation 'guile)
 '(global-evil-search-highlight-persist t)
 '(global-font-lock-mode t nil (font-lock))
 '(global-hl-line-sticky-flag t)
 '(global-page-break-lines-mode t nil (page-break-lines))
 '(gnutls-min-prime-bits 512)
 '(google-translate-default-target-language "ko")
 '(grep-command "grep --null -arni ")
 '(grep-use-null-device nil)
 '(guide-key-mode t)
 '(guide-key/guide-key-sequence
   '("C-x r" "C-x p" "C-c p" "<SPC> p" "C-c C-o" "<SPC> h" "C-x <RET>" "C-x v" "<SPC> s" "<SPC> y" "<SPC> r" "<SPC> o"))
 '(helm-case-fold-search 'smart)
 '(helm-completing-read-handlers-alist
   '((describe-function . helm-completing-read-symbols)
     (describe-variable . helm-completing-read-symbols)
     (describe-symbol . helm-completing-read-symbols)
     (debug-on-entry . helm-completing-read-symbols)
     (find-function . helm-completing-read-symbols)
     (disassemble . helm-completing-read-symbols)
     (trace-function . helm-completing-read-symbols)
     (trace-function-foreground . helm-completing-read-symbols)
     (trace-function-background . helm-completing-read-symbols)
     (find-tag . helm-completing-read-with-cands-in-buffer)
     (org-capture . helm-org-completing-read-tags)
     (org-set-tags . helm-org-completing-read-tags)
     (ffap-alternate-file)
     (tmm-menubar)
     (find-file)
     (execute-extended-command)
     (dired)
     (dired-do-copy)))
 '(helm-completion-style 'emacs)
 '(helm-dash-docsets-path "c:/usr/local/editor/emacsw32/dashdocset")
 '(helm-dictionary-online-dicts
   '(("translate.reference.com de->eng" . "http://translate.reference.com/translate?query=%s&src=de&dst=en")
     ("translate.reference.com eng->de" . "http://translate.reference.com/translate?query=%s&src=en&dst=de")
     ("Leo eng<->de" . "http://dict.leo.org/ende?lp=ende&lang=de&search=%s")
     ("en.wiktionary.org" . "http://en.wiktionary.org/wiki/%s")
     ("de.wiktionary.org" . "http://de.wiktionary.org/wiki/%s")
     ("Linguee eng<->de" . "http://www.linguee.de/deutsch-englisch/search?sourceoverride=none&source=auto&query=%s")
     ("ko.wiktionary.org" . "http://ko.wiktionary.org/wiki/%s")))
 '(helm-echo-input-in-header-line t)
 '(helm-github-stars-username "dongce@gmail.com")
 '(helm-grep-default-command "grep -a -d skip %e -rn%cH -e %p %f")
 '(helm-minibuffer-history-key "M-p")
 '(helm-mu-default-search-string "date:1d..now")
 '(helm-org-headings-max-depth 5 t)
 '(helm-posframe-poshandler 'posframe-poshandler-window-top-center)
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-tail-colors
   '(("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100)))
 '(hl-bg-colors
   '("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00"))
 '(hl-fg-colors
   '("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36"))
 '(hl-sexp-background-color "blue4")
 '(ido-enable-flex-matching t)
 '(ido-mode 'buffer nil (ido))
 '(iflipb-ignore-buffers "^[*][^m]")
 '(iflipb-wrap-around t)
 '(indicate-buffer-boundaries 'left)
 '(indicate-empty-lines t)
 '(inferior-js-program-command "t:/usr/local/nodejs/node.exe --interactive")
 '(initial-frame-alist '((tool-bar-lines . 0) (fullscreen . maxmized)))
 '(irfc-assoc-mode t)
 '(ivy-mode nil)
 '(ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
 '(js-indent-level 2)
 '(large-file-warning-threshold 50000000)
 '(load-home-init-file t t)
 '(ls-lisp-dirs-first t)
 '(ls-lisp-use-insert-directory-program t)
 '(lsp-enable-links nil)
 '(lsp-pyls-server-command '("/opt/anaconda3/bin/pyls"))
 '(magit-auto-revert-mode nil)
 '(magit-diff-arguments '("--stat" "--no-ext-diff" "--ignore-all-space"))
 '(magit-diff-options '("--ignore-space-at-eol"))
 '(magit-diff-refine-hunk 'all)
 '(magit-diff-use-overlays nil)
 '(magit-git-global-arguments nil)
 '(magit-git-standard-options nil)
 '(magit-process-connection-type t)
 '(magit-use-overlays nil)
 '(mail-personal-alias-file "/mnt/develop/orgdir/mail-aliases")
 '(max-specpdl-size 134000)
 '(message-send-mail-function 'smtpmail-send-it)
 '(message-sendmail-extra-arguments '("--read-envelope-from" "-a" "dongil"))
 '(message-sendmail-f-is-evil t)
 '(mini-frame-ignore-commands
   '(eval-expression "edebug-eval-expression" debugger-eval-expression org-schedule org-deadline))
 '(mini-frame-internal-border-color "yellow")
 '(mini-frame-resize 'grow-only)
 '(mini-frame-resize-max-height 15)
 '(mini-frame-resize-min-height 15)
 '(mm-body-charset-encoding-alist
   '((iso-2022-jp . 7bit)
     (iso-2022-jp-2 . 7bit)
     (utf-16 . base64)
     (utf-16be . base64)
     (utf-16le . base64)
     (utf-8 . base64)))
 '(mm-content-transfer-encoding-defaults
   '(("text/x-patch" 8bit)
     ("text/.*" base64)
     ("message/rfc822" 8bit)
     ("application/emacs-lisp" qp-or-base64)
     ("application/x-emacs-lisp" qp-or-base64)
     ("application/x-patch" qp-or-base64)
     (".*" base64)))
 '(mmm-global-mode 'maybe)
 '(modelinepos-column-limit 100)
 '(mouse-drag-copy-region t)
 '(mu4e-bookmarks
   '(("flag:unread AND NOT flag:trashed" "Unread messages" 117)
     ("date:1d..now" "오늘의 메일" 116)
     ("flag:attach" "첨부파일있음" 97)
     ("date:8d..now" "Last 7 days" 119)
     ("mime:image/*" "Messages with images" 112)))
 '(mu4e-contact-process-function 'decode-contacts)
 '(mu4e-debug nil t)
 '(mu4e-field-list
   '(:path :docid :from :to :cc :subject :date :size :message-id :maildir :priority :flags :attachments :references) t)
 '(mu4e-headers-date-format "%Y-%m-%d %H:%M(%a)")
 '(mu4e-headers-fields
   '((:empty . 2)
     (:human-date . 20)
     (:flags . 6)
     (:subject . 70)
     (:from . 22)))
 '(mu4e-headers-results-limit -1)
 '(mu4e-headers-time-format "%R")
 '(mu4e-headers-visible-lines 30)
 '(mu4e-hide-index-messages t)
 '(mu4e-index-cleanup nil)
 '(mu4e-index-lazy-check t)
 '(mu4e-maildir "f:/PERSONAL/" t)
 '(mu4e-mu-binary "/opt/local/bin/mu")
 '(mu4e-my-email-addresses '("di7979.kim@hanwhasystems.com" "dongce@gmail.com"))
 '(mu4e-org-link-desc-func
   (lambda
     (msg)
     (let
         ((subject
           (or
            (plist-get msg :subject)
            "No subject"))
          (date
           (or
            (format-time-string mu4e-headers-date-format
                                (mu4e-msg-field msg :date))
            "No date")))
       (concat subject "-" date "-"
               (format " %s 📨 %s"
                       (mu4e-msg-field msg :from)
                       (mu4e-msg-field msg :flags))))))
 '(mu4e-org-link-query-in-headers-mode nil t)
 '(mu4e-query-fragments-list
   '(("%pkx" . "subject:*PKX* or *PKG")
     ("%ffx" . "subject:*ffx*")))
 '(mu4e-save-multiple-attachments-without-asking t)
 '(mu4e-use-fancy-chars t)
 '(mu4e-view-auto-mark-as-read nil)
 '(mu4e-view-show-images t)
 '(nodejs-repl-command "t:/usr/local/nodejs/node.exe")
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(nxml-heading-element-name-regexp "title\\|head\\|글")
 '(nxml-section-element-name-regexp
   "article\\|\\(sub\\)*section\\|chapter\\|div\\|appendix\\|part\\|preface\\|reference\\|simplesect\\|bibliography\\|bibliodiv\\|glossary\\|glossdiv\\|제목[0-9]+")
 '(nxml-slash-auto-complete-flag t)
 '(on-screen-global-mode t)
 '(openwith-associations
   '(("\\.pdf\\'" "acroread"
      (file))
     ("\\.mp3\\'" "xmms"
      (file))
     ("\\.\\(?:mpe?g\\|avi\\|wmv\\)\\'" "mplayer"
      ("-idx" file))
     ("\\.\\(?:jp?g\\|png\\)\\'" "mspaint"
      (file))))
 '(org-M-RET-may-split-line '((default)))
 '(org-agenda-files "/mnt/develop/orgdir/agenda.txt")
 '(org-agenda-include-diary t)
 '(org-agenda-start-with-follow-mode t)
 '(org-attach-screenshot-command-line "d:/usr/local/iview/i_view64.exe /capture=4 /convert=%f")
 '(org-attach-screenshot-relative-links nil)
 '(org-babel-load-languages
   '((dot . t)
     (python . t)
     (scheme . t)
     (emacs-lisp . t)
     (C . t)
     (calc . t)
     (shell . t)
     (js . t)
     (plantuml . t)
     (calc . t)
     (ditaa . t)))
 '(org-babel-python-command "/opt/anaconda3/bin/python")
 '(org-babel-scheme-cmd "winprojcd")
 '(org-babel-shell-names
   '("sh" "bash" "csh" "ash" "dash" "ksh" "mksh" "posh" "bc" "cmdproxy"))
 '(org-capture-templates
   '(("t" "할 일" entry
      (file+headline "" "할 일")
      "* TODO %a %? 
TIMESTAMP: %T ")
     ("u" "긴 급" entry
      (file+headline "" "할 일")
      "* TODO %a %?
DEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))")
     ("i" "정 보" entry
      (file+headline "/mnt/develop/orgdir/info.org" "정보")
      "* %?
  TIMESTAMP: %T 
%a
")
     ("x" "org-protocol" entry
      (file "/mnt/develop/orgdir/web.org")
      "* TODO Review %c
%U
%i
" :immediate-finish)
     ("w" "사 업" entry
      (file+headline "/mnt/develop/orgdir/info.org" "사업")
      "* %a %? ")
     ("s" "일 정" entry
      (file+headline "/mnt/develop/orgdir/info.org" "일정")
      "* %a %? ")))
 '(org-confirm-babel-evaluate nil)
 '(org-default-notes-file "/mnt/develop/orgdir/notes.org")
 '(org-directory "/mnt/develop/orgdir/")
 '(org-ellipsis " »")
 '(org-export-with-section-numbers nil)
 '(org-export-with-smart-quotes t)
 '(org-export-with-toc nil)
 '(org-file-apps
   '((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . default)
     ("\\.xls[x]\\'" . system)
     ("\\.doc[x]\\'" . system)
     ("\\.ppt[x]\\'" . system)
     (t . emacs)
     ("\\.png" . system)))
 '(org-global-properties nil)
 '(org-hide-leading-stars t)
 '(org-html-head-include-default-style nil)
 '(org-html-infojs-options
   '((path . "http://orgmode.org/org-info.js")
     (view . "content")
     (toc . :with-toc)
     (ftoc . "0")
     (tdepth . "max")
     (sdepth . "max")
     (mouse . "underline")
     (buttons . "0")
     (ltoc . "1")
     (up . :html-link-up)
     (home . :html-link-home)))
 '(org-html-mathjax-options
   '((path "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML")
     (scale "100")
     (align "left")
     (font "Neo-Euler")
     (linebreaks "false")
     (autonumber "AMS")
     (indent "0em")
     (multlinewidth "85%")
     (tagindent ".8em")
     (tagside "right")))
 '(org-html-postamble nil)
 '(org-html-toplevel-hlevel 2)
 '(org-latex-default-packages-alist
   '(("AUTO" "inputenc" t
      ("pdflatex"))
     ("T1" "fontenc" t
      ("pdflatex"))
     ("" "graphicx" t nil)
     ("" "grffile" t nil)
     ("" "longtable" nil nil)
     ("" "wrapfig" nil nil)
     ("" "rotating" nil nil)
     ("normalem" "ulem" t nil)
     ("" "amsmath" t nil)
     ("" "textcomp" t nil)
     ("" "amssymb" t nil)
     ("" "capt-of" nil nil)
     ("" "hyperref" nil nil)
     ("" "listings" t nil)))
 '(org-latex-pdf-process
   '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f" "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
 '(org-link-use-indirect-buffer-for-internals t)
 '(org-log-done nil)
 '(org-mu4e-convert-to-html t t)
 '(org-refile-targets '((nil :maxlevel . 4) (org-agenda-files :maxlevel . 4)))
 '(org-refile-use-outline-path 'file)
 '(org-return-follows-link t)
 '(org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
 '(org-reverse-note-order t)
 '(org-startup-indented nil)
 '(org-superstar-headline-bullets-list '("✳" "⭐ " "🔎" "🌀" "🔥" "📡" "💡" "📌" "🏷" "👉" "📢" "🌼" "🌸"))
 '(org-superstar-prettify-item-bullets nil)
 '(org-todo-keyword-faces
   '(("TODO" :foreground "DarkGoldenRod3" :weight bold)
     ("WAITING" :foreground "chocolate" :weight bold)
     ("STARTED" :foreground "olive drab" :weight bold)
     ("DELEGATED" :foreground "PaleVioletRed3" :weight bold)
     ("DONE" :foreground "gray" :weight bold)
     ("RESOLVED" :foreground "sea green" :weight bold)))
 '(org-todo-keywords
   '((sequence "TODO(t)" "REVIEW(v)" "STARTED(s)" "RESOLVED(r)" "|" "DONE(d@)" "DELEGATED(l@)" "CANCELED(c@)" "PENDING(p@)")))
 '(outline-cycle-emulate-tab t)
 '(outlook\.exe
   "C:\\Program Files\\Microsoft Office\\Office16\\OUTLOOK.EXE" t)
 '(package-check-signature nil)
 '(package-hidden-regexps '("paradox-list-packages"))
 '(package-selected-packages
   '(org-special-block-extras string-edit drag-stuff marginalia company-prescient ivy-prescient embark embark-consult transient-posframe consult-selectrum counsel-descbinds selectrum-persient selectrum-prescient selectrum consult swiper-helm mu4e-views org-ref lsp-origami dired-posframe which-key-posframe maple-minibuffer lsp-pyright mini-frame helm-bufler forge ivy-avy sphinx-doc valign evil-easymotion helm-posframe ivy-posframe rng-loc xah-replace-pairs evil-vimish-fold xah-math-input-mode org-mu4e org-protocol ox-html5presentation general htmlr project-buffer-mode recentf-ext simple-secrets mark-more-like-this "\\|^.~$\\|^.projectile$" concat dired-omit-files add-hook nil dired-omit-verbose setq dired-filter dired-hacks dired+ dired-x mmm-auto libgit magit-libgit leaf leaf-convert leaf-keywords nord-theme block-nav counsel-fd doct evil-tex shfmt fd-dired nov shrface baff company-math math-symbols auctex cdlatex srfi ob-latex-as-png company-manually ascii-table rainbow-mode zenburn-theme modus-vivendi-theme gruvbox-theme org-noter-pdftools org-pdftools ereader tracwiki-mode dir-treeview init-loader yankpad dap-mode pydoc annalist org-superstar dired-narrow evil-collection treemacs-icons-dired evil-textobj-column evil-text-object-python graphviz-dot-mode dot-mode pt cal-korea-x names xah-get-thing transpar nxml-mode package-helper origami mu4e-query-fragments project-explorer eshell-z httprepl xah-math-input ox-reveal ccls helm-mu helm-gitignore helm-git-grep indent-info shell-pop ob-http rtags edit-server plantuml-mode xah-find org-attach-screenshot ada-ref-man org-bullets ada-mode fast-scroll pcre2el evil-surround balanced-windows org-msg helm-org sdcv hl-block-mode ewal ewal-evil-cursors ewal-spacemacs-theme mu4e-overview s alarm-clock yaml-imenu espy picpocket org-category-capture amx ahk-mode helm-lib-babel org-chef bmx-mode orgit mu4e el-get org-pdfview ipython-shell-send dired tramp-archive ox-trac ob-async counsel-bbdb counsel-dash counsel-gtags counsel-pydoc a org-plus-contrib pdf-tools org-capture-pop-frame excorporate org-caldav svg-clock facemenu+ browse-kill-ring+ crosshairs col-highlight ag 0xc column-enforce-mode clean-aindent-mode bracketed-paste auto-highlight-symbol adaptive-wrap ace-jump-helm-line ac-math jade epresent hyperbole org-present help-fns+ datetime 0blayout org-fstree bog spinner helm-grepint ox-html5slide hl-line+ second-sel highline browse-kill-ring dom better-defaults better-registers git commander winpoint wikidoc wiki w3 uuid swbuff slime-js redo+ quack pyvirtualenv python-pylint python-pep8 pymacs pycomplete parenface-reversion outlined-elisp-mode oauth2 nzenburn-theme nrepl-tracing mwe-log-commands mode-compile mark-multiple magit-push-remote magit-commit-training-wheels macro-utils list-processes+ jsshell-bundle irfc ipython impatient-mode hjkl-mode hideshowvis helm-helm-commands flymake fastnav evil-args eldoc-extension eimp dpaste_de dired-sort-menu+ dired-details+ cycbuf csv-mode css-mode colorsarenice-theme color-theme-sanityinc-solarized color-theme-heroku color-theme clippy chess cedit cdnjs bufshow buffer-utils buffer-move bs-ext browse-url-dwim bpe bison-mode bbdb-vcard bbdb-ext back-button awk-it auctex-latexmk ascope asciidoc ascii annotate ack ace-jump-mode ac-helm abl-mode))
 '(page-break-lines-char 8250)
 '(paradox-github-token t)
 '(paredit-commands
   '("Basic Insertion Commands" "Movement & Navigation"
     (("M-S-<up>" "ESC <up>")
      paredit-splice-sexp-killing-backward
      ("(foo (let ((x 5)) |(sqrt n)) bar)" "(foo (sqrt n) bar)"))
     (("M-S-<down>" "ESC <down>")
      paredit-splice-sexp-killing-forward
      ("(a (b c| d e) f)" "(a b c f)"))
     "Barfage & Slurpage"
     (("M-S-<right>")
      paredit-forward-slurp-sexp
      ("(foo (bar |baz) quux zot)" "(foo (bar |baz quux) zot)")
      ("(a b ((c| d)) e f)" "(a b ((c| d) e) f)"))
     (("M-S-<left>")
      paredit-forward-barf-sexp
      ("(foo (bar |baz quux) zot)" "(foo (bar |baz) quux zot)"))) t)
 '(password-cache-expiry nil)
 '(paste-host "10.239.12.181:8000/dpaste" t)
 '(plantuml-jar-path "/opt/site-lisp/thirdpath/plantuml.jar")
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(posframe-arghandler 'my-posframe-arghandler)
 '(posframe-mouse-banish nil)
 '(powerline-default-separator 'utf-8)
 '(prettify-symbols-unprettify-at-point 'right-edge)
 '(preview-image-type 'dvipng)
 '(printer-name "IP_10.239.12.81")
 '(proced-filter-alist
   '((user)
     (user-running
      (state . "\\`[Rr]\\'"))
     (all)
     (all-running
      (state . "\\`[Rr]\\'"))
     (emacs
      (fun-all lambda
               (list)
               (proced-filter-children list 1632)))))
 '(projectile-buffers-filter-function 'projectile-buffers-with-file)
 '(projectile-completion-system 'helm)
 '(projectile-enable-caching t)
 '(projectile-indexing-method 'native)
 '(ps-lpr-switches '("-query"))
 '(ps-multibyte-buffer 'non-latin-printer)
 '(ps2pdf-gs-program
   "t:\\usr\\local\\postscript\\ghostscript\\bin\\gswin32c.exe")
 '(pt-executable "/opt/local/bin/pt")
 '(puml-plantuml-jar-path
   "c:\\usr\\local\\editor\\emacsW32\\site-lisp\\thirdparty\\plantuml\\plantuml.jar")
 '(purpose-use-default-configuration nil)
 '(python-check-command "pyflakes")
 '(quack-programs
   '("t:/usr/local/guile/bin/winprojcd.exe" "c:/usr" "c:\\icms\\CFCS\\DLPLINK11\\DLPLINK11\\proj\\winproj2005\\Debug\\winproj.exe" ".\\winproj.exe" "MFC_TDL_ISDL_GEN_CTRL" "bigloo" "c:/icms/CFCS/DLPLINK11/DLPLINK11/proj/winproj2005/Debug/winproj.exe" "c:/usr/local/guile/bin/winprojcd.exe" "c:\\ffx\\CFCS\\ICU_KNCCS\\ProjWin\\Debug\\icuknccs_win.exe" "codes" "csi" "csi -hygienic" "gosh" "gsi" "gsi ~~/syntax-case.scm -" "guile" "icuknccs_win.exe" "isdlcd" "isdlcde" "kawa" "mit-scheme" "mred -z" "mzscheme" "mzscheme -M errortrace" "rs" "rs232" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi" "tinyscheme" "win" "winprocd" "winproj.exe" "winprojcd" "winprojcdc" "winrpojcd" "winsigconv" "winsigconv.exe"))
 '(recentf-max-saved-items 1000)
 '(recentf-mode t)
 '(request-log-level 'debug)
 '(rmh-elfeed-org-files '("/mnt/develop/orgdir/feed.org"))
 '(rtog/mode-repl-alist
   '((emacs-lisp-mode . ielm)
     (python-mode . python-shell-switch-to-shell)
     (dos-mode . shell)
     (sql-mode . sql-mysql)
     (js2-mode lambda nil
               (run-js inferior-js-program-command))
     (js2-mode . slime-connect)
     (js2-mode . jsshell)
     (scheme-mode lambda nil
                  (run-scheme scheme-program-name))))
 '(safe-local-variable-values
   '((org-latex-listings . minted)
     (eval my/execute-startup-blocks)
     (org-image-actual-width quote
                             (700))
     (org-image-actual-width . 700)
     (helm-org-headings-max-depth . 4)
     (python-backend . anaconda)
     (eval set-variable 'geiser-guile-binary "/ICMS/CFCS/DLPLINK11/IP_L11/IP_L11/proj/testgen/testgen.out")
     (eval when
           (locate-library "rainbow-mode")
           (require 'rainbow-mode)
           (rainbow-mode))
     (helm-org-headings-max-depth . 2)
     (modc . emacs-lisp)
     (modc . org)
     (page-break-lines-mode . t)
     (eval set-variable 'geiser-guile-binary "/home/buildadmin/gitdir/dlpisdl/proj/testgen/testgen.out")
     (read-only-mode . 0)
     (read-only-mode)
     (encoding . utf-8)
     (helm-org-headings-max-depth . 1)
     (dongil/copy-line-at-bol . t)
     (dongil/copy-line-at-bol)
     (eval org-display-inline-images nil t)
     (eval when
           (require 'rainbow-mode nil t)
           (rainbow-mode 1))
     (eval set-variable 'geiser-guile-binary "t:/gitdir/dlp_link11/proj/testgen/testgen.out")
     (eval set-variable 'geiser-guile-binary "/gitdir/dlplink11/proj/testgen/testgen.out")
     (auto-fill-monde)
     (eval font-lock-add-keywords nil
           `((,(concat "("
                       (regexp-opt
                        '("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl")
                        t)
                       "\\_>")
              1 'font-lock-variable-name-face)))
     (mangle-whitespace . t)
     (eval when
           (fboundp 'rainbow-mode)
           (rainbow-mode 1))
     (eval setq orgstruct-heading-prefix-regexp ";;;;")
     (eval orgstruct-mode t)
     (eval if
           (fboundp 'pretty-symbols-mode)
           (pretty-symbols-mode -1))
     (major-mode . org-mode)
     (eval allout-hide-bodies)
     (eval progn
           (allout-minor-mode)
           (allout-hide-bodies))
     (Eval allout-hide-bodies)
     (buffer-file-coding-system . utf-8)))
 '(save-abbrevs 'silently)
 '(savehist-autosave-interval nil)
 '(scheme-compile-exp-command "%s")
 '(scheme-program-name "winprojcd")
 '(sdcv-dictionary-complete-list
   '("Concise Oxford English Dictionary (En-En)" "Concise Oxford Thesaurus 2nd Ed. (Eng-Eng)" "Korean Medical Dic" "quick_english-korean" "Hanja(Korean Hanzi) Dic" "Korean Animal Medical Dic" "Korean Dic" "Korean-English Dic" "Korean Law Dic" "Kor-Eng Dictionary") t)
 '(sdcv-dictionary-simple-list '("quick_english-korean") t)
 '(sdcv-word-pronounce-command
   "c:/usr/local/editor/emacsW32/espeak/command_line/espeak.exe")
 '(server-name "server")
 '(server-use-tcp t)
 '(setq ecb-tip-of-the-day)
 '(show-paren-mode nil nil (paren))
 '(shr-width nil)
 '(simpleclip-mode t)
 '(smartparens-global-mode nil)
 '(smex-auto-update t)
 '(smtpmail-smtp-server "10.239.23.115")
 '(smtpmail-smtp-service 589)
 '(sort-fold-case t)
 '(sp-base-key-bindings 'paredit)
 '(speedbar-use-images nil)
 '(sql-mysql-options '("-C" "-t" "-f" "-n" "-P 3307"))
 '(sql-mysql-program "/usr/bin/mysql")
 '(sql-sqlite-program "sqlite3")
 '(sqlite-program "sqlite3" t)
 '(sublimity-global-mode t)
 '(switch-window-querty-shortcuts '("a" "s" "d" "f" "j" "k" "l" ";" "w" "e" "i" "o") t)
 '(switch-window-shortcut-style 'qwerty t)
 '(syslog-debug-face
   '((t :background unspecified :foreground "#2aa198" :weight bold)))
 '(syslog-error-face
   '((t :background unspecified :foreground "#dc322f" :weight bold)))
 '(syslog-hour-face '((t :background unspecified :foreground "#859900")))
 '(syslog-info-face
   '((t :background unspecified :foreground "#268bd2" :weight bold)))
 '(syslog-ip-face '((t :background unspecified :foreground "#b58900")))
 '(syslog-su-face '((t :background unspecified :foreground "#d33682")))
 '(syslog-warn-face
   '((t :background unspecified :foreground "#cb4b16" :weight bold)))
 '(tab-width 2)
 '(tabkey2-alternate-key [pause])
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(text-mode-hook '(turn-on-auto-fill text-mode-hook-identify))
 '(tramp-adb-sdk-dir "c:/usr/local/androidsdk/")
 '(tramp-default-host "k3client")
 '(tramp-default-method "rsh")
 '(tramp-default-user-alist
   '(("\\`smb\\'" nil nil)
     ("\\`\\(?:fcp\\|krlogin\\|nc\\|r\\(?:cp\\|emcp\\|sh\\)\\|telnet\\)\\'" nil "dongil")
     ("\\`\\(?:ksu\\|su\\(?:do\\)?\\)\\'" nil "root")
     ("\\`\\(?:socks\\|tunnel\\)\\'" nil "dongil")
     ("\\`synce\\'" nil nil)
     ("plink" "nil" "buildadmin")))
 '(tramp-histfile-override nil)
 '(tramp-syntax 'default nil (tramp))
 '(transient-mark-mode t)
 '(undo-fu-allow-undo-in-region t)
 '(undo-tree-auto-save-history nil)
 '(undo-tree-mode-lighter " UN")
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(url-queue-timeout 30)
 '(user-full-name "김동일")
 '(user-mail-address "di7979.kim@hanwha-rd.com")
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(vc-handled-backends '(RCS CVS SVN SCCS SRC Bzr Hg))
 '(warning-minimum-log-level :error)
 '(warning-suppress-log-types
   '(((defvaralias losing-value diredp-menu-bar-encryption-menu))))
 '(warning-suppress-types
   '(((defvaralias losing-value diredp-menu-bar-regexp-recursive-menu))
     ((defvaralias losing-value diredp-menu-bar-images-recursive-menu))
     ((defvaralias losing-value diredp-menu-bar-encryption-menu))))
 '(web-mode-css-offset 2 t)
 '(web-mode-html-offset 2 t)
 '(web-mode-java-offset 2 t)
 '(web-mode-javascript-offset 2 t)
 '(webpaste-providers-alist
   '(("modernpaste" :uri "http://10.239.12.200:8090/api/paste/submit" :post-data
      (("title" . "")
       ("poster" . "")
       ("expiry_days" . 1))
      :post-field "contents" :post-lang-field-name "language" :lang-overrides
      ((emacs-lisp-mode . "clojure"))
      :success-lambda webpaste--providers-success-location-header)))
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))
 '(which-func-maxout 1000)
 '(which-func-modes t)
 '(which-func-non-auto-modes '(python-mode))
 '(which-function-mode nil)
 '(which-key-posframe-poshandler 'posframe-poshandler-frame-top-right-corner)
 '(which-key-side-window-max-width 0.5)
 '(wisi-disable-face t)
 '(xah-find-file-background-color "tomato")
 '(xah-find-file-separator
   "══════════════════════════════════════════════════════════════════════
")
 '(xah-find-match-background-color "blue1")
 '(xah-find-occur-postfix "》")
 '(xah-find-occur-prefix "《")
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(completions-first-difference ((t (:foreground "IndianRed1"))))
 '(consult-line-number-prefix ((t (:foreground "white smoke"))))
 '(diff-refine-added ((t (:background "PaleGreen4" :foreground "#A3BE8C"))))
 '(diff-refine-changed ((t (:background "dark goldenrod" :foreground "#EBCB8B"))))
 '(diff-refine-removed ((t (:background "light salmon" :foreground "#BF616A"))))
 '(evil-search-highlight-persist-highlight-face ((t (:background "dark slate gray"))))
 '(highlight ((t (:background "IndianRed3" :foreground "#88C0D0"))))
 '(ivy-current-match ((t (:inherit region :underline (:color "yellow" :style wave)))))
 '(lazy-highlight ((t (:background "dark slate blue"))))
 '(mu4e-thread-folding-child-face ((t (:extend t :underline (:color foreground-color :style wave)))))
 '(mu4e-thread-folding-root-folded-face ((t (:inherit nil :box (:line-width (2 . 2) :color "grey75" :style released-button) :overline nil :underline nil))))
 '(mu4e-thread-folding-root-unfolded-face ((t (:extend t :box (:line-width (2 . 2) :color "DodgerBlue3" :style pressed-button) :overline nil))))
 '(org-level-1 ((t (:extend nil :foreground "#8FBCBB" :weight extra-bold :height 1.3))))
 '(org-level-2 ((t (:extend nil :foreground "#88C0D0" :weight bold :height 1.2))))
 '(org-level-3 ((t (:extend nil :foreground "#81A1C1" :weight semi-bold :height 1.1))))
 '(region ((t (:extend t :background "DodgerBlue3"))))
 '(selectrum-current-candidate ((t (:box (:line-width (2 . 2) :color "grey75" :style released-button)))))
 '(shadow ((t (:foreground "SteelBlue3")))))
)
