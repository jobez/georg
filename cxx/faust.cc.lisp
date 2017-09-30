;; -*- mode: Lisp; eval: (cm-mode 1); -*-
(use-package :cm-ifs)
(include <faust/dsp/dsp.h>)
(include <faust/dsp/llvm-dsp.h>)
(include <faust/audio/jack-dsp.h>)
(include <ecl/ecl.h>)
(include "ecl-helpers.h")

(load "helpers.lisp")
;; (include <faust/gui/UI.h>)
;; (include <faust/gui/PathBuilder.h>)

(with-interface (faust)
  (namespace
   'faust
   (decl ((jackaudio audio)
          (llvm_dsp_factory*
           dsp-factory)
          (dsp* DSP))

     (gen-ecl-wrapper
      (function init-jack ()
          -> void
        (audio.init
         "booboo")))

     (gen-ecl-wrapper
      (function str-to-dsp
          ((#:std::string dsp-str))
          -> void
        (decl ((#:std::string error-msg))
          (set dsp-factory
               (createDSPFactoryFromString
                "titi"
                dsp-str
                0
                0
                ""
                error-msg))

          (<< #:std::cerr error-msg #:std::endl)
          (<< #:std::cerr dsp-str #:std::endl)
          (set DSP (dsp-factory->createDSPInstance)))))

     (gen-ecl-wrapper
      (function connect-dsp ()
          -> void
        (audio.setDsp DSP)))

     (gen-ecl-wrapper
      (function play ()
          -> void
        (audio.start)))


     (gen-ecl-wrapper
      (function stop ()
          -> void
        (audio.stop)))

     (make-ecl-loader)
     )))
