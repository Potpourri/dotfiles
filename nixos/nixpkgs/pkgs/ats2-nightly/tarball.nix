{
  stdenv,
  fetchgit,
  gmp,
  ats,
  autoconf,
  automake,
  version
}:

stdenv.mkDerivation rec {
  name = "ATS2-Postiats-gmp-${version}";
  inherit version;

  src = fetchgit {
    url = https://github.com/githwxi/ATS-Postiats.git;
    rev = "3efbfb4e4a9e1ef51dd5553fe6970a955580020c";
    sha256 = "14qsh6q1grigxc2w71955l2jyqyv8hnyjwsxa4c1k55xb7mjxwv6";
  };

  buildInputs = [
    autoconf
    automake
    gmp
  ];

  ATSHOME = "${ats}/lib/ats-anairiats-${ats.version}";
  ATSHOMERELOC = "ATS-${ats.version}";

  patchPhase = ''
    patchShebangs doc/DISTRIB/ATS-Postiats/autogen.sh
    substituteInPlace doc/DISTRIB/ATS-Postiats/configure.ac --replace "[0.3.13]" "[${version}]"
  '';

  configurePhase = ''
    export PATSHOME=$PWD
    make -f codegen/Makefile_atslib
  '';

  buildPhase = ''
    make -C src all C3NSTRINTKND=gmpknd
    make -C src CBOOTgmp
    make -C src/CBOOT/libc
    make -C src/CBOOT/libats
    make -C src/CBOOT/prelude
    make -C doc/DISTRIB atspackaging
    cp -r utils/myatscc/node_modules doc/DISTRIB/ATS-Postiats/utils/myatscc/
    cp bin/* doc/DISTRIB/ATS-Postiats/bin/
    make -C doc/DISTRIB atspacktarzvcf_gmp
  '';

  installPhase = "mv doc/DISTRIB/${name} $out";

  meta = with stdenv.lib; {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
}
