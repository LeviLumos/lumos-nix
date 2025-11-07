{
  pkgs,
  config,
  inputs,
  system,
  username,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.allowBroken = true;
  };
  # Cachix, Optimization settings and garbage collection automation
  nix = {
    package = pkgs.lix;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    channel.enable = true;
    extraOptions = ''
      warn-dirty = false
    '';
    settings = {
      auto-optimise-store = true;
      system-features = [
        "gccarch-x86-64-v3" # for chaotic-nyx pkgsx86_64-v3
      ];
      experimental-features = [
        "nix-command" # 启用 nix build, nix run, nix flake 等新命令
        "flakes"
        # "ca-derivations" # 启用内容寻址 derivation（Content Addressed Derivations）! lix 不再支持 ca-derivations 这个实验性特性
      ];
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        # "https://hyprland.cachix.org"
        "https://cache.garnix.io" # add garnix cache form github loneros-nixos repo
        "https://nix-community.cachix.org"
        # "https://loneros.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "loneros.cachix.org-1:dVCECfW25sOY3PBHGBUwmQYrhRRK2+p37fVtycnedDU="
      ];
      trusted-users = [
        "root"
        "${username}"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}

# { username, ... }:

# {
#   nix.settings = {
#     # enable flakes globally
#     experimental-features = [
#       "nix-command"
#       "flakes"
#     ];

#     # given the users in this list the right to specify additional substituters via:
#     #    1. `nixConfig.substituers` in `flake.nix`
#     #    2. command line args `--options substituers http://xxx`
#     trusted-users = [ username ];

#     # substituers that will be considered before the official ones(https://cache.nixos.org)
#     substituters = [
#       # cache mirror located in China
#       # status: https://mirrors.ustc.edu.cn/status/
#       # "https://mirrors.ustc.edu.cn/nix-channels/store"
#       # status: https://mirror.sjtu.edu.cn/
#       # "https://mirror.sjtu.edu.cn/nix-channels/store"
#       # others
#       # "https://mirrors.sustech.edu.cn/nix-channels/store"
#       "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
#       "https://nix-community.cachix.org"
#       # my own cache server, currently not used.
#       # "https://ryan4yin.cachix.org"
#     ];

#     trusted-public-keys = [
#       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
#       "ryan4yin.cachix.org-1:Gbk27ZU5AYpGS9i3ssoLlwdvMIh0NxG0w8it/cv9kbU="
#     ];
#     builders-use-substitutes = true;
#   };

# }