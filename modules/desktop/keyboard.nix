{ ... }:

{
  console.useXkbConfig = true;

  services.xserver.xkb = {
    layout = "jp";
    options = "ctrl:swapcaps";
  };
}
