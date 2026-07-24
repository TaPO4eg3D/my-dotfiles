------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")

    hl.exec_cmd("exec setxkbmap -layout us,ru -option grp:alt_shift_toggle")

    hl.exec_cmd("fcitx5")

    hl.exec_cmd("brave", { workspace = "1_silent" })
    hl.exec_cmd("obsidian", { workspace = "special:magic_silent" })
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS,@im", "fcitx")

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        border_size = 2,
        col = {
            active_border = "rgba(ea9a97ee)",
            inactive_border = "rgba(6e6a86ee)"
        },
        layout = "dwindle"
    },
    misc = {
        vrr = 0,
        render_unfocused_fps = 30,
    },
    render = {
        direct_scanout = 1,
    },
    xwayland = {
        force_zero_scaling = true,
    }
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us,ru",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "grp:alt_shift_toggle,caps:escape",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill -x rofi; ~/.local/bin/launchrofi d"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot --freeze -m region --clipboard-only"))

-- Movement
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Resize windows
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))

-- Switch between workspaces
for i = 1, 10 do
    local key = i % 10

    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Window groups
hl.bind(mainMod .. " + S", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.group.lock())
hl.bind(mainMod .. " + I", hl.dsp.group.prev())
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ out_of_group = "l" }))
hl.bind(mainMod .. " + O", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ out_of_group = "r" }))

-- Special workspace
hl.bind(mainMod .. " + N", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Programming workspace is scrolling by default
-- hl.workspace_rule({
--     workspace = "2",
--     layout = "scrolling",
-- })

-- Zed always takes the full screen on the scrolling layout
hl.window_rule({
    name = "zed-full-scrolling",
    match = {
        class = "dev.zed.Zed",
    },

    scrolling_width = 1.0,
})

-- Ignore maximize requests from all apps
local supress_rule = hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})

hl.on("workspace.active", function(active)
    if active == "2" then
        supress_rule:set_enabled(false)
    else
        supress_rule:set_enabled(true)
    end
end)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "telegram-media-viewer-fix",
    match = {
        class = "org.telegram.desktop",
        initial_title = "Media viewer"
    },
    float = true,
    fullscreen = true
})

hl.window_rule({
  name = "factorio-render",
  match = {
    class = "factorio",
  },
  render_unfocused = true,
})
