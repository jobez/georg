;; -*- mode: Lisp; eval: (cm-mode 1); -*-
(use-package :cm-ifs)

;; (include <faust/midi/jack-midi.h>)
;; (include <faust/midi/rt-midi.h>)
;; (include <faust/midi/RtMidi.cpp>)
;; (include <faust/gui/PrintUI.h>)
;; (include <faust/gui/PathBuilder.h>)

(load "helpers.lisp")


(with-interface (faust)
  (interface-only
   (include <ecl/ecl.h>)
   (include <faust/dsp/dsp.h>)
   (include <faust/dsp/llvm-dsp.h>)
   (include <faust/dsp/poly-dsp.h>)
   (include <faust/audio/jack-dsp.h>))

  (implementation-only
   ;; (include <faust/gui/faustgtk.h>)
   (include <faust/gui/FUI.h>)
   (include <faust/gui/OSCUI.h>)
   (include <faust/gui/httpdUI.h>)
   (include "ecl-helpers.h"))

  (namespace
   'faust
   (implementation-only
    (decl ((jackaudio audio)
           (llvm_dsp_factory*
            dsp-factory)

           (dsp* DSP)
           (GUI* oscinterface)
           (httpdUI* httpdinterface)
           ((instantiate #:std::list (GUI*)) #:GUI::fGuiList)))
    (inject-syntax "ztimedmap GUI::gTimedZoneMap;")

    (gen-ecl-wrapper
     (function init-jack ()
         -> void
       (audio.init
        "georg")))

    (gen-ecl-wrapper
     (function str-to-dsp
         ((#:std::string dsp-str))
         -> void
       (decl ((#:std::string error-msg)
              ;; (GUI* interface = (new (GTKUI "georg" 0 0)))
              )
         (set dsp-factory
              (createDSPFactoryFromString
               "georgDSP"
               dsp-str
               0
               0
               ""
               error-msg))

         (<< #:std::cerr error-msg #:std::endl)
         (<< #:std::cout dsp-str #:std::endl)
         (set DSP (dsp-factory->createDSPInstance))
         ;; (DSP->buildUserInterface interface)



          )))

    (gen-ecl-wrapper
     (function build-interfaces ()
         -> void
       (decl ()
         (set oscinterface
              (new (OSCUI "georg"
                          0
                          0)))

         (set httpdinterface
              (new (httpdUI
                                               "georg"
                                               (DSP->getNumInputs)
                                               (DSP->getNumOutputs)
                                               0
                                               0)))
       (DSP->buildUserInterface oscinterface)
       (<< #:std::cout "osc-interface is on" #:std::endl)
       (DSP->buildUserInterface httpdinterface)
       (httpdinterface->run)
       (oscinterface->run)
       )))

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

    (gen-ecl-wrapper
     (function kill-interfaces ()
         -> void
       (httpdinterface->stop)
       (delete httpdinterface)))
    )

   (make-ecl-loader)
     ))
