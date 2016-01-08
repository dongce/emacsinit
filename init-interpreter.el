;; http://www.masteringemacs.org/articles/2013/07/31/comint-writing-command-interpreter/
;; 
;; 
;; 
;; 
;; Follow:
;;     RSS
;;     Email
;;     Twitter
;; 
;; Emacs 22 LogoMastering Emacs
;; a blog about mastering the world's best text editor
;; 
;;     Home
;;     About
;;     Effective Editing
;;     Reading Guide
;;     All Articles
;;     For Beginners
;;     Quick Tips
;;     Tutorials
;; 
;; Tags
;; 
;; buffer, comint, customization, elisp, productivity, workflow
;; Comint: Writing your own Command Interpreter
;; by mickey on July 31st, 2013
;; Mastering Emacs > All Articles > Comint: Writing your own Command Interpreter
;; 
;; One of the hallmarks of Emacs is its ability to interface with external processes and add to the user experience with the full coterie of Emacs functionality like syntax highlighting, macros, command history, and so on. This functionality has been in Emacs since time immemorial, yet few people make their own command interpreters — also known as comint — in Emacs, fearing that it is either really difficult or not possible.
;; 
;; It’s not surprising people feel this way when you consider how woefully underdocumented this functionality is; the few, scattered references to comint “mode” reveal little, and as a hacker you are forced to use the source, Luke.
;; The Theory
;; 
;; Before I demonstrate how you use comint, a quick briefing — but rough, as I’m leaving out a few boring steps — on how it works.
;; 
;; At its core, you are spawning a process and either redirecting the stdin, stdout and stderr pipes to Emacs; or you use a pseudo-terminal. The choice between the two is governed by process-connection-type, but it’s unlikely that you would ever want to change that manually.
;; 
;; The fundamental building blocks for interacting with processes are start-process, for kinda-sorta-asynchronous process calls; andcall-process, for synchronous process calls.
;; 
;; One layer above that and we get to comint with its very pared-down, basic interpreter framework. This is what things like M-x shell and the various REPL modes like Python build on. comint has handles all the nitty-gritty stuff like handling input/output; a command history; basic input/output filter hooks; and so on. In other words, it’s the perfect thing to build on if you want something interactive but want more than just what comint has to offer. To use comint is very simple: run-comint takes one argument, PROGRAM, and nothing else; run it with a filepath to your favourite program and watch it fly. For greater configurability, you can use make-comint-in-buffer.
;; 
;; Important caveat about pipe redirection: Oftentimes programs will detect that you are redirecting its pipes to a dumb terminal or file and it disables its shell prompt; this is extremely frustrating as not all programs detect that it is running inside Emacs by looking for the signature environment variables Emacs will set: EMACS and INSIDE_EMACS. If that happens you may get lucky and find a flag you can set to force it to run in “interactive” mode — for example, in Python it’s -i.
;; 
;; One layer above that and we get to things like M-x shell, which I’ve talked about before in Running Shells in Emacs: An Overview.
;; 
;; And finally, you can list all running/open processes by typing M-x list-processes.
;; Writing a Comint Mode
;; 
;; With that out of the way, let’s write some code. I’ve been playing around with Cassandra, the database, and like all respectable databases it has a fine commandline interface — but no Emacs mode! Oh no!
;; 
;; The most important thing about writing a comint mode is that it’s very easy to get 80% of the way there, but getting those remaining 20 percentage points is the really difficult part! I’m only doing the 80% here!
;; 
;; Let’s write one. To start the Cassandra CLI you run the program cassandra-cli and you’re presented with output similar to this:
;; 
;; $ ./cassandra-cli Connected to: "Test Cluster" on 127.0.0.1/9160 Welcome to Cassandra CLI version 1.2.8 Type 'help;' or '?' for help. Type 'quit;' or 'exit;' to quit. [default@unknown]
;; 1
;; 2
;; 3
;; 4
;; 5
;; 6
;; 7
;; 8
;; 	
;; $ ./cassandra-cli
;; Connected to: "Test Cluster" on 127.0.0.1/9160
;; Welcome to Cassandra CLI version 1.2.8
;;  
;; Type 'help;' or '?' for help.
;; Type 'quit;' or 'exit;' to quit.
;;  
;; [default@unknown]
;; 
;; If you run cassandra-cli with comint-run — you already have a working, interactive process. It’s barebones and simple, but its defaults are reasonable and it will work well enough. If you want to extend it, you have to write your own wrapper function around make-comint-in-buffer and write a major mode also. So let’s do just that.
;; The Comint Template
;; 
;; (defvar cassandra-cli-file-path "/opt/cassandra/bin/cassandra-cli" "Path to the program used by `run-cassandra'") (defvar cassandra-cli-arguments '() "Commandline arguments to pass to `cassandra-cli'") (defvar cassandra-mode-map (let ((map (nconc (make-sparse-keymap) comint-mode-map))) ;; example definition (define-key map "\t" 'completion-at-point) map) "Basic mode map for `run-cassandra'") (defvar cassandra-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)" "Prompt for `run-cassandra'.")
;; 1
;; 2
;; 3
;; 4
;; 5
;; 6
;; 7
;; 8
;; 9
;; 10
;; 11
;; 12
;; 13
;; 14
;; 15
;; 	
;; (defvar cassandra-cli-file-path "/opt/cassandra/bin/cassandra-cli"
;;   "Path to the program used by `run-cassandra'")
;;  
;; (defvar cassandra-cli-arguments '()
;;   "Commandline arguments to pass to `cassandra-cli'")
;;  
;; (defvar cassandra-mode-map
;;   (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
;;     ;; example definition
;;     (define-key map "\t" 'completion-at-point)
;;     map)
;;   "Basic mode map for `run-cassandra'")
;;  
;; (defvar cassandra-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)"
;;   "Prompt for `run-cassandra'.")
;; 
;; The first thing we need to do is declare some sensible variables so users can change the settings without having to edit the code. The first one is obvious: we need to store a path to cassandra-cli, the program we want to run.
;; 
;; The next variable, cassandra-cli-arguments, holds an (empty) list of commandline arguments.
;; 
;; The third, is an empty and currently disused mode map for storing our custom keybindings. It is inherited from comint-mode-map, so we get the same keys exposed in comint-mode.
;; 
;; Finally, we have cassandra-prompt-regexp, which holds a regular expression that matches the prompt style Cassandra uses. It so happens that by default it sort-of works already, but it pays to be prepared and it’s a good idea to have a regular expression that matches no more than it needs to. Furthermore, as you’re probably going to use this code to make your own comint derivatives, you’ll probably have to change it anyway.
;; 
;; (defun run-cassandra () "Run an inferior instance of `cassandra-cli' inside Emacs." (interactive) (let* ((cassandra-program cassandra-cli-file-path) (buffer (comint-check-proc "Cassandra"))) ;; pop to the "*Cassandra*" buffer if the process is dead, the ;; buffer is missing or it's got the wrong mode. (pop-to-buffer-same-window (if (or buffer (not (derived-mode-p 'cassandra-mode)) (comint-check-proc (current-buffer))) (get-buffer-create (or buffer "*Cassandra*")) (current-buffer))) ;; create the comint process if there is no buffer. (unless buffer (apply 'make-comint-in-buffer "Cassandra" buffer cassandra-program cassandra-cli-arguments) (cassandra-mode))))
;; 1
;; 2
;; 3
;; 4
;; 5
;; 6
;; 7
;; 8
;; 9
;; 10
;; 11
;; 12
;; 13
;; 14
;; 15
;; 16
;; 17
;; 	
;; (defun run-cassandra ()
;;   "Run an inferior instance of `cassandra-cli' inside Emacs."
;;   (interactive)
;;   (let* ((cassandra-program cassandra-cli-file-path)
;;          (buffer (comint-check-proc "Cassandra")))
;;     ;; pop to the "*Cassandra*" buffer if the process is dead, the
;;     ;; buffer is missing or it's got the wrong mode.
;;     (pop-to-buffer-same-window
;;      (if (or buffer (not (derived-mode-p 'cassandra-mode))
;;              (comint-check-proc (current-buffer)))
;;          (get-buffer-create (or buffer "*Cassandra*"))
;;        (current-buffer)))
;;     ;; create the comint process if there is no buffer.
;;     (unless buffer
;;       (apply 'make-comint-in-buffer "Cassandra" buffer
;;              cassandra-program cassandra-cli-arguments)
;;       (cassandra-mode))))
;; 
;; This messy pile of code does some basic housekeeping like re-starting the Cassandra process if you’re already in the buffer, or create the buffer if it does not exist. Annoyingly there is a dearth of macros to do stuff like this in the comint library; a shame, as it would cut down on the boilerplate code you need to write. The main gist of this function is the apply call taking make-comint-in-buffer as the function. Quite honestly, a direct call to make-comint-in-buffer would suffice, but you lose out on niceties like restartable processes and so on; but if you’re writing a comint-derived mode for personal use you may not care about that sort of stuff.
;; 
;; (defun cassandra--initialize () "Helper function to initialize Cassandra" (setq comint-process-echoes t) (setq comint-use-prompt-regexp t)) (define-derived-mode cassandra-mode comint-mode "Cassandra" "Major mode for `run-cassandra'. \\<cassandra-mode-map>" nil "Cassandra" ;; this sets up the prompt so it matches things like: [foo@bar] (setq comint-prompt-regexp cassandra-prompt-regexp) ;; this makes it read only; a contentious subject as some prefer the ;; buffer to be overwritable. (setq comint-prompt-read-only t) ;; this makes it so commands like M-{ and M-} work. (set (make-local-variable 'paragraph-separate) "\\'") (set (make-local-variable 'font-lock-defaults) '(cassandra-font-lock-keywords t)) (set (make-local-variable 'paragraph-start) cassandra-prompt-regexp)) ;; this has to be done in a hook. grumble grumble. (add-hook 'cassandra-mode-hook 'cassandra--initialize)
;; 1
;; 2
;; 3
;; 4
;; 5
;; 6
;; 7
;; 8
;; 9
;; 10
;; 11
;; 12
;; 13
;; 14
;; 15
;; 16
;; 17
;; 18
;; 19
;; 20
;; 21
;; 22
;; 	
;; (defun cassandra--initialize ()
;;   "Helper function to initialize Cassandra"
;;   (setq comint-process-echoes t)
;;   (setq comint-use-prompt-regexp t))
;;  
;; (define-derived-mode cassandra-mode comint-mode "Cassandra"
;;   "Major mode for `run-cassandra'.
;;  
;; \\<cassandra-mode-map>"
;;   nil "Cassandra"
;;   ;; this sets up the prompt so it matches things like: [foo@bar]
;;   (setq comint-prompt-regexp cassandra-prompt-regexp)
;;   ;; this makes it read only; a contentious subject as some prefer the
;;   ;; buffer to be overwritable.
;;   (setq comint-prompt-read-only t)
;;   ;; this makes it so commands like M-{ and M-} work.
;;   (set (make-local-variable 'paragraph-separate) "\\'")
;;   (set (make-local-variable 'font-lock-defaults) '(cassandra-font-lock-keywords t))
;;   (set (make-local-variable 'paragraph-start) cassandra-prompt-regexp))
;;  
;; ;; this has to be done in a hook. grumble grumble.
;; (add-hook 'cassandra-mode-hook 'cassandra--initialize)
;; 
;; And finally, we have our major mode definition. Observe that we derive from comint-mode. I overwrite the default comint-prompt-regexp with our own, and I force the prompt to be read only also. I add a mode hook and set comint-process-echoes to t to avoid duplicating the input we write on the screen. And finally, I tweak the paragraph settings so you can navigate between each prompt with M-{ and M-}.
;; 
;; And.. that’s more or less it for the template. It’s trivial to tweak it to your own needs and it’s a good place to start.
;; 
;; Let’s add some cool functionality to our cassandra-mode: basic syntax highlighting.
;; Extending Cassandra Mode
;; 
;; The first thing I want to do is add simple syntax highlighting for the commands you get when you run help;.
;; 
;; We need to think about some simple rules we can come up with that will highlight stuff. This is the hard bit: coming up with a regular expression for non-regular languages is nigh-on impossible to get right; especially not when you’re doing it for a commandline application that spits out all manner of output.
;; 
;; Before we do that though, let’s augment our major mode to support syntax highlighting (which is actually known as font locking in Emacs parlance.)
;; 
;; (set (make-local-variable 'font-lock-defaults) '(cassandra-font-lock-keywords t))
;; 1
;; 	
;;   (set (make-local-variable 'font-lock-defaults) '(cassandra-font-lock-keywords t))
;; 
;; Add this form to the body of the major mode (next to the existing setq calls) and then add the following form to the top of the file, to hold our font lock rules:
;; 
;; (defconst cassandra-keywords '("assume" "connect" "consistencylevel" "count" "create column family" "create keyspace" "del" "decr" "describe cluster" "describe" "drop column family" "drop keyspace" "drop index" "get" "incr" "list" "set" "show api version" "show cluster name" "show keyspaces" "show schema" "truncate" "update column family" "update keyspace" "use")) (defvar cassandra-font-lock-keywords (list ;; highlight all the reserved commands. `(,(concat "\\_<" (regexp-opt cassandra-keywords) "\\_>") . font-lock-keyword-face)) "Additional expressions to highlight in `cassandra-mode'.")
;; 1
;; 2
;; 3
;; 4
;; 5
;; 6
;; 7
;; 8
;; 9
;; 10
;; 11
;; 12
;; 	
;; (defconst cassandra-keywords
;;   '("assume" "connect" "consistencylevel" "count" "create column family"
;;     "create keyspace" "del" "decr" "describe cluster" "describe"
;;     "drop column family" "drop keyspace" "drop index" "get" "incr" "list"
;;     "set" "show api version" "show cluster name" "show keyspaces"
;;     "show schema" "truncate" "update column family" "update keyspace" "use"))
;;  
;; (defvar cassandra-font-lock-keywords
;;   (list
;;    ;; highlight all the reserved commands.
;;    `(,(concat "\\_<" (regexp-opt cassandra-keywords) "\\_>") . font-lock-keyword-face))
;;   "Additional expressions to highlight in `cassandra-mode'.")
;; 
;; There is one font lock rule: it highlights all matching keywords that I extracted from the help; command.
;; 
;; comint exposes a set of filter function variables that’re triggered and run (in order, it’s a list) when certain conditions are met:
;; Variable Name 	Purpose
;; comint-dynamic-complete-functions 	List of functions called to perform completion.
;; comint-input-filter-functions 	Abnormal hook run before input is sent to the process.
;; comint-output-filter-functions 	Functions to call after output is inserted into the buffer.
;; comint-preoutput-filter-functions 	List of functions to call before inserting Comint output into the buffer.
;; comint-redirect-filter-functions 	List of functions to call before inserting redirected process output.
;; comint-redirect-original-filter-function 	The process filter that was in place when redirection is started
;; 
;; Another useful variable is comint-input-sender, which lets you alter the input string mid-stream. Annoyingly its name is inconsistent with the filter functions above.
;; 
;; You can use them to control how input and output is processed and interpreted mid-stream.
;; 
;; And there you go: a simple, comint-enabled Cassandra CLI in Emacs.
;; Share
;; 
;; From → All Articles, Tutorials
;; 2 Comments →
;; 
;;     skeeto permalink
;; 
;;     As someone who maintains a mode derived from comint-mode I can tell you first-hand that comint-mode is a real mess right now. That last 20% truly is a pain. I used ielm as my implementation guide.
;;     Reply	
;;         mickey permalink
;; 
;;         It certainly is. The inconsistency is probably the worst of it!
;;         Reply	
;; 
;; Leave a Reply
;; Name: (required):
;; Email: (required):
;; Website:
;; Comment:
;; 
;; Note: XHTML is allowed. Your email address will never be published.
;; 
;; Subscribe to this comment feed via RSS
;; 
;;     Tags
;;     ansi-term autocomplete beginner buffer customization cygwin editing elisp eshell eval files guide ido ielm info inspect key bind mark multilingual navigation network news opinion orgmode productivity prompt python readability recentf regexp region repl scratch shell tabs term terminology tips tramp transient trash can twitter vimgolf whitespace workflow
;;     Pages
;;         About
;;         Effective Editing
;;         Reading Guide
;;     Blogroll
;;         Emacs on Reddit
;;         Follow me on Twitter
;;         Irreal's Emacs blog
;;         The Emacs Wiki
;;         WikEmacs
;; 
;; About
;; 
;; Hi, I'm Mickey and this is my blog about mastering Emacs. I've been using Emacs for eight years and I'd like to share with you all the things I've learned over the years.
;; 
;; The blog will cover all facets of Emacs and will be suitable for beginners and -- I hope -- experts alike.
;; 
;;     Categories
;;         All Articles
;;         For Beginners
;;         Quick Tips
;;         Tutorials
;; 
;; Search
;; 
;; Copyright © 2013 Mickey Petersen. Titan Theme by The Theme Foundry.
