with import <nixpkgs> {};
let
in stdenv.mkDerivation rec {
  name = "georg";
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
    # gtk2
    glib
    # qt4
  ];
  shellHook = ''
export PATH=$PATH:/home/jmsb/exps/langs/lisp/common/compilec/c-mera

'';
}
#
