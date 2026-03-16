configuration {
    modi:       "dmenu";
    show-icons: true;
    font:       "JetBrains Mono 11";
}

* {
    bg:     {{bg}};
    bg-alt: {{surface}};
    fg:     {{fg}};
    fg-dim: {{overlay}};
    sel:    {{accent}};

    background-color: transparent;
    text-color:       @fg;
    border-color:     transparent;
    spacing:          0;
    padding:          0;
    margin:           0;
}

window {
    background-color: @bg;
    border:           2px;
    border-color:     {{surface2}};
    border-radius:    20px;
    width:            900px;
    height:           600px;
    location:         center;
    anchor:           center;
}

mainbox {
    background-color: transparent;
    children:         [inputbar, listview];
    padding:          24px;
    spacing:          20px;
}

inputbar {
    background-color: @bg-alt;
    border-radius:    10px;
    padding:          12px 16px;
    children:         [prompt, entry];
    spacing:          10px;
}

prompt {
    text-color: @sel;
}

entry {
    background-color:  transparent;
    text-color:        @fg;
    placeholder:       "Select wallpaper...";
    placeholder-color: @fg-dim;
    vertical-align:    0.5;
}

listview {
    background-color: transparent;
    columns:          4;
    lines:            3;
    spacing:          12px;
    scrollbar:        true;
    fixed-height:     false;
    layout:           vertical;
}

element {
    background-color: transparent;
    border-radius:    12px;
    padding:          10px;
    spacing:          8px;
    orientation:      vertical;
    cursor:           pointer;
}

element-icon {
    background-color: transparent;
    cursor:           inherit;
    size:             180px;
}

element-text {
    background-color: transparent;
    text-color:       @fg;
    horizontal-align: 0.5;
    vertical-align:   0.5;
    cursor:           inherit;
}

element.selected.normal {
    background-color: @bg-alt;
}

element.selected.normal element-icon {
    border:        2px;
    border-color:  @sel;
    border-radius: 8px;
}

element.selected.normal element-text {
    text-color: @sel;
    font:       "JetBrains Mono Bold 11";
}
