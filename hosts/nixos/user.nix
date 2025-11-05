{ config, pkgs, username,... }:
{
  users = {
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${username}";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      initialPassword = "lumos";
    };

    # 允许过期不维护的包
    nixpkgs.config.permittedInsecurePackages = [
      "electron-11.5.0" # NUR baidunetdisk needed
    ];

  }
}