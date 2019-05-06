# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }:

let
  secrets = import ../../secrets/nixos/secrets.nix;
in

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [ (import nixpkgs/overlays/potpourri-overlay.nix) ];
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
      pulseaudio = true;
    };
  };

  system.stateVersion = "19.03";
  networking.hostName = "nixos";

  ##################################################################################################
  # Bootloader and kernel
  ##################################################################################################

  boot = {
    #kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
    loader = {
      timeout = 1;
      grub = {
        enable = true;
        version = 2;
        extraConfig = "set gfxpayload=keep;";
        gfxmodeBios = "1280x1024-32";
        devices = [
          "/dev/sda"
          "/dev/sdb"
        ];
      };
    };
  };

  ##################################################################################################
  # Internationalisation and date/time
  ##################################################################################################

  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    consoleUseXkbConfig = true;
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  time.timeZone = "Europe/Moscow";

  ##################################################################################################
  # Environment, term, shell and system packages list
  ##################################################################################################

  environment = {
    loginShellInit = "fbterm --font-size=17";
    variables = rec {
      VISUAL = "emacsclient";
      EDITOR = VISUAL;
    };
  };

  environment.systemPackages = with pkgs; [
    #######################################
    # Desktop environment
    #######################################
    myEmacs
    # for xdg-user-dirs-update
    xdg-user-dirs
    # for update-desktop-database
    desktop-file-utils
    gnome3.adwaita-icon-theme
    #######################################
    # Services
    #######################################
    gnupg
    pinentry
    udiskie
    ncpamixer
    #######################################
    # GUI apps
    #######################################
    firefox-bin
    libreoffice-fresh
    #######################################
    # Shell/term apps
    #######################################
    wget
    tree
    git
    direnv
    # archivers:
    libarchive
    p7zip
    unrar
    maxcso
    # clouds:
    rclone
    marcfs
  ];

  #WORKAROUND: fbterm requires root privileges
  security.wrappers.fbterm = {
    source = "${pkgs.fbterm}/bin/fbterm";
    capabilities = "cap_sys_tty_config+ep";
  };

  programs.bash = {
    interactiveShellInit = ''
      PATH+=:~/Projects/dotfiles/scripts
      eval "$(direnv hook bash)"
    '';
    #WORKAROUND: fbterm's fix ($TERM = linux)
    promptInit = ''
      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" -o "$TERM" = "linux" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };

  ##################################################################################################
  # X11 server and desktop environment
  ##################################################################################################

  services.xserver = {
    enable = true;
    layout = "us,ru";
    # delay before key shuold be start repeating
    autoRepeatDelay = 200;
    # interval between repeating key
    autoRepeatInterval = 60;
    # Nvidia GeForce GT 710 driver
    videoDrivers = [ "nvidia" ];
    xkbOptions = "grp:lwin_toggle,grp_led:scroll,caps:swapescape";
    screenSection = ''
      Option "metamodes" "1280x1024_75 +0+0"
    '';
  };

  services.xserver.displayManager.slim = {
    enable = true;
    autoLogin = true;
    defaultUser = "john";
  };

  services.xserver.desktopManager = {
    default = "exwm";
    xterm.enable = false;
    session = lib.singleton {
      name = "exwm";
      start = ''
        xsetroot -cursor_name left_ptr
        export _JAVA_AWT_WM_NONREPARENTING=1
        XDG_DATA_DIRS+=:~/.local/share
        exec dbus-launch --exit-with-session emacs --fullscreen --eval "(exwm-enable)"
      '';
    };
  };

  systemd.user.services.gnome-settings-daemon = {
    enable = true;
    description = "gnome-settings-daemon for themes, etc";
    wantedBy = [ "default.target" ];
    path = [ pkgs.gnome3.gnome-settings-daemon ];
    after = [ "display-manager.service" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 2;
      ExecStart = "${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings";
    };
  };

  ##################################################################################################
  # Sound
  ##################################################################################################

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #WORKAROUND: https://github.com/NixOS/nixpkgs/issues/54387
  systemd.services.alsa-restore = {
    description = "Restore Sound Card State";
    wantedBy = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = "/var/lib/alsa";
    unitConfig.ConditionVirtualization = "!systemd-nspawn";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.alsaUtils}/sbin/alsactl restore 0";
    };
  };

  ##################################################################################################
  # Fonts
  ##################################################################################################

  fonts = {
    fonts = with pkgs; [
      source-serif-pro
      source-sans-pro
      source-code-pro
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif = [ "Source Serif Pro" ];
      };
      #WORKAROUND: ugly fonts in GTK's apps when penultimate enabled
      penultimate.enable = false;
      ultimate.enable = true;
    };
  };

  ##################################################################################################
  # System and user services
  ##################################################################################################

  services.printing = {
    enable = true;
    # Brother HL-2132R driver
    drivers = [ pkgs.brgenml1cupswrapper ];
  };

  services.apcupsd = {
    enable = true;
    # APC Back-UPS CS 350 config
    configText = ''
      UPSCABLE usb
      UPSTYPE usb
      BATTERYLEVEL 15
      MINUTES 1
    '';
  };

  systemd.user.services.udiskie = {
    enable = true;
    description = "udiskie to automount removable media";
    wantedBy = [ "default.target" ];
    path = [ pkgs.udiskie ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 2;
      ExecStart = "${pkgs.udiskie}/bin/udiskie --no-notify --no-file-manager";
    };
  };

  networking.firewall.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.transmission = {
    enable = true;
    settings.incomplete-dir-enabled = true;
  };

  programs.adb.enable = true;

  ##################################################################################################
  # Virtualisation
  ##################################################################################################

  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host = {
    enable = true;
    #WORKAROUND: https://github.com/NixOS/nixpkgs/issues/24512
    enableHardening = false;
    enableExtensionPack = true;
  };

  ##################################################################################################
  # Define users
  ##################################################################################################

  users = {
    mutableUsers = false;
    extraUsers.john = {
      isNormalUser = true;
      uid = 1000;
      hashedPassword = secrets.johnHashedPassword;
      shell = pkgs.bashInteractive;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "adbusers"
        "docker"
        "vboxusers"
        "transmission"
      ];
    };
  };

  services.mingetty.autologinUser = "john";
  # don't use root as authenticating user
  security.polkit.adminIdentities = [ "unix-group:wheel" ];
}