{ buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "conform";
  version = "v0.1.0-alpha.16";

  goPackagePath = "github.com/autonomy/conform";

  src = fetchFromGitHub {
    owner = "talos-systems";
    repo = pname;
    rev = "7bed9129bc73b5a6fd2b6d8c12f7c024ea4b7107";
    sha256 = "1wlv29822wz4x605pvdrx0y1d7pv21lwfay3hg2v011v6parzwij";
  };

  goDeps = ./deps.nix;
}
