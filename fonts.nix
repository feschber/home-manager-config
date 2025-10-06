{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pkgs.nerd-fonts.caskaydia-mono
  ];
}
