;;; poly-php.el --- Polymode for PHP                 -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Friends of Emacs-PHP

;; Author: USAMI Kenta <tadsan@zonu.me>
;; Created: 3 Mar 2019
;; Version: 0.0.1
;; Keywords: languages, php
;; URL: https://github.com/emacs-php/poly-php
;; Package-Requires: ((emacs "25") (polymode "0.1.5") (php-mode "1.21.4"))
;; License: GPL-3.0-or-later

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package integrates Polymode and PHP.

;;; Code:
(require 'polymode)
(require 'php)
(require 'php-mode)

(defconst poly-php--re-tag-tail-matcher
  (eval-when-compile
    (rx "?>")))

(defun poly-php--tag-tail-matcher (ahead)
  "Matcher for tail of PHP block."
  (save-excursion
    (let ((re-search (if (< ahead 0) #'re-search-backward #'re-search-forward))
          found matched)
      (while (and (not found)
                  (setq matched (funcall re-search poly-php--re-tag-tail-matcher nil t)))
        (when (and matched (not (php-in-string-or-comment-p)))
          (setq found (cons (match-beginning 0) (match-end 0)))))
      found)))

(define-innermode php-innermode
  :mode 'php-mode
  :head-matcher (eval-when-compile
                  (rx (or (: "<?php" word-end)
                          (: "<?=")
                          (: "<?" (or " " "\t" "\n" "\r")))))
  :tail-matcher #'poly-php--tag-tail-matcher
  :head-mode 'body
  :tail-mode 'body)

(define-polymode poly-php-html-mode
  :hostmode 'poly-html-hostmode
  :innermodes '(php-innermode))

;;;###autoload
(autoload 'poly-php-html-mode "poly-php")

(provide 'poly-php)
;;; poly-php.el ends here
