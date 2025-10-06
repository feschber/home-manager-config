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
    shellAliases.v = "nvim";
  };


  programs.nixvim = {
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
	grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
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
  };
}
