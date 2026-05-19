-- Import modules
require("settings.autostart")
require("settings.looks")
require("settings.keybinds")
require("settings.permissions")
require("settings.misc")
require("settings.input")
require("settings.windowrules")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.25",
})    

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("HYPRCURSOR_THEME", "24")
hl.env("HYPRCURSOR_THEME", "24")
hl.env("QT_QPA_PLATFORMTHEME","qt6ct")
hl.env("QT_QPA_PLATFORM","wayland")
hl.env("XDG_CURRENT_DESKTOP","Hyprland")

package.path = os.getenv("HOME") .. "/.config/hypr/?.lua;" .. package.path

-- Global settings (monitors, general, decoration, animations, etc.)
hl.config({
    monitor = {
        { name = "", width = 1920, height = 1080, refresh = 144, position = "auto", scale = 1.25 }
    },    
    general = {
        gaps_in = 9,
        gaps_out = 18,
        border_size = 1,
        col = { active_border = "rgba(56b6c2aa)", inactive_border = "rgba(595959aa)" },
        layout = "dwindle"
    },    
    -- ... (all your other settings from the previous config)
})    
