{ config, pkgs, username, hostName, ... }:
let
  inherit (import ./variables.nix) defaultLocale timezone;
in
{
  networking.hostName = ${hostName};
  time.timeZone = timezone;  # 请根据实际时区调整
  i18n.defaultLocale = defaultLocale;

  # 音频
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # 安全
  security.sudo.wheelNeedsPassword = false;

  # 网络
  networking.networkmanager.enable = true;

  # 启用 Docker
  # virtualisation.docker.enable = true;

  # 全局字体 & 输入法
  # fonts.packages = with pkgs; [
  #   (nerd-fonts.override { font = "jetbrains-mono" ; })
  # ];

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-configtool ];
  # };
}