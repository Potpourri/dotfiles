{ stdenv
, nix-prefetch-git
, jq
}:

stdenv.mkDerivation rec {
  name = "update-pinned-nixpkgs";
  version = "0.1.1";
  src = ./.;

  patchPhase = ''
    substituteInPlace update-pinned-nixpkgs --replace 'nix-prefetch-git' \
      '${nix-prefetch-git}/bin/nix-prefetch-git'
    substituteInPlace update-pinned-nixpkgs --replace 'jq' \
      '${jq}/bin/jq'
  '';

  installPhase = ''
    install -Dm755 update-pinned-nixpkgs $out/bin/update-pinned-nixpkgs
  '';
}
