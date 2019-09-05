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
    nvidia_x11_beta = callPackage (import <nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix> {
      version = "435.17";
      sha256_64bit = "19p9v5km1kfw45ghqmzgawa2fdq559jj6h1dkbnkbbzhp2syq757";
      settingsSha256 = "1i3bmsrgzwpahsgxyffly2hipxbparnr63c1xvb63wmivbad3fg9";
      persistencedSha256 = "0pifk6nzbyr08hs6229v91jnawg0dgfcqyv1n4yl2fbaqcrw1bfq";
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

  #WORKAROUND: https://github.com/NixOS/nixpkgs/pull/61735
  passff-host = super.passff-host.overrideAttrs(oldA: rec {
    name = "passff-host-${version}";
    version = "1.2.1";
    src = super.fetchFromGitHub {
      owner = "passff";
      repo = "passff-host";
      rev = version;
      sha256 = "0ydfwvhgnw5c3ydx2gn5d7ys9g7cxlck57vfddpv6ix890v21451";
    };
    patchPhase = ''
      sed -i 's#COMMAND = "pass"#COMMAND = "${self.myPass}/bin/pass"#' src/passff.py
      substituteInPlace src/passff.py --replace '"PATH"' '#"PATH"'
    '';
    preBuild = null;
    postBuild = null;
  });

  #WORKAROUND: only > 3.0.0-alpha2 support color output
  shfmt = callPackage ../pkgs/shfmt { };

  # new packages

  #WORKAROUND: compile emms-print-metadata
  emacs-emms = super.emacsPackagesNg.melpaBuild rec {
    pname = "emms";
    version = "5.2";
    src = super.fetchgit {
      url = https://git.savannah.gnu.org/git/emms.git;
      rev = version;
      sha256 = "0r0ai788mn5f3kf5wrp6jywncl2z3gpjif41pm5m0892y7l0vh9i";
    };
    buildInputs = [ super.taglib ];
    preBuild = ''
      make emms-print-metadata
      install -m 755 -D src/emms-print-metadata $out/bin/emms-print-metadata
    '';
    recipe = super.writeText "recipe" ''
      (emms
       :url "https://git.savannah.gnu.org/git/emms.git"
       :fetcher git
       :files ("lisp/*.el" "doc/emms.texinfo"))
    '';
    packageRequires = [
      super.mpg321
      super.mpv
    ];
  };

  myEmacs = super.emacsWithPackages(epkgs: [
    epkgs.pdf-tools
    super.editorconfig-core-c
    self.emacs-emms
    # Flycheck:
    self.ats2-nightly
    # Djvu viewer:
    super.djvulibre
    super.python3
    # Image-Dired:
    super.imagemagick7
    super.exiftool
    super.libjpeg
  ]);

  myGHC = super.haskellPackages.ghcWithPackages(hpkgs: (with hpkgs; [
    # for Agda:
    ieee754
    text
  ]));

  #WORKAROUND: expose bash completions for pass extensions
  passWithExtensions = exts: (super.pass.withExtensions exts).overrideAttrs(oldA: let
    extensionsEnv = lib.last oldA.buildInputs;
  in {
    preFixup = ''
      for f in ${extensionsEnv}/share/bash-completion/completions/*; do
        ln -s $f $out/share/bash-completion/completions/
      done
    '';
  });

  myPass = self.passWithExtensions (_: [
    (callPackage ../pkgs/pass/audit.nix { })
    (callPackage ../pkgs/pass/update.nix { })
  ]);

  marcfs = callPackage ../pkgs/marcfs { };

  maxcso = callPackage ../pkgs/maxcso { };

  padsc = callPackage ../pkgs/padsc { };

  ats2-nightly = callPackage ../pkgs/ats2-nightly { };

  warcat = callPackage ../pkgs/warcat { };

  wpull = callPackage ../pkgs/wpull { };

  #WORKAROUND: https://github.com/NixOS/nixpkgs/pull/52814
  python3 = let
    myOverride = {
      packageOverrides = self: super: {
        certauth = self.callPackage ../pkgs/python-modules/certauth { };
        lupa = self.callPackage ../pkgs/python-modules/lupa { };
        fakeredis = self.callPackage ../pkgs/python-modules/fakeredis { };
        portalocker = self.callPackage ../pkgs/python-modules/portalocker { };
        py3amf =self. callPackage ../pkgs/python-modules/py3amf { };
        surt = self.callPackage ../pkgs/python-modules/surt { };
        warcio = self.callPackage ../pkgs/python-modules/warcio { };
        wsgiprox = self.callPackage ../pkgs/python-modules/wsgiprox { };
        #WORKAROUND: new pkg - flake8 plugin
        flake8-tabs = self.callPackage ../pkgs/python-modules/flake8-tabs { };
        #WORKAROUND: new pkg - flake8 plugin
        flake8-mypy = self.callPackage ../pkgs/python-modules/flake8-mypy { };
        #WORKAROUND: new pkg - flake8 plugin
        flake8-docstrings = self.callPackage ../pkgs/python-modules/flake8-docstrings { };
      };
    };
  in
    super.python3.override myOverride;
  pywb = callPackage ../pkgs/pywb { };

  media-scripts = callPackage ../pkgs/media-scripts { };

  update-pinned-nixpkgs = callPackage ../pkgs/update-pinned-nixpkgs { };
}
