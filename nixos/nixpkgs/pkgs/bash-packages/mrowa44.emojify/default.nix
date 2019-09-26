{ stdenv
, fetchFromGitHub
, coreutils
}:

let
  author = "mrowa44";
  package = "emojify";
in

stdenv.mkDerivation rec {
  name = "bash-${author}.${package}-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = author;
    repo = package;
    rev = "2bd4a6618b50d5e9930d7310fcd9cfb95869fe09";
    sha256 = "05rz5wybpajvv46nxxzrvcr0q510krihwldgwg742sqgkvk1a0fm";
  };

  buildInputs = [ coreutils ];

  patches = [ ./bash-bundler.patch ];

  postPatchPhase = ''
    substituteInPlace emojify --replace 'cat' '${coreutils}/bin/cat'
  '';

  installPhase = ''
    install -m 0444 -D emojify "$out/share/bashlib/${author}.${package}.bash"
  '';

  dontPatchELF = true;
  dontStrip = true;

  setupHook = builtins.toFile "setupHook.sh" ''
    export BASH_LIB_PATH="$BASH_LIB_PATH:@out@/share/bashlib"
  '';
}
