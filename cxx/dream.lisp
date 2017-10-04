(time (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                             (user-homedir-pathname))))
        (when (probe-file quicklisp-init)
          (load quicklisp-init))))

(load
 (asdf/system:system-relative-pathname :swank "start-swank.lisp")
 :verbose t)

(DEFUN SHEN ()
    (FORMAT T "~%~%Call (exit-shen) for leaving the Shen toplevel.~%~%")
    (FINISH-OUTPUT)
    (CATCH 'EXIT-SHEN
      (|shen.shen|)))

(ext:chdir "/home/jmsb/exps/langs/lisp/common/scratch/music/faust-riffs/ecl")
;; (SETF (READTABLE-CASE *READTABLE*) :PRESERVE)
(defvar |*language*| "Common Lisp")
(defvar |*implementation*| "ECL")
(defvar |*port*| 2.1)
(defvar |*porters*| "Mark Tarver")
(PROCLAIM '(OPTIMIZE (DEBUG 0) (SPEED 3) (SAFETY 0)))
(DEFCONSTANT COMPILED-SUFFIX ".fas")
(DEFCONSTANT OBJECT-SUFFIX ".o")
(DEFCONSTANT NATIVE-PATH "./ecl/")
(EXT:INSTALL-C-COMPILER)

(DEFPARAMETER *SHEN-READTABLE* (LET ((RT (COPY-READTABLE NIL)))
                                 (SETF (READTABLE-CASE RT) :PRESERVE)
                                 RT))
(let ((*READTABLE* *SHEN-READTABLE*))


  (DEFUN translate-kl (KlCode)
    (MAPCAR #'(LAMBDA (X) (shen.kl-to-lisp NIL X)) KlCode))

  (DEFUN write-lsp-file (File Code)
    (WITH-OPEN-FILE
        (Out File
             :DIRECTION         :OUTPUT
             :IF-EXISTS         :SUPERSEDE
             :IF-DOES-NOT-EXIST :CREATE)
      (FORMAT Out "~%")
      (MAPC #'(LAMBDA (X) (FORMAT Out "~S~%~%" X)) Code)
      File))

  (load "primitives.fas")
  (load "backend.fas")
  (load "toplevel.lsp")
  (load "core.fas")
  (load "sys.fas")
  (load "sequent.fas")
  (load "yacc.fas")
  (load "reader.fas")
  (load "prolog.fas")
  (load "track.fas")
  (load "load.fas")
  (load "writer.fas")
  (load "macros.fas")
  (load "declarations.fas")
  (load "types.lsp")
  (load "t-star.fas")
  (load "overwrite.fas")

  (DEFUN |exit-shen| ()
    (THROW 'EXIT-SHEN NIL)))


(DEFUN |stinput| () swank-repl::*standard-input*)
(DEFUN |stoutput| () |*stoutput*|)
(DEFUN |sterror| () |*sterror*|)
