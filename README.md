# Hyprland Theme Switcher

A theme switcher for Hyprland setups that renders one theme across multiple applications from a single palette.

The goal is simple:

- define colors once
- apply them everywhere
- keep the desktop consistent

## Features

- Single-command theme switching
- Shared color palette across supported applications
- Template-based config generation
- Theme-specific wallpaper support
- Dynamic theme support through `matugen`
- Safe reload behavior when optional apps are not installed

## Requirements

This project assumes you are already using **Hyprland**.

Required:

- `jq`
- `swww`
- `bash`
- `sed`
- `pgrep`
- `pkill`
- `mktemp`
- `rofi` or `wofi` for theme and wallpaper pickers

Optional:

- `matugen` for the `dynamic` theme
- `ddcutil` and `inotifywait` for the SwayNC brightness daemon

## Fonts

The configuration expects:

**JetBrainsMono Nerd Font**

If it is missing, applications will fall back to another font.

You can change the font from the templates if needed.

## Supported Applications

The switcher currently generates configuration for:

- Waybar
- Wofi / Rofi
- Kitty
- Fastfetch
- Starship
- Hyprlock
- SwayNC
- Wlogout
- Peaclock
- Obsidian

If a supported application is not installed, configuration files may still be generated, but reload commands for that application will have no effect.

## Notes

### Dynamic theme

`matugen` support is included, but completely optional.

The `dynamic` theme uses `matugen` to generate `colors.json` from the selected wallpaper.

---

### Rofi / Wofi behavior

If `rofi` is installed, the picker scripts use Rofi.

If `rofi` is not installed but `wofi` is, they fall back to Wofi.

---

### Obsidian

Obsidian uses vault-specific snippets.

Because of that, the theme switcher expects a vault named `obsidian` under your home directory by default.

This behavior can be changed in the Obsidian block inside `apply-theme.sh`.

If you do not want to edit the script, create a vault called `obsidian`, apply a theme, then enable the generated snippet from Obsidian settings.

---

### Peaclock

Peaclock reads its configuration when it starts.

If Peaclock is already running while you switch themes, it will not update immediately.

Restart Peaclock after switching themes.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/enes-less/theme-switcher.git
cd theme-switcher
```

2. Run the installer:

```bash
chmod +x ./install.sh
./install.sh
```

The installer will:

- back up your existing Hyprland configuration
- install the Hyprland config files
- install the theme switcher into `~/.config/theme-switcher`
- install helper scripts into `~/bin`
- install SwayNC helper scripts
- install and enable the `brightnessd.service` user service

## Usage

Apply a theme with:

~/.config/theme-switcher/apply-theme.sh <theme>

If your keybinds are already set up, you can also use the picker scripts from there.

## Generated Theme Note

The repository includes a default `generated-theme.conf` so Hyprland starts with a valid theme file.

However, this does **not** mean the full theme has already been applied.

Reloading Hyprland only loads the Hyprland-side configuration.

To apply the full theme across supported applications such as Waybar, Kitty, Wofi, Rofi, SwayNC, and others, you still need to apply a theme through the theme switcher.
