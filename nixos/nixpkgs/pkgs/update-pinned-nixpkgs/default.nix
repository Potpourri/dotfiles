{ stdenv
, nix-prefetch-git
}:

stdenv.mkDerivation rec {
  name = "update-pinned-nixpkgs";
  version = "0.1.0";
  src = ./.;

  buildInputs = [ nix-prefetch-git ];

  installPhase = ''
    install -Dm755 $src/update-pinned-nixpkgs $out/bin/update-pinned-nixpkgs
  '';
}
