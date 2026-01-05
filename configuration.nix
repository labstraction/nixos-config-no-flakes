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


    networking.hostName = "ritalevix"; # Define your hostname.

#-----------------------------------------------------------------------------------
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
#-----------------------------------------------------------------------------------
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
    };

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



    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
    };


    services.displayManager.defaultSession = "xfce";

    environment.xfce.excludePackages = with pkgs; [
      xfce.parole
      xfce.xfce4-terminal
    ];
      
    
    services.touchegg.enable = true;
    services.gnome.gnome-keyring.enable = true;


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
    boot.extraModprobeConfig = ''
      options snd-hda-intel model=thinkpad
    '';
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
      packages = with pkgs; [];
    };

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    environment.systemPackages = with pkgs; [
      wget
      protonvpn-gui
      xclip
      gnome-tweaks
      vlc
      vscode.fhs
      nodejs
      dive
      podman-tui
      docker-compose
      yt-dlp
      tmux
      entr
      ghostty
      live-server
      bottom
      broot
      curl
      neofetch
      pandoc
      glslviewer
      wiper
      epr
      visidata
      posting
      cariddi
      sttr
      monolith
      doxx
      blueberry
      inkscape
      seahorse
      peek
      peazip
      pavucontrol
      wireplumber
      qalculate-gtk
      gleam
      erlang_28
    ];


    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "ghostty.desktop" ];
    };

    environment.variables = {
      TERMINAL = "ghostty";
    };

    environment.sessionVariables = {
      TERMINAL = "ghostty";
      TERM = "ghostty";  
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


