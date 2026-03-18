/* Catppuccin Mocha palette */
@define-color base   {{bg}};
@define-color mantle {{bg_alt}};
@define-color crust  {{bg}};
@define-color surface0 {{surface}};
@define-color surface1 {{surface2}};
@define-color overlay0 {{overlay}};
@define-color text   {{fg}};
@define-color subtext0 {{fg_dim}};
@define-color blue   {{blue}};
@define-color mauve  {{accent}};
@define-color red    {{red}};
@define-color green  {{green}};
@define-color yellow {{yellow}};
@define-color peach  {{orange}};

* {
    font-family: "JetBrainsMono Nerd Font Mono", "JetBrains Mono", monospace;
    font-size: 13px;
    border: none;
    border-radius: 0;
    min-height: 0;
}

window#waybar {
    background: transparent;
    color: @text;
}

.modules-left,
.modules-center,
.modules-right {
    background: {{bg_rgba}};
    border-radius: 12px;
    padding: 2px 8px;
    border: 1px solid @surface0;
}

/* Arch icon */
#custom-arch {
    color: @blue;
    font-size: 18px;
    padding: 0 8px 0 4px;
}

/* Workspaces */
#workspaces {
    margin: 0 4px;
}

#workspaces button {
    padding: 4px 14px;
    color: @subtext0;
    background: @surface0;
    border-radius: 8px;
    font-size: 14px;
    font-weight: bold;
    transition: all 0.2s ease;
    min-width: 32px;
}

#workspaces button:hover {
    background: @surface0;
    color: @text;
}

@keyframes ws-active {
    0%   { background-color: {{blue}}; }
    50%  { background-color: {{accent}}; }
    100% { background-color: {{blue}}; }
}

@keyframes ws-active {
    0%   { background-color: {{blue}}; }
    50%  { background-color: {{accent}}; }
    100% { background-color: {{blue}}; }
}

#workspaces button.active {
    background-color: {{blue}};
    color: @base;
    font-weight: bold;
    animation: ws-active 3s linear infinite;
}

#workspaces button.urgent {
    background: @red;
    color: @base;
}

/* Window title */
#window {
    color: @subtext0;
    padding: 0 8px;
    font-style: italic;
}

/* Clock */
#clock {
    color: @blue;
    font-weight: bold;
    padding: 0 10px;
}

/* CPU */
#cpu {
    color: @peach;
    padding: 0 8px;
}

#cpu.warning { color: @yellow; }
#cpu.critical { color: @red; }

/* Memory */
#memory {
    color: @mauve;
    padding: 0 8px;
}

/* Network */
#network {
    color: @green;
    padding: 0 8px;
}

#network.disconnected {
    color: @red;
}

/* Audio */
#pulseaudio {
    color: @blue;
    padding: 0 8px;
}

#pulseaudio.muted {
    color: @overlay0;
}

/* Battery */
#battery {
    color: @green;
    padding: 0 8px;
}

#battery.warning {
    color: @yellow;
}

#battery.critical {
    color: @red;
    animation: blink 1s linear infinite;
}

@keyframes blink {
    to { color: @base; background: @red; }
}

/* Tray */
#tray {
    padding: 0 8px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: @red;
    border-radius: 6px;
}

/* Arch icon */
#custom-arch {
    color: @blue;
    font-size: 20px;
    padding: 0 10px;
}

/* Tooltip (calendario y otros) */
tooltip {
    background: @mantle;
    border: 1px solid @surface0;
    border-radius: 14px;
    padding: 20px 28px;
    min-width: 520px;
}

tooltip label {
    color: @text;
    font-family: "JetBrains Mono";
    font-size: 16px;
}

/* Power button */
#custom-swaync {
    padding: 0 15px;
}

#custom-power {
    color: @red;
    padding: 0 10px;
    font-size: 16px;
    font-weight: bold;
}

#custom-power:hover {
    color: @base;
    background: @red;
    border-radius: 8px;
}
