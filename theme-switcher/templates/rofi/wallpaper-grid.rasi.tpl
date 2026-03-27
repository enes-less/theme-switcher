configuration {
    modi:         "dmenu";
    show-icons:   true;
    hover-select: true;
    me-select-entry: "";
    me-accept-entry: "MousePrimary";
    font:         "{{font_family}} 11";
}

* {
    background-color: transparent;
    text-color:       {{fg}};
    spacing:          0;
    padding:          0;
    margin:           0;
}

window {
    background-color: {{bg}}aa;
    border:           2px;
    border-color:     {{accent}};
    border-radius:    20px;
    width:            1120px;
    location:         center;
    anchor:           center;
}

mainbox {
    background-color: transparent;
    children:         [inputbar, listview];
    padding:          20px;
    spacing:          16px;
}

inputbar {
    background-color: {{surface}}88;
    border-radius:    14px;
    padding:          12px 16px;
    children:         [prompt, entry];
    spacing:          10px;
}

prompt {
    background-color: transparent;
    text-color:       {{accent}};
}

entry {
    background-color:  transparent;
    text-color:        {{fg}};
    placeholder:       " Select wallpaper...";
    placeholder-color: {{fg_dim}};
    vertical-align:    0.5;
}

listview {
    background-color: transparent;
    columns:          4;
    lines:            2;
    spacing:          16px;
    padding:          4px;
    scrollbar:        true;
    fixed-columns:    false;
    fixed-height:     false;
    cycle:            true;
    dynamic:          true;
    layout:           vertical;
    flow:             horizontal;
    border:           0px;
}

scrollbar {
    width:            8px;
    border:           0;
    border-radius:    999px;
    background-color: {{surface2}}16;
    handle-width:     8px;
    handle-color:     {{accent}};
}

element {
    border-radius:    16px;
    padding:          16px;
    spacing:          10px;
    orientation:      vertical;
    cursor:           pointer;
}

element normal.normal,
element alternate.normal {
    background-color: {{surface}}88;
}

element selected.normal {
    background-color: {{accent}}33;
    border:           2px;
    border-color:     {{accent}};
}

element-icon {
    background-color: transparent;
    border-radius:    10px;
    cursor:           inherit;
    horizontal-align: 0.5;
    vertical-align:   0.5;
    size:             180px;
}

element-text {
    background-color: transparent;
    text-color:       {{fg}}f2;
    cursor:           inherit;
    font:             "{{font_family}} 11";
    horizontal-align: 0.5;
    vertical-align:   0.5;
}

element selected.normal element-text {
    text-color: {{accent}}f2;
}