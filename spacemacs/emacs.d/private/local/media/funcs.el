
;;; funcs.el --- media layer functions file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Alejandro Erickson <alejandro.erickson@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Should these things be wrapped in post-init?

(defun emms-play-pause-dwim ()
  "Try to (un)pause, or play from playlist, or play a random track from the music library."
  (interactive)
  (let ((res nil))
    (ignore-errors
      (emms-pause)
      (setq res t)
      )
    (unless res
      (let ((res nil))
        (ignore-errors
          (emms-playlist-mode-go)
          (goto-line 1)
          (emms-playlist-mode-play-smart)
          (emms-playlist-mode-bury-buffer)
          (setq res t)
          )
        (unless res
          (let ((res nil))
            (ignore-errors
              (emms-browser)
              (emms-browse-by-album)
              (emms-browser-goto-random)
              (emms-browser-add-tracks-and-play)
              (emms-browser-bury-buffer)
              (setq res t)
              )
            (unless res
              (message "Failed to play music.  Populate your EMMS library or playlist.")
              )
            )
          )
        )
      )
    )
)
