# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, home-manager, ... }:

{
  # imports =
  #   [ # Include the results of the hardware scan.
  #     <home-manager/nixos>
  #   ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nix = {
  #   package = pkgs.nixUnstable;
  #   extraOptions = ''
  #     experimental-features = nix-command flakes
  #   '';
  # };

  # install with https://shen.hong.io/installing-nixos-with-encrypted-root-partition-and-seperate-boot-partition/
  boot = {
    loader = {
      timeout = null;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices.root = {
      device = "/dev/disk/by-partuuid/4f419ebd-2b49-4959-aa5f-46cfdd0cfc3e";
      header = "/dev/disk/by-partuuid/b0255c40-fd3c-4c95-9af7-4d64ad2e450f";
      allowDiscards = true;
    };
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  networking.hostName = "chn-nixos-test"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "C.UTF-8/UTF-8"];
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.waydroid.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # nixpkgs.hostPlatform = {
  #   system = "x86_64-linux";
  #   gcc.arch = "alderlake";
  #   gcc.tune = "alderlake";
  # };
  # nixpkgs.localSystem = {
  #   system = "x86_64-linux";
  #   platform = pkgs.lib.systems.platforms.pc64 {
  #     gcc.arch = "skylake";
  #     gcc.tune = "skylake";
  #   };
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chn = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$lhYtoAr6rqb$IKxf2/m8dgEFuOsvfNScRLTBWWDy51fdIKKkiibmRnLtFmA3dpZRalbm/5bfwittN.WKxkKr8vlvjM3SzfH141";
    shell = pkgs.zsh;
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim zsh wget tree gparted git
    zsh-powerlevel10k zsh-autosuggestions zsh-syntax-highlighting autojump
    nix-output-monitor
    firefox google-chrome vscode qemu_full virt-manager zotero element-desktop tdesktop remmina qbittorrent bitwarden
    apacheHttpd pigz rar unrar upx snapper snapper-gui docker docker-compose spotify certbot-full crow-translate beep
    neofetch screen scrcpy ocrmypdf dos2unix pdfgrep texlive.combined.scheme-full tldr
  ]
  ++ (with lib; filter isDerivation (attrValues pkgs.plasma5Packages.kdeGear));

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      source-han-sans
      source-han-serif
      source-code-pro
      hack-font
      jetbrains-mono
      nerdfonts
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Sarasa Mono SC"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Source Han Sans SC"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Source Han Serif SC"
          "DejaVu Serif"
        ];
      };
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime fcitx5-chinese-addons fcitx5-mozc
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh =
  {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;
}

