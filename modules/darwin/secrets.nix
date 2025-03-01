{
  config,
  pkgs,
  agenix,
  secrets,
  ...
}: let
  user = "lessuseless";
in {
  age = {
    identityPaths = [
      "/Users/${user}/.ssh/id_ed25519"
    ];

    secrets = {
      "github-ssh-key" = {
        symlink = true;
        path = "/Users/${user}/.ssh/id_github";
        file = "${secrets}/github-ssh-key.age";
        mode = "600";
        owner = "${user}";
        group = "staff";
      };

      "github-signing-key" = {
        symlink = false;
        path = "/Users/${user}/.ssh/pgp_github.key";
        file = "${secrets}/github-signing-key.age";
        mode = "600";
        owner = "${user}";
      };
    };
  };
}
