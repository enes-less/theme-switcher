# layout
block 2 1
ratio 2 1
date-padding 1

# content
fill ' '
date '%a %d %b'
mode clock
view digital
toggle padding

# behavior
set hour-24 on
set seconds on
set date on
set auto-size off
set auto-ratio on

# colors
style active-fg clear
style inactive-fg clear
style colon-fg clear

style active-bg {{accent}}
style inactive-bg {{bg}}
style colon-bg {{accent}}

style date {{fg}}
style background clear
style text {{fg}}
style prompt {{fg}}
style success {{blue}}
style error {{red}}