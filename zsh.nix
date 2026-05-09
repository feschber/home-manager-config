{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
    . "$HOME/.cargo/env"
    '';
    shellAliases = {
      ll = "ls -l";
      v = "nvim";
      update = "nix flake update --flake ~/nixos-config; nixos-rebuild switch --flake ~/nixos-config";
      nd = "nix develop -c zsh";
      y = "yazi";
    };
    initExtra = ''
      bindkey -e
      source "$HOME/.p10k.zsh"
    '';
    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  
  programs.eza = {
    enable = true;
    colors = "auto";
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  home.packages = with pkgs; [
    ripgrep
    jq
    gron
    wget
    curl
    tmux
    htop
    gh
  ];
  
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

}
