(ql:quickload :metabang-bind)
(ql:quickload :iterate)
(ql:quickload :arrow-macros)
(ql:quickload :prove)


(uiop:define-package georg-user
    (:mix :cl-user
          :arrow-macros
          :metabang-bind
          :iterate
          :prove))

(in-package :georg-user)

(defmacro dsp (&rest expressions)
  (let ((*print-case* :downcase)))
  (format nil "~{~{~a~#[;~%~:; = ~]~}~}"
          expressions))

(format nil "~{~{~a~#[;~%~:; = ~]~}~}"
        (bind (((op &rest elements) '(, 1 2 3)))
          (mapcan
           (lambda (el)
             (list op el))
           elements)))

(dsp )


(dsp (random "+(12345)~*(1103515245)")
     (noise "random/2147483647.0")
     (process noise))

(- thing fang chang)



(cl-user::ecl-str-to-dsp
 (let ((*print-case* :))

   ))



(export #'cl-user::ecl-stop)

(defparameter elementary-signal-ops
  ('- * ^ ! % mem @))

;; arithmetic operations
(defparameter block-diagram-ops
    '(:series ":"
      :parallel ","
      :split "<:"
      :merge ":>"
      :recur "~"))

(defun expand-georg (expr)
  (cond ((atom expr)
         (if (keywordp expr)
             (getf block-diagram-ops expr)
             expr))
        (t (cons
            (expand-georg (car expr))
            (expand-georg (cdr expr))))))

(defun pre->in (expr)
  (bind (((op leftmost &rest args) expr))
    (->> (mapcan
          (lambda (arg)
            (if (atom arg)
                (list op arg)
                (pre->in arg)))
          args)
      (cons (cond-> leftmost
              (consp leftmost) pre->in)))))

;; one and the many

(defun expr->str (expr)
  (format nil (if (atom expr)
                  "~a"
                  "~{~a~}")
          expr))

(defstruct expression)

;; join expression expression

(defun reduce-expr (expr)
  (reduce
   (lambda (lhs rhs)
     (apply #'format nil "~a ~a"
            (mapcar #'expr->str
                    (list lhs rhs))))
          expr))

(is
 (let ((*print-case* :downcase))
   (->> '(:series
          (:parallel x y) ^)
     expand-georg
     pre->in
     reduce-expr))
 "x,y : ^")
