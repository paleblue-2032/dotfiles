{ ... }:

{
  networking.hostName = "Liberty-pad";

  networking.networkmanager.enable = true;

  # Tailscale client: join the tailnet to reach the file server.
  # No exit node, subnet router, or inbound firewall opening.
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
}
