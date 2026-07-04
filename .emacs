;; Setting the custom-file so that auto-generated config from emacs is in a separate file.
(setq custom-file "~/.emacs.custom.el")
(load custom-file)

;; Colors for all new frames
(add-to-list 'default-frame-alist '(background-color . "grey15"))
(add-to-list 'default-frame-alist '(foreground-color . "grey80"))
;; Also apply to the initial frame (already exists when .emacs loads)
(set-background-color "grey15")
(set-foreground-color "grey80")

;; Configuring MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; no blinking
(blink-cursor-mode -1)

;; redirect backup files to a central directory instead of littering ~-files everywhere
(setq backup-directory-alist '(("." . "~/.emacs_backups")))

;; confirm that you want to close emacs
(setq confirm-kill-emacs #'yes-or-no-p)

;; some C/C++ specific reworking
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(font-lock-add-keywords
 'c++-mode
 '(
   ("\\<\\(static_assert\\|export\\|nullptr\\|constexpr\\|final\\|override\\)\\>" . font-lock-keyword-face)))
(font-lock-add-keywords
 'c++-mode
 '(
   ("\\(\\[\\[[a-z_]*\\]\\]\\)" 0 'c-attribute-face t)))
(defface c-attribute-face
    '((t (:foreground "#667788")))
  "Face used to highlight C/C++ attributes."
  :group 'c-faces)

;; Rust stuff
(require 'rust-mode)

;; UNFORTUNATELY, I THINK I DON'T LIKE LSPs......
;; I FIND THEM VERY RARELY USEFUL BUT STILL I'LL THIS CONFIG AROUND
;; eglot (LSP) for C/C++ navigation — uses clangd
;; Auto-start for local files; use M-x eglot manually for TRAMP files
;; (defun my/eglot-ensure-local ()
;;   (unless (file-remote-p buffer-file-name)
;;     (eglot-ensure)))
;; (add-hook 'c-mode-hook #'my/eglot-ensure-local)
;; (add-hook 'c++-mode-hook #'my/eglot-ensure-local)

;; (add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))
;; (add-hook 'eglot-managed-mode-hook (lambda () (eldoc-mode -1)))

;; Ensure TRAMP uses the remote machine's full PATH (so it finds clangd)
(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; expand-region - the alternative to "inner" in vim
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Requires downloading font from https://tom7.org/fixedersys/
(add-to-list 'default-frame-alist `(font . "FixederSys 2x 16"))

;; ido-mode for completions
(require 'ido)
(ido-mode t)
(setq ido-show-dot-for-dired t)

;; multiple cursors setup
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; reformatter setup - because I like sillyfmt: https://github.com/thomask-m/sillyfmt
(setq sillyfmt-command "/Users/mas/proj/sillyfmt/target/release/sillyfmt")
(reformatter-define sillyfmt-format
  :program sillyfmt-command)
(defun sf ()
  "Call sillyfmt on buffer. Prompts for confirmation if the buffer is writable."
  (interactive)
  (if buffer-read-only
      ;; progn groups multiple expressions into one body for the "then"
      ;; branch of `if`, since `if` only takes a single form per branch.
      ;; Without progn, only the first expression would be the "then" branch
      ;; and the rest would be treated as the "else" branch.
      (progn
        (read-only-mode -1)
        (sillyfmt-format-buffer)
        (read-only-mode 1))
    (when (y-or-n-p "Buffer is writable. Format anyway? ")
      (sillyfmt-format-buffer))))

;; clang-format setup
(setq clang-fmt-command "clang-format")
(reformatter-define clang-fmt-format
  :program clang-fmt-command
  :args '("-style=LLVM"))
(defun cf ()
  "Call clang-format on buffer"
  (interactive)
  (clang-fmt-format-buffer))
(global-set-key (kbd "C-c C-f") 'cf)

(global-set-key (kbd "C-:") 'avy-goto-char)

;; vterm tramp setup - i like fish with vterm
(setq vterm-tramp-shells '((t "/bin/fish")))

;; I like vim's "o" and "O" command in normal mode
(defun like_vim_normal_mode_o_command ()
  "Add a new line just like o command in vim"
  (interactive)
  (end-of-line)
  (newline-and-indent))
(defun like_vim_normal_mode_shift_o_command ()
  "Add a new line to the previous line just like O command in vim"
  (interactive)
  (beginning-of-line)
  (newline-and-indent)
  (previous-line))
(global-set-key (kbd "<C-return>") 'like_vim_normal_mode_o_command)
(global-set-key (kbd "<C-S-return>") 'like_vim_normal_mode_shift_o_command)

;; I like vim's shift-v to mark current line as a region
(defun mark-current-line-as-region ()
  "Mark current line as region like shift-v in vim"
  (interactive)
  (beginning-of-line)
  (set-mark (point-at-eol))
  (forward-line 0)
  (activate-mark))
(global-set-key (kbd "C-c l") 'mark-current-line-as-region)

;; I do not like C-z being minimize window, going to remap to undo
(global-set-key (kbd "C-z") 'undo)

;; Commenting is too frequent
(global-set-key (kbd "C-;") 'comment-line)
(global-set-key (kbd "s-/") 'comment-line)

;; Show *compilation* side-by-side when the window is wide enough
(defun my/display-buffer-split-sensibly (buffer alist)
  "Display BUFFER in a vertical split (side-by-side) if the selected window
is at least 160 columns wide; otherwise split horizontally (top/bottom)."
  (let ((width-threshold 160))  ; tune this number to taste
    (if (>= (window-total-width) width-threshold)
        (display-buffer-in-direction buffer
          (append '((direction . right) (window-width . 0.5)) alist))
      (display-buffer-below-selected buffer alist))))

(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-reuse-window
                my/display-buffer-split-sensibly)
               (window-min-width . 80)))

;; M-x compile is much too frequent
(with-eval-after-load 'cc-mode
  (define-key c++-mode-map (kbd "C-c C-c") 'compile))
(global-set-key (kbd "C-c C-c") #'compile)
;; M-x recompile as well
(global-set-key (kbd "s-r") #'recompile)

;; Years of using an apple machine as my primary device has trained me to reach for cmd:
;; C-x 1 (delete-other-windows) is just one too many keystrokes
(global-set-key (kbd "s-1") 'delete-other-windows)
(global-set-key (kbd "s-b") 'ido-switch-buffer)
;; Cmd+Delete (Cmd+Backspace on macOS) — kill from point to beginning of line
(global-set-key (kbd "s-<backspace>") (lambda () (interactive) (kill-line 0)))

;; ace-window — visual hint window selection (same author as avy)
(require 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

;; winner-mode — undo/redo window layouts (C-c <left> / C-c <right>)
(winner-mode 1)

;; windmove — directional window navigation
(windmove-default-keybindings)  ; S-left, S-right, S-up, S-down

;; get rid of menu bar
(menu-bar-mode 0)
;; get rid of tool bar
(tool-bar-mode 0)
; get rid of scroll bar
(scroll-bar-mode 0)
; set line numbers
(global-display-line-numbers-mode)
; set column number in display line
(column-number-mode 1)

;; ORG MODE STUFF BELOW
;; org-mode setup
(setq org-directory "~/org/")
(setq org-agenda-files '("~/org/"))

;; task states: left of | = open, right of | = closed
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "ON-HOLD" "|" "DONE" "CANCELLED")))

;; log timestamp when a task is marked DONE
(setq org-log-done 'time)

;; org-agenda keybinding
(global-set-key (kbd "C-c a") 'org-agenda)

;; org-capture keybinding and template
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      '(("t" "Task" entry (file "~/org/projects.org")
         "* TODO %?\n  %u")))
