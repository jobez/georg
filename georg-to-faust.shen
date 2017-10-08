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

  X : georg-identifier; !;
  _____________________
  X : georg-term;

  X : string; !;
  _______________
  X : georg-term;

  X : number; !;
  _______________
  X : georg-term;)

(datatype georg-expression

  ______________________
  [] : georg-expression;

  Expressions : (list georg-expression); !;
  _________________________________________
  Expressions : georg-expression;

  Expressions : (list georg-expression) >> P; !;
  _________________________________________
  Expressions : georg-expression >> P;

  Operator : georg-identifier;
  Operands : (list georg-expression); !;
  ___________________________________________
  [p Operator | Operands] : georg-expression;

  Operator : georg-identifier,
  Operands : (list georg-expression) >> P; !;
  _______________________________________________
  [p Operator | Operands] : georg-expression >> P;

  X : georg-term; !;
  ____________________
  X : georg-expression;

  X : georg-term >> P; !;
  __________________________
  X : georg-expression >> P;

  Terms : (list georg-term); !;
  _________________________
  Terms : georg-expression;

  Operator : georg-identifier;
  Operands : (list georg-expression); !;
  _________________________________________________
  [in Operator | Operands] : georg-expression;

  Operator : georg-identifier,
  Operands : (list georg-expression) >> P; !;
  _________________________________________________
  [in Operator | Operands] : georg-expression >> P;

  Integer : number;
  Fractional : number;
  ==============================================
  [f Integer Fractional] : georg-expression;)

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
  series -> ":"
  parallel -> "par"
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
  GeorgDefs : georg-definition >> P;)

(define emit-expression
  {georg-expression --> string}
  [f Integer Fractional] -> (make-string "~A.~A" Integer Fractional)
  \* [dec Key Value] -> (make-string "declare ~A ~S;~%" Key Value)  *\

  [p Op | Operands] -> (make-string "~A(~A)"
                                    (georg-op->faust-expr Op)
                                    (emit-expression* comma Operands))
  [in Op | Operands] -> (emit-expression* Op Operands)

  [GeorgTerm | GeorgTerms] -> (@s (emit-expression GeorgTerm)
                                  (emit-expression GeorgTerms))

  [] -> ""
  X -> (make-string "~S" X) where (string? X)
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


\***** import is a statement, as is declare *****\
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
