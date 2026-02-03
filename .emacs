; Setting the custom-file so that auto-generated config from emacs is in a separate file.
(setq custom-file "~/.emacs.custom.el")
(load custom-file)

; Configuring MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

; tree-sitter mode
(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

; expand-region - the alternative to "inner" in vim
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

; Requires downloading font from https://tom7.org/fixedersys/
(add-to-list 'default-frame-alist `(font . "FixederSys 2x 16"))

; ido-mode for completions
(require 'ido)
(ido-mode t)
(setq ido-show-dot-for-dired t)

; multiple cursors setup
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

; I like vim's "o" and "O" command in normal mode
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

; get rid of menu bar
(menu-bar-mode 0)
; get rid of tool bar
(tool-bar-mode 0)
; get rid of scroll bar
(scroll-bar-mode 0)
; set line numbers
(global-display-line-numbers-mode)
