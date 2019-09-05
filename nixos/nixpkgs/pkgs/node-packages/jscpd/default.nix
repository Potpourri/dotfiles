{ stdenv
, pkgs
}:

let
  version = "2.0.15";
in

(import ./jscpd.nix {
  inherit pkgs;
  inherit (stdenv.hostPlatform) system;
})."jscpd-${version}".override(oldA: {
  buildInputs = oldA.buildInputs ++ [ pkgs.nodePackages.node-gyp-build ];
})
