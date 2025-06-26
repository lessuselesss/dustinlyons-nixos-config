{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellApplication {
  name = "apl";
  runtimeInputs = [ pkgs.age-plugin-ledger ];
  text = ''
    #!/usr/bin/env bash
    # apl: Age Plugin Layer - exposes age-plugin-ledger API, extensible via stdin/stdout/stderr.

    PLUGIN="$1"
    shift || true

    case "$PLUGIN" in
      ""|"age-plugin-ledger")
        exec age-plugin-ledger "$@"
        ;;
      *)
        if command -v "$PLUGIN" >/dev/null 2>&1; then
          exec "$PLUGIN" "$@"
        else
          echo "Unknown plugin: $PLUGIN" >&2
          exit 1
        fi
        ;;
    esac
  '';
}
