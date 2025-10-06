{ nixvim, pkgs, ... }:

{
  imports = [
    nixvim.homeModules.nixvim
  ];

  programs.zsh = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
    };
  };


  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
  };
}
