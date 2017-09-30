; -*- mode: Lisp; eval: (cm-mode 1); -*-
(use-package :cm-ifs)

(include <ecl/ecl.h>)
(include <iostream>)
(include <fstream>)


(load "helpers.lisp")

(with-interface (ecl-helpers)
  (namespace
   'ecl-helpers

   (function cl-str-to-str ((cl_object cl-str))
       -> #:std::string
     (decl ((int j = cl-str->string.dim)
            (ecl_character* selv = cl-str->string.self)
            (#:std::string str {""}))

       (for ((int i = 0)
             (< i j)
             (set i (+ i 1)))
         ;; (set str (+ str (+ selv i)))
         (normie-syntax "str += (*(selv+i));"))
       (return str)))

   (function call-lisp ((const #:std:string &call))
       ->
       void
     (cl_eval (c_string_to_object (call.c_str))))))
