# read-only-directory.el

Open files in directory in read-only-mode.

## Install

Download el file and place it in your own emacs directory.

https://github.com/nsaeki/read-only-directory.el/blob/master/read-only-directory.el

## Setup

```elisp
(require 'read-only-directory)
(read-only-directory-init)
```

and then if you open the file or directory you want to make their siblings or children be
read-only (for example, you are reading someone's code and do not want to modify them),
run `M-x read-only-directory`.

If you want to remove the directory from read-only-direcotry-list, run again `M-x read-only-directory`.

## Details

Once you run `read-only-directory`, directory list is saved to `read-only-directory-save-file`.
It's default value is "~/.emacs.d/read-only-directories". You can change this value as:

```elisp
(setq read-only-directory-save-file "YOUR_FILE_PATH")
```

You can manually edit that file and load that list via `M-x read-only-directory-load`
in this version.
