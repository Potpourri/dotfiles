{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08y5k39mn5a7n69wv0hsyjqb51lazs4i4dpxp42nla2lhllnpbyr";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    # Based on https://github.com/WoLpH/portalocker/blob/master/pytest.ini
    py.test --doctest-modules $(ls portalocker_tests/*.py | grep -v __init__.py)
  '';

  meta = with lib; {
    description = "Easy API to file locking";
    homepage = https://github.com/WoLpH/portalocker;
    license = licenses.psfl;
    maintainers = with maintainers; [ ivan ];
  };
}
