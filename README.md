# read-only-directory.el

Open all files always in read-only-mode if those files are in
specified directories.

This el is intented to use avoid changing files when you open
someone's file for reading (especially you use auto-save-buffers).

## Install

Download el file and place it in your own emacs directory.

https://github.com/nsaeki/read-only-directory.el/blob/master/read-only-directory.el

## Setup

```elisp
(require 'read-only-directory)
(read-only-directory-init)
```

and then when you open the file or directory you want to make their
siblings or children read-only, run `M-x read-only-directory`.

If you want to restore the directory to normal mode, run again `M-x
read-only-directory`.

You can define following function to add repository root into
read-only-diretory-list (needs projectile.el).

```elisp
(defun my-read-only-directory ()
  (interactive)
  (read-only-mode t)
  (read-only-directory (when (projectile-project-p)
                         (projectile-project-root))))
```

## Details

Once you run `read-only-directory`, directory list is saved to `read-only-directory-save-file`.
It's default value is "~/.emacs.d/read-only-directories". You can change this value as:

```elisp
(setq read-only-directory-save-file "YOUR_FILE_PATH")
```

You can manually edit that file and load that list via `M-x read-only-directory-load`
in this version.
