{
  pkgs,
  ...
}:


{

  environment.systemPackages =
  with pkgs;
  [
    modrinth-app
    gparted
    filezilla
    moonlight-qt
    spotify
    shortwave # Internet radio
    obsidian # Notes
  ];
}
