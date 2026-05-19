-------------------
---- AUTOSTART ----
-------------------
-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function () 
  hl.exec_cmd("waybar & awww-daemon & swaync")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal -r & /usr/lib/polkit-kde-authentication-agent-1")
  hl.exec_cmd("wl-paste --type text --watch cliphist store & wl-paste --type image --watch cliphist store")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("nm-applet")
end)