(tc +)

(datatype globals

  ________________________________
  (value *statement-ops*) : (list symbol);
  ________________________________
  (value *el-ops*) : (list symbol);

  ___________________________________________
  (value *block-diagram-ops*) : (list symbol);

  _________________________________________
  (value *signal-type-ops*) : (list symbol);

  _______________________________________________
  (value *signal-comparison-ops*) : (list symbol);)

(set *statement-ops*
      [definition
       file-import
       declaration
       documentation])

(set *el-ops*
      [add
       subtract
       multiply
       divide
       exponentiate
       cut
       modulo
       delay-one
       delay])

(set *block-diagram-ops*
      [in-series
       in-parallel
       split
       merge
       recurse])

(set *signal-type-ops*
      [int
       float])

(set *signal-comparison-ops*
      [less-than
       less-than-equal
       greater-than
       greater-than-equal
       equal
       not-equal])

(datatype statement-op
  if (element? X (value *statement-ops*))
  _________________
  X : statement-op;)

(datatype el-op

  if (element? X (value *el-ops*))
  __________
  X : el-op;)

(datatype block-diagram-op

  if (element? X (value *block-diagram-ops*))
  _____________________
  X : block-diagram-op;)

(datatype signal-type-op
  if (element? X (value *signal-type-ops*))
  ___________________
  X : signal-type-op;)

(datatype signal-comparison-op
  if (element? X (value *signal-comparison-ops*))
  __________________________
  X : signal-comparison-op;)

(datatype georg-op

  X : block-diagram-op >> Y : A;
  ______________________________
  [georg-op X] : georg-op >> Y : A;

  X : block-diagram-op;
  ____________________
  [georg-op X] : georg-op;

  X : el-op >> Y : A;
  ________________________________
  [georg-op X] : georg-op >> Y : A;

  X : el-op;
  ________________________
  [georg-op X] : georg-op;

  X : signal-type-op >> Y : A;
  ________________________________
  [georg-op X] : georg-op >> Y : A;

  X : signal-type-op;
  _______________________
  [georg-op X] : georg-op;

  X : signal-comparison-op >> Y : A;
  __________________________________
  [georg-op X] : georg-op >> Y : A;

  X : signal-comparison-op;
  _________________________
  [georg-op X] : georg-op;
  )


(datatype prefix
  __________________________________
  (value *prefix*) : (list georg-op);)

(set *prefix*
      [[georg-op in-series]
       [georg-op in-parallel]
       [georg-op add]
       [georg-op multiply]])

(datatype georg-ref
  X : georg-op; !;
  _______________
  X : georg-ref;

  X : symbol; !;
  ______________
  X : georg-ref;

  X : symbol >> P; !;
  ___________________
  X : georg-ref >> P;)

(datatype georg-term

  X : georg-ref; !;
  ________________
  X : georg-term;

  X : number; !;
  _______________
  X : georg-term;)

(datatype georg-expression

  Georg-expr0 : georg-expression;
  Georg-expr1 : georg-expression;
  ===================================================
  [Georg-expr0 Georg-expr1] : georg-expression;

  Georg-op : georg-ref;
  Georg-lhs : georg-expression;
  Georg-rhs : georg-expression;
  ===================================================
  [Georg-lhs Georg-op Georg-rhs] : georg-expression;

  Georg-op : georg-ref;
  Georg-lhs : georg-expression;
  Georg-rhs : georg-expression;
  ===================================================
  [Georg-op Georg-lhs Georg-rhs] : georg-expression;


  GE : (list georg-expression);
  _____________________________
  GE : georg-expression;

  GE : georg-expression; GEs : (list georg-expression);
  ===================================================
  [GE | GEs] : georg-expression;

  GEs0 : georg-expression; GEs1 : georg-expression;
  ===================================================
  [GEs1 | GEs0] : georg-expression;




  X : georg-term; !;
  ____________________
  X : georg-expression;

  _____________________
  [] : georg-expression;

  )

(datatype verified-types
  ________________________________________
  (symbol? Var) : verified >> Var : symbol;

  _____________________________________
  (number? N) : verified >> N : number;

  L : (list A);
  ___________________________________
  (element? X L) : verified >> X : A;)


\* bitwise operations for integer signals *\
\* foreign constants & variables *\
\* foreign functions *\

(define georg-op->faust-expr
  {georg-term --> string}
  add -> "sum"
  subtract -> "-"
  multiply -> "prod"
  divide -> "/"
  exponentiate -> "pow"
  cut -> "!"
  modulo -> "%"
  delay-one -> "mem"
  delay -> "@"
  in-series -> "seq"
  in-parallel -> "par"
  plit -> "<:"
  merge -> ":>"
  recurse -> "~"
  less-than -> "<"
  less-than-equal -> "<="
  greater-than -> ">"
  greater-than-equal -> ">="
  equal -> "=="
  not-equal -> "!="
  X -> (make-string "!~A" X))


(define fix-pass
  {georg-expression --> georg-expression}

  [Op X Y] -> [Op (fix-pass X) (fix-pass Y)] where (element?
                                                    Op
                                                    (type [in-series
                                                           in-parallel
                                                           add
                                                           multiply]
                                                          (list georg-term)))

  [Op X Y] -> [(fix-pass X) Op (fix-pass Y)] where (symbol? Op)
  [X | Y] -> [(fix-pass X) | (fix-pass Y)]
  X -> X)

(define assignment-pass
  {georg-expression --> georg-expression}
  [let [Lhs Rhs]] -> [Lhs = Rhs]
  [Lhs Rhs] -> [(assignment-pass Lhs)
                (assignment-pass Rhs)]

  [X | Y] -> [(assignment-pass X) | (assignment-pass Y)]

  X -> X)

(define emit-faust
  {georg-expression --> string}
  [Op Arg] -> (make-string "~A(~A)" Op Arg) where (symbol? Op)
  [X = Y] -> (make-string "~A ~A ~A; ~%"
                          (emit-faust X)
                          =
                          (emit-faust Y))

  [Op X Y] -> (make-string "~A(~A, ~A)"
                           (georg-op->faust-expr Op)
                           (emit-faust X)
                           (emit-faust Y)) where (element?
                                                  Op
                                                  (type [in-series
                                                         in-parallel
                                                         add
                                                         multiply]
                                                        (list georg-term)))

  [X Op Y] -> (make-string "~A ~A ~A"
                           (emit-faust X)
                           (georg-op->faust-expr Op)
                           (emit-faust Y)) where (symbol? Op)

  [Expr | Exprs] -> (@s (emit-faust Expr)
                        (emit-faust Exprs))




  [] -> ""
  X -> (make-string "~A" X))


(declare ecl-str-to-dsp [string --> number])

(ecl-str-to-dsp
 (emit-faust
  (assignment-pass
   (fix-pass
    [\* [let [random [recurse [add 12345 _] [multiply 1103515245 _]]]] *\
     \* [let [noise [divide random [float 2147483647]]]] *\
     [let [process 1]]]))))
