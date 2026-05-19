-----------------------
----- PERMISSIONS -----
-----------------------

-- Visit https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/ fot more
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")