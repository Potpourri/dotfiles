{ lib
, fetchFromGitHub
, buildPythonPackage
, flake8
, mypy
, attrs
}:

buildPythonPackage rec {
  pname = "flake8-mypy";
  version = "17.8.0";

  src = fetchFromGitHub {
    owner = "ambv";
    repo = "flake8-mypy";
    rev = "616eeb98092edfa0affc00c6cf4f7073f4de26a6";
    sha256 = "0w18inyv97qfv72dw7vbhr33skaggxpjs5yn3012ch42jmwwsrbd";
  };

  propagatedBuildInputs = [
    flake8
    mypy
    attrs
  ];

  doCheck = false;
}
