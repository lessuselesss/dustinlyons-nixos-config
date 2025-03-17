{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state";

  # MPC Client Config Paths
  claude_desktop_path = "${config.users.users.${user}.home}/Library/Application Support/Claude/claude_desktop_config.json";
  cursor_path = "${config.users.users.${user}.home}/.cursor/mcp.json";
  
  # Documents directory for MCP
  documents_dir = "${xdg_dataHome}/documents";
in
{
  # Create the documents directory
  "${documents_dir}/.keep" = {
    text = "";
  };

  # Claude MCP Client Config
  "${claude_desktop_path}" = {
    text = ''
      {
        "mcpServers": {
          "filesystem": {
            "command": "/bin/sh",
            "args":  ["-c", "PATH=/run/current-system/sw/bin:$PATH exec npx -y @modelcontextprotocol/server-filesystem ${documents_dir}"]
          }
        }
      }
    '';
  };

  # Cursor MCP Client Config
  "${cursor_path}" = {
    text = ''
      {
        "mcpServers": {
           "filesystem": {
            "command": "npx",
            "args":  [
            "-y",
            "@modelcontextprotocol/server-filesystem",
            "${documents_dir}"
            ]
          }
        }
      }
    '';
  };

  # Raycast script so that "Run Emacs" is available and uses Emacs daemon
  "${xdg_dataHome}/bin/emacsclient" = {
    executable = true;
    text = ''
      #!/bin/zsh
      #
      # Required parameters:
      # @raycast.schemaVersion 1
      # @raycast.title Run Emacs
      # @raycast.mode silent
      #
      # Optional parameters:
      # @raycast.packageName Emacs
      # @raycast.icon ${xdg_dataHome}/img/icons/Emacs.icns
      # @raycast.iconDark ${xdg_dataHome}/img/icons/Emacs.icns

      if [[ $1 = "-t" ]]; then
        # Terminal mode
        ${pkgs.emacs}/bin/emacsclient -t $@
      else
        # GUI mode
        ${pkgs.emacs}/bin/emacsclient -c -n $@
      fi
    '';
  };
}
