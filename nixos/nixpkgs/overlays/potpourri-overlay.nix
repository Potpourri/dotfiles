self: super:

let
  inherit (super)
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

  /*
  linuxPackages_latest = super.linuxPackages_latest.extend(_self: _super: {
    nvidia_x11 = callPackage (import ../pkgs/nvidia-x11/generic.nix {
      version = "415.25";
      sha256_64bit = "0jck3sjhkdf9j40fqa6hpm2m9i11bfka9diaxmk2apni4f4mpdk4";
      settingsSha256 = "0x5a9dhr29g67rbgl1w973fzgjfg1lyn3dpq7fpc7chfp91vxzrp";
      persistencedSha256 = "0z1d7hrz7zvi4x3ir1c3gcfpsj57wdr5pylvmjhdi3x47cb1w34f";
    }) {
      kernel = self.linuxPackages_latest.kernel;
    };
  });
  */

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

  retroarchBare = callPackage ../pkgs/retroarch {
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
