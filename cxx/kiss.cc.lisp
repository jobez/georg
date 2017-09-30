; -*- mode: Lisp; eval: (cm-mode 1); -*-
(use-package :cm-ifs)


(include <ecl/ecl.h>)
(include <iostream>)
(include <cstdlib>)
(include <fstream>)
(include "ecl-root.h")

(with-interface (kiss)
  (using-namespace std)

  (decl ((int elapsed = 0)
         (int maxtime = 3600))

   (function main ((int argc)
                   (char* argv[]))
       -> int
     (#:ecl_root::initialize-ecl argc argv)
     (while 1

       ))))
