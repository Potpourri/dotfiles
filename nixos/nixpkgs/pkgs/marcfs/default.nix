{
  stdenv,
  fetchgit,
  curl,
  fuse3,
  jsoncpp,
  cmake
}:

stdenv.mkDerivation rec {
  name = "marcfs-${version}";
  version = "0.6.0";

  src = fetchgit {
    url = https://gitlab.com/Kanedias/MARC-FS.git;
    fetchSubmodules = true;
    rev = "788319665a1679b2240b384d77caba9fbf13b34e";
    sha256 = "1j7b0yaqyd833s37z5pww0wvxwj7xyrx4zhcsr647wcr5q9xzpzi";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    fuse3
    jsoncpp
  ];
}
