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
  name    = "ATS2-Postiats-gmp-${version}";
  inherit version;

  src = fetchgit {
    url = https://github.com/githwxi/ATS-Postiats.git;
    rev = "6034e714794a767870b366ee85406a8269fb1996";
    sha256 = "15kbagqhbzbsv23559lc18ymkkhc2b4xkymbdk93fvg2xxiva02k";
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
