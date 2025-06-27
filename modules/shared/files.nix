{ pkgs, config, ... }:

let
  # keycutter naming convention
  # [<service>_]<user>@<device>
  #
  # Connect to github.com as user 'alex'
  # $ ssh github.com_alex
  #
  # Connect to github.com as user 'work'
  # $ ssh github.com_work
  # attribution: https://github.com/mbailey/keycutter/blob/4c730df89a63e46b4645366812a6f359fbea1403/docs/ssh-keytags.md

  
  githubPublicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBK7FLBdSazoQCqOm8qdrtX+5mKcrlhw6DAlqpvQJ2CCzZq3yOb+kjusEuecRFWHGYSVVascwiDbzsIe6PHsXP9I= <ssh://github.com_lessuseless@tachi|nist256p1>";
  # githubPublicSigningKey = '''';
in

{
  # Initializes Emacs with org-mode so we can tangle the main config
  #
  # @todo: Get rid of this after we've upgraded to Emacs 29 on the Macbook
  # Emacs 29 includes org-mode now
  ".emacs.d/init.el" = {
    text = builtins.readFile ./config/emacs/init.el;
  };

  ".ssh/id_github.pub" = {
    text = githubPublicKey;
  };

 # ".ssh/pgp_github.pub" = {
 #   text = githubPublicSigningKey;
 # };
}
