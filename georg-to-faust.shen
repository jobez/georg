(datatype globals
  _______________________________________________
  emit-expression : (georg-expression --> string);

  _____________________________________________________________________
  emit-expression* : (georg-identifier --> georg-expression --> string);)

(datatype georg-identifier
  X : symbol;
  ====================
  X : georg-identifier;)

(datatype georg-term

  X : georg-identifier;
  _____________________
  X : georg-term;

  X : number;
  _______________
  X : georg-term;)

(datatype georg-expression

  Expression : (list georg-expression); !;
  ________________________________________
  Expression : georg-expression;

  Expression : (list georg-expression) >> P; !;
  _____________________________________________
  Expression : georg-expression >> P;

  Expression : georg-expression; !;
  Expressions : (list georg-expression); !;
  ______________________________________________
  [Expression | Expressions] : georg-expression;

  Expression : georg-expression >> P; !;
  Expressions : (list georg-expression) >> P; !;
  ___________________________________________________
  [Expression | Expressions] : georg-expression >> P;

  Operator : georg-identifier;
  Operands : (list georg-expression);
  ==============================================
  [p Operator | Operands] : georg-expression;

  Operator : georg-identifier;
  Operands : (list georg-expression);
  ==============================================
  [in Operator | Operands] : georg-expression;

  X : georg-term;
  ______________________________________________
  X : georg-expression;

  __________________________________
  [] : georg-expression;

  Terms : (list georg-term);
  ===============================================
  Terms : georg-expression;

  Term : georg-term;
  Terms : (list georg-term);
  ==================================
  [Term | Terms] : georg-expression;)

(define georg-op->faust-expr
  {georg-identifier --> string}
  add -> "+"
  subtract -> "-"
  multiply -> "*"
  divide -> "/"
  exponentiate -> "pow"
  cut -> "!"
  modulo -> "%"
  delay-one -> "mem"
  delay -> "@"
  in-series -> "seq"
  in-parallel -> "par"
  split -> "<:"
  merge -> ":>"
  recurse -> "~"
  less-than -> "<"
  less-than-equal -> "<="
  greater-than -> ">"
  greater-than-equal -> ">="
  equal -> "=="
  not-equal -> "!="
  comma -> " ,"
  X -> (make-string "~A" X))

(datatype georg-definition

  Package : string;
  ______________________________________________
  [import Package] : georg-definition;

  Identifier : symbol;
  Expression : georg-expression;
  ===============================================
  [let Identifier Expression] : georg-definition;

  Identifier : symbol;
  Parameters : (list georg-term);
  Expression : georg-expression;
  =============================================================
  [flet Identifier [Parameters Expression]] : georg-definition;

  _____________________________________
  [] : georg-definition;

  GeorgDefs : (list georg-definition);
  ____________________________
  GeorgDefs : georg-definition;


  GeorgDefs : (list georg-definition) >> P; !;
  ____________________________________________
  GeorgDefs : georg-definition >> P;

  \* GeorgDef : georg-definition; *\
  \* GeorgDefs : (list georg-definition); *\
  \* ==================================== *\
  \* [GeorgDef | GeorgDefs] : georg-definition; *\
  )

(define emit-expression
  {georg-expression --> string}

  [declare Key Value] -> (make-string "declare ~A ~S;~%" Key Value)

  [p Op | Operands] -> (make-string "~A(~A)"
                                        (georg-op->faust-expr Op)
                                        (emit-expression* comma Operands))
  [in Op | Operands] -> (emit-expression* Op Operands)

  [GeorgTerm | GeorgTerms] -> (@s (emit-expression GeorgTerm)
                                  (emit-expression GeorgTerms))

  [] -> ""

  X -> (make-string "~A" X))

(define emit-expression*
  {georg-identifier --> georg-expression --> string}
  _ [] -> ""

  Sep [Term | []] -> (emit-expression Term)

  Sep [Term | Terms] -> (if (= Sep comma)
                            (@s
                             (emit-expression Term)
                             ","
                             (emit-expression* comma Terms))
                            (@s
                             (emit-expression Term)
                             " "
                             (georg-op->faust-expr Sep)
                             " "
                             (emit-expression* Sep
                                               Terms))))



(define emit-definition
  {georg-definition --> string}

  [import Package] -> (make-string "import(~S);~%" Package)

  [let Id Expr] -> (make-string "~A = ~A;~%"
                                Id
                                (emit-expression  Expr))

  [flet Id [Params Expr]] -> (make-string "~A(~A) = ~A;"
                                          Id
                                          (emit-expression* comma Params)
                                          (emit-expression Expr))

  [Def | Defs] -> (@s (emit-definition Def)
                      (emit-definition Defs))

  [] -> "")
