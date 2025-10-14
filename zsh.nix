{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
    . "$HOME/.cargo/env"
    '';
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
}
