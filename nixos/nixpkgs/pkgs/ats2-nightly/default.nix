{
  stdenv,
  fetchgit,
  callPackage,
  gmp,
  autoconf,
  automake
}:

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = "0.4.0";

  src = callPackage ./tarball.nix { inherit version; };

  buildInputs = [
    autoconf
    automake
    gmp
  ];

  setupHook = builtins.toFile "setupHook.sh"
    "export PATSHOME=@out@/lib/ats2-postiats-@version@";

  meta = with stdenv.lib; {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
}
