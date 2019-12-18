;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     (erc :variables
          erc-server-list
          '(("irc.freenode.net"
             :port "6667"
             :ssl t
             :nick "rayenok")
            ))
     (shell :variables
            shell-default-shell 'multi-term
            shell-default-height 30
            shell-default-position 'bottom
            shell-default-term-shell "/usr/bin/zsh")
     vimscript
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     auto-completion
     docker
     ;; better-defaults
     emacs-lisp
     ;;git
     ;; markdown
     org
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;;spell-checking
     ;; python
     ;; To make lsp python work had to install the following:
     ;; pip install python-language-server pyls-isort pyls-mypy importmagic epc ipython
     ;; sudo apt install python-backports.functools-lru-cache
     (python :variables
             lsp-restart 'ignore
             python-backend 'lsp)
     ;; syntax-checking
     ;; version-control
     git
     dap
     (gtags :variables gtags-enable-by-default t)
     lsp
     ;; twitter
     ;; slack
     ;; c-c++ 
     ;; (c-c++ :variables c-c++-enable-clang-support t)
     (c-c++ :variables
            c-c++-backend 'lsp-ccls
            lsp-ui-doc-enable nil
            ;; c-c++-enable-clang-support t
            )
     ;; nasm-mode
     shell-scripts
     cscope
     ;; vim-powerline
     ;; elfeed
     ;; gtags
     (gtags :variables gtags-enable-by-default t)
     plantuml
     pdf
     pandoc
     (mu4e :variables
           mu4e-maildir "~/.maildir"
           mu4e-use-maildirs-extension t)
     ;;rcirc
     asm
     ;; csv
     html
     javascript
     ;; php
     shell-scripts
     windows-scripts
     ranger
     ;; shell
     spell-checking
     syntax-checking
     (shell :variables shell-default-shell 'ansi-term)
     ;;java
     ;; ietf
     ;; unicode-fonts
     ;; spotify
     emoji
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages '(badwolf-theme
   cyberpunk-theme load-theme-buffer-local eziam-theme
   org-super-agenda yasnippet-snippets yankpad org-noter el-get
   olivetti poet-theme dired-narrow all-the-icons-dired
   all-the-icons ranger ietf-docs unicode-fonts monky realgud
   realgud-pry esup org-babel-eval-in-repl beacon mode-icons
   eterm-256color elpy org-bullets lsp-mode lsp-ui lsp-treemacs
   helm-lsp dap-mode company-lsp ccls docker-tramp)
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
  (setq-default
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   ;; dotspacemacs-editing-style 'hybrid
   dotspacemacs-editing-style '(hybrid :variables
                                       hybrid-mode-enable-evilified-state t
                                       hybrid-mode-enable-hjkl-bindings t
                                       hybrid-mode-default-state 'normal)
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects)
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   ;; disable check for updates
   dotspacemacs-check-for-update nil
   ;;themes
   dotspacemacs-themes '(
                         ;;sanityinc-tomorrow-night
                         ;; badwolf
                         ;; cyberpunk
                         ;; eziam-theme
                         busybee
                         cyberpunk
                         ;;gruber-darker
                         ;;solarized-dark
                         ;;spacemacs-dark
                         ;;spacemacs-light
                         ;;leuven
                         ;;solarized-light
                         ;; monokai
                         ;; badwolf
                         ;;zenburn
			)
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.

   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to miminimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup t
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 95
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'nil
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil

   dotspacemacs-distinguish-gui-tab t
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init'.  You are free to put any
user code."

  ;;font
  ;; (set-frame-font "-outline-Roboto Mono-normal-normal-normal-*-*-*-*-*-p-*-iso8859-7")
  (setq-default dotspacemacs-default-font '("Roboto Mono-11.5"
                                            :size 14
                                            :height: 20
                                            :weight normal
                                            :width normal))

  (setq tramp-default-method "ssh") 

  (defun linux-paths ()
    (defvar system-agenda-path "/mnt/agenda/")
    (defvar system-security-path "/mnt/security/")
    (defvar system-dropbox-path "/mnt/dropbox/")
    (defvar journal-path "/mnt/journal/")
    (defvar path-to-python "/usr/bin/python3")
    (defvar system-home-path "~/")
	(load-file (expand-file-name ".spacemacs.d/custom-config-files/.org-define-paths.el" system-home-path))
    (common-paths)
    (work-paths)
    (security-paths)
    (org-paths)
    (config-paths)
    (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
    ;; (load-file "~/Dropbox/spacemacs/custom-theme/poet-custom.el")
    ;; (load-custom-theme)
    (load-config-files)
    (message "linux-paths initializated")
    )

  (defun windows-paths()
    ;;TODO disable vim-powerline when running windows
    (defvar system-agenda-path "a:/")
    (defvar system-security-path "b:/")
    (defvar system-dropbox-path (getenv "DROPBOX"))
    (defvar system-home-path (getenv "HOME"))
    (defvar path-to-python (expand-file-name "spacemacs/dep/windows-program-files/Python/Python37/Scripts/ipython3.exe" system-dropbox-path))
    (defvar journal-path "g:/")
	(load-file (expand-file-name ".spacemacs.d/custom-config-files/.org-define-paths.el" system-home-path))
    (common-paths)
    (work-paths)
    (security-paths)
    (org-paths)
    (config-paths)
    ;; (exec-dropbox-paths)
    ;;(setq org-agenda-files (list ( to_common )))
    ;; (load-custom-theme)
    (load-config-files)
    (setq find-program (expand-file-name "spacemacs/dep/windows-program-files/msys64/usr/bin/find" system-dropbox-path))
    (message "windows-paths initializated")
    )


  (when (eq system-type 'windows-nt) (windows-paths))
  (when (eq system-type 'gnu/linux) ( linux-paths ))
  (message "System: %s" system-type)

  (defvar exec-from-dropbox (list 
                            (expand-file-name "spacemacs/dep/windows-program-files/global/bin/" system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/cscope/" system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/msys64/usr/bin/." system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/msys64/mingw64/bin/." system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/Python/Python37/" system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/Python/Python37/Scripts/" system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/LLVM/bin/" system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/Java/bin/" system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/qemu/" system-dropbox-path)
                            (expand-file-name "spacemacs/dep/windows-program-files/VeraCrypt/" system-dropbox-path)
                             ))

  (when (string-equal system-type "windows-nt")
    (let (
          (string-paths  
          '(
            "c:/Program Files/emacs-26.2-x86_64/bin/"
            "c:/Program Files/PuTTY/"
            "C:/Windows/system32/"
            "C:/Windows/"
            "C:/Windows/system32/WindowsPowerShell/v1.0/"
            ) )
          )
      (message "Concatenating...")
      (message "string-paths: %s" string-paths)
      (message "exec-from-dropbox: %s" exec-from-dropbox)
      (setq mypaths (append string-paths exec-from-dropbox))
      (message "mypaths: %s" mypaths)
      (setenv "PATH" (mapconcat 'identity mypaths ";") )

      (setq exec-path (append mypaths (list "." exec-directory)) )
      ))


  ;; FIXME not working => https://www.reddit.com/r/emacs/comments/8z4jcs/tip_how_to_integrate_company_as_completion/
  (setq company-backends-org-mode '((company-dabbrev-code
                                                          company-gtags
                                                          company-etags
                                                          company-yankpad
                                                          company-keywords
                                                          company-dabbrev
                                                          company-yasnippet)
                                                          company-files))

  (defun setup-company()
   (setq company-begin-commands '(self-insert-command))
   (setq company-idle-delay .1)
   (setq company-minimum-prefix-length 2)
   (setq company-show-numbers t)
   (setq company-tooltip-align-annotations nil)
   (setq company-dabbrev-downcase nil)
   (setq company-dabbrev-ignore-case nil)
   (setq company-require-match nil)
   (setq company-transformers
     (quote
      (spacemacs//company-transformer-cancel company-sort-by-occurrence)))
   (global-company-mode t))
  (add-hook 'company-mode 'setup-company)

  (defun setup-c-mode()
   (add-to-list 'company-backends 'company-clang)
  )
  (add-hook 'c-mode 'setup-c-mode)


  ;;Auto-fill in order to have an horizontal limit for paragraphs
  ;; (defun set-word-wrapper ()
  ;;   (setq-default auto-fill-function 'do-auto-fill)
  ;;   (setq fill-column 120))

  ;; (add-hook 'org-mode-hook 'set-word-wrapper)
  ;; (add-hook 'org-mode-hook 'do-auto-fill)
  ;; (add-hook 'org-mode-hook (lambda ()(setq fill-column 120)))

  ;;;;Yankpad
  ;;(setq org-directory "A:/agenda/")
  ;;(setq yankpad-descriptive-list-treatment nil)

 )


  (defun dotspacemacs/user-config ()
    "Configuration function for user code.
  This function is called at the very end of Spacemacs initialization after
  layers configuration. You are free to put any user code."
      (message "Starting user-config")
      ;; (auto-completion :variables auto-completion-enable-snippets-in-popup t)
      (setq warning-minimum-level :emergency) ;;Comment this line if you want more warnings/debugging

      (require 'ox-latex)
      (add-to-list 'org-latex-packages-alist '("" "minted"))

      (setq org-latex-listings 'minted) 

      (setq org-latex-pdf-process
            '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
              "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
              "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

      (setq org-src-fontify-natively t)

      (global-auto-revert-mode nil)

      (global-unset-key (kbd "<C-l>" ))
      (global-set-key (kbd "<C-l>") 'hippie-expand)
      
      (setq org-latex-minted-options '(("breaklines" "true")
                                       ("breakanywhere" "true")))

      ;; load narrow indirect
	    ;; (load-file (expand-file-name ".spacemacs.d/additional-package-files/narrow-indirect.el" system-home-path))

      ;;; scroll one line at a time (less "jumpy" than defaults)
      (setq mouse-wheel-scroll-amount '(2 ((shift) . 1))) ;; two lines at a time
      (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
      (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

      ;; paste in multi-term mode
      (eval-after-load "term"
        '(define-key term-raw-map (kbd "C-c C-y") 'term-paste))

      (spacemacs/toggle-mode-line-org-clock-on)
      (smartparens-global-mode)

      (add-hook 'term-mode-hook #'eterm-256color-mode)

      (setq-default ;; alloc.c
       gc-cons-threshold (\* 20 1204 1204)
       gc-cons-percentage 0.5)

      ;;archives
      (setq org-archive-location (concat ".archive/"
                                         (format-time-string "%Y-" (current-time))
                                         "%s_archive::"))

      ;;support for ansi-colors
      (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

      ;;Improve scroll
      (setq redisplay-dont-pause t
            scroll-margin 1
            scroll-step 1
            scroll-conservatively 10000
            scroll-preserve-screen-position 1)

      ;; (add-hook 'dired-mode-hook 'dired-conf)

      ;; removes highlighting of blank lines
      (setq-default spacemacs-show-trailing-whitespace nil)

      (add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

      ;;set time out to make org-capture faster
      (setq x-selection-timeout 10)

      (message "middle user-config ")
      ;;Twitter - put to false to remove the images
      (setq twittering-icon-mode t)

      ;;disable spell checking by default
      (setq-default dotspacemacs-configuration-layers
                    '((spell-checking :variables spell-checking-enable-by-default nil)))

      ;; detect language (for spell checker) automatically
      (setq-default dotspacemacs-configuration-layers
                    '((spell-checking :variables spell-checking-enable-auto-dictionary t)))

      ;; (add-hook 'c-mode-hook (lambda () (load-theme-buffer-local 'badwolf (current-buffer))))
      (add-hook 'eshell-mode-hook (lambda () (
                                              (load-theme 'busybox)
                                              (load-theme-buffer-local 'cyberpunk
                                                                      (current-buffer)
                                                                      ))
                                    ))

      ;; disable backups to remove problems with Windows-docker
      ;;disable backup
      (setq backup-inhibited t)
      ;;disable auto save
      (setq auto-save-default nil)
      ;; disable locking
      (setq create-lockfiles nil)

      ;;ediff ignore whitespaces
      (setq ediff-diff-options "-w")

      ;; load other custom config files
      (message "Starting loading other config files")
	    (load-file (expand-file-name ".spacemacs.d/custom-config-files/org.el" system-home-path))
	    (load-file (expand-file-name ".spacemacs.d/custom-config-files/org-agenda.el" system-home-path))
	    (load-file (expand-file-name ".spacemacs.d/custom-config-files/helm.el" system-home-path))
	    ;; (load-file (expand-file-name ".spacemacs.d/custom-config-files/mu4e.el" system-home-path))
	    (load-file (expand-file-name ".spacemacs.d/custom-config-files/auto-complete.el" system-home-path))
	    (load-file (expand-file-name ".spacemacs.d/custom-config-files/ranger.el" system-home-path))
	    (load-file (expand-file-name ".spacemacs.d/custom-config-files/bookmarks.el" system-home-path))
	    (load-file (expand-file-name ".spacemacs.d/custom-config-files/face.el" system-home-path))
      (message "Finished user configuration")

)



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
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/.cache/bookmarks")
 '(package-selected-packages
   (quote
    (docker-tramp ox-asciidoc yasnippet-snippets yapfify yankpad x86-lookup ws-butler writeroom-mode winum which-key web-mode web-beautify volatile-highlights vimrc-mode vi-tilde-fringe uuidgen use-package unicode-fonts treemacs-projectile treemacs-evil toc-org tagedit symon symbol-overlay string-inflection spaceline-all-the-icons smeargle slim-mode shell-pop scss-mode sass-mode restart-emacs realgud-pry ranger rainbow-delimiters pytest pyenv-mode py-isort pug-mode prettier-js powershell popwin poet-theme plantuml-mode pippel pipenv pip-requirements persp-mode pdf-tools pcre2el password-generator paradox pandoc-mode ox-pandoc overseer orgit org-super-agenda org-projectile org-present org-pomodoro org-noter org-mime org-download org-cliplink org-bullets org-brain org-babel-eval-in-repl open-junk-file olivetti nodejs-repl nasm-mode nameless multi-term mu4e-maildirs-extension mu4e-alert move-text monky mode-icons magit-svn magit-gitflow macrostep lsp-ui lsp-treemacs lsp-python-ms lorem-ipsum load-theme-buffer-local livid-mode live-py-mode link-hint json-navigator json-mode js2-refactor js-doc insert-shebang indent-guide importmagic impatient-mode ietf-docs hybrid-mode hungry-delete hl-todo highlight-parentheses highlight-numbers helm-xref helm-themes helm-swoop helm-rtags helm-pydoc helm-purpose helm-projectile helm-org-rifle helm-org helm-mu helm-mode-manager helm-make helm-lsp helm-gtags helm-gitignore helm-git-grep helm-flx helm-descbinds helm-css-scss helm-cscope helm-company helm-c-yasnippet helm-ag google-translate google-c-style golden-ratio gnuplot gitignore-templates gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link ggtags fuzzy font-lock+ flyspell-correct-helm flycheck-rtags flycheck-pos-tip flycheck-package flycheck-bashate flx-ido fish-mode fill-column-indicator fancy-battery eziam-theme eyebrowse expand-region evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-textobj-line evil-surround evil-org evil-numbers evil-nerd-commenter evil-matchit evil-magit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-escape evil-ediff evil-cleverparens evil-args evil-anzu eval-sexp-fu eterm-256color esup eshell-z eshell-prompt-extras esh-help erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks emojify emoji-cheat-sheet-plus emmet-mode elpy elisp-slime-nav el-get editorconfig dumb-jump dotenv-mode doom-modeline disaster dired-narrow diminish devdocs define-word dap-mode dactyl-mode cython-mode cyberpunk-theme cquery cpp-auto-include company-web company-tern company-statistics company-shell company-rtags company-lsp company-emoji company-c-headers company-anaconda column-enforce-mode clean-aindent-mode clang-format centered-cursor-mode ccls busybee-theme blacken beacon badwolf-theme auto-yasnippet auto-highlight-symbol auto-dictionary auto-compile all-the-icons-dired aggressive-indent ace-link ace-jump-helm-line ac-ispell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
