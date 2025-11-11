
{
  pkgs,
  ...
}:
{
  # enable fish shell manager
  programs.fish.enable = true;

  # default shell
  programs.fish.shellInit = "exec fish";

}