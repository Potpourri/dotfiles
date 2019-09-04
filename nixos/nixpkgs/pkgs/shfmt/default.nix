{ buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "shfmt";
  version = "3.0.0-alpha2";

  goPackagePath = "mvdan.cc/sh";
  subPackages = [ "cmd/shfmt" ];

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "0a56b9ab511e44991b6ed1dfb675b68cc747ec43";
    sha256 = "0647rls4cr9pcjlwr2m5za5bv3fhs3kam8g7b3xsk6pp4zgxzzsi";
  };

  goDeps = ./deps.nix;
}
