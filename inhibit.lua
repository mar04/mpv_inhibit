local msg = require("mp.msg")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib

local bus = Gio.bus_get_sync(Gio.BusType.SESSION)
local inhibit_cookie = nil


local function inhibit()
    if inhibit_cookie then
        return
    end

    local reason = "Playback"
    local res, err = bus:call_sync(
        "org.freedesktop.ScreenSaver",
        "/org/freedesktop/ScreenSaver",
        "org.freedesktop.ScreenSaver",
        "Inhibit",
        GLib.Variant("(ss)", { "mpv", reason }),
        GLib.VariantType.new("(u)"),
        Gio.DBusCallFlags.NONE,
        -1,
        nil
    )

    if res then
        inhibit_cookie = res.value[1]
        msg.debug("Screensaver inhibited:", reason, "(Cookie:", inhibit_cookie, ")")
    else
        msg.warn("Failed to inhibit screensaver:", err)
    end
end

local function uninhibit()
    if not inhibit_cookie then
        return
    end

    bus:call_sync(
        "org.freedesktop.ScreenSaver",
        "/org/freedesktop/ScreenSaver",
        "org.freedesktop.ScreenSaver",
        "UnInhibit",
        GLib.Variant("(u)", { inhibit_cookie }),
        nil,
        Gio.DBusCallFlags.NONE,
        -1,
        nil
    )

    msg.debug("Screensaver uninhibited (Cookie:", inhibit_cookie, ")")
    inhibit_cookie = nil
end

local function on_pause_change(_, paused)
    if paused then
        uninhibit()
    else
        inhibit()
    end
end

mp.observe_property("pause", "bool", on_pause_change)
