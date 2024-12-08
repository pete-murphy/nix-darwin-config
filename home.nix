{
  config,
  pkgs,
  lib,
  nixvim,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pete";
  # home.homeDirectory = "/Users/pete"; -- TODO: Not sure why this was giving an error, neede to use `mkForce`
  home.homeDirectory = lib.mkForce "/Users/pete";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.alejandra
    pkgs.awscli2
    pkgs.bat
    pkgs.bore-cli
    pkgs.bun
    pkgs.caddy
    pkgs.coreutils
    pkgs.delta
    pkgs.du-dust
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-json
    pkgs.elmPackages.elm-land
    pkgs.elmPackages.elm-language-server
    pkgs.elmPackages.elm-live
    pkgs.elmPackages.elm-review
    pkgs.elmPackages.elm-test
    pkgs.eza
    pkgs.fd
    pkgs.ffmpeg
    pkgs.gh
    pkgs.gron
    pkgs.hyperfine
    pkgs.icu
    pkgs.imagemagick
    pkgs.jnv
    pkgs.jq
    pkgs.just
    pkgs.nerd-fonts.fira-code
    pkgs.nix-prefetch-git
    pkgs.nodejs_20
    pkgs.pandoc
    pkgs.postgresql
    pkgs.powerline-fonts
    pkgs.ripgrep
    pkgs.rustup
    pkgs.sd
    pkgs.shellcheck
    pkgs.tokei
    pkgs.tree
    pkgs.typescript
    pkgs.unison-ucm
    # pkgs.visidata
    pkgs.yt-dlp
    pkgs.yq
    pkgs.zoxide
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pete/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vi";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nushell.enable = true;

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      simplified_ui = true;
      pane_frames = false;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Peter Murphy";
    userEmail = "26548438+pete-murphy@users.noreply.github.com";

    extraConfig = {
      # core.editor = "code --wait --reuse-window";
      core.editor = "vi";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    includes = [
      {
        condition = "gitdir:~/Well/";
        contents = {
          # userEmail = "18291327-peter.murphy1@users.noreply.gitlab.com";
          user.email = "peter.murphy@well.co";
        };
      }
    ];

    delta.enable = true;

    ignores = [
      "*~"
      ".*.swn"
      ".*.swp"
      ".*.swo"
      "*.ignore.*"
    ];
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = {
      lualine.enable = true;
      vim-surround.enable = true;
      fzf-lua.enable = true;
      # telescope.enable = true;
      # harpoon.enable = true;
      # harpoon.enableTelescope = true;
      # web-devicons.enable = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history = {
      size = 500000;
      ignoreSpace = true;
      ignoreDups = true;
    };
    oh-my-zsh = {
      enable = true;
    };
    shellAliases = {
      ls = "exa";
    };
    zsh-abbr = {
      enable = true;
      abbreviations = {
        ".j" = "just --justfile $HOME/.user.justfile --working-directory .";
      };
    };
    initExtraBeforeCompInit = ''
      eval "$(zoxide init zsh)"
    '';
    initExtra = ''
      export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$HOME/.local/bin"
      export EDITOR=nvim
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line
      runChrome () {
        /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 >&/dev/null &
      }
    '';
  };
}
