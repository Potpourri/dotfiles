{ stdenv
, fetchFromGitHub
, coreutils
, gnused
, gawk
, gnugrep
}:

let
  author = "mclarkson";
  package = "jsonpath";
in

stdenv.mkDerivation rec {
  name = "bash-${author}.${package}-${version}";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = author;
    repo = "JSONPath.sh";
    rev = "086eb5d8a589c705931f318d3ef9f201f025946f";
    sha256 = "0chl4wqxvdyjxvsqg5k097vryqhmr7hr2nf3yay2d7nxddippwyv";
  };

  buildInputs = [
    coreutils
    gnused
    gawk
    gnugrep
  ];

  patches = [
    ./bash-bundler.patch
    ./shellcheck.patch
  ];

  postPatchPhase = ''
    substituteInPlace JSONPath.sh --replace 'cat' '${coreutils}/bin/cat'
    substituteInPlace JSONPath.sh --replace 'seq' '${coreutils}/bin/seq'
    substituteInPlace JSONPath.sh --replace 'sed' '${gnused}/bin/sed'
    substituteInPlace JSONPath.sh --replace 'awk' '${gawk}/bin/cat'
    substituteInPlace JSONPath.sh --replace 'grep' '${gnugrep}/bin/grep'
  '';

  installPhase = ''
    install -m 0444 -D JSONPath.sh "$out/share/bashlib/${author}.${package}.bash"
  '';

  dontPatchELF = true;
  dontStrip = true;

  setupHook = builtins.toFile "setupHook.sh" ''
    export BASH_LIB_PATH="$BASH_LIB_PATH:@out@/share/bashlib"
  '';
}
