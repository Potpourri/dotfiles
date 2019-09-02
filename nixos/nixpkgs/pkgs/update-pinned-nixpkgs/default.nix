{ stdenv
, nix-prefetch-git
}:

stdenv.mkDerivation rec {
  name = "update-pinned-nixpkgs";
  version = "0.1.0";
  src = ./.;

  patchPhase = ''
    substituteInPlace update-pinned-nixpkgs --replace 'nix-prefetch-git' \
      '${nix-prefetch-git}/bin/nix-prefetch-git'
  '';

  installPhase = ''
    install -Dm755 update-pinned-nixpkgs $out/bin/update-pinned-nixpkgs
  '';
}
