{
  pkgs,
  inputs,
  ...
}:

let
  version = "24.05";
in
{
  imports = [
    inputs.hardware-configuration.outPath
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment = {
    systemPackages = with pkgs; [
      git
    ];
    sessionVariables = {
      RUSTFLAGS = "-C linker=clang -C link-arg=-fuse-ld=${pkgs.mold}/bin/mold";
    };
    # enable completion for system packages
    pathsToLink = [ "/share/zsh" ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono NF" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Emoji" ];
      };
    };
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  security.sudo.wheelNeedsPassword = false;

  users = {
    defaultUserShell = pkgs.zsh;
    users.e = {
      initialPassword = "e";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  # required to be able to set zsh as default shell for users
  programs.zsh.enable = true;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    tcp.enable = true;
  };

  networking = {
    hostName = "nixos";
    firewall.enable = true;
    wireless.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      windowManager.i3 = {
        enable = true;
      };
      autoRepeatDelay = 200;
      autoRepeatInterval = 25;
      xkb.layout = "us";
    };

    libinput.enable = true;

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

  };

  fileSystems."/".options = [
    "noatime"
    "nodiratime"
    "discard"
  ];

  boot = {
    kernelParams = [
      "intel_pstate=no_hwp"
      "quiet"
      "splash"
    ];
    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-partlabel/luks_root";
  };

  system.stateVersion = version;
}
