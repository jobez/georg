with import <nixpkgs> {};
let
in stdenv.mkDerivation rec {
  ffiPath = "${libffi.dev}/include";
  name = "faust-riffs";
  buildInputs = [
    ecl
    jack2Full
    llvm_4
    libffi
    gmp
    alsaLib
    pkgconfig
    boehmgc
    faust2
  ];
  shellHook = ''
export PATH=$PATH:/home/jmsb/exps/langs/lisp/common/compilec/c-mera

'';
}
