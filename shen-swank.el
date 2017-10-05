(require 'slime)

(defun slime-eval-last-expression-shen ()
  (interactive)
    (slime-eval-with-transcript
     `(shen-swank:slime-interactive-eval-shen
       ,(slime-last-expression))))

(defun slime-pprint-eval-last-expression-shen ()
  (interactive)
  (slime-eval-describe
   `(shen-swank:pprint-eval-shen
     ,(slime-last-expression))))


(global-set-key (kbd "s-e") 'slime-eval-last-expression-shen)
(global-set-key (kbd "s-p") 'slime-pprint-eval-last-expression-shen)
