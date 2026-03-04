;; Setting the custom-file so that auto-generated config from emacs is in a separate file.
(setq custom-file "~/.emacs.custom.el")
(load custom-file)

;; Configuring MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


;; tree-sitter mode
(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; eglot (LSP) for C/C++ navigation — uses clangd
;; Auto-start for local files; use M-x eglot manually for TRAMP files
(defun my/eglot-ensure-local ()
  (unless (file-remote-p buffer-file-name)
    (eglot-ensure)))
(add-hook 'c-mode-hook #'my/eglot-ensure-local)
(add-hook 'c++-mode-hook #'my/eglot-ensure-local)

(add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))
(add-hook 'eglot-managed-mode-hook (lambda () (eldoc-mode -1)))           

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
  "Call sillyfmt on buffer, disabling read-only buffer and resetting it after formatting is done"
  (interactive)
  ;; I don't love it, but disabling read-only is the only thing that will format the compilation output
  (read-only-mode -1)
  (sillyfmt-format-buffer)
  (read-only-mode 1))

;; clang-format setup
(setq clang-fmt-command "clang-format")
(reformatter-define clang-fmt-format
  :program clang-fmt-command
  :args '("--style=Google"))
(defun cf ()
  "Call clang-format on buffer"
  (interactive)
  (clang-fmt-format-buffer))

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

;; M-x compile is much too frequent
(global-set-key [f9] #'compile)
;; M-x recompile as well
(global-set-key [(control f9)] #'recompile)

;; Years of using an apple machine as my primary device has trained me to reach for cmd:
;; C-x 1 (delete-other-windows) is just one too many keystrokes
(global-set-key (kbd "s-1") 'delete-other-windows)
(global-set-key (kbd "s-b") 'ido-switch-buffer)

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
