{
  description = "Liberty-pad NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    
    momoi-say.url = "github:haruki-nikaidou/momoisay-rs";

    dpgk = {
      url = "github:shibadogcap/dpgk/v0.1.3";
      flake = false;
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, niri, noctalia-greeter,  ... }:
  let
    system = "x86_64-linux";
    hostname = "Liberty-pad";
  in
  {
    nixosConfigurations.${hostname} =
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [

          ./hardware-configuration.nix
          ./configuration.nix

          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd

          niri.nixosModules.niri

          inputs.noctalia-greeter.nixosModules.default

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            home-manager.users.paleblue_2032 = import ./home.nix;
          }

        ];
      };
  };
}
