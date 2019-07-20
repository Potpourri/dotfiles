{ fetchFromGitHub
, python3Packages
, makeWrapper
}:

python3Packages.buildPythonPackage rec {
  pname = "warcat";
  version = "2.2.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "chfoo";
    repo = "warcat";
    sha256 = "1dd3bc1sv23yzrb3xjxwcw0z071x9sp1q9c17b4f5silpa0j61rh";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ python3Packages.isodate ];

  postInstall = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/warcat \
      --set PYTHONPATH "$PYTHONPATH:$out/share/warcat" \
      --add-flags "-m warcat"
  '';
}
