(add-hook 'tex-mode-hook
	  (lambda ()
	    (local-set-key (quote [f1])(quote help-for-help))))
;; by an unknown contributor
;; added, march 1, 2011
;; removing this because doesn't allow me to add percent in the text.
;; (global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))m
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

;; -------------- MODES --------------
;; Setting different modes over here
(show-paren-mode 1)
(column-number-mode)
(global-linum-mode 1)

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)

;; change the default size to 2 for when using GNU Emacs
(setq default-tab-width 2)

;; Rinari
(add-to-list 'load-path "~/.emacs.d/plugins/rinari")
(add-to-list 'load-path "~/.emacs.d/plugins/")
(add-to-list 'load-path "~/.emacs.d/")

;; all for the fancy auto-complete mode :)
;; there definitely is a better way than this to do this but this works for now
(load "~/.emacs.d/plugins/auto-complete-1.3.1/popup.el")
(load "~/.emacs.d/plugins/auto-complete-1.3.1/auto-complete.el")

(require 'rinari)

;; swap locations of 2 windows using C-c s
(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((/= (count-windows) 2)
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1))))
  (other-window 1))

(global-set-key (kbd "C-c x") 'swap-windows)

;;---------------------------------------------------------
;; add stuff for tab-completion
;; whats cool? do a C-x h <tab>, 
;; where C-x h (selects entire text) and the <tab> indents it
(add-to-list 'load-path "~/.emacs.d/plugins/smarttab")
(define-key read-expression-map [(tab)] 'hippie-expand)
(define-key read-expression-map [(shift tab)] 'unexpand)

;;---------------------------------------------------------
;; when starting ruby mode, start the rinari-rails mode too
(add-hook 'ruby-mode 'rinari-minor-mode)


;;--------------------------------------------------------
;; map M-g to goto a certain line
(global-set-key "\M-g" 'goto-line)


(setq minibuffer-max-depth nil)

;; just copying this from gary bernhardts .emacs file
; GRB: split the windows
;(progn
;  (interactive)
;  (split-window)
;  (other-window 1)
;  (other-window 1)
;  (split-window-horizontally 80)
;  (eshell)
;  (other-window -3))

;; too bright color themes, at least for my taste :) but I am sure there is something better in this file
;(require 'color-theme)
;(color-theme-pok-wog
(set-default 'show-trailing-whitespace t)

; GRB: use C-o and M-o to switch windows
(global-set-key "\C-o" 'other-window)
(defun prev-window ()
  (interactive)
  (other-window -1))
(global-set-key "\M-o" 'prev-window)

; use a box cursor
(setq cursor-type 'box)
(setq default-cursor-type 'box)

;; http://www.emacswiki.org/emacs/ThreeWindows
;; this might be a little tricky, but (split-v-3) will change the 
;; configuration to what you see right now, but without the split
;; it doesn't do anything so do not apply independently
(defun split-v-3 ()
  "Change 3 window style from horizontal to vertical"
  (interactive)
  (select-window (get-largest-window))
  (if (= 3 (length (window-list)))
      (let ((winList (window-list)))
	(let ((1stBuf (window-buffer (car winList)))
	      (2ndBuf (window-buffer (car (cdr winList))))
	      (3rdBuf (window-buffer (car (cdr (cdr winList))))))
	  (message "%s %s %s" 1stBuf 2ndBuf 3rdBuf)
	  (delete-other-windows)
	  (split-window-horizontally)
	  (set-window-buffer nil 1stBuf)
	  (other-window 1)
	  (set-window-buffer nil 2ndBuf)
	  (split-window-vertically)
	  (set-window-buffer (next-window) 3rdBuf)
	  (select-window (get-largest-window))))))

;(progn (interactive) (split-window) (split-window-horizontally) (eshell) (other-window 1))

(split-v-3)

;; experimental stuff, for HTML completion
;;(load "/Users/spatil/Downloads/nxhtml/autostart.el")

;; turn on transient mark mode
;;(that is, we highlight the selected text)
(transient-mark-mode t)

(setq my-tab-width 2)

(defun indent-block()
  (shift-region my-tab-width)
  (setq deactivate-mark nil))

(defun unindent-block()
  (shift-region (- my-tab-width))
  (setq deactivate-mark nil))

(defun shift-region(numcols)
" my trick to expand the region to the beginning and end of the area selected
 much in the handy way I liked in the Dreamweaver editor."
  (if (< (point)(mark))
    (if (not(bolp))    (progn (beginning-of-line)(exchange-point-and-mark) (end-of-line)))
    (progn (end-of-line)(exchange-point-and-mark)(beginning-of-line)))
  (setq region-start (region-beginning))
  (setq region-finish (region-end))
  (save-excursion
    (if (< (point) (mark)) (exchange-point-and-mark))
    (let ((save-mark (mark)))
      (indent-rigidly region-start region-finish numcols))))

(defun indent-or-complete ()
  "Indent region selected as a block; if no selection present either indent according to mode,
or expand the word preceding point. "
  (interactive)
  (if  mark-active
      (indent-block)
    (if (looking-at "\\>")
  (hippie-expand nil)
      (insert "\t"))))

(defun my-unindent()
  "Unindent line, or block if it's a region selected.
When pressing Shift+tab, erase words backward (one at a time) up to the beginning of line.
Now it correctly stops at the beginning of the line when the pointer is at the first char of an indented line. Before the command would (unconveniently)  kill all the white spaces, as well as the last word of the previous line."

  (interactive)
  (if mark-active
      (unindent-block)
    (progn
      (unless(bolp)
        (if (looking-back "^[ \t]*")
            (progn
              ;;"a" holds how many spaces are there to the beginning of the line
              (let ((a (length(buffer-substring-no-properties (point-at-bol) (point)))))
                (progn
                  ;; delete backwards progressively in my-tab-width steps, but without going further of the beginning of line.
                  (if (> a my-tab-width)
                      (delete-backward-char my-tab-width)
                    (backward-delete-char a)))))
          ;; delete tab and spaces first, if at least 2 exist, before removing words
          (progn
            (if(looking-back "[ \t]\\{2,\\}")
                (delete-horizontal-space)
              (backward-kill-word 1))))))))

(add-hook 'find-file-hooks (function (lambda ()
 (unless (eq major-mode 'org-mode)
(local-set-key (kbd "<tab>") 'indent-or-complete)))))

(if (not (eq  major-mode 'org-mode))
    (progn
      (define-key global-map "\t" 'indent-or-complete) ;; with this you have to force tab (C-q-tab) to insert a tab after a word
      (define-key global-map [S-tab] 'my-unindent)
      (define-key global-map [C-S-tab] 'my-unindent)))

;; mac and pc users would like selecting text this way
(defun dave-shift-mouse-select (event)
 "Set the mark and then move point to the position clicked on with
 the mouse. This should be bound to a mouse click event type."
 (interactive "e")
 (mouse-minibuffer-check event)
 (if mark-active (exchange-point-and-mark))
 (set-mark-command nil)
 ;; Use event-end in case called from mouse-drag-region.
 ;; If EVENT is a click, event-end and event-start give same value.
 (posn-set-point (event-end event)))

;; be aware that this overrides the function for picking a font. you can still call the command
;; directly from the minibufer doing: "M-x mouse-set-font"
(define-key global-map [S-down-mouse-1] 'dave-shift-mouse-select)

;; to use in into emacs for  unix I  needed this instead
; define-key global-map [S-mouse-1] 'dave-shift-mouse-select)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; this final line is only necessary to escape the *scratch* fundamental-mode
;; and let this demonstration work
(text-mode)

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)
