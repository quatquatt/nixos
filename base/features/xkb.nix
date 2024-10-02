{ lib, ... }:
let
  layoutName = "caps";
in
{
  console.useXkbConfig = true;
  # services.xserver.exportConfiguration = lib.mkForce true;


  services.xserver.xkb =
  {
    layout = "us";

    # extraLayouts.${layoutName} =
    # {
    #   description = "Custom layout with Escape unbound";
    #   languages = [ "eng" ];
    #   symbolsFile = ./${layoutName}.xkb;
    # };
  };

  hm.dconf.settings =
  {
    "org/gnome/desktop/input-sources" =
    {
      xkb-options =
      [
        "terminate:ctrl_alt_bksp"
        "caps:swapescape"
        "compose:rctrl" # Right control --> weird characters
      ];

      # sources = lib.singleton
      # (
      #   lib.gvariant.mkTuple ["xkb" layoutName]
      # );
    };



  };
}