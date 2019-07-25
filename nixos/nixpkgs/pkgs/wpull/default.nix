{ fetchFromGitHub
, python35Packages
}:

let
  html5lib_1_0b8 = python35Packages.html5lib.overridePythonAttrs(oldA: rec {
    name = "${oldA.pname}-${version}";
    version = "1.0b8";
    src = oldA.src.override {
      inherit version;
      sha256 = "1lknq5j3nh11xrl268ks76zaj0gyzh34v94n5vbf6dk8llzxdx0q";
    };
    doCheck = false;
  });

in

python35Packages.buildPythonPackage rec {
  pname = "wpull";
  version = "2.0.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "ArchiveTeam";
    repo = "wpull";
    sha256 = "0d0kx500l4c14b53p7p0v6za4rcc27s8g4mf5bb6n3s6xfvzz84v";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace dnspython3 dnspython
  '';

  propagatedBuildInputs = with python35Packages; [
    chardet
    dnspython
    html5lib_1_0b8
    namedlist
    sqlalchemy
    tornado_4
    Yapsy
  ];

  # Test suite has tests that fail on all platforms
  doCheck = false;
}
