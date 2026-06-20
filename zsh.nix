{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    defaultKeymap = "emacs";

    shellAliases = {
        pacs = "pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S";
        yays = "yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S";
        parus = "paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S";

        pacrm = "pacman -Qqs | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -Rns";
        uefi = "sudo systemctl reboot --firmware-setup";
        rr = "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash";
        ll = "ls -l";
        la = "ls -lah";
        v = "nvim";
        update = "nix flake update --flake ~/nixos-config; sudo nixos-rebuild switch --flake ~/nixos-config";
        nd = "nix develop -c zsh";
        y = "yazi";
    };


    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
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
