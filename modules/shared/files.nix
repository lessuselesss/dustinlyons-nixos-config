{
  pkgs,
  config,
  ...
}: let
  githubPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMZXJvdecO8KZbZkfo5i1izNyiMxRnyuGx4Bcm+Qz3x lessuseless@anubis.local";
  githubPublicSigningKey = ''
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    mQINBGfCq/ABEADR2z2eK+K5r4canZ7t82C2G28fvLAh36jvCE0Nz6rusqPrkVt/
    eoR2iPPdRRlAjk+m/FMlOtV0a18+ikDheDFGElVkcf2P3PF2I0JPx8/9vfTen86P
    2Mw3mXHjEviPjOYDPnQjrwqXQAPb1qhWe0+AIShvEz+xuU19vetBCfSy9BfAB1GS
    Y9ss9HGvHP0SGsQgIhqPPI7ykwhMMorge5BVrr9AEtM7RK7YYT+PhTkmWF31hWjx
    aPiCrPQ5/t/cxCYpjp03zEXgZQKbLhuUgOwCCbBRa+1Qf7onIznZHVbvCAh07c1o
    1+PyUsG7VTpy1lTMVoMrxr7vsNYnZDKoeFDPDZnYZYZK2iYchXFciPygYDncK9Pa
    RfzoUI6pqPeX/4yKfBNY9fq4ivVDuYvXQe/2m/f0/7JE7PYySdlpo023RnFaTnXG
    2ai+n/VYgQpIfzYWN6MWiPxdUcKQZonGGfBfvdqkzbGqBy8y3+4nJEj58vbTvl89
    OR6DuVpSJwzTgaCm19OY8uDnKkFWQEUgNR4O34cFjeL+PwXWRk75/UAzjFn+mU/x
    mNQDdTA/rM/qU+oihnTw/T8WFIPcGwI6MaFpUes1NTucjw73BAKDttV4EvntG/Jh
    0yHP9yqQAf+RP9GPgtoWtGOrDzAf0IABkilXOH8Kx5VlriCId7Iszt/CNwARAQAB
    tCRsZXNzdXNlbGVzcyA8bGVzc3VzZWxlc3NAZ2l0aHViLmNvbT6JAlIEEwEIADwW
    IQQp9vIi2vrH1twKOkYsNYsFvhU6HgUCZ8Kr8AMbLwQFCwkIBwICIgIGFQoJCAsC
    BBYCAwECHgcCF4AACgkQLDWLBb4VOh5ZGQ/+IMBc/8xr/1xHkjC1GFT5NZS8hcP4
    Yyt7m6zdb+PFjjJCt0qzWrsBUFCmDrIfmM51bfNsh6UM9T98icz/PEu/1oxI6S2G
    8FA5cXAxLyJQ7mHImdCq4vvXa4mdf71UmwrHulKu2H5XUe+7c0TzUJmQQ6iu2+u3
    ShZCaGUelu6iI8rvG8hVb/lyQyYUASw47sONI0XW9vXi2f9QHssQozFgcYwr0dJF
    YSw9ShSpjQAyhhgc+0WV4UmUpwRLpbCZJFq1VKJHBXi7D1rj7ysICiCyL1/TBUZw
    iLqZaxfnjKqC3DwmmwZP1MBFK9lll2Yy1hLUXSnvjo3OHWobK3bRuemi9TU65Tsr
    PdfHsaWz7YcYRawSptZL2pQCmk0JXUl3+0LNnyikfuaD5MKbPKHHgSZcmlHAEE3I
    nofeUDf4mpsrMtOuYdwSWaVbch93FTYGQ8tpVP5WLLqjxvVulO/34LRIABQ1JHu2
    sBR3oppQT/MRFx9t0bbsxFQbhNa4TeVbUUTF96pNai3i0me+dSXJRCMRySknUyGG
    WzKuRPP/QKKUzXRAywjqhnvIRF2KhY2ettqZfeiL6anL7Mu7hqXvnisFJ5sQEkWe
    jsZr/prlBiJ7dvO3ALTynqpJisnJrU5dnJ0vYcZ76p0+gM1sZYTMg3iH13Gqpv4A
    WF8xx1Nyvy1Ao68=
    =xdhI
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
