{
  stdenv,
  fetchFromGitHub,
  libuv,
  lz4,
  zlib
}:

stdenv.mkDerivation rec {
  name = "maxcso-${version}";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "unknownbrackets";
    repo = "maxcso";
    rev = "0009369dba6ab614f24b7e80913bc7dab5904af8";
    sha256 = "16vpylzkn1p50qfxlh6sj2045dm4m51ir8qkl42qf1kh8l93qs9k";
  };

  buildInputs = [
    libuv
    lz4
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv maxcso $out/bin
  '';
}
