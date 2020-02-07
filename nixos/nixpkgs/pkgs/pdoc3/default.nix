{ python37Packages }:

python37Packages.buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.7.4";

  src = python37Packages.fetchPypi {
    inherit pname version;
    sha256 = "01dbjd1fazpm5i1711052naymrd5gf4hp38s1rn9ghp8n7b974qs";
  };

  propagatedBuildInputs = with python37Packages; [
    setuptools_scm
    setuptools-git
    Mako
    markdown
  ];
}
