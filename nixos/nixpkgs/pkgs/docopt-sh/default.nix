{ python37Packages
}:

python37Packages.buildPythonPackage rec {
  pname = "docopt-sh";
  version = "0.9.15";

  src = python37Packages.fetchPypi {
    inherit pname version;
    sha256 = "1k0fxivc803ayc32r6vxxip0xsg6bjw38m6kkf12r0crnz47jghl";
  };

  propagatedBuildInputs = with python37Packages; [
    docopt
    termcolor
  ];

  doCheck = false;
}
