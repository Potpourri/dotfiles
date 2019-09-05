{ lib
, fetchPypi
, buildPythonPackage
, flake8
, pydocstyle
}:

buildPythonPackage rec {
  pname = "flake8-docstrings";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01ns1hfb8in55xzjs9g0b679dgr6i9f7df2kvw7xgzqskakva3cw";
  };

  propagatedBuildInputs = [
    flake8
    pydocstyle
  ];
}
