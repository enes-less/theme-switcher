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
  margin: 2px 0; /* 8'den 2'ye düşürdük: Widget'lar arası boşluğu daraltır */
  background: transparent;
}

.widget-title,
.widget-dnd,
.widget-label {
  color: @cc_fg;
  background: transparent;
}

/* =========================
   BUTTON GRID
   ========================= */

.cc_controls > flowbox {
  background: transparent;
}

.cc_controls > flowbox > flowboxchild {
  background: transparent;
  border-radius: 20px;
}

.cc_controls > flowbox > flowboxchild > button {
  background: shade(@cc_bg, 1.10);
  color: @cc_fg;
  border-radius: 16px;
  padding: 10px;
  font-size: 17px;
  transition: 120ms;
  box-shadow: none;
}

.cc_controls > flowbox > flowboxchild > button.toggle:checked {
  background: @cc_accent;
  color: @cc_bg;
}

/* =========================
   SLIDERS
   ========================= */

.widget-volume,
.widget-backlight,
.cc_brightness {
  background: transparent;
}

.widget-volume scale trough,
.widget-backlight scale trough,
.cc_brightness scale trough {
  background: shade(@cc_bg, 0.85);
  border-radius: 999px;
  min-height: 10px;
}

.widget-volume scale highlight,
.widget-backlight scale highlight,
.cc_brightness scale highlight {
  background: @cc_accent;
  border-radius: 999px;
}

/* =========================
   NOTIFICATIONS
   ========================= */

.control-center .control-center-list,
.control-center .control-center-list scrolledwindow,
.control-center .control-center-list viewport,
.control-center .control-center-list box,
.control-center .control-center-list row {
  background: transparent;
  box-shadow: none;
  margin: 0;
  padding: 0;
}

/* notification card */
.control-center .control-center-list .notification {
  background: shade(@cc_bg, 1.08);
  border-radius: 14px;
  padding: 4px 10px; 
  margin: 2px 0;
  box-shadow: none;
}

.control-center .control-center-list .notification box,
.control-center .control-center-list .notification grid,
.control-center .control-center-list .notification row,
.control-center .control-center-list .notification .notification-content,
.control-center .control-center-list .notification .content,
.control-center .control-center-list .notification image {
  background: transparent;
  box-shadow: none;
}

.notification-row .notification-background .notification .notification-default-action {
  padding-top: 2px;
  padding-bottom: 2px;
}

.notification-row .notification-background .notification .notification-default-action .notification-content .text-box .summary {
  color: @cc_fg;
  font-weight: 700;
  background: transparent;
  padding-top: 4px; 
}

.notification-row .notification-background .notification .notification-default-action .notification-content .text-box .body {
  color: @cc_muted;
  background: transparent;
}

/* title */
.control-center .notif_title label {
  font-size: 21px;
  font-weight: 700;
  padding-bottom: 4px;
  border-bottom: 1px solid rgba(255,255,255,0.05);
  background: transparent;
}

/* =========================
   CLOSE BUTTON
   ========================= */

.notification-background .close-button,
.control-center .notification-group .close-button,
.notification-group .close-button {
  background-image: none;
  background-color: @cc_accent;
  color: @cc_bg;
  border-radius: 999px;
  box-shadow: none;
  transform: translate(6px, -2px);
}

.notification-background .close-button image,
.control-center .notification-group .close-button image,
.notification-group .close-button image {
  color: @cc_bg;
  background: transparent;
}

.notification-row .notification-background .notification .notification-default-action .notification-content .text-box .time {
  margin-top: 4px;
}