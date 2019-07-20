{ fetchFromGitHub
, python36Packages
}:

python36Packages.buildPythonPackage rec {
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

  propagatedBuildInputs = with python36Packages; [
    chardet
    dnspython
    html5lib
    namedlist
    sqlalchemy
    tornado_4
    Yapsy
  ];

  # Test suite has tests that fail on all platforms
  doCheck = false;
}
