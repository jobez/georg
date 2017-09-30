(use-package :cm-ifs)

(include <ecl/ecl.h>)
(include <iostream>)
(include <fstream>)
(include "faust.h")
(include "ecl-helpers.h")
(load "helpers.lisp")

(with-interface (ecl-root)
  (namespace
   'ecl-root
   (function initialize_ecl ((int argc)
                             (char* argv[]))
       -> void

     (cl_boot argc argv)
     (atexit cl_shutdown)
     (#:faust::load-ecl-bindings)
     (load-embed-lisp "dream.lisp"))))
