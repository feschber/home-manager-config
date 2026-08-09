{ nixvim, pkgs, ... }:

let
  tree-sitter-e2 = {
    language = "e2";
    version = "0330380ca817bfb3164c5461d8057eba4c30b7d1";
    src = pkgs.fetchFromGitHub {
      owner = "mrdgo";
      repo = "tree-sitter-e2";
      rev = "0330380ca817bfb3164c5461d8057eba4c30b7d1";
      hash = "sha256-xVrpviC7rO523eFIdEigqPjgVK+rUVLilfMDvl9IUv0=";
    };
  };

  e2grammar = pkgs.tree-sitter.buildGrammar tree-sitter-e2;

  e2plugin = pkgs.fetchFromGitHub {
    owner = "mrdgo";
    repo = "e2.nvim";
    rev = "9b5063a26eab61a6206765fec69840f310405ff0";
    hash = "sha256-lDeXVuJHCbjx3lWRW2+uTimOGy7bGptxizXDUHlRm7g=";
  };
in
{
  imports = [
    nixvim.homeModules.nixvim
  ];

  programs.zsh = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
    };
    shellAliases.v = "nvim";
  };


  programs.nixvim = {
    autoCmd = [
      {
        event = [ "BufRead" "BufNewFile" ];
        pattern = [ "*.e2" ];
        command = "set filetype=e2";
      }
    ];
    enable = true;
    colorschemes.gruvbox.enable = true;
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 4;
      tabstop = 4;
      colorcolumn = "80";
      expandtab = true;
    };
    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
      colorizer.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          e2grammar
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
          rust
          java
          c
          cpp
        ];
      };
      lsp = {
        enable = true;
        autoLoad = true;
        inlayHints = true;
        servers = {
          bashls.enable = true;
          nil_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          jdtls.enable = true;
          texlab.enable = true;
          pyright.enable = true;
        };
        keymaps = {
          silent = true;
          lspBuf = {
            K = "hover";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
          };
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
          "<leader>fg" = "live_grep";
        };
      };
      gitsigns = {
        enable = true;
        settings = {
          auto_attach = true;
          watch_gitdir = {
            follow_files = true;
          };
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      yuck-vim
      nvim-treesitter-parsers.yuck
    ];
    extraConfigLua = ''
      vim.opt.runtimepath:append("${e2plugin}")

      -- tree-sitter-nix ships highlights.scm using the legacy nvim-treesitter
      -- predicate `(#is-not? local)`, which neither nvim core nor the rewritten
      -- nvim-treesitter registers anymore. Without a handler the highlighter
      -- errors on every .nix file containing a builtin. Treating every match as
      -- non-local just means shadowed builtins keep their builtin highlight.
      vim.treesitter.query.add_predicate("is-not?", function()
        return true
      end, { force = true, all = false })
    '';
  };
}
