{ config, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nix-hypr";
  time.timeZone = "Asia/Shanghai";  # 请根据实际时区调整
  i18n.defaultLocale = "en_US.UTF-8";

  # 用户
  users.users.${username} = {
    isNormalUser = true;
    description = "lumos";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell = pkgs.fish;
  };
  
  # 启用 Docker
  virtualisation.docker.enable = true;

  # 安全
  security.sudo.wheelNeedsPassword = false;

  # 网络
  networking.networkmanager.enable = true;

  # 图形 & Wayland
  services.xserver.enable = false;  # 纯 Wayland
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;

  # 启用 ly 显示管理器（轻量，支持 Wayland）
  services.ly.enable = true;

  # 音频
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # 全局字体 & 输入法
  fonts.packages = with pkgs; [
    (nerd-fonts.override { fonts = [ "jetbrains-mono" ]; })
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-configtool ];
  };

  # 系统包（可选）
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    firefox
    thunar
    yazi
    docker-compose
    clash-verge-rev
  ];

  # Nix 设置
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 系统版本
  system.stateVersion = "25.05";
}