background {
    monitor =
    # path = {{wallpaper_path}}
    color = {{bg}}
    blur_passes = 2
    contrast = 0.8916
    brightness = 0.8172
    vibrancy = 0.1696
    vibrancy_darkness = 0.0
}

general {
    no_fade_in = false
    grace = 0
    disable_loading = true
}

input-field {
    monitor =
    size = 250, 60
    outline_thickness = 2
    dots_size = 0.2
    dots_spacing = 0.2
    dots_center = true

    outer_color = {{border}}
    inner_color = {{input_bg}}
    font_color = {{fg}}

    fade_on_empty = true
    placeholder_text = <span foreground="{{fg_hex}}">Password...</span>
    hide_input = false
    position = 0, -120
    halign = center
    valign = center
}

label {
    monitor =
    text = $TIME
    color = {{fg}}
    font_size = 120
    font_family = {{font_family_bold}}
    position = 0, 80
    halign = center
    valign = center
}

label {
    monitor =
    text = hi, $USER
    color = {{accent}}
    font_size = 25
    font_family = {{font_family}}
    position = 0, -40
    halign = center
    valign = center
}