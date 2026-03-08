* {
  font-family: {{font_family}}, sans-serif;
  font-size: 17px;
  box-shadow: none;
}

window {
  background: {{bg_rgba}};
}

button {
  background-color: {{surface_rgba}};
  color: {{fg}};
  border-radius: 16px;

  border: 2px solid {{overlay}};

  margin: 8px;
  padding: 12px 16px;

  background-repeat: no-repeat;
  background-position: center 38%;
  background-size: 26%;
}

button:hover {
  border: 2px solid {{accent}};
  background-color: {{surface2}};
}

#lock {
  background-image: url("{{icon_dir}}/lock.svg");
}

#logout {
  background-image: url("{{icon_dir}}/logout.svg");
}

#suspend {
  background-image: url("{{icon_dir}}/suspend.svg");
}

#hibernate {
  background-image: url("{{icon_dir}}/hibernate.svg");
}

#reboot {
  background-image: url("{{icon_dir}}/reboot.svg");
}

#shutdown {
  background-image: url("{{icon_dir}}/shutdown.svg");
}

label {
  margin-top: 4px;
  color: {{fg}};
}