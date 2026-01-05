{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    git
    gh
  ];

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "labstraction";
        email = "labstraction@protonmail.com";
      };

#init = {
#defaultBranch = "main";
#};

core = {
  editor = "vim";
  autocrlf = "input";
  whitespace = "trailing-space,space-before-tab";
  pager = "less -FRX";
};

pull = {
  rebase = false;
};

push = {
  default = "current";
  autoSetupRemote = true;
};

fetch = {
  prune = true;
};

rebase = {
  autoStash = true;
  autoSquash = true;
};

merge = {
  ff = "only";
  conflictStyle = "diff3";
};

diff = {
  algorithm = "histogram";
  colorMoved = "default";
};

log = {
  date = "relative";
};

color = {
  ui = "auto";
};

alias = {
# Trova file
find = "!git ls-files | grep -i";

# Grafico ASCII completo
tree = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
            };
          };
        };

# Abilita l'agente SSH
programs.ssh = {
  #startAgent = true;
  extraConfig = ''
            Host github.com
            HostName github.com
            User git
            IdentityFile ~/.ssh/id_ed25519
            AddKeysToAgent yes
  '';
};


}
