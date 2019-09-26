{ stdenv
, fetchFromGitHub
}:

let
  author = "fidian";
  package = "ansi";
in

stdenv.mkDerivation rec {
  name = "bash-${author}.${package}-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = author;
    repo = package;
    rev = version;
    sha256 = "05nj48ycqlqr53hbsqg0kzq2sng8p0m7mypgag3zmb718jp80vq4";
  };

  patches = [ ./bash-bundler.patch ];

  installPhase = ''
    install -m 0444 -D ansi "$out/share/bashlib/${author}.${package}.bash"
  '';

  dontPatchELF = true;
  dontStrip = true;

  setupHook = builtins.toFile "setupHook.sh" ''
    export BASH_LIB_PATH="$BASH_LIB_PATH:@out@/share/bashlib"
  '';
}
