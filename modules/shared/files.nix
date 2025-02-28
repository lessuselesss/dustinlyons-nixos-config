{
  pkgs,
  config,
  ...
}: let
  githubPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICE+MMZZuWLM9smEyrCXSKOeAKfWiUnaMgjRvadYC4GG lessuseless@anubis.local";
  githubPublicSigningKey = ''
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    mDMEZ74U2RYJKwYBBAHaRw8BAQdAM1ofYWRSeD/jnTnHOZOc5dmTW2BwyqmNltYk
    zqdgdmS0KkFzaGxleSBCYXJyIChqZWVwZykgPGxlc3N1c2VsZXNzQGR1Y2suY29t
    PoiZBBMWCgBBFiEEF/k++Ji+zfdK0WJHwEsc8/MtblMFAme+FNkCGwMFCQB2pwAF
    CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQwEsc8/MtblPDqQEAtDPNhdU5
    DGWaBkud6AC/oruOZeErtzeBbIzQiCRA0hYA/ic5GzBMkkxa1O8/dtxs7Bh7zAyx
    WxYaCWg8gGb+qRsMuDgEZ74U2RIKKwYBBAGXVQEFAQEHQAONx2Cp8Z6kmxdF/2o8
    EGtQJ8erASgKBJsbKdgeCh1sAwEIB4h+BBgWCgAmFiEEF/k++Ji+zfdK0WJHwEsc
    8/MtblMFAme+FNkCGwwFCQB2pwAACgkQwEsc8/MtblNS0gEA2VHBRcvbw627pPQ5
    t9QxOpUt5+NjDSA03+Gf+/ZGkcgBAI3vqtNmqSdSJS3y+D4JgowWC0vu71RtqGrA
    GriVQkkF
    =CFd5
    -----END PGP PUBLIC KEY BLOCK-----
  '';
in {
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

  ".ssh/pgp_github.pub" = {
    text = githubPublicSigningKey;
  };
}
