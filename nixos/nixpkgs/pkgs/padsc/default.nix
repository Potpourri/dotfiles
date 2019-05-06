{
  stdenv,
  makeWrapper,
  coreutils,
  perl,
  bison,
  yacc,
  smlnj
}:

stdenv.mkDerivation rec {
  name = "padsc-${version}";
  version = "2.01";

  src = /home/john/Projects/pads;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    perl
    bison
    yacc
    smlnj
  ];

  patchPhase = ''
    patchShebangs scripts/removepadsparts.pl
    patchShebangs scripts/removedups.pl
    patchShebangs scripts/getprobeinfo.pl
    patchShebangs scripts/mksrc.pl
    patchShebangs scripts/stripnlnl.pl
    patchShebangs scripts/addnl.pl

    substituteInPlace scripts/opsys --replace '`uname' '`${coreutils}/bin/uname'
    substituteInPlace scripts/arch-n-opsys --replace '`uname' '`${coreutils}/bin/uname'
  '';

  configurePhase = "echo Skip configure phase";

  buildPhase = ''
    export PADS_HOME=$PWD
    . scripts/Q_DO_SETENV.sh
    make
  '';

  installPhase = ''
    find . -name \*.o -delete
    mkdir $out
    mv scripts ast-ast padsc lib $out/
    wrapProgram $out/scripts/padsc --prefix PATH ":" ${smlnj}/bin
  '';

  dontPatchELF = true;
  dontStrip = true;

  setupHook = builtins.toFile "setupHook.sh" ''
    export PADS_HOME=@out@
    . $PADS_HOME/scripts/Q_DO_SETENV.sh
  '';
}
