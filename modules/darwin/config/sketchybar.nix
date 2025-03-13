{ config, lib, pkgs, ... }:

with lib; let
  space-sh = pkgs.writeShellScriptBin "space.sh" ''
    if [ "$SELECTED" = "true" ]
    then
      sketchybar -m --set $NAME background.color=0xff81a1c1
    else
      sketchybar -m --set $NAME background.color=0xff57627A
    fi
  '';
  window-title-sh = pkgs.writeShellScriptBin "window_title.sh" ''
    WINDOW_TITLE=$(${pkgs.yabai}/bin/yabai -m query --windows --window | ${pkgs.jq}/bin/jq -r '.app')
    if [[ $WINDOW_TITLE != "" ]]; then
      sketchybar -m --set title label="$WINDOW_TITLE"
    fi
  '';
in {
  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    extraPackages = [
      pkgs.jq
      pkgs.gh
      space-sh
      window-title-sh
    ];
    config = ''
      # PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
      # ITEM_DIR="$HOME/.config/sketchybar/items"

      # # Colors
      # BLACK=0xff181926
      # WHITE=0xffcad3f5
      # MAGENTA=0xffc6a0f6
      # BLUE=0xff8aadf4
      # CYAN=0xff7dc4e4
      # GREEN=0xffa6da95
      # YELLOW=0xffeed49f
      # ORANGE=0xfff5a97f
      # RED=0xffed8796
      # GREY=0xff939ab7
      # TRANSPARENT=0x00000000

      # # General bar colors
      # BAR_COLOR=0xff1e1e2e
      # ICON_COLOR=$WHITE # Color of all icons
      # LABEL_COLOR=$WHITE # Color of all labels
      # BACKGROUND_1=0xff3c3e4f
      # BACKGROUND_2=0xff494d64

      # POPUP_BACKGROUND_COLOR=$BLACK
      # POPUP_BORDER_COLOR=$WHITE

      # SHADOW_COLOR=$BLACK

      # # Item specific special colors
      # SPOTIFY_GREEN=0xff1db954
      # PADDING=3

      # # General bar config
      # sketchybar --bar height=38 \
      #                 blur_radius=0 \
      #                 position=top \
      #                 sticky=on \
      #                 padding_left=10 \
      #                 padding_right=10 \
      #                 color=$BAR_COLOR \
      #                 y_offset=0 \
      #                 margin=0 \
      #                 corner_radius=0

      # # Setting up default values
      # sketchybar --default updates=when_shown \
      #                     drawing=on \
      #                     cache_scripts=on \
      #                     icon.font="Hack Nerd Font:Bold:17.0" \
      #                     icon.color=$ICON_COLOR \
      #                     icon.highlight_color=$GREY \
      #                     label.font="Hack Nerd Font:Bold:14.0" \
      #                     label.color=$LABEL_COLOR \
      #                     label.highlight_color=$GREY \
      #                     label.padding_left=$PADDING \
      #                     label.padding_right=$PADDING \
      #                     icon.padding_left=$PADDING \
      #                     icon.padding_right=$PADDING

      # # Left
      # sketchybar --add item logo left \
      #           --set logo icon= \
      #                 icon.color=$MAGENTA \
      #                 icon.padding_right=15 \
      #                 label.drawing=off \
      #                 click_script='sketchybar --update'

      # # Space number
      # sketchybar --add event window_focus \
      #           --add event title_change \
      #           --add event space_change

      # SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

      # for i in "''${!SPACE_ICONS[@]}"
      # do
      #   sid=$(($i+1))
      #   sketchybar --add space space.$sid left \
      #             --set space.$sid associated_space=$sid \
      #                               icon="''${SPACE_ICONS[i]}" \
      #                               icon.padding_left=8 \
      #                               icon.padding_right=8 \
      #                               icon.highlight_color=$MAGENTA \
      #                               background.padding_left=5 \
      #                               background.padding_right=5 \
      #                               background.color=$BACKGROUND_1 \
      #                               background.corner_radius=5 \
      #                               background.height=22 \
      #                               background.drawing=off \
      #                               label.drawing=off \
      #                               script="${space-sh}/bin/space.sh" \
      #                               click_script="yabai -m space --focus $sid"
      # done

      # # Window title
      # sketchybar --add item title left \
      #           --set title script="${window-title-sh}/bin/window_title.sh" \
      #                 icon.drawing=off \
      #           --subscribe title window_focus front_app_switched space_change title_change

      # # Adding right items
      # sketchybar --add item time right \
      #           --set time update_freq=1 \
      #                 icon.drawing=off \
      #                 script="date '+%I:%M %p'"

      # sketchybar --add item date right \
      #           --set date update_freq=1000 \
      #                 icon.drawing=off \
      #                 script="date '+%a %d/%m/%y'"

      # sketchybar --add item battery right \
      #           --set battery update_freq=3 \
      #                 icon.drawing=off \
      #                 script="pmset -g batt | grep -Eo '\d+%'"

      # # Finalizing setup
      # sketchybar --update
    '';
  };
}