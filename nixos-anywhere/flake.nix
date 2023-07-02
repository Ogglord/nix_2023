{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, disko, ... }@attrs: {
    #-----------------------------------------------------------
    # The following line names the configuration as batu
    # This name will be referenced when nixos-remote is run
    #-----------------------------------------------------------
    nixosConfigurations.batu = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({ modulesPath, ... }: {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
            disko.nixosModules.disko
          ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
          };
          boot.loader.grub = {
            device = "/dev/sda";
            efiSupport = false;
            #efiInstallAsRemovable = true;
          };
          networking = {
            usePredictableInterfaceNames = false;
            hostName = "batu";
            ## configure network
            firewall.enable = false;
            interfaces.eth0.ipv4.addresses = [{
              address = "194.87.149.71";
              prefixLength = 26;
            }];

            defaultGateway = "194.87.149.65";
            nameservers = [ "127.0.0.53" ];

          };
          services.resolved = {
            # enable dns server          
            enable = true;
            fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
          };
          ## enable SSH Daemon
          services.sshd.enable = true;
          services.openssh.settings.PermitRootLogin = "no";
          services.openssh.settings.PasswordAuthentication = "no";
          services.openssh.enable = true;
          #Define a user account. Don't forget to set a password with ‘passwd’.
          users.users.ogge = {
            isNormalUser = true;
            extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.            
          };

          users.users.ogge.initialPassword = "apskalle";
          #-------------------------------------------------------
          # Change the line below replacing <insert your key here>
          # with your own ssh public key
          #-------------------------------------------------------
          users.users.ogge.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWX4zp7ZFi3au4GfaMi2pOgtX9gUUw8gsykQKDt8KtG8Y9TQnmTKqXSr/WlxO9FScBVSd91269lKqGf4jyLopN+nRjr7vfQcDtm70NNeH3Z48feMOpfBOv4g2ntn4q/lJxktHe2cGSX5V0SHNTEd+LKC+cHjokITxkiS6VyWyrB40JrQW2U5aOrABVto5gDunsSbyPvNyNwQCOL+5cAaOjDn+1G6kg9+TXZrqh8KeB0lJddDWvWjlW/CxRymvgMTBvL/EjghlNMfr91hTGiUpeFIJOAqNsfgnHu/SMLUB9D0LiZ20YTvG61tb+4tyzm96nAftz6iNT3Nj+N/FEnywqbpFGZ5D8FY623Y0g1g7+VxoxhkErcbnQB9jR2aTFZm00y3WgpxquISfzJFmyOSGAPjCLn4KMPfclwuZfH/7T2gLHkrmr046QqPpBSpWc6AvBQllML7e9L5UavFCFvySp3kRPZj5cp3jyjAxZq9vHpex3FxM0tTxAK+ReMjm2fec= ogge@ogge" ];
        })
      ];
    };
  };
}
