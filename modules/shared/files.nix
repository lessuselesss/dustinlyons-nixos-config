{ pkgs, config, ... }:

let
  githubPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJXCuhvhfxTiziLC75QMuKNkEJM9kpPG5M9gny4eie5e lessuseless@duck.com";
  githubPublicSigningKey = ''
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    mDMEZ897DBYJKwYBBAHaRw8BAQdA7zeiv8GFRnmpPhi2ZSXUaEqUC8ASxN8HCi0V
    /srF+ci0MkFzaGxleSBCYXJyIChhbnViaXMtbml4c3lzKSA8bGVzc3VzZWxlc3NA
    ZHVjay5jb20+iJkEExYKAEEWIQQFw+x86BicYsPbzacxVDfPVBNswgUCZ897DAIb
    AwUJAeEzgAULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCRAxVDfPVBNswgvg
    AQCdHqgKi8s2aBduNBb+cY33/kBpQZ91k3MKIjiFJLCWGgEAqwRaxaiOs+RAfcrA
    yDRIPu/MjFuLP53smteJz1lfbA+4OARnz3sMEgorBgEEAZdVAQUBAQdAQOOyhe9u
    Bj9ZebPJ4ts1XFDIRa6EsuLi2w72n4JZ6i8DAQgHiH4EGBYKACYWIQQFw+x86Bic
    YsPbzacxVDfPVBNswgUCZ897DAIbDAUJAeEzgAAKCRAxVDfPVBNswvOPAP44NQhL
    AicxHpz65+U42+U9/Oj/TdPfOACdlp8b1IjFegEApk/PUnUbK3yHTcopYQ6W5RP0
    WO6THLvfXUWyiQPhrAg=
    =yuV3
    -----END PGP PUBLIC KEY BLOCK-----
  '';
in
{
  # Initializes Emacs with org-mode so we can tangle the main config
  ".emacs.d/init.el" = {
    text = builtins.readFile ../shared/config/emacs/init.el;
  };

  ".ssh/id_github.pub" = {
    text = githubPublicKey;
  };

  ".ssh/pgp_github.pub" = {
    text = githubPublicSigningKey;
  };
}
