# Hyprland Theme Switcher

A modular theme switcher for Hyprland setups.

This project applies a single theme definition to multiple components in your desktop environment.

Themes are defined once and automatically rendered into configuration files for supported applications.

The idea is simple:

- define a palette once
- apply it everywhere
- keep your system visually consistent

---

# Features

- Single-command theme switching
- Unified color palette system
- Template-based configuration rendering
- Wallpaper switching support (theme-specific)
- Works across multiple UI components
- Safe reload behavior (won't crash if an app isn't installed)

---

# Requirements

This project assumes you are already running **Hyprland**.

The following tools **must** be installed:

- `jq` – used to parse JSON theme files
- `swww` – used to change wallpapers

The script also relies on common Linux utilities which normally already exist:

- `bash`
- `sed`
- `pgrep`
- `pkill`
- `mktemp`

---

# Fonts

The configuration expects this font to exist:

**JetBrainsMono Nerd Font**

If the font is missing, applications will fall back to another font. You can edit the font from templates. This requires a bit of knowledge, and understanding of code.

---

# Supported Applications

The theme switcher can currently generate configuration for the following programs:

- Waybar
- Wofi
- Kitty
- Starship
- Hyprlock
- SwayNC
- Wlogout
- Peaclock

If one of these programs is not installed, the script will still generate the configuration files. Reload commands will simply have no effect.

Peaclock runs as a live terminal application and loads its configuration when launched.  
Because of this, theme changes applied while Peaclock is already running will not take effect immediately.  
To apply the new theme, restart Peaclock after switching themes.

More programs will be added in future.

---

# Installation

1. Clone the repository

```bash
   git clone https://github.com/enes-less/theme-switcher.git
   cd theme-switcher
```

2. Move the scripts to a directory in your PATH

```bash
   mkdir -p ~/bin
   cp scripts/\* ~/bin/
```

3. Install the theme-switcher system

```bash
   cp -r theme-switcher ~/.config/
```

4. Install the Hyprland configuration
   - Note: This will override your existing hyprland config. Make a backup of your own config before proceeding.

```bash
   mkdir -p ~/.config/hypr
   cp -r hyprland/* ~/.config/hypr/
```

5. Reload Hyprland

```bash
   hyprctl reload
```

6. Open the theme picker and select a theme

   Default keybind: $mainMod + T (Windows Key + T)

   Selecting a theme will generate and apply configuration files for supported applications.

   For each theme, there are multiple wallpaper options. You can pick wallpapers using:
   $mainMod + W

---

# Note

The repository includes a default `generated-theme.conf` so Hyprland has a valid theme configuration from the start.

However, the full theme is not applied until you select one through the theme picker. Reloading Hyprland only loads the provided Hyprland configuration.

To apply the full theme across supported applications such as Waybar, Kitty, and Wofi, you must select a theme using the theme picker.

Also, GTK font choice will not be effected with the current version of the theme switcher. An optional apply function will be implemented.
