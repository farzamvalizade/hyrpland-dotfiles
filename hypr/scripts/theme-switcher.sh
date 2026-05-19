#!/usr/bin/env bash

CONFIG_HOME="$HOME/.config"
THEMES_DIR="$CONFIG_HOME/hypr/settings/themes"
WAYBAR_COLORS_DIR="$CONFIG_HOME/waybar/colors"
ROFI_COLORS_DIR="$CONFIG_HOME/rofi/launchers/shared"
KITTY_THEMES_DIR="$CONFIG_HOME/kitty/kitty-themes"

# --- Theme selection ---
mapfile -t AVAILABLE_THEMES < <(find "$THEMES_DIR" -maxdepth 1 -type d -exec test -f {}/hyprland.conf \; -printf "%f\n" | sort)
if [ ${#AVAILABLE_THEMES[@]} -eq 0 ]; then
    echo "ERROR: No valid themes found in $THEMES_DIR"
    exit 1
fi

if command -v rofi &>/dev/null; then
    SELECTED_THEME=$(printf "%s\n" "${AVAILABLE_THEMES[@]}" | rofi -dmenu -p "Select theme" -theme ~/.config/rofi/launchers/style-1.rasi -theme-str 'window {width: 20%;}')
elif command -v wofi &>/dev/null; then
    SELECTED_THEME=$(printf "%s\n" "${AVAILABLE_THEMES[@]}" | wofi --dmenu -p "Select theme")
elif command -v fzf &>/dev/null; then
    SELECTED_THEME=$(printf "%s\n" "${AVAILABLE_THEMES[@]}" | fzf --prompt="Theme: ")
else
    echo "Available themes:"
    select SELECTED_THEME in "${AVAILABLE_THEMES[@]}"; do
        if [ -n "$SELECTED_THEME" ]; then break; fi
    done
fi

[ -z "$SELECTED_THEME" ] && echo "No theme selected. Exiting." && exit 0

# --- Hyprland ---
THEME_FILE="$THEMES_DIR/$SELECTED_THEME/hyprland.conf"
if [ ! -f "$THEME_FILE" ]; then
    echo "ERROR: Theme file not found: $THEME_FILE"
    exit 1
fi
echo "$SELECTED_THEME" > "$HOME/.cache/current_theme"
ln -sf "$THEME_FILE" "$CONFIG_HOME/hypr/active-theme.conf"
hyprctl reload >/dev/null
echo "✓ Hyprland → $SELECTED_THEME"

# --- Waybar (Swaync, Swayosd and wlogout will use this active.css too.) ---
WAYBAR_COLOR_FILE="$WAYBAR_COLORS_DIR/$SELECTED_THEME.css"
if [ -f "$WAYBAR_COLOR_FILE" ]; then
    ln -sf "$WAYBAR_COLOR_FILE" "$WAYBAR_COLORS_DIR/active.css"
    pkill -SIGUSR2 waybar
    echo "✓ Waybar → $SELECTED_THEME"
else
    echo "⚠️ Waybar color file missing: $WAYBAR_COLOR_FILE"
fi

# --- Rofi ---
case "$SELECTED_THEME" in
    "one-dark") ROFI_THEME_FILE="onedark.rasi" ;;
    "rose-pine"|"rose pine") ROFI_THEME_FILE="rosepine.rasi" ;;
    "nord") ROFI_THEME_FILE="nord.rasi" ;;
    *) ROFI_THEME_FILE="" ;;
esac
if [ -n "$ROFI_THEME_FILE" ]; then
    ROFI_COLOR_PATH="$ROFI_COLORS_DIR/$ROFI_THEME_FILE"
    if [ -f "$ROFI_COLOR_PATH" ]; then
        cp "$ROFI_COLOR_PATH" "$ROFI_COLORS_DIR/colors.rasi"
        echo "✓ Rofi → $ROFI_THEME_FILE"
    else
        echo "⚠️ Rofi file missing: $ROFI_COLOR_PATH"
    fi
fi

# --- Kitty ---
KITTY_THEME_FILE="$KITTY_THEMES_DIR/$SELECTED_THEME.conf"
if [ -f "$KITTY_THEME_FILE" ]; then
    ln -sf "$KITTY_THEME_FILE" "$KITTY_THEMES_DIR/active.conf"
    pkill -SIGUSR1 kitty 2>/dev/null && echo "✓ Kitty reloaded (SIGUSR1)" || echo "⚠️ No Kitty windows"
else
    echo "⚠️ Kitty theme missing: $KITTY_THEME_FILE"
fi

# --- Swaync Reload ---
if pgrep -x "swaync" >/dev/null; then
    if command -v swaync-client &>/dev/null; then
        swaync-client -rs >/dev/null 2>&1
        echo "✓ SwayNC CSS reloaded (swaync-client -rs)"
    else
        pkill -HUP swaync 2>/dev/null && echo "✓ SwayNC SIGHUP" || echo "⚠️ SwayNC reload failed"
    fi
else
    swaync &>/dev/null &
    echo "✓ SwayNC started"
fi

# --- Swayosd Reload ---
if pgrep -x "swayosd-server" >/dev/null; then
    pkill swayosd-server 2>/dev/null
    swayosd-server &
    echo "✓ swayosd-server restarted"
else
    swayosd-server &
    echo "✓ swayosd-server started"
fi

# --- Set wallpaper matching the theme ---
if [ -f "$HOME/.local/bin/wallset" ]; then
    "$HOME/.local/bin/wallset" "$SELECTED_THEME"
fi

# --- Notification – sent immediately, not after all components ---
notify-send "Theme Switcher" "Switched to $SELECTED_THEME" -t 1500 &