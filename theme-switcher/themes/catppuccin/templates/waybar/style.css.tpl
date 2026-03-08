/* Single Center Pill (visible) — window stays full width, UI doesn't */

* {
  border: none;
  min-height: 0;
  font-family: {{font_family}};
  font-size: 12px;
  margin: 0;
}

window#waybar {
  background: transparent;
}

#waybar {
  background: transparent;
  margin: 0;
}

/* Only the center module group becomes the island */
.modules-center {
  background: rgba(46, 52, 64, 0.25);
  color: {{fg}};
  margin: 0;
  padding: 6px 6px;
  border-radius: 17px;
}

/* Left/right invisible (also empty in config, but keep safe) */
.modules-left,
.modules-right {
  background: transparent;
}

/* No per-module pills */
#pulseaudio,
#network,
#bluetooth,
#clock,
#tray,
#custom-notification {
  background: transparent;
  padding: 0 0 0 10px;
  margin: 0;
}

#custom-notification {
  padding: 0 10px 0 10px;
}

/* Module colors */
#pulseaudio {
  color: {{orange}} ;
}

#network {
  color: {{green}};
}

#bluetooth {
  color: {{blue}};
}

#clock {
  color: {{accent}};
}

#custom-notification {
  color: {{red}};
}

/* Workspace container */
#workspaces {
  padding: 0 4px;
}

/* Default workspaces (inactive) */
#workspaces button {
  min-width: 10px;
  min-height: 10px;

  margin: 0 4px;
  padding: 0 4px;

  background: transparent;
  border: 2px solid {{accent}};
  border-radius: 4px;

  color: {{fg}};
}

/* Active workspace */
#workspaces button.active {
  min-width: 32px;
  min-height: 12px;

  background: {{accent}};
  border-radius: 6px;
  border: none;

  color: {{bg}};
}

/* Hover (optional) */
#workspaces button:hover {
  background: {{surface}};
}

#workspaces button.active:hover {
  background: {{accent}};
}

/* Subtle separators inside the pill */
#pulseaudio,
#network,
#bluetooth,
#clock,
#tray,
#custom-notification {
  border-left: 1px solid {{surface2}};
  padding-left: 12px;
}
