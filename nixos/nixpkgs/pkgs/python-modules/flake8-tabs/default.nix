{ lib
, fetchPypi
, buildPythonPackage
, flake8
}:

buildPythonPackage rec {
  pname = "flake8-tabs";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x05r9mx9l0wrkyl25cfrypn17bimkq55s7awkk3f01421869rrz";
  };

  propagatedBuildInputs = [ flake8 ];
}
