#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/theme-switcher"
THEME="${1:-}"
THEME_PATH="$BASE/themes/$THEME"

COLORS="$THEME_PATH/colors.json"
THEME_JSON="$THEME_PATH/theme.json"
TPL="$THEME_PATH/templates/hyprland.conf.tpl"
OUT="$HOME/.config/hypr/generated-theme.conf"

# Set theme. This will allow all components load the theme earlier.
[[ -z "$THEME" ]] && { echo "Usage: apply-theme.sh <theme>"; exit 1; }
[[ ! -d "$THEME_PATH" ]] && { echo "Theme not found: $THEME_PATH"; exit 1; }

[[ ! -f "$COLORS" ]] && { echo "Missing: $COLORS"; exit 1; }
[[ ! -f "$THEME_JSON" ]] && { echo "Missing: $THEME_JSON"; exit 1; }
[[ ! -f "$TPL" ]] && { echo "Missing: $TPL"; exit 1; }

# Color converters
hex_to_rgba_ff() {
  local h="${1#\#}"
  [[ "$h" =~ ^[0-9a-fA-F]{6}$ ]] || { echo "Invalid hex: $1" >&2; exit 1; }
  echo "rgba(${h}ff)"
}

hex_to_rgba_css() {
  local hex="${1#\#}"
  local alpha="${2:-1}"
  [[ "$hex" =~ ^[0-9a-fA-F]{6}$ ]] || { echo "Invalid hex: $1" >&2; exit 1; }
  printf "rgba(%d,%d,%d,%s)" \
    $((16#${hex:0:2})) \
    $((16#${hex:2:2})) \
    $((16#${hex:4:2})) \
    "$alpha"
}

hex_to_rgb_css() {
  local hex="${1#\#}"
  [[ "$hex" =~ ^[0-9a-fA-F]{6}$ ]] || { echo "Invalid hex: $1" >&2; exit 1; }
  printf "rgb(%d,%d,%d)" \
    $((16#${hex:0:2})) \
    $((16#${hex:2:2})) \
    $((16#${hex:4:2}))
}

ensure_swww() {
  if ! pgrep -x swww-daemon >/dev/null 2>&1; then
    swww-daemon >/dev/null 2>&1 &
  fi

  # daemon ready wait (max ~1s)
  for _ in {1..20}; do
    swww query >/dev/null 2>&1 && return 0
    sleep 0.05
  done

  echo "Warning: swww-daemon not ready" >&2
  return 1
}

# ---------------- Cache JSON reads (ONLY 2 jq calls total) ----------------

# colors.json -> one shot
IFS=$'\t' read -r \
  bg_hex accent_hex fg_hex fg_dim_hex bg_alt_hex surface_hex surface2_hex \
  red_hex green_hex yellow_hex blue_hex magenta_hex cyan_hex shadow_hex accent_alt_hex \
  pink_hex orange_hex teal_hex lavender_hex sky_hex overlay_hex \
  < <(jq -r '
    [
      (.bg // ""),
      (.accent // ""),
      (.fg // "#ffffff"),
      (.fg_dim // (.fg // "#ffffff")),
      (.bg_alt // ""),
      (.surface // (.bg_alt // .bg // "#000000")),
      (.surface2 // .surface // .bg_alt // .bg // "#000000"),

      (.red // ""),
      (.green // ""),
      (.yellow // ""),
      (.blue // .accent_alt // ""),
      (.magenta // .mauve // ""),
      (.cyan // .teal // ""),
      (.shadow // .bg // "#111111"),
      (.accent_alt // ""),

      (.pink // ""),
      (.orange // ""),
      (.teal // ""),
      (.lavender // ""),
      (.sky // ""),
      (.overlay // "")
    ] | @tsv
  ' "$COLORS")

# theme.json -> one shot
IFS=$'\t' read -r \
  border_size gaps_out rounding blur_enabled_bool blur_size blur_passes blur_vibrancy default_wallpaper \
  font_family font_family_bold \
  < <(jq -r '
    [
      (.hypr.border_size // 3),
      (.hypr.gaps_out // 20),
      (.hypr.rounding // 16),
      (.hypr.blur.enabled // true),
      (.hypr.blur.size // 2),
      (.hypr.blur.passes // 3),
      (.hypr.blur.vibrancy // 0.8),
      (.default_wallpaper // ""),
      (.fonts.family // "JetBrainsMono Nerd Font"),
      (.fonts.family_bold // "JetBrainsMono Nerd Font Bold")
    ] | @tsv
  ' "$THEME_JSON")

[[ -z "$bg_hex" ]] && { echo "colors.json missing .bg"; exit 1; }
[[ -z "$accent_hex" ]] && { echo "colors.json missing .accent"; exit 1; }

# ---------------- One-time fallbacks ----------------
[[ -z "$accent_hex" ]] && accent_hex="${accent_alt_hex:-${green_hex:-${blue_hex:-#7aa2f7}}}"
[[ -z "$fg_hex" ]] && fg_hex="#c0caf5"
[[ -z "$red_hex" ]] && red_hex="${pink_hex:-#f7768e}"
[[ -z "$yellow_hex" ]] && yellow_hex="${orange_hex:-${accent_alt_hex:-#e0af68}}"
[[ -z "$green_hex" ]] && green_hex="${teal_hex:-${accent_hex:-#9ece6a}}"
[[ -z "$blue_hex" ]] && blue_hex="${lavender_hex:-${sky_hex:-${accent_hex:-#7aa2f7}}}"

[[ -z "$bg_hex" ]] && bg_hex="#111111"
bg_alt_hex="${bg_alt_hex:-$surface_hex}"
surface_hex="${surface_hex:-$bg_alt_hex}"
surface2_hex="${surface2_hex:-$surface_hex}"
shadow_hex="${shadow_hex:-$bg_hex}"

# Font fallbacks
[[ -z "$font_family" ]] && font_family="JetBrainsMono Nerd Font"
[[ -z "$font_family_bold" ]] && font_family_bold="JetBrainsMono Nerd Font Bold"

# Kitty-specific fallbacks (no behavior change, just centralized)
[[ -z "$fg_dim_hex" ]] && fg_dim_hex="$fg_hex"
[[ -z "$surface_hex" ]] && surface_hex="${bg_alt_hex:-$bg_hex}"
[[ -z "$surface2_hex" ]] && surface2_hex="$surface_hex"

# NOTE: keep kitty color fallbacks same logic: if missing, use accent
[[ -z "$red_hex" ]] && red_hex="$accent_hex"
[[ -z "$green_hex" ]] && green_hex="$accent_hex"
[[ -z "$yellow_hex" ]] && yellow_hex="$accent_hex"
[[ -z "$magenta_hex" ]] && magenta_hex="$accent_hex"
[[ -z "$cyan_hex" ]] && cyan_hex="$accent_hex"
# --------------------------------------------------------------------------------------

# Read HEX (for other apps). Convert for Hypr.
bg="$(hex_to_rgba_ff "$bg_hex")"
accent="$(hex_to_rgba_ff "$accent_hex")"

# --- Theme vars (0.54-safe: no true/false; use 1/0 for enabled) ---
gaps_in="5"
layout="dwindle"

border_active="$accent"
border_inactive="$bg"

active_opacity="0.9"
inactive_opacity="0.85"

shadow_enabled="1"
shadow_range="4"
shadow_power="3"
shadow_color="rgba(1a1a1aee)"

if [[ "$blur_enabled_bool" == "true" ]]; then
  blur_enabled="1"
else
  blur_enabled="0"
fi

tmp_out="$(mktemp)"
trap 'rm -f "$tmp_out"' EXIT

sed \
  -e "s/{{gaps_in}}/$gaps_in/g" \
  -e "s/{{gaps_out}}/$gaps_out/g" \
  -e "s/{{border_size}}/$border_size/g" \
  -e "s/{{layout}}/$layout/g" \
  -e "s/{{border_active}}/$border_active/g" \
  -e "s/{{border_inactive}}/$border_inactive/g" \
  -e "s/{{rounding}}/$rounding/g" \
  -e "s/{{active_opacity}}/$active_opacity/g" \
  -e "s/{{inactive_opacity}}/$inactive_opacity/g" \
  -e "s/{{shadow_enabled}}/$shadow_enabled/g" \
  -e "s/{{shadow_range}}/$shadow_range/g" \
  -e "s/{{shadow_power}}/$shadow_power/g" \
  -e "s/{{shadow_color}}/$shadow_color/g" \
  -e "s/{{blur_enabled}}/$blur_enabled/g" \
  -e "s/{{blur_size}}/$blur_size/g" \
  -e "s/{{blur_passes}}/$blur_passes/g" \
  -e "s/{{blur_vibrancy}}/$blur_vibrancy/g" \
  -e "s/{{font_family}}/$font_family/g" \
  -e "s/{{font_family_bold}}/$font_family_bold/g" \
  "$TPL" > "$tmp_out"

mkdir -p "$(dirname "$OUT")"
mv "$tmp_out" "$OUT"

# --------- Wallpaper - SWWW ----------
wp_rel=""

if [[ -f "$THEME_PATH/current-wallpaper.txt" ]]; then
  wp_rel="$(cat "$THEME_PATH/current-wallpaper.txt" 2>/dev/null || true)"
fi

if [[ -z "$wp_rel" ]]; then
  wp_rel="$default_wallpaper"
fi

if [[ -n "$wp_rel" ]]; then
  wp_abs="$THEME_PATH/$wp_rel"
  if [[ -f "$wp_abs" ]]; then
    ensure_swww || true
    swww img "$wp_abs" --transition-type wipe --transition-angle 29 --transition-duration 0.75 --transition-fps 75 --transition-bezier 0.25,0.1,0.25,1 >/dev/null 2>&1 || true
  else
    echo "Warning: wallpaper not found: $wp_abs" >&2
  fi
fi

printf '{ "theme": "%s", "wallpaper": "%s" }\n' "$THEME" "${wp_rel:-}" > "$BASE/current-theme.json"

# --- Derived colors for CSS (wofi etc.) ---
bg_rgba="$(hex_to_rgba_css "$bg_hex" "0.85")"
surface_rgba="$(hex_to_rgba_css "$surface_hex" "0.70")"
accent_soft="$(hex_to_rgba_css "$accent_hex" "0.15")"

# --------- Wofi ----------
WOFI_TPL="$BASE/templates/wofi.css.tpl"
WOFI_OUT="$HOME/.config/wofi/style.css"

if [[ -f "$WOFI_TPL" ]]; then
  mkdir -p "$HOME/.config/wofi"

  sed \
    -e "s/{{bg_rgba}}/$bg_rgba/g" \
    -e "s/{{surface_rgba}}/$surface_rgba/g" \
    -e "s/{{fg}}/$fg_hex/g" \
    -e "s/{{accent}}/$accent_hex/g" \
    -e "s/{{accent_soft}}/$accent_soft/g" \
    -e "s/{{bg}}/$bg_hex/g" \
    -e "s/{{font_family}}/$font_family/g" \
    -e "s/{{font_family_bold}}/$font_family_bold/g" \
    "$WOFI_TPL" > "$WOFI_OUT"
fi

# --------- Rofi ----------
ROFI_TPL_DIR="$BASE/templates/rofi"
ROFI_OUT_DIR="$HOME/.config/rofi"

if [[ -d "$ROFI_TPL_DIR" ]]; then
  mkdir -p "$ROFI_OUT_DIR"

  for tpl in "$ROFI_TPL_DIR"/*.tpl; do
    [[ -f "$tpl" ]] || continue
    out="$ROFI_OUT_DIR/$(basename "$tpl" .tpl)"

    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{surface}}/$surface_hex/g" \
      -e "s/{{surface2}}/$surface2_hex/g" \
      -e "s/{{overlay}}/$overlay_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{font_family}}/$font_family/g" \
      "$tpl" > "$out"
  done
fi

# --------- Waybar (theme-specific layout + colors) ----------
WAYBAR_DIR="$THEME_PATH/templates/waybar"
WAYBAR_OUT_DIR="$HOME/.config/waybar"
WAYBAR_CFG_OUT="$WAYBAR_OUT_DIR/config"
WAYBAR_STYLE_OUT="$WAYBAR_OUT_DIR/style.css"

if [[ -d "$WAYBAR_DIR" ]]; then
  mkdir -p "$WAYBAR_OUT_DIR"

  if [[ -f "$WAYBAR_DIR/config" ]]; then
    cp "$WAYBAR_DIR/config" "$WAYBAR_CFG_OUT"
  fi

  if [[ -f "$WAYBAR_DIR/style.css.tpl" ]]; then
    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{accent_alt}}/$accent_alt_hex/g" \
      -e "s/{{green}}/$green_hex/g" \
      -e "s/{{yellow}}/$yellow_hex/g" \
      -e "s/{{orange}}/$orange_hex/g" \
      -e "s/{{blue}}/$blue_hex/g" \
      -e "s/{{teal}}/$teal_hex/g" \
      -e "s/{{red}}/$red_hex/g" \
      -e "s/{{pink}}/$pink_hex/g" \
      -e "s/{{lavender}}/$lavender_hex/g" \
      -e "s/{{surface}}/$surface_hex/g" \
      -e "s/{{surface2}}/$surface2_hex/g" \
      -e "s/{{font_family}}/$font_family/g" \
      -e "s/{{font_family_bold}}/$font_family_bold/g" \
      "$WAYBAR_DIR/style.css.tpl" > "$WAYBAR_STYLE_OUT"
  fi

  pkill waybar >/dev/null 2>&1 || true
  waybar >/dev/null 2>&1 &
fi

# --------- Starship (theme-aware) ----------
STARSHIP_TPL="$BASE/templates/starship.toml.tpl"
STARSHIP_OUT="$HOME/.config/starship.toml"
STARSHIP_LOG="/tmp/theme-switcher.log"

if [[ -f "$STARSHIP_TPL" ]]; then
  mkdir -p "$HOME/.config"

  tmp_star="$(mktemp)"
  if sed \
    -e "s/{{accent}}/$accent_hex/g" \
    -e "s/{{fg}}/$fg_hex/g" \
    -e "s/{{red}}/$red_hex/g" \
    -e "s/{{yellow}}/$yellow_hex/g" \
    -e "s/{{green}}/$green_hex/g" \
    -e "s/{{blue}}/$blue_hex/g" \
    -e "s/{{bg}}/$bg_hex/g" \
    -e "s/{{bg_alt}}/$bg_alt_hex/g" \
    -e "s/{{surface}}/$surface_hex/g" \
    -e "s/{{surface2}}/$surface2_hex/g" \
    -e "s/{{shadow}}/$shadow_hex/g" \
    -e "s/{{font_family}}/$font_family/g" \
    -e "s/{{font_family_bold}}/$font_family_bold/g" \
    "$STARSHIP_TPL" > "$tmp_star"; then
    mv "$tmp_star" "$STARSHIP_OUT"
    echo "STARSHIP OK $(date) -> $STARSHIP_OUT" >> "$STARSHIP_LOG"
  else
    rm -f "$tmp_star"
    echo "STARSHIP FAIL $(date) (sed render)" >> "$STARSHIP_LOG"
  fi
fi

# --------- Kitty ----------
KITTY_TPL="$BASE/templates/kitty.conf.tpl"
KITTY_OUT="$HOME/.config/kitty/theme.conf"

if [[ -f "$KITTY_TPL" ]]; then
  mkdir -p "$HOME/.config/kitty"

  sed \
    -e "s/{{bg}}/$bg_hex/g" \
    -e "s/{{fg}}/$fg_hex/g" \
    -e "s/{{fg_dim}}/$fg_dim_hex/g" \
    -e "s/{{accent}}/$accent_hex/g" \
    -e "s/{{surface}}/$surface_hex/g" \
    -e "s/{{surface2}}/$surface2_hex/g" \
    -e "s/{{red}}/$red_hex/g" \
    -e "s/{{green}}/$green_hex/g" \
    -e "s/{{yellow}}/$yellow_hex/g" \
    -e "s/{{blue}}/$blue_hex/g" \
    -e "s/{{magenta}}/$magenta_hex/g" \
    -e "s/{{cyan}}/$cyan_hex/g" \
    -e "s/{{font_family}}/$font_family/g" \
    -e "s/{{font_family_bold}}/$font_family_bold/g" \
    "$KITTY_TPL" > "$KITTY_OUT"

  for s in /tmp/kitty.sock-*; do
    [[ -S "$s" ]] || continue
    kitty @ --to "unix:$s" set-colors -a "$KITTY_OUT" >/dev/null 2>&1 || true
  done
fi

# --------- Hyprlock ----------
HYPRLOCK_TPL="$THEME_PATH/templates/hyprlock.conf.tpl"
HYPRLOCK_OUT="$HOME/.config/hypr/hyprlock.conf"

if [[ -f "$HYPRLOCK_TPL" ]]; then
  mkdir -p "$(dirname "$HYPRLOCK_OUT")"

  hypr_bg="$(hex_to_rgba_css "$bg_hex" "1.0")"
  hypr_fg="$(hex_to_rgb_css "$fg_hex")"

  input_bg_src="${bg_alt_hex:-${surface_hex:-$bg_hex}}"
  border_src="${border_active_hex:-${accent_hex}}"
  accent_src="${accent_hex:-${accent_alt_hex:-$fg_hex}}"

  hypr_input_bg="$(hex_to_rgb_css "$input_bg_src")"
  hypr_border="$(hex_to_rgb_css "$border_src")"
  hypr_accent="$(hex_to_rgb_css "$accent_src")"

  sed \
    -e "s|{{bg}}|$hypr_bg|g" \
    -e "s|{{fg}}|$hypr_fg|g" \
    -e "s|{{input_bg}}|$hypr_input_bg|g" \
    -e "s|{{border}}|$hypr_border|g" \
    -e "s|{{accent}}|$hypr_accent|g" \
    -e "s|{{fg_hex}}|$fg_hex|g" \
    -e "s|{{font_family}}|$font_family|g" \
    -e "s|{{font_family_bold}}|$font_family_bold|g" \
    -e "s|{{wallpaper_path}}||g" \
    "$HYPRLOCK_TPL" > "$HYPRLOCK_OUT"
fi

# --------- SwayNC ----------
SWAYNC_TPL_DIR="$BASE/templates/swaync"
SWAYNC_OUT_DIR="$HOME/.config/swaync"

SWAYNC_CFG_TPL="$SWAYNC_TPL_DIR/config.json.tpl"
SWAYNC_STYLE_TPL="$SWAYNC_TPL_DIR/style.css.tpl"

SWAYNC_CFG_OUT="$SWAYNC_OUT_DIR/config.json"
SWAYNC_STYLE_OUT="$SWAYNC_OUT_DIR/style.css"

if [[ -d "$SWAYNC_TPL_DIR" ]]; then
  mkdir -p "$SWAYNC_OUT_DIR"

  if [[ -f "$SWAYNC_CFG_TPL" ]]; then
    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{blue}}/$blue_hex/g" \
      -e "s/{{lavender}}/$lavender_hex/g" \
      -e "s/{{font_family}}/$font_family/g" \
      -e "s/{{font_family_bold}}/$font_family_bold/g" \
      "$SWAYNC_CFG_TPL" > "$SWAYNC_CFG_OUT"
  fi

  if [[ -f "$SWAYNC_STYLE_TPL" ]]; then
    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{accent_alt}}/$accent_hex/g" \
      -e "s/{{font_family}}/$font_family/g" \
      -e "s/{{font_family_bold}}/$font_family_bold/g" \
      "$SWAYNC_STYLE_TPL" > "$SWAYNC_STYLE_OUT"
  fi

  # reload swaync safely
  if command -v swaync-client >/dev/null 2>&1; then
    swaync-client -R >/dev/null 2>&1 || true
    swaync-client -rs >/dev/null 2>&1 || true
  fi
fi

# --------- Wlogout ----------
WLOGOUT_TPL_DIR="$BASE/templates/wlogout"
WLOGOUT_ICON_TPL_DIR="$WLOGOUT_TPL_DIR/icons"

WLOGOUT_OUT_DIR="$HOME/.config/wlogout"
WLOGOUT_ICON_OUT_DIR="$WLOGOUT_OUT_DIR/icons"

WLOGOUT_LAYOUT_TPL="$WLOGOUT_TPL_DIR/wlogout-layout.tpl"
WLOGOUT_STYLE_TPL="$WLOGOUT_TPL_DIR/wlogout-style.css.tpl"

WLOGOUT_LAYOUT_OUT="$WLOGOUT_OUT_DIR/layout"
WLOGOUT_STYLE_OUT="$WLOGOUT_OUT_DIR/style.css"

if [[ -d "$WLOGOUT_TPL_DIR" ]]; then
  mkdir -p "$WLOGOUT_OUT_DIR" "$WLOGOUT_ICON_OUT_DIR"

  if [[ -f "$WLOGOUT_LAYOUT_TPL" ]]; then
    cp "$WLOGOUT_LAYOUT_TPL" "$WLOGOUT_LAYOUT_OUT"
  fi

  if [[ -d "$WLOGOUT_ICON_TPL_DIR" ]]; then
    for tpl in "$WLOGOUT_ICON_TPL_DIR"/*.svg.tpl; do
      [[ -f "$tpl" ]] || continue
      out="$WLOGOUT_ICON_OUT_DIR/$(basename "$tpl" .svg.tpl).svg"

      sed \
        -e "s/{{fg}}/$fg_hex/g" \
        -e "s/{{accent}}/$accent_hex/g" \
        -e "s/{{font_family}}/$font_family/g" \
        -e "s/{{font_family_bold}}/$font_family_bold/g" \
        "$tpl" > "$out"
    done
  fi

  if [[ -f "$WLOGOUT_STYLE_TPL" ]]; then
    wlogout_bg_rgba="$(hex_to_rgba_css "$bg_hex" "0.80")"
    wlogout_surface_rgba="$(hex_to_rgba_css "$surface_hex" "0.70")"

    [[ -z "${overlay_hex:-}" ]] && overlay_hex="${surface2_hex:-$surface_hex}"

    sed \
      -e "s/{{bg_rgba}}/$wlogout_bg_rgba/g" \
      -e "s/{{surface_rgba}}/$wlogout_surface_rgba/g" \
      -e "s/{{surface2}}/$surface2_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{overlay}}/$overlay_hex/g" \
      -e "s|{{icon_dir}}|$WLOGOUT_ICON_OUT_DIR|g" \
      -e "s/{{font_family}}/$font_family/g" \
      -e "s/{{font_family_bold}}/$font_family_bold/g" \
      "$WLOGOUT_STYLE_TPL" > "$WLOGOUT_STYLE_OUT"
  fi
fi

# --------- Peaclock ----------
PEACLOCK_TEMPLATE="$BASE/templates/peaclock.conf.tpl"
PEACLOCK_DIR="$HOME/.config/peaclock"
PEACLOCK_OUT="$PEACLOCK_DIR/config"

if [[ -f "$PEACLOCK_TEMPLATE" ]]; then
  mkdir -p "$PEACLOCK_DIR"

  peaclock_lavender="${lavender_hex:-${accent_alt_hex:-$accent_hex}}"
  peaclock_red="${red_hex:-#f38ba8}"

  sed \
    -e "s/{{bg}}/$bg_hex/g" \
    -e "s/{{fg}}/$fg_hex/g" \
    -e "s/{{blue}}/$blue_hex/g" \
    -e "s/{{accent}}/$accent_hex/g" \
    -e "s/{{red}}/$peaclock_red/g" \
    -e "s/{{font_family}}/$font_family/g" \
    -e "s/{{font_family_bold}}/$font_family_bold/g" \
    "$PEACLOCK_TEMPLATE" > "$PEACLOCK_OUT"
fi

hyprctl reload >/dev/null 2>&1 || true