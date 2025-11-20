{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./firefox.nix
      ./git.nix
      ./vim.nix
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
            # Create a `docker` alias for podman, to use it as a drop-in replacement
            dockerCompat = true;
            # Required for containers under podman-compose to be able to talk to each other.
            defaultNetwork.settings.dns_enabled = true;
          };
        };



        networking.hostName = "nixos"; # Define your hostname.

#-----------------------------------------------------------------------------------
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
#-----------------------------------------------------------------------------------

hardware.enableRedistributableFirmware = true;


networking.networkmanager.enable = true;
networking.networkmanager.wifi.powersave = false; #?
boot.kernelPackages = pkgs.linuxPackages_latest; #?

    # Set your time zone.
    time.timeZone = "Europe/Rome";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };

    #Enable the X11 windowing system.
    services.xserver.enable = true;

    #Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      geary              
      totem         
      gnome-music
      gnome-contacts
      gnome-maps
      gnome-weather
      yelp          
      gnome-calendar
      gnome-clocks
      decibels
      gnome-console
    ];



    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "it";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "it2";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

#----------------------------------------------------------
# If you want to use JACK applications, uncomment this
#jack.enable = true;
#----------------------------------------------------------

#------------------------------------------------------------------------------------------
# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
#------------------------------------------------------------------------------------------
    };


#------------------------------------------------------------------
# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;
#------------------------------------------------------------------

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.labstraction = {
      isNormalUser = true;
      description = "labstraction";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
            #  thunderbird
          ];
        };


    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget
      pciutils
      usbutils
      ethtool
      dmidecode
      protonvpn-gui
      xclip
      gnome-tweaks     
      vlc
      vscode
      nixpkgs-fmt
      nodejs
      dive
      podman-tui
      docker-compose
      yt-dlp
      tmux
      entr
      ghostty
      live-server
    ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "ghostty.desktop" ];
    };

    environment.variables = {
      TERMINAL = "ghostty";
    };

    environment.sessionVariables = {
      TERMINAL = "ghostty";
      TERM = "ghostty";  # o "ghostty" se supportato
    };


#-------------------------------------------------------------------
# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };
#-------------------------------------------------------------------
# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;
#-------------------------------------------------------------------
# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;
#---------------------------------------------------------------
system.stateVersion = "25.05"; # Did you read the comment?

}


