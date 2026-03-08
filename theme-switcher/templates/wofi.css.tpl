window {
  background: transparent;
  font-family: "{{font_family}}";
  font-size: 14px;
}

#outer-box {
  padding: 12px;
  border-radius: 14px;
  background: {{bg_rgba}};
}

#input {
  margin-bottom: 10px;
  padding: 10px 12px;
  border-radius: 10px;
  border: none;

  background: {{surface_rgba}};
  color: {{fg}};
}

#input {
    outline: none;
    box-shadow: none;
    border: 2px solid transparent;
}

#input:focus {
    outline: none;
    box-shadow: 0 0 0 2px {{accent_soft}};
    border: 2px solid {{accent}};
}

#entry {
  padding: 8px 10px;
  margin: 3px 0;
  border-radius: 10px;
}

#entry:hover {
  background: {{accent_soft}};
}

#entry:selected {
  background: {{accent}};
}

#entry:selected #text {
  color: {{bg}};
  font-weight: 600;
}

#text {
  margin-left: 8px;
  color: {{fg}};
}
