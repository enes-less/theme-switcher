{
  "label" : "lock",
  "action" : "pkill -x wlogout || true; sleep 0.2; hyprlock",
  "text" : "Lock",
  "keybind" : "l"
}

{
  "label" : "logout",
  "action" : "hyprctl dispatch exit",
  "text" : "Logout",
  "keybind" : "e"
}

{
  "label" : "suspend",
  "action" : "systemctl suspend",
  "text" : "Suspend",
  "keybind" : "u"
}

{
  "label" : "hibernate",
  "action" : "systemctl hibernate",
  "text" : "Hibernate",
  "keybind" : "h"
}

{
  "label" : "reboot",
  "action" : "systemctl reboot",
  "text" : "Reboot",
  "keybind" : "r"
}

{
  "label" : "shutdown",
  "action" : "systemctl poweroff",
  "text" : "Shutdown",
  "keybind" : "s"
}