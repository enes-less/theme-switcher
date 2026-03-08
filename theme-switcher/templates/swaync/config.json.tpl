{
  "$schema": "/etc/xdg/swaync/configSchema.json",
  "positionX": "right",
  "positionY": "top",
  "layer": "overlay",
  "control-center-positionX": "right",
  "control-center-positionY": "top",
  "control-center-layer": "top",
  "control-center-exclusive-zone": true,
  "control-center-width": 420,
  "fit-to-screen": true,
  "notification-window-width": 420,
  "widgets": [
    "buttons-grid#cc_controls",
    "volume#cc_volume",
    "slider#cc_brightness",
    "label#notif_title",
    "notifications#cc_notifications"
  ],
  "widget-config": {
    "buttons-grid#cc_controls": {
      "buttons-per-row": 3,
      "actions": [
        {
          "label": "󰖩 Network",
          "command": "sh -c 'kitty -e nmtui >/dev/null 2>&1 & disown; swaync-client -cp'"
        },
        {
          "label": "󰂯 Bluetooth",
          "command": "sh -c 'blueman-manager >/dev/null 2>&1 & disown; sleep 0.1; swaync-client -cp'"
        },
        {
          "label": "󰖔 Focus",
          "type": "toggle",
          "command": "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && swaync-client -dn || swaync-client -df'",
          "update-command": "sh -c '[[ $(swaync-client -D) == \"true\" ]] && echo true || echo false'"
        }
      ]
    },
    "volume#cc_volume": {
      "label": "Volume",
      "show-per-app": false
    },
    "slider#cc_brightness": {
      "label": "Brightness",
      "min_limit": 0,
      "max_limit": 100,
      "min": 0,
      "max": 100,
      "cmd_getter": "~/.config/swaync/scripts/brightness_get.sh",
      "cmd_setter": "~/.config/swaync/scripts/brightness_set.sh $value"
    },
    "label#notif_title": {
      "text": "Notifications"
    },
    "notifications#cc_notifications": {
      "vexpand": true
    }
  }
}
