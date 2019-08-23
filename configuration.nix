# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot = { 
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    initrd = { 
      checkJournalingFS = true;
      kernelModules = [ "dm-snapshot" ];
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        editor = true;
      };
      grub.enable = false;
      efi.canTouchEfiVariables = true;
    };
  };

    networking = {
   enableIPv6 = true;
   hostName = "xana"; # Define your hostname.
   networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
        scanRandMacAddress = true;
      };
    };
    firewall.enable = false;
   };

    security = {
    sudo.enable = true;
    apparmor.enable = true;
    audit.enable = true;
    auditd.enable = true;
    dhparams = {
      enable = true;
      stateful = true;
    };
    hideProcessInformation = true;
    polkit.enable = true;
    rngd.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/NewYork";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Applications
    ## Audio
    caudec
    mpc_cli
    ncmpcpp

    ## Editor
    android-studio
    neovim
    vim
    vscode
   
    ## Graphics
    feh

    ## Misc
    calcurse
    zathura

    ## Networking
    ### Browsers
    brave
    firefox

    ### Instant-Messengers
    tdesktop
    telegram-cli

    ### Sniffers
    wireshark

    ## Office
    libreoffice

    ## Version-Management
    ### Git-and-Tools
    git

    ## Video
    mpv
    obs-studio

    # Build-Support
    ## Binutils-Wrapper
    binutils

    ## CC-Wrapper
    clang
    gcc

    ## Trivial-Builder
    # texlive.combined.scheme-full

    # Development
    ## Compilers
    chez
    gforth
    ghc
    llvm
    openjdk
    racket

    ## Haskell-Modules
    ### Hackage-Packages
    haskellPackages.cabal-install
    haskellPackages.ghcid
    haskellPackages.hoogle
    haskellPackages.pandoc
    haskellPackages.stack

    ## Interpreters
    guile
    python37Full

    ## Libraries
    libnotify

    ## Tools
    ### Misc
    dialog
    patchelf

    ## Web
    csslint

    # Misc
    ## Emulators
    wine

    # OS-Specific
    ## Linux
    iotop
    powertop
    psmisc
    linuxPackages.wireguard

    # Tools
    ## Archivers
    unzip

    ## Filesystems
    android-file-transfer

    ## Graphics
    pywal
    escrotum

    ## Misc
    neofetch
    tldr
    tmpwatch
    youtube-dl

    ## Networking
    traceroute
    wget
    whois
    wireguard-tools

    ## Package-Management
    dpkg
    nix-index

    ## Security
    nmap
    gnupg
    pass
    passff-host

    ## System
    htop
    lshw
    ps_mem
    tree

    ## X11
    arandr
  ];

  # Some programs need SUID wrappers, can be configured further or are
   # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    bash.enableCompletion = true;
    command-not-found = {
      enable = true;
      dbPath = "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite";
    };
    mtr.enable = true;
    gnupg.agent = { 
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = true;
    };
  };

  # List services that you want to enable:

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

    services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      permitRootLogin = "no";
      passwordAuthentication = false;
      allowSFTP = true;
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "0 0 1 * *     root     tmpwatch -maf 240 /tmp"
      ];
    };
    upower = {
      enable = true;
      package = pkgs.upower;
    };
    nixosManual.showManual = true;
    printing.enable = true;
    fprintd.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      startDbusSession = true;
      terminateOnReset = true;
      libinput = {
        enable = true;
        tapping = false;
      };
      synaptics.enable = false;
      desktopManager = {
        xterm.enable = false;
        plasma5.enable = true;
      };
      displayManager.sddm.enable = true;
    };
    pcscd.enable = true;
    udev.packages = with pkgs; [
      android-udev-rules
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    enforceIdUniqueness = true;
    mutableUsers = true;
    extraUsers.aprophecy = {
      description = "Jessie";
      createHome = true;
      home = "/home/aprophecy";
      isNormalUser = true;
      extraGroups = [
        "wheel" "disk" "audio" "video"
        "networkmanager" "systemd-journal"
        "libvirtd"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        discord
      ];
    };
  };

    nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

    nix = {
    checkConfig = true;
    gc = {
      automatic = true;
      dates = "3:00";
    };
    optimise = {
      automatic = true;
      dates = [ "3:30" ];
    };
    maxJobs = lib.mkDefault 4;
    readOnlyStore = true;
    requireSignedBinaryCaches = true;
    useSandbox = true;
  };

    powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
  };

    # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system = {
    stateVersion = "19.03"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-19.03/";
    };
  };
}
