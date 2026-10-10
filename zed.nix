# Home-manager module: Zed with Nix-provided language servers (incl. LaTeX).
# Import it from your home.nix:  imports = [ ./zed.nix ];
{ pkgs, lib, ... }:
let
  # TeX distribution. Swap texliveMedium for texliveSmall or texliveFull as needed.
  tex = pkgs.texliveMedium.withPackages (ps: with ps; [
    latexmk
    chktex
    latexindent
    # extra CTAN packages, e.g.:
    # biblatex biber siunitx tikz-cd
  ]);
in
{
  programs.zed-editor = {
    enable = true;

    # Extensions are WASM and install fine; only the binaries they download break.
    extensions = [
      "nix"
      "toml"
      "dockerfile"
      "latex"
    ];

    # Added to Zed's PATH via a wrapper, so Zed finds these instead of downloading.
    extraPackages = with pkgs; [
      # Nix
      nixd
      nil

      # Rust / Go / C
      rust-analyzer
      gopls
      clang-tools # clangd

      # Python
      pyright
      basedpyright
      ruff

      # Web / config / docs
      typescript-language-server
      vscode-langservers-extracted # html, css, json, eslint
      yaml-language-server
      lua-language-server
      marksman
      taplo

      # LaTeX
      texlab
      tex

      # Runtime for npm-based servers
      nodejs
    ];

    userSettings = {
      # Use Nix's node instead of the one Zed downloads (which won't run on NixOS).
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      # Pick up per-project `nix develop` / direnv environments.
      load_direnv = "shell_hook";

      lsp = {
        # Remove an entry here if you want the server from a project's dev shell
        # to be used instead (a pinned path always wins over PATH).
        rust-analyzer.binary.path = lib.getExe pkgs.rust-analyzer;
        nixd.binary.path = lib.getExe pkgs.nixd;
        nil.binary.path = lib.getExe pkgs.nil;
        clangd.binary.path = "${pkgs.clang-tools}/bin/clangd";
        gopls.binary.path = lib.getExe pkgs.gopls;

        texlab = {
          binary.path = lib.getExe pkgs.texlab;
          settings.texlab = {
            build = {
              executable = "${tex}/bin/latexmk";
              args = [ "-pdf" "-interaction=nonstopmode" "-synctex=1" "%f" ];
              onSave = true;
            };
            chktex = {
              onEdit = false;
              onOpenAndSave = true;
            };
            latexindent.local = null;
          };
        };
      };
    };
  };

  # Makes latexmk, pdflatex, etc. available in your terminal too.
  home.packages = [ tex ];
}
