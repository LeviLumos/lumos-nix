
{
  pkgs,
  ...
}:
{
  # enable fish shell manager
  programs.fish.enable = true;

  # default shell
  programs.fish.shellInit = "exec fish";

  # aliase

  programs.fish.functions = {
    lg = {
      body = "sudo lazygit"
    }

  }


}