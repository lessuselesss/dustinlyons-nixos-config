{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
# ---- Dock Management ----
# dockutil         # Manage icons in the dock

# ---- macOS System/CLI Utilities ----
# m-cli            # macOS command-line utilities

# ---- File & Device Utilities ----
# fswatch          # File change monitor

# ---- App Store / macOS Integration ----
# mas              # Mac App Store command-line utility

# ---- Productivity & Media ----
# iina             # Video player for macOS

# ---- Security & Authentication ----
# pinentry_mac     # GPG pinentry for macOS

# ---- Window Management ----
# yabai            # Tiling window manager for macOS
# mods             # Modal editing for macOS (if this is your own package or a public one)

# ---- Development / Formatting ----
# gh               # GitHub CLI
# alejandra        # Nix code formatter

# ---- Hardware Wallets (commented in most configs) ----
# trezor-agent             # Hardware wallet agent (commented out)
# ledger-agent             # Ledger device agent (commented out)
# python312Packages.ledgerwallet  # Ledger wallet Python package (commented out)
# python312Packages.bleak         # Bluetooth library for Python (commented out)

# ---- Android / Recovery Tools (commented in most configs) ----
# heimdall                 # Flashing tool for Samsung devices (commented out)
# heimdall-gui             # GUI for Heimdall (commented out)

# ---- Custom Scripts ----
# (pkgs.writeScriptBin "setup-ledger-ssh" '' ... '')  # Ensures SSH agent socket for ledger-agent

# ---- Notes ----
# - shared-packages are imported but not listed here (content unknown).
# - Some entries are commented in original configs. Uncomment to enable.
]
