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

This project assumes you are already using **Hyprland**, and have a working Hyprland setup.

### Absolutely required
- `bash`

### Required for all core functions
- `jq`
- `sed`
- `find`
- `sort`
- `mktemp`
- `pgrep`
- `pkill`
- `hyprctl`
- `swww`

### Required for dynamic theme
- `matugen`

### Required for the theme/wallpaper picker (choose one)
- `rofi`
- `wofi`

### Additional feature-specific dependencies
- `ddcutil` — required for the SwayNC brightness scripts
- `inotify-tools` (`inotifywait`) — required for the `brightnessd` daemon
- `systemd` / `systemctl --user` — required if you want the installer to enable and start `brightnessd.service`
- `imagemagick` (`magick` or `convert`) — optional, only for thumbnail generation in the theme picker

## Fonts

The configuration expects:

**JetBrainsMono Nerd Font**

If it is missing, applications will fall back to another font. Icons might not appear. You can use any Nerd Font you want.

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
- VSCode

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

Available options for `./install.sh`:

- `--dry-run`  
  Show what would be done without writing, copying, deleting, or enabling anything.

- `--skip-systemd`  
  Install files but skip `systemctl --user daemon-reload` and `systemctl --user enable --now brightnessd.service`.

- `--no-backup`  
  Do not create a backup of an existing `~/.config/hypr` directory before installing.

- `--home PATH`  
  Install into an alternate HOME directory instead of your real `$HOME`.

- `--install-deps`  
  Install dependencies before copying files.

- `--no-install-deps`  
  Skip dependency installation and only perform the file installation steps.

- `-h`, `--help`  
  Show the help message and exit.

If run without arguments, or without `--install-deps`, the installer will first ask:

```text
Do you also want to install all dependencies? [Y/n]
```
- Y / Enter → installs dependencies first, then continues with file installation
- n → skips dependency installation and only installs the project files

After that, the installer will:

- Back up your existing Hyprland configuration
- Install the Hyprland config files
- Install the theme switcher into ~/.config/theme-switcher
- Install helper scripts into ~/bin
- Install SwayNC helper scripts
- Install and enable the brightnessd.service user service

## Usage

After installation:

1. Open the theme picker with:

   `$mainMod + T`

2. Open the wallpaper picker for the current theme with:

   `$mainMod + W`

In the included Hyprland configuration, `$mainMod` is set to the Super key. Change it if needed.

## Generated Theme Note

The repository includes a default `generated-theme.conf` so Hyprland starts with a valid theme file.

However, this does **not** mean the full theme has already been applied.

Reloading Hyprland only loads the Hyprland-side configuration.

To apply the full theme across supported applications such as Waybar, Kitty, Wofi, Rofi, SwayNC, and others, you still need to apply a theme through the theme switcher.
