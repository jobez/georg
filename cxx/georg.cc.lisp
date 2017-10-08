; -*- mode: Lisp; eval: (cm-mode 1); -*-
(use-package :cm-ifs)

(with-interface (georg)
  (include <iostream>)
  (include <cstdlib>)
  (include <fstream>)
  (interface-only
   (include "ecl-root.h"))


  (using-namespace std)

  (function main ((int argc)
                  (char* argv[]))
      -> int
    (#:ecl_root::initialize-ecl argc argv)
    (while 1

      )))
