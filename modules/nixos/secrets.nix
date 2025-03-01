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
      "/home/${user}/.ssh/id_github"
    ];

    # secrets = {
    #   "syncthing-cert" = {
    #     symlink = true;
    #     path = "/home/${user}/.config/syncthing/cert.pem";
    #     file =  "${secrets}/felix-syncthing-cert.age";
    #     mode = "600";
    #     owner = "${user}";
    #     group = "users";
    #   };

    #   "syncthing-key" = {
    #     symlink = true;
    #     path = "/home/{$user}/.config/syncthing/key.pem";
    #     file =  "${secrets}/felix-syncthing-key.age";
    #     mode = "600";
    #     owner = "${user}";
    #     group = "users";
    #   };

    secrets = {
      "github-ssh-key" = {
        symlink = true;
        path = "/home/${user}/.ssh/id_github";
        file = "${secrets}/github-ssh-key.age";
        mode = "600";
        owner = "${user}";
        group = "users";
      };

      "github-signing-key" = {
        symlink = false;
        path = "/home/${user}/.ssh/pgp_github.key";
        file = "${secrets}/github-signing-key.age";
        mode = "600";
        owner = "${user}";
      };
    };
  };
}
