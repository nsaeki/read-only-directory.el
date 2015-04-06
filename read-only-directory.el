;;; read-only-directory.el --- Open files in directory in read-only-mode.
;;
;; Filename: read-only-directory.el
;; Description: Open all files in read-only-mode.
;; Author: Nobuo Saeki
;; Maintainer: Nobuo Saeki
;; Created: Mon Apr  6 22:07:48 2015 (+0900)
;; Version: 0.0.1
;; Package-Requires: ()
;; URL: https://github.com/nsaeki/read-only-directory.el
;;
;; The MIT License (MIT)
;;
;; Copyright (c) 2015 Nobuo Saeki
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(defcustom read-only-directory-save-file
  (expand-file-name "~/.emacs.d/read-only-directories")
  nil)

(defcustom read-only-directory-default-directories '() nil)

(defvar read-only-directory-list nil '())

(defun read-only-directory-file-p (file)
  (read-only-directory-file-r-p read-only-directory-list file))

(defun read-only-directory-file-r-p (regex file)
  (if (car regex)
      (let ((pos (string-match-p (car regex) file)))
        (if (and pos (= 0 pos)) t
          (read-only-directory-file-r-p (cdr regex) file)))))

(defun read-only-directory-find-file ()
  (if (read-only-directory-file-p buffer-file-name)
      (read-only-mode t)))

(defun read-only-directory (&optional dir)
  (interactive)
  (unless dir
    (setq dir default-directory)
    (read-only-mode t))
  (read-only-directory-add dir))

(defun read-only-directory-add (dir)
  (if (read-only-directory-file-p dir)
      (message (format "%s is already in read-only-directory-list" dir))
    (add-to-list 'read-only-directory-list (expand-file-name dir))
    (read-only-directory-save)
    (message (format "Added %s to read-only-directory-list" dir))))

(defun read-only-directory-del (dir)
  (delete (expand-file-name dir) read-only-directory-list)
  (read-only-directory-save))

(defun read-only-directory-save (&optional file)
  (unless file
    (setq file read-only-directory-save-file))
  (when file
    (condition-case nil
        (with-temp-file file
          (set-buffer-file-coding-system 'utf-8)
          (prin1 read-only-directory-list (current-buffer))
          (insert "\n"))
      (error (message "Cannot save read-only-directory-list to %s" file)))))

(defun read-only-directory-load (&optional file)
  (unless file
    (setq file read-only-directory-save-file))
  (when file
    (condition-case nil
        (setq read-only-directory-list
              (append (with-temp-buffer
                        (insert-file-contents file)
                        (goto-char (point-min))
                        (read (current-buffer)))
                      read-only-directory-default-directories))
      (error (message "Cannot read read-only-directory-list at %s" file)))))

(defun read-only-directory-init ()
  (read-only-directory-load)
  (add-hook 'find-file-hooks
            'read-only-directory-find-file))

(provide 'read-only-directory)
