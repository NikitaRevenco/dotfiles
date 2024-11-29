{
  programs.git = {
    enable = true;
    userName = "Nikita Revenco";
    userEmail = "154856872+NikitaRevenco@users.noreply.github.com";
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      safe.directory = "*";
    };
    aliases = {
      "a" = "add";
      "c" = "commit";
      "s" = "status";
      "f" = "fetch";
      "b" = "branch";
      "l" = "log";
      "co" = "checkout";
      "cl" = "clone";
      "ps" = "push";
      "pl" = "pull";
      "re" = "remote";
      "M" = "merge";
      "R" = "rebase";
    };
  };
}
