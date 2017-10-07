(defpackage shen-swank
  (:use :cl :swank))

(in-package :shen-swank)

(defun shen-eval (input)
  (cl-user::|shen.interactive-evaluate|
            (cl-user::|@p|
                      (cl-user::|read-from-string| input)
                      (cl-user::|map| #'(LAMBDA (X) (cl-user::|string->n| X)) (cl-user::|explode| input))
                      )))

(swank::defslimefun slime-interactive-eval-shen (input)
  (format nil "~A" 'life)
  (shen-eval input))

(swank::defslimefun pprint-eval-shen (input)
  (swank::with-buffer-syntax ()
    (let* ((s (make-string-output-stream))
           (values
            (let ((*standard-output* s)
                  (*trace-output* s))
              (multiple-value-list (shen-eval input)))))
      (swank::cat
       (get-output-stream-string s)
       (swank::swank-pprint values)))))
