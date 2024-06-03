{
  vars,
  ...
}:

{

  programs.home-manager.enable = true;

  home =
  {
    username = vars.username;
    homeDirectory = vars.homeDirectory;
    stateVersion = "23.11";
  };


}