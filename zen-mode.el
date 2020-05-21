;;; zen-mode.el --- Zen Editing Mode for emacs

;; Copyright (C) 2017 Akilan Elango

;; Author: Akilan Elango <akilan1997 [at] gmail.com>
;; Keywords: convenience
;; X-URL: https://github.com/aki237/zen-mode
;; URL: https://github.com/aki237/zen-mode
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Zen mode for Emacs is a distraction free editing mode for Emacs.
;;
;;; Installation:
;;
;;   (require 'zen-mode)
;;
;;; Use:
;; This is used to start a distraction free editing session in Emacs like in
;; Sublime Text.
;;
;;; Code:

;; require


;; variables
(defvar zen-mode:disable-mode-line t "Hide the mode line in zen-mode.")
(defvar zen-mode:zen-cols 81 "Default width of zen mode text area (columns).")

;; local variables
(defvar-local zen-run-mode nil "Set to true when zen mode is enabled")

;; Variables for saving the pre-zen state of the window, and restoring it when disabling zen mode
(defvar-local prezen-modeline nil "Pre-zen modeline format")
(defvar-local prezen-menubar nil "Pre-zen menubar enabled-disabled")
(defvar-local prezen-toolbar nil "Pre-zen toolbar enabled-disabled")
(defvar-local prezen-linum nil "Pre-zen line number mode")
(defvar-local prezen-cursorblink nil "Pre-zen cursor blink")
(defvar-local prezen-lm 0 "Pre-zen left margin")
(defvar-local prezen-rm 0 "Pre-zen right margin")
(defvar-local prezen-lf 0 "Pre-zen left margin")
(defvar-local prezen-rf 0 "Pre-zen right margin")
(defvar-local prezen-fullscreen nil "Pre-zen fullscreen state")

;;;###autoload
(define-minor-mode zen-mode
  "zen-mode is a distraction free editing mode for Emacs"
  :lighter " Zen"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-<") 'zen-mode:decrease-text-width)
            (define-key map (kbd "C->") 'zen-mode:increase-text-width)
            map)
  (zen-toggle))

;; functions
(defun zen-toggle()
  "zen-run is a lisp function which activates and deactivates the zen-mode"
  (if zen-run-mode
			(zen-mode:zen-off)
		(zen-mode:zen-on)))

(defun zen-mode:zen-on()
	"Turn zen-mode on"
	(setq prezen-modeline mode-line-format)
	(setq prezen-menubar (and (boundp 'menu-bar-mode) menu-bar-mode))
	(setq prezen-toolbar (and (boundp 'tool-bar-mode) tool-bar-mode))
	(setq prezen-linum (and (boundp 'linum-mode) linum-mode))
	(setq prezen-cursorblink (and (boundp 'cursor-blink-mode) cursor-blink-mode))
	(setq prezen-lm left-margin-width)
	(setq prezen-rm right-margin-width)
	(setq prezen-lf left-fringe-width)
	(setq prezen-rf right-fringe-width)
	(setq prezen-fullscreen (frame-parameter (selected-frame) 'fullscreen))

	(add-hook 'window-size-change-functions 'zen-mode:refresh-buffer)
	(set-frame-parameter nil 'fullscreen 'fullboth)

	(linum-mode -1)
	(menu-bar-mode -1)
	(tool-bar-mode -1)
	(blink-cursor-mode -1)
	(setq left-fringe-width 0)
	(setq right-fringe-width 0)

	(if zen-mode:disable-mode-line
		 (setq mode-line-format nil))

	(zen-mode:set-margins)
	(setq zen-run-mode t)
	(message "Distractions Removed"))

(defun zen-mode:zen-off()
	"Turn zen-mode off"
	(setq zen-run-mode nil)
	(remove-hook 'window-size-change-functions 'zen-mode:refresh-buffer)
	(if prezen-menubar (menu-bar-mode 1))
	(if prezen-toolbar (tool-bar-mode 1))
	(if prezen-linum (linum-mode 1))
	(if prezen-cursorblink (cursor-blink-mode))


	(setq left-fringe-width prezen-lf)
	(setq right-fringe-width prezen-rf)
	(setq left-margin-width prezen-lm)
	(setq right-margin-width prezen-rm)
	(set-frame-parameter nil 'fullscreen prezen-fullscreen)
	(set-window-buffer nil (current-buffer))
	(message "Distractions are back")
	)

(defun zen-mode:decrease-text-width()
  "Decrease zen text width by two columns"
  (interactive)
  (setq zen-mode:zen-cols (- zen-mode:zen-cols 2))
  (zen-mode:set-margins)
  )

(defun zen-mode:increase-text-width()
  "Increase zen text width by two columns"
  (interactive)
  (setq zen-mode:zen-cols (+ zen-mode:zen-cols 2))
  (zen-mode:set-margins)
  )

(defun zen-mode:set-margins()
  "zen-mode:set-margins is a lisp function to set the margin width (both left and right)."
  (setq left-margin-width (/ (- (window-total-width) zen-mode:zen-cols) 2))
  (setq right-margin-width (/ (- (window-total-width) zen-mode:zen-cols) 2))
  (set-window-buffer nil (current-buffer))
  )

(defun zen-mode:refresh-buffer(frame)
  "zen-mode:refresh-buffer is a lisp function to refresh the buffer's margin width when window is resized"
	(zen-mode:set-margins))

(provide 'zen-mode)

;; coding: utf-8
;; End:
;;; zen-mode.el ends here
