{
  username,
  pkgs,
  ...
}:
let
  hypr-session = "${pkgs.hyprland}/bin/Hyprland";
  # niri-session = "${pkgs.niri}/bin/niri-session";
in
{
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "${username}";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -g 'Welcome to the LeviLumos!' --user-menu --time --time-format '%A, %B %d, %Y - %I:%M:%S %p' --asterisks --greet-align center --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red"; # start Hyprland with a TUI login manager
      };
      # 自动登录: --cmd ${session}
      initial_session = {
        user = "${username}";
        command = "${hypr-session}";
      };
    };
  };
}
