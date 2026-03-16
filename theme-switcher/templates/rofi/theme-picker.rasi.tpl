configuration {
    modi:         "dmenu";
    show-icons:   true;
    hover-select: true;
    me-select-entry: "";
    me-accept-entry: "MousePrimary";
}

* {
    accent: {{accent}};

    background-color: transparent;
    text-color:       {{fg}};
    border-color:     transparent;
    spacing:          0;
    padding:          0;
    margin:           0;
}

window {
    background-color: {{bg}}f2;
    border:           0;
    border-radius:    20px;
    width:            60%;
    location:         center;
    anchor:           center;
}

mainbox {
    background-color: transparent;
    children:         [listview];
    padding:          20px;
    spacing:          15px;
}

listview {
    background-color: transparent;
    columns:          4;
    lines:            2;
    spacing:          15px;
    padding:          10px;
    fixed-height:     false;
    fixed-columns:    true;
    border:           0;
}

element {
    background-color: transparent;
    border-radius:    15px;
    padding:          15px;
    spacing:          10px;
    orientation:      vertical;
    cursor:           pointer;
}

element selected.normal {
    background-color: {{accent}}33;
    border:           2px;
    border-color:     @accent;
}

element-icon {
    background-color: transparent;
    border-radius:    10px;
    horizontal-align: 0.5;
    size:             200px;
}

element-text {
    background-color: transparent;
    text-color:       {{fg}};
    font:             "{{font_family}} 12";
    horizontal-align: 0.5;
    vertical-align:   0.5;
}

element selected.normal element-text {
    text-color: @accent;
}
