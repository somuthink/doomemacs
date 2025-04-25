;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'light-blue-theme)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;
;;
;; prev: forget-me-not, doom-acario-light
(setq doom-theme 'doom-ayu-light)
(setq display-line-numbers-type 'relative)

;; PATH for latex support
(setenv "PATH" (concat ":/Library/TeX/texbin/" (getenv "PATH")))
(add-to-list 'exec-path "/Library/TeX/texbin/")

;; custom startup page
(setq initial-buffer-choice "~/.config/doom/start.org")

(add-hook! 'emacs-startup-hook
  (setq default-directory "~/notes/2024-2025/"))


(define-minor-mode start-mode
  "Provide functions for custom start page."
  :lighter " start"
  :keymap (let ((map (make-sparse-keymap)))
            ;;(define-key map (kbd "M-z") 'eshell)
            (evil-define-key 'normal start-mode-map
              (kbd "n") '(lambda () (interactive) (projectile-switch-project "~/notes/2024-2025"))
              (kbd "1") '(lambda () (interactive) (find-file "~/notes/2024-2025/refile.org"))
              (kbd "2") '(lambda () (interactive) (find-file "~/.config/doom/config.el"))
              (kbd "3") '(lambda () (interactive) (find-file "~/.config/doom/init.el"))
              (kbd "4") '(lambda () (interactive) (find-file "~/.config/doom/packages.el"))
              )
            map))

(add-hook 'start-mode-hook 'read-only-mode) ;; make start.org read-only; use 'SPC t r' to toggle off read-only.
(provide 'start-mode)

;; (setq mac-right-command-modifier 'meta)


;; org initial settings
(setq org-directory "~/notes/2024-2025/"
      org-agenda-files (directory-files-recursively "~/notes/" "\\.org$"
                                                    ))
(setq org-default-notes-file (concat org-directory "/refile.org"))
(setq org-roam-directory "~/notes/2024-2025/")



;; org customization
(after! org




  (setq org-image-actual-width '(160))

  ;; super agenda (useless)
  (use-package! org-super-agenda
    :after org-agenda
    :init
    (org-super-agenda-mode)
    :config
    (setq org-super-agenda-header-map (make-sparse-keymap)))


  (setq org-capture-templates
        '(("t" "Todo" entry (file "refile.org")
           "* TODO %?\n  %i\n  %a")

          ("T" "Todo Daily" entry (file+headline "refile.org" "Daily")
           "* NEXT %?\nSCHEDULED: %^t\n%i\n%a")


          ("n" "Next" entry (file "refile.org")
           "* NEXT %?\nSCHEDULED: %^t\n%i\n%a")

          ("N" "Note" entry (file "refile.org")
           "* %?\n %i\n")

          ("j" "Journal" entry (file+datetree "journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")

          ("p" "Protocol" entry (file+headline "refile.org" "Reading list")
           "* TODO %?\n[[%:link][%:description]]\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n")
          ("L" "Protocol Link" entry (file+headline "refile.org" "Reading list")
           "* TODO %?\n[[%:link][%:description]]")

          ))
  (use-package! org-habit )
  (setq
   org-habit-show-all-today t)


  ;; Hide tasks that are scheduled in the future.
  ;; (setq org-agenda-todo-ignore-scheduled 'future)

  ;; Use "second" instead of "day" for time comparison.
  ;; It hides tasks with a scheduled time like "<2020-11-15 Sun 11:30>"
  ;; (setq org-agenda-todo-ignore-time-comparison-use-seconds t)

  ;; Hide the deadline prewarning prior to scheduled date.
  (setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-start-day nil)
  (setq org-agenda-start-on-weekday 1)
  (setq org-agenda-span 7)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "PROG(p)" "INTR(i)" "DONE(d)" )))

  (setq org-agenda-sorting-strategy
        '((agenda time-up priority-down category-keep)
          (todo   priority-down category-keep)
          (tags   priority-down category-keep)
          (search category-keep)))


  (setq org-todo-keyword-faces
        '(("PROG" . (:foreground "yellow" :weight bold))
          ("INTR" . (:foreground "red" :weight bold))
          ))

  (setq org-agenda-custom-commands
        '(("n" "My Weekly Agenda"
           ((agenda "" nil)
            (todo "INTR" nil)
            (todo "PROG" nil)
            (todo "NEXT"
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'scheduled 'deadline))))
            )
           nil)
          ("t" "TODOS"
           (

            (todo "TODO" ((org-agenda-overriding-header "")
                          (org-agenda-sorting-strategy '( priority-down))
                          (org-super-agenda-groups '((:auto-parent t)))
                          ))


            ))))


  ;; org latex preview tools defenition
  (setq org-preview-latex-process-alist
        '
        ((dvipng :programs
                 ("lualatex" "dvipng")
                 :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
                 (1.0 . 1.0)
                 :latex-compiler
                 ("lualatex -output-format dvi -interaction nonstopmode -output-directory %o %f")
                 :image-converter
                 ("dvipng -fg %F -bg %B -D %D -T tight -o %O %f"))
         (dvisvgm :programs
                  ("latex" "dvisvgm")
                  :description "dvi > svg" :message "you need to install the programs: latex and dvisvgm." :use-xcolor t :image-input-type "xdv" :image-output-type "svg" :image-size-adjust
                  (1.7 . 1.5)
                  :latex-compiler
                  ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
                  :image-converter
                  ("dvisvgm %f -n -b min -c %S -o %O"))
         (imagemagick :programs
                      ("latex" "convert")
                      :description "pdf > png" :message "you need to install the programs: latex and imagemagick." :use-xcolor t :image-input-type "pdf" :image-output-type "png" :image-size-adjust
                      (1.0 . 1.0)
                      :latex-compiler
                      ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
                      :image-converter
                      ("convert -density %D -trim -antialias %f -quality 100 %O"))))
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  )

;; EMMMS
(setq emms-player-list '(emms-player-mpv))
(setq emms-source-file-default-directory "~/Music/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(add-to-list 'treesit-extra-load-path (expand-file-name "~/.config/emacs/tree-sitter/"))

(setq lsp-volar-take-over-mode nil)
(after! lsp-mode
  (setq  lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  (setq  lsp-go-use-gofumpt t)

  )



(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'typescript-mode-hook #'lsp-deferred)
