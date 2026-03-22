{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "~/.config/fastfetch/ascii.txt",
    "type": "file",
    "padding": {
      "top": 0,
      "left": 3
    },
    "color": {
      "1": "{{fg}}"
    }
  },
  "display": {
    "separator": "",
    "key": {
      "width": 15
    }
  },
  "modules": [
    {
      "key": " user",
      "type": "title",
      "format": "{user-name}",
      "keyColor": "31"
    },
    {
      "key": "󰇅 hostname",
      "type": "title",
      "format": "{host-name}",
      "keyColor": "32"
    },
    {
      "key": "󰅐 uptime",
      "type": "uptime",
      "keyColor": "33"
    },
    {
      "key": "{icon} distro",
      "type": "os",
      "keyColor": "34"
    },
    {
      "key": " kernel",
      "type": "kernel",
      "keyColor": "35"
    },
    {
      "key": "󰇄 desktop",
      "type": "de",
      "keyColor": "36"
    },
    {
      "key": " terminal",
      "type": "terminal",
      "keyColor": "31"
    },
    {
      "key": " shell",
      "type": "shell",
      "keyColor": "32"
    },
    {
      "key": "󰍛 cpu",
      "type": "cpu",
      "showPeCoreCount": true,
      "keyColor": "33"
    },
    {
      "key": "󰢮 gpu",
      "type": "gpu",
      "keyColor": "34"
    },
    {
      "key": "󰉉 disk",
      "type": "disk",
      "folders": "/",
      "keyColor": "34"
    },
    {
      "key": " memory",
      "type": "memory",
      "keyColor": "35"
    },
    {
      "key": " colors",
      "type": "colors",
      "symbol": "circle",
      "keyColor": "39"
    }
  ]
}