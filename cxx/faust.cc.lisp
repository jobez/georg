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
   (include <faust/dsp/timed-dsp.h>)
   (include <faust/dsp/llvm-dsp.h>)
   (include <faust/dsp/poly-dsp.h>)
   (include <faust/dsp/dsp-combiner.h>)
   (include "audio.h"))

  (implementation-only
   ;; (include <faust/gui/faustgtk.h>)
   (include <faust/gui/FUI.h>)
   (include <faust/gui/OSCUI.h>)
   (include <faust/gui/httpdUI.h>)

   (include <faust/gui/MidiUI.h>)
   (include <faust/midi/rt-midi.h>)
   (include <faust/midi/RtMidi.cpp>)

   (include "ecl-helpers.h"))

  (namespace
   'faust
   (implementation-only
    (decl ((GeorgAudio audio)
           (MidiUI* midiinterface)
           (llvm_dsp_factory*
            dsp-factory)
           (mydsp_poly* dsp_poly = #\NULL)
           (dsp* DSP)
           (GUI* oscinterface)
           (httpdUI* httpdinterface)
           ((instantiate #:std::list (GUI*)) #:GUI::fGuiList)))
    (inject-syntax "ztimedmap GUI::gTimedZoneMap;")

    (gen-ecl-wrapper
     (function str-to-dsp
         ((#:std::string dsp-str))
         -> void
       (decl ((#:std::string error-msg))
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

         (set dsp_poly (new (mydsp_poly (dsp-factory->createDSPInstance) 8 true 1)))
         ;; (set DSP (new (timed_dsp
         ;;                dsp_poly)))

         (set DSP (dsp-factory->createDSPInstance))

         )))

    (gen-ecl-wrapper
     (function init-jack-midi ()
         -> void
       (audio.init
        "georg" DSP true)))

    (gen-ecl-wrapper
     (function init-jack ()
         -> void
       (audio.init
        "georg" DSP)))

    (gen-ecl-wrapper
     (function build-interfaces ()
         -> void

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

       (set midiinterface (new (MidiUI &audio)))

       (DSP->buildUserInterface midiinterface)

       (DSP->buildUserInterface oscinterface)

       (<< #:std::cout "osc-interface is on" #:std::endl)

       (DSP->buildUserInterface httpdinterface)

       (midiinterface->run)

       (httpdinterface->run)

       (oscinterface->run)))

    (gen-ecl-wrapper
     (function connect-dsp ()
         -> void
       (audio.setDsp DSP)))

    (gen-ecl-wrapper
     (function update-dsp ()
         -> void
       (audio.updateDsp DSP)))

    (gen-ecl-wrapper
     (function play ()
         -> void
       (audio.addMidiIn dsp_poly)
       (audio.start)))

    (gen-ecl-wrapper
     (function stop ()
         -> void
       (audio.stop)))

    (gen-ecl-wrapper
     (function kill-dsp ()
         -> void
       (delete DSP)))

    (gen-ecl-wrapper
     (function kill-interfaces ()
         -> void
       (httpdinterface->stop)
       (oscinterface->stop)
       (midiinterface->stop)
       ;; (delete midiinterface)
       (delete httpdinterface)
       (delete oscinterface)))
    )

   (make-ecl-loader)
     ))
