add_newline = false
command_timeout = 1000

format = """
$time$os$username$hostname$directory$git_branch$git_status$character
"""

# ---------------- TIME ----------------
[time]
disabled = false
time_format = "%H:%M"
style = "bg:{{accent}} fg:{{shadow}}"
format = "[](fg:{{accent}})[  $time ]($style)[](fg:{{accent}} bg:{{surface}})"

# ---------------- OS ----------------
[os]
disabled = false
style = "bg:{{surface}} fg:{{accent}}"
format = "[ $symbol ]($style)"

[os.symbols]
Arch = ""

# ---------------- USER ----------------
[username]
show_always = true
style_user = "bg:{{surface}} fg:{{fg}}"
format = "[ $user ]($style)"

# ---------------- HOST ----------------
[hostname]
ssh_only = false
style = "bg:{{surface}} fg:{{blue}}"
format = "[@$hostname ]($style)[](fg:{{surface}} bg:{{surface2}})"

# ---------------- DIRECTORY ----------------
[directory]
home_symbol = "~"
truncation_length = 3
truncation_symbol = "…/"
style = "bg:{{surface2}} fg:{{accent}}"
format = "[ $path ]($style)[](fg:{{surface2}})"

# ---------------- GIT ----------------
[git_branch]
symbol = ""
style = "bg:{{surface2}} fg:{{green}}"
format = "[ $symbol $branch ]($style)"

[git_status]
style = "bg:{{surface2}} fg:{{yellow}}"
format = "[ $all_status$ahead_behind ]($style)[](fg:{{surface2}} bg:{{bg}})"

# ---------------- PROMPT ----------------
[character]
success_symbol = "[ ❯](fg:{{accent}})"
error_symbol = "[ ❯](fg:{{red}})"

# ---------------- CLEAN ----------------
[package]
disabled = true
[cmd_duration]
disabled = true