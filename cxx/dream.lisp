(time (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                             (user-homedir-pathname))))
        (when (probe-file quicklisp-init)
          (load quicklisp-init))))

(load
 (asdf/system:system-relative-pathname :swank "start-swank.lisp")
 :verbose t)

(defun set-shen-interactive! (stream)
   ;; (|shen.initialise_environment|)
  (labels ((read-stream ()
             (let* ((input-str (gray:stream-read-line stream))
                    (input-octets-vec (swank/backend:string-to-utf8 input-str))
                    (input-octets
                     (map 'list #'identity input-octets-vec))
                    (compiled-line
                     (|compile| #'(LAMBDA (X) (|shen.<st_input>| X)) input-octets
                                #'(LAMBDA (E) '|shen.nextline|)))
                    (line-read (|@p| compiled-line input-octets)))
               line-read)))

    (setf |shen.*interactive-input*| #'read-stream)))

(load "../shen-swank.lisp")

(ext:chdir "/home/jmsb/exps/langs/lisp/common/scratch/music/georg/ecl")

(defvar |*language*| "Common Lisp")
(defvar |*implementation*| "ECL")
(defvar |*port*| 2.1)
(defvar |*porters*| "Mark Tarver")
(defvar |*shen.interactive-input*| (lambda ()))

(PROCLAIM '(OPTIMIZE (DEBUG 0) (SPEED 3) (SAFETY 3)))
(DEFCONSTANT COMPILED-SUFFIX ".fas")
(DEFCONSTANT OBJECT-SUFFIX ".o")
(DEFCONSTANT NATIVE-PATH "./ecl/")
;; (EXT:INSTALL-C-COMPILER)



(DEFPARAMETER *SHEN-READTABLE* (LET ((RT (COPY-READTABLE NIL)))
                                 (SETF (READTABLE-CASE RT) :PRESERVE)
                                 RT))
(let ((*READTABLE* *SHEN-READTABLE*))




  (load "primitives.fas")
  (load "backend.fas")
  (load "toplevel.fas")
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
  (load "types.fas")
  (load "t-star.fas")
  (load "overwrite.fas")

  (DEFUN |exit-shen| ()
    (THROW 'EXIT-SHEN NIL)))
