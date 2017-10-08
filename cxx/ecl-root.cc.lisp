(use-package :cm-ifs)

(load "helpers.lisp")

(with-interface (ecl-root)
  (include <ecl/ecl.h>)
  (include <iostream>)
  (include <fstream>)
  (implementation-only
   (include "faust.h")
   (include "ecl-helpers.h"))


  (namespace
   'ecl-root
   (function initialize_ecl ((int argc)
                             (char* argv[]))
       -> void

     (cl_boot argc argv)
     (atexit cl_shutdown)
     (#:faust::load-ecl-bindings)
     (load-embed-lisp "dream.lisp"))))
