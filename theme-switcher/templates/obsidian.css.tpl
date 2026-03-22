.theme-dark,
.theme-light {
  /* ---------- Core backgrounds ---------- */
  --background-primary: {{bg}};
  --background-primary-alt: {{bg}};
  --background-secondary: {{surface}};
  --background-secondary-alt: {{surface2}};

  /* Sidebars / workspace / tabs */
  --sidebar-background: {{surface}};
  --sidebar-background-alt: {{surface2}};
  --tab-container-background: {{surface}};
  --titlebar-background: {{surface}};
  --titlebar-background-focused: {{surface}};

  /* ---------- Text ---------- */
  --text-normal: {{fg}};
  --text-muted: {{fg_dim}};
  --text-faint: {{overlay}};
  --text-accent: {{accent}};
  --text-accent-hover: {{accent_alt}};

  /* Headings */
  --h1-color: {{accent}};
  --h2-color: {{blue}};
  --h3-color: {{lavender}};
  --h4-color: {{teal}};
  --h5-color: {{yellow}};
  --h6-color: {{pink}};

  /* ---------- Interactive ---------- */
  --interactive-normal: {{surface2}};
  --interactive-hover: {{bg_alt}};
  --interactive-accent: {{accent}};
  --interactive-accent-hover: {{accent_alt}};

  /* ---------- Borders / modifiers ---------- */
  --background-modifier-border-hover: {{accent}};
  --background-modifier-border: color-mix(in srgb, {{surface2}} 65%, {{bg}} 35%);
  --background-modifier-border-focus: {{accent}};
  --background-modifier-hover: {{bg_alt}};
  --background-modifier-active-hover: {{surface2}};
  --background-modifier-success: {{green}};
  --background-modifier-success-rgb: {{green_rgb}};
  --background-modifier-error: {{red}};
  --background-modifier-error-rgb: {{red_rgb}};
  --background-modifier-error-hover: {{red}};
  --background-modifier-message: {{blue}};

  /* ---------- Selection / cursor / highlights ---------- */
  --text-selection: {{accent_soft}};
  --caret-color: {{accent}};
  --highlight-mix-blend-mode: normal;
  --text-highlight-bg: {{accent_soft}};

  /* ---------- Code ---------- */
  --code-background: {{surface}};
  --code-normal: {{fg}};
  --code-comment: {{fg_dim}};
  --code-function: {{blue}};
  --code-important: {{red}};
  --code-keyword: {{pink}};
  --code-operator: {{accent}};
  --code-property: {{teal}};
  --code-punctuation: {{fg_dim}};
  --code-string: {{green}};
  --code-tag: {{yellow}};
  --code-value: {{lavender}};

  /* ---------- Inline stuff ---------- */
  --bold-color: {{fg}};
  --italic-color: {{fg}};
  --link-color: {{accent}};
  --link-color-hover: {{accent_alt}};
  --link-external-color: {{blue}};
  --link-unresolved-color: {{yellow}};

  /* ---------- Quotes / callouts ---------- */
  --blockquote-color: {{fg_dim}};
  --blockquote-border-color: {{accent}};
  --hr-color: {{overlay}};

  /* ---------- Tags ---------- */
  --tag-color: {{accent}};
  --tag-background: {{accent_soft}};
  --tag-border-color: {{accent}};

  /* ---------- Inputs / buttons / menus ---------- */
  --input-shadow: none;
  --input-hover-border-color: {{accent}};
  --input-focus-border-color: {{accent}};
  --input-border-color: {{overlay}};
  --prompt-border-color: {{overlay}};
  --modal-border-color: {{overlay}};
  --modal-background: {{surface}};
  --dropdown-background: {{surface}};
  --dropdown-border-color: {{overlay}};
  --menu-background: {{surface}};
  --menu-border-color: {{overlay}};
  --menu-separator-color: {{overlay}};
  --scrollbar-bg: transparent;
  --scrollbar-thumb-bg: {{surface2}};
  --scrollbar-active-thumb-bg: {{accent}};

  /* ---------- Checkboxes ---------- */
  --checkbox-color: {{accent}};
  --checkbox-color-hover: {{accent_alt}};
  --checkbox-border-color: {{overlay}};
  --checklist-done-color: {{fg_dim}};

  /* ---------- Graph view / misc ---------- */
  --graph-text: {{fg}};
  --graph-line: {{overlay}};
  --graph-node: {{accent}};
  --graph-node-focused: {{yellow}};
  --graph-node-tag: {{teal}};
  --graph-node-attachment: {{blue}};

  /* ---------- Radii ---------- */
  --radius-s: 6px;
  --radius-m: 10px;
  --radius-l: 14px;

  /* ---------- Fonts ---------- */
  --font-interface-theme: "{{font_family}}";
  --font-text-theme: "{{font_family}}";
  --font-monospace-theme: "{{font_family}}";
}

/* Workspace polish */
.workspace,
.workspace-split,
.workspace-leaf,
.workspace-tab-container,
.workspace-tabs,
.mod-root .workspace-tab-header-container {
  background-color: var(--background-primary);
}

.workspace-tab-header,
.workspace-tab-header.is-active,
.nav-files-container,
.nav-folder-children,
.workspace-leaf-content,
.view-content,
.markdown-source-view,
.markdown-preview-view {
  color: var(--text-normal);
}

/* Ribbon + sidebars */
.workspace-ribbon,
.side-dock-ribbon,
.mod-left-split,
.mod-right-split {
  background: var(--sidebar-background);
  border-color: var(--background-modifier-border);
}

/* Files / navigation */
.nav-file-title,
.nav-folder-title,
.tree-item-self,
.workspace-tab-header-inner-title {
  color: var(--text-normal);
}

.nav-file-title:hover,
.nav-folder-title:hover,
.tree-item-self:hover {
  background: var(--background-modifier-hover);
}

.nav-file-title.is-active,
.nav-folder-title.is-being-dragged-over,
.workspace-tab-header.is-active {
  background: var(--interactive-normal);
  color: var(--text-accent);
}

/* Editor / preview */
.markdown-source-view,
.markdown-preview-view {
  background: var(--background-primary);
  color: var(--text-normal);
}

/* Headings */
.markdown-rendered h1,
.cm-header-1 { color: var(--h1-color); }

.markdown-rendered h2,
.cm-header-2 { color: var(--h2-color); }

.markdown-rendered h3,
.cm-header-3 { color: var(--h3-color); }

.markdown-rendered h4,
.cm-header-4 { color: var(--h4-color); }

.markdown-rendered h5,
.cm-header-5 { color: var(--h5-color); }

.markdown-rendered h6,
.cm-header-6 { color: var(--h6-color); }

/* Links */
a,
.cm-link,
.external-link {
  color: var(--link-color);
}

/* Inline code / code blocks */
.cm-inline-code,
.markdown-rendered code {
  background: var(--code-background);
  color: var(--code-normal);
  border-radius: 6px;
}

.HyperMD-codeblock,
.markdown-rendered pre {
  background: var(--code-background);
  border: 1px solid var(--background-modifier-border);
  border-radius: 10px;
}

/* Quotes */
.markdown-rendered blockquote {
  color: var(--blockquote-color);
  border-left: 3px solid var(--blockquote-border-color);
  background: color-mix(in srgb, {{surface}} 88%, transparent);
}

/* Tables */
.markdown-rendered table {
  border-color: var(--background-modifier-border);
}

.markdown-rendered th,
.markdown-rendered td {
  border-color: var(--background-modifier-border);
}

/* Buttons */
button,
.clickable-icon,
.mod-cta {
  color: var(--text-normal);
}

button.mod-cta,
.setting-item-control button.mod-cta {
  background: var(--interactive-accent);
  color: {{bg}};
}

button:hover,
.clickable-icon:hover {
  background: var(--background-modifier-hover);
}

/* Inputs */
input,
textarea,
select,
.search-input,
.prompt-input {
  background: var(--background-secondary);
  color: var(--text-normal);
  border: 1px solid var(--input-border-color);
}

input:focus,
textarea:focus,
select:focus,
.search-input:focus,
.prompt-input:focus {
  border-color: var(--input-focus-border-color);
  box-shadow: none;
}

/* Checkbox */
input[type="checkbox"] {
  accent-color: var(--checkbox-color);
}

/* Status bar */
.status-bar {
  background: var(--background-secondary);
  color: var(--text-muted);
  border-top: 1px solid var(--background-modifier-border);
}

/* Callouts */
.callout {
  --callout-border-opacity: 0.35;
  --callout-title-color: var(--text-normal);
  background: color-mix(in srgb, {{surface}} 92%, transparent);
  border: 1px solid var(--background-modifier-border);
}

/* Search matches */
.search-result-file-matched-text,
.cm-searchResult {
  background: var(--text-highlight-bg);
  color: var(--text-normal);
}

/* Canvas */
.canvas-node-container,
.canvas-control-item,
.menu,
.modal,
.suggestion-container {
  background: var(--background-secondary);
  color: var(--text-normal);
  border-color: var(--background-modifier-border);
}

/* Feel free to remove after here. These three rules remove the window controls. */
.is-hidden-frameless:not(.is-fullscreen) .workspace-tabs.mod-top-right-space .workspace-tab-header-container {
  padding-right: 0 !important;
}

/* Kill the reserved slot on the right */
.is-hidden-frameless:not(.is-fullscreen):not(.mod-macos) .workspace-tabs.mod-top-right-space .workspace-tab-header-container::after {
  content: none !important;
  width: 0 !important;
  min-width: 0 !important;
  max-width: 0 !important;
  display: none !important;
}

/* Hide actual window controls */
.titlebar-button-container,
.window-controls,
.mod-linux .titlebar-button-container,
.mod-linux .window-controls {
  display: none !important;
}