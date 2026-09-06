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
;;
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
(setq doom-theme 'tsdh-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

;;; -*- lexical-binding: t; -*-

;;;; Configuration ------------------------------------------------------------

(defvar my/ultimate-work-directory
  (expand-file-name "~/Documents/Programming/")
  "Directory containing my work files.")

(defvar my/ultimate-project-directory
  (expand-file-name "~/Documents/Programming/C/")
  "Project directory used by kanban.")

(defvar my/ultimate-todo-file
  (expand-file-name "TODO.md" my/ultimate-work-directory)
  "TODO file.")

(defvar my/ultimate-org-file
  (expand-file-name "WORK.org" my/ultimate-work-directory)
  "Main Org work file.")

(defvar my/ultimate-kanban-file
  (expand-file-name "boards.json" my/ultimate-project-directory)
  "Kanban board file.")


;;;; Workspace names ----------------------------------------------------------

(defconst my/ultimate-workspace-work "work")
(defconst my/ultimate-workspace-web "web")
(defconst my/ultimate-workspace-command "command")


;;;; Helpers ------------------------------------------------------------------

(defun my/ultimate--recent-file ()
  "Return the most recently visited file, excluding dashboard files."
  (require 'recentf)

  (seq-find
   (lambda (file)
     (not
      (member
       (expand-file-name file)
       (mapcar #'expand-file-name
               (list my/ultimate-todo-file
                     my/ultimate-org-file
                     my/ultimate-kanban-file)))))
   recentf-list))


(defun my/ultimate--switch-workspace (name)
  "Switch to workspace NAME, creating it if necessary."
  (if (+workspace-exists-p name)
      (+workspace-switch name)
    (+workspace-switch name t)))


(defun my/ultimate--setup-work ()
  "Create the Work workspace.

Main file gets roughly 70% of the width.
TODO.md gets roughly 30%."
  (my/ultimate--switch-workspace my/ultimate-workspace-work)

  (delete-other-windows)

  (let ((main-window (selected-window))
        (last-file (my/ultimate--recent-file)))

    ;; Main file.
    (if last-file
        (find-file last-file)
      (switch-to-buffer "*scratch*"))

    ;; TODO window.
    (let ((todo-window
           (split-window
            main-window
            (floor (* (window-total-width main-window) 0.70))
            'right)))

      (set-window-buffer
       todo-window
       (find-file-noselect my/ultimate-todo-file)))

    ;; Return focus to main file.
    (select-window main-window)))


(defun my/ultimate--setup-web ()
  "Create the Documentation workspace and display C documentation."
  (my/ultimate--switch-workspace my/ultimate-workspace-web)

  ;; Make this workspace start with exactly one window.
  (delete-other-windows)

  ;; Reuse the existing documentation buffer if possible.
  (if-let ((buffer (get-buffer "*Documentation*")))
      (switch-to-buffer buffer)
    (eww "https://en.cppreference.com/w/c/language")
    (rename-buffer "*Documentation*" t))

  ;; Make absolutely sure EWW is the selected/full window.
  (switch-to-buffer "*Documentation*")
  (delete-other-windows))

(defun my/ultimate--setup-command ()
  "Create the Command workspace with Org, rmpc, and Kanban."
  (interactive)

  (my/ultimate--switch-workspace my/ultimate-workspace-command)

  ;; Start with exactly one window.
  (delete-other-windows)

  (let* ((org-window (selected-window))

         ;; Top 70%, bottom 30%.
         (bottom-window
          (split-window
           org-window
           (- (floor (* (window-total-height org-window) 0.30)))
           'below))

         ;; Split the bottom window in half.
         (kanban-window
          (split-window
           bottom-window
           nil
           'right)))

    ;; ============================================================
    ;; ORG
    ;; ============================================================

    (set-window-buffer
     org-window
     (find-file-noselect my/ultimate-org-file))

    ;; ============================================================
    ;; RMPC
    ;; ============================================================

    ;; Create the vterm buffer WITHOUT allowing vterm to
    ;; manipulate the window layout.
    (let ((rmpc-buffer
           (generate-new-buffer "*rmpc*")))

      (set-window-buffer bottom-window rmpc-buffer)

      (with-current-buffer rmpc-buffer
        (vterm-mode))

      ;; Start rmpc inside this exact vterm.
      (with-current-buffer rmpc-buffer
        (vterm-send-string "rmpc")
        (vterm-send-return)))

    ;; ============================================================
    ;; KANBAN
    ;; ============================================================

    (let ((kanban-buffer
           (generate-new-buffer "*kanban*")))

      (set-window-buffer kanban-window kanban-buffer)

      (with-current-buffer kanban-buffer
        (vterm-mode))

      ;; Start kanban inside this exact vterm.
      (with-current-buffer kanban-buffer
        (vterm-send-string "kanban")
        (vterm-send-return)))

    ;; ============================================================
    ;; FINISH ON ORG
    ;; ============================================================

    (select-window org-window)))

;;;; Main command -------------------------------------------------------------

(defun my/ultimate-work-setup ()
  "Build the complete ultimate work environment."
  (interactive)

  (message "ULTIMATE: starting")

  ;; Make sure recentf is available.
  (require 'recentf)
  (recentf-mode 1)

  ;; =========================================================================
  ;; WORK
  ;; =========================================================================

  (message "ULTIMATE: creating Work workspace...")
  (my/ultimate--setup-work)

  ;; =========================================================================
  ;; WEB / DOCUMENTATION
  ;; =========================================================================

  (message "ULTIMATE: creating Documentation workspace...")
  (my/ultimate--setup-web)

  ;; =========================================================================
  ;; COMMAND
  ;; =========================================================================

  (message "ULTIMATE: creating Command workspace...")
  (my/ultimate--setup-command)

  ;; =========================================================================
  ;; FINISH ON COMMAND / ORG
  ;; =========================================================================

  (message "ULTIMATE: switching to Command workspace...")
  (my/ultimate--switch-workspace my/ultimate-workspace-command)

  (when-let ((org-buffer
              (get-file-buffer my/ultimate-org-file)))
    (when-let ((org-window
                (get-buffer-window org-buffer t)))
      (select-window org-window)))

  (message "ULTIMATE: work environment ready!"))
