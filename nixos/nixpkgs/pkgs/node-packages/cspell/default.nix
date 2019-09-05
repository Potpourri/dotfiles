{ stdenv
, pkgs
}:

let
  version = "4.0.28";
in

(import ./cspell.nix {
  inherit pkgs;
  inherit (stdenv.hostPlatform) system;
})."cspell-${version}"
