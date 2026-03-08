/* =========================
   THEME COLORS
   ========================= */

@define-color cc_bg {{bg}};
@define-color cc_fg {{fg}};
@define-color cc_accent {{accent}};
@define-color cc_muted {{accent_alt}};

/* =========================
   CONTROL CENTER PANEL
   ========================= */

.control-center {
  background: @cc_bg;
  color: @cc_fg;
  border-radius: 16px;
  padding: 12px;
}

/* =========================
   WIDGET BLOCKS
   ========================= */

.widget {
  margin: 8px 0;
}

.widget-title,
.widget-dnd,
.widget-label {
  color: @cc_fg;
}

/* =========================
   BUTTON GRID
   ========================= */

.cc_controls > flowbox > flowboxchild > button {
  background: shade(@cc_bg, 1.10);
  color: @cc_fg;
  border-radius: 16px;
  padding: 10px;
  transition: 120ms;
  font-size: 17px;
}

.cc_controls > flowbox > flowboxchild {
  border-radius: 20px;
}

.cc_controls > flowbox > flowboxchild > button:hover {
  background: shade(@cc_bg, 1.18);
}

.cc_controls > flowbox > flowboxchild > button.toggle:checked {
  background: @cc_accent;
  color: @cc_bg;
}

/* =========================
   SLIDERS
   ========================= */

.widget-volume scale trough,
.widget-backlight scale trough {
  background: shade(@cc_bg, 0.85);
  border-radius: 999px;
  min-height: 10px;
}

.widget-volume scale highlight,
.widget-backlight scale highlight {
  background: @cc_accent;
  border-radius: 999px;
}

/* =========================
   NOTIFICATIONS
   ========================= */

.control-center .control-center-list {
  background: transparent;
}

.control-center .control-center-list .notification {
  background: shade(@cc_bg, 1.08);
  border-radius: 14px;
  padding: 10px;
  margin: 6px 0;
}

.control-center .control-center-list .notification .summary {
  color: @cc_fg;
  font-weight: 700;
}

.control-center .control-center-list .notification .body {
  color: @cc_muted;
}

.control-center .notif_title label {
    font-size: 21px;
    font-weight: 700;
    padding-bottom: 10px;
    border-bottom: 1px solid rgba(255,255,255,0.05);
}

/* Brightness custom slider */

.cc_brightness scale trough {
  background: shade(@cc_bg, 0.85);
  border-radius: 999px;
  min-height: 10px;
}

.cc_brightness scale highlight {
  background: @cc_accent;
  border-radius: 999px;
}