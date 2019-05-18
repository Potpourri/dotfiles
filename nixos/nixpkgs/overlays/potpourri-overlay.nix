self: super:

let
  inherit (super)
    lib
    callPackage
    fetchurl;
in

{
  # override packages

  /*
  linux_4_20 = super.linux_4_20.override({
    argsOverride = rec {
      version = "4.20";
      modDirVersion = concatStrings (intersperse "." (take 3 (splitString "." "${version}.0")));
      extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));
      src = fetchurl {
        url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
        sha256 = "0f14l6mb5c4rwpqjbcb2yrvk1bmmiyh0mpw24fbl7rr26lc2625d";
      };
      kernelPatches = with super.kernelPatches; [
        bridge_stp_helper
        modinst_arg_list_too_long
      ];
    };
  });
  */

  linuxPackages_latest = super.linuxPackages_latest.extend(_self: _super: {
    nvidia_x11 = callPackage (import <nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix> {
      version = "418.74";
      sha256_64bit = "03qj42ppzkc9nphdr9zc12968bb8fc9cpcx5f66y29wnrgg3d1yw";
      settingsSha256 = "15mbqdx5wyk7iq13kl2vd99lykpil618izwpi1kfldlabxdxsi9d";
      persistencedSha256 = "0442qbby0r1b6l72wyw0b3iwvln6k20s6dn0zqlpxafnia9bvc8c";
    }) {
      inherit (_self) kernel;
    };
  });

  /*
  linuxPackages_latest = super.linuxPackages_latest.extend(_self: _super: {
    virtualbox = _super.virtualbox.overrideAttrs(oldA: {
      patches = [
        ../pkgs/virtualbox/fix_kerndir.patch
        ../pkgs/virtualbox/fix_kbuild.patch
      ];
    });
  });
  virtualbox = callPackage ../pkgs/virtualbox {
    stdenv = super.stdenv_32bit;
    inherit (super.gnome2) libIDL;
    pulseSupport = true;
  };
  virtualboxExtpack = callPackage ../pkgs/virtualbox/extpack.nix { };
  */

  nwjs = callPackage ../pkgs/nwjs {
    gconf = super.gnome2.GConf;
  };

  retroarchBare = super.libsForQt5.callPackage ../pkgs/retroarch {
    inherit (super.darwin) libobjc;
    inherit (super.darwin.apple_sdk.frameworks) AppKit Foundation;
  };

  bazel = super.bazel.overrideAttrs(oldA: rec {
    name = "bazel-${version}";
    version = "0.24.1";
    src = fetchurl {
      url = "https://github.com/bazelbuild/bazel/releases/download/${version}/${name}-dist.zip";
      sha256 = "0m6dl1yjhb2n8bivlkyk0ri9xcs2iqbl85v22cl87b83j0cipsjn";
    };
  });

  # new packages

  myEmacs = super.emacsWithPackages(epkgs: [
    epkgs.pdf-tools
    super.djvulibre
    super.python3
    super.editorconfig-core-c
    self.ats2-nightly
  ]);

  myGHC = super.haskellPackages.ghcWithPackages(hpkgs: (with hpkgs; [
    ieee754
    text
  ]));

  marcfs = callPackage ../pkgs/marcfs { };

  maxcso = callPackage ../pkgs/maxcso { };

  padsc = callPackage ../pkgs/padsc { };

  ats2-nightly = callPackage ../pkgs/ats2-nightly { };
}
