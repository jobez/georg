(defpackage shen-swank
  (:use :cl :swank))

(in-package :shen-swank)

(defun shen-eval (input)
  (cl-user::|shen.toplevel_interactive|
   (cl-user::|read-from-string| input)))

(swank::defslimefun slime-interactive-eval-shen (input)
  (shen-eval input))


(defun swank-pprint (values)
  "Bind some printer variables and pretty print each object in VALUES."
  (swank::with-buffer-syntax ()
    (swank::with-bindings *swank-pprint-bindings*
      (cond ((null values) "; No value")
            (t (with-output-to-string (*standard-output*)
                 (dolist (o values)
                   (pprint o)
                   (terpri))))))))

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
