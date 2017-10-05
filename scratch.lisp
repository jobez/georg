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
