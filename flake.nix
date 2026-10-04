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
    
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, ... }:
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
