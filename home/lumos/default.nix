{ pkgs, ... }:

{
  home.username = "lumos";
  home.homeDirectory = "/home/lumos";
  home.stateVersion = "25.05";

  # Shell
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    alias ll 'ls -lh --color=auto'
    alias la 'ls -la --color=auto'
  '';

  # Terminal
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12.0;
      background_opacity = "0.9";
      dynamic_background_opacity = true;
    };
  };

  # Desktop Environment
  home.packages = with pkgs; [
    hyprland
    waybar-hyprland
    mako
    wofi
    swaybg
    swayidle
    swaylock-effects
    grim
    slurp
    xdg-utils
    wl-clipboard
  ];

  # Hyprland 配置
  xdg.configFile."hypr".source = ./hypr;

  # Waybar 配置
  xdg.configFile."waybar".source = ./waybar;

  # Mako 配置
  xdg.configFile."mako/config".source = ./mako/config;

  # 自动启动
  systemd.user.services.hyprland-start = {
    Unit.Description = "Start Hyprland session";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.hyprland}/bin/Hyprland";
      Environment = [ "XDG_CURRENT_DESKTOP=Hyprland" ];
    };
  };

  # GTK/Qt 输入法支持
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-im-module = "fcitx";
    };
    gtk4.extraConfig = {
      gtk-im-module = "fcitx";
    };
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style.name = "kvantum";
  };

  # Home Manager 自管理
  programs.home-manager.enable = true;
}