-- luacheck: globals awesome client root screen mouse button drawin drawable tag key

-- Libraries {{{
-- timing, monitor this within Xephyr
os.execute("echo start: ; date +%s.%N")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local ruled = require("ruled")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menu_utils = require("menubar.utils")
require("awful.autofocus")
-- local modules
beautiful.init(require("theme"))
local mywidgets = require("widgets")
local config = require("config")
os.execute("echo loaded libraries: ; date +%s.%N")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Default modkey
local modkey = config.modkey or "Mod4"

local hotkeys_popup = require("awful.hotkeys_popup.widget").new { width = 1350, height = 650 }
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.append_default_layouts {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        if wallpaper:find("^#") then
            gears.wallpaper.set(wallpaper)
        else
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
end)

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    -- use font glyph for tag names or icons for, well, icons
    for index = 1, 9 do
        awful.tag.add(beautiful.tag_icons[index][1], {
            screen = s,
            index = index,
            gap_single_client = index ~= 2,
            selected = index == 1,
            icon = beautiful.tag_icons[index][2],
            layout = awful.layout.layouts[1],
        })
    end

    local function test_templ()
        return config.use_image_icon and
        {
            {
                id     = 'icon_role',
                widget = wibox.widget.imagebox,
            },
            margins = beautiful.bar_size * 0.3,
            widget = wibox.container.margin,
        } or {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox,
            },
            forced_width = beautiful.bar_size,
            forced_height = beautiful.bar_size,
            widget = wibox.container.margin
        }
    end

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        layout = wibox.layout.fixed.vertical,
        filter = awful.widget.taglist.filter.all,
        buttons = gears.table.join(
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                             if client.focus then client.focus:move_to_tag(t) end
                         end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                             if client.focus then client.focus:toggle_tag(t) end
                         end)
        ),
        widget_template = { -- TODO: use icon_button
            { -- this provides 'icon_role' and 'text_role'
                test_templ(),
                widget = mywidgets.clickable,
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = gears.table.join(
            awful.button({ }, 1, function (c)
                if c == client.focus then
                    c.minimized = true
                else
                    -- Without this, the following :isvisible() makes no sense
                    c.minimized = false
                    if not c:isvisible() and c.first_tag then
                        c.first_tag:view_only()
                    end
                    -- This will also un-minimize the client, if needed
                    client.focus = c
                    c:raise()
                end
            end),
            awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
            awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
        ),
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        left = beautiful.tasklist_icon_vmargin,
                        right = beautiful.tasklist_icon_vmargin,
                        top = beautiful.tasklist_icon_margin,
                        bottom = beautiful.tasklist_icon_margin,
                        widget  = wibox.container.margin
                    },
                    {
                        {
                            id = 'close_role',
                            mywidgets.icon_button(beautiful.closebutton),
                            shape = gears.shape.circle,
                            widget = mywidgets.clickable,
                        },
                        left = beautiful.tasklist_icon_vmargin,
                        right = beautiful.tasklist_icon_vmargin,
                        widget = wibox.container.margin,
                    },
                    forced_height = beautiful.bar_size - 2,
                    layout = wibox.layout.align.horizontal,
                },
                {
                    wibox.widget.base.make_widget(),
                    -- forced_height = 4,
                    id            = 'background_role',
                    widget        = wibox.container.background,
                },
                layout = wibox.layout.align.vertical,
            },
            widget = mywidgets.clickable,
            create_callback = function(self, c, _, _)
                -- self.tooltip = awful.tooltip({
                --   objects = { self },
                --   delay_show = 0.4,
                --   margin_leftright = beautiful.tooltip_marginv,
                --   margin_topbottom = beautiful.tooltip_marginh,
                --   timer_function = function() return c.name end,
                -- })
                -- self.tooltip.mode = "outside"
                -- self.tooltip.preferred_alignments = {"middle", "front", "back"}

                local closebutton = self:get_children_by_id("close_role")[1]
                closebutton:buttons(awful.util.table.join(
                    awful.button({}, 1, function()
                        c:kill()
                    end)
                ))
            end,
        },
    }

    -- Create the bars and panels
    s.topbar = mywidgets.topbar(s)
    s.leftpanel = mywidgets.leftpanel(s)
    s.leftbar = mywidgets.leftbar(s)
end)
os.execute("echo loaded panels: ; date +%s.%N")
-- }}}

-- {{{ Key bindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey            }, "b", function () mouse.screen.topbar.visible = not mouse.screen.topbar.visible end,
              {description = "toggle topbar", group="awesome"}),
    awful.key({ modkey,           }, "a", function() mouse.screen.leftpanel:toggle() end,
              {description = "toggle side panel", group="awesome"}),
    awful.key({ modkey,           }, "s", function() hotkeys_popup:show_help() end,
              {description = "show short cut keys", group="awesome"}),
    awful.key({ modkey,           }, "Up",   awful.tag.viewprev,
              {description = "goto previous tag", group = "tag"}),
    awful.key({ modkey,           }, "Down",  awful.tag.viewnext,
              {description = "goto next tag", group = "tag"}),
    awful.key({ modkey,           }, ",",      awful.tag.viewprev,
              {description = "goto previous tag", group = "tag"}),
    awful.key({ modkey,           }, ".",      awful.tag.viewnext,
              {description = "goto next tag", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "goto last tag", group = "tag"}),

    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx( 1) end,
              {description = "focus next client", group = "client"}),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
              {description = "focus previous client", group = "client"}),
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "Tab", function ()
                  awful.client.focus.history.previous()
                  if client.focus then client.focus:raise() end
              end,
              {description = "focus last client", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return",  function () awful.spawn(config.terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "Return",  function ()
                    if config.terminal == "st" then
                        awful.spawn("st -c St-float")
                    else
                        awful.spawn(config.terminal, { properties = { floating = true } })
                    end
                end,
              {description = "open a floating terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "l",  function () awful.spawn("dm-tool switch-to-greeter") end,
              {description = "lock screen", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next layout", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous layout", group = "layout"}),

    awful.key({ modkey, "Control" }, "n", function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then client.focus = c c:raise() end
              end,
              {description = "restore minimized", group = "client"}),

    -- screen shot
    awful.key({                    }, "Print",
              function () awful.spawn.with_shell(config.scrot_full .. config.scrot_save) end,
              {description = "save to file",                group = "screenshot"}),
    awful.key({            "Shift" }, "Print",
              function () awful.spawn.with_shell(config.scrot_rect .. config.scrot_save) end,
              {description = "save selection to file",      group = "screenshot"}),
    awful.key({ "Control"          }, "Print",
              function () awful.spawn.with_shell(config.scrot_full .. config.scrot_clip) end,
              {description = "save to clipboard",           group = "screenshot"}),
    awful.key({ "Control", "Shift" }, "Print",
              function () awful.spawn.with_shell(config.scrot_rect .. config.scrot_clip) end,
              {description = "save selection to clipboard", group = "screenshot"}),

    -- Prompt
    awful.key({ modkey,           }, "d", function () awful.spawn(config.launcher_rofi_cmd(mouse.screen)) end,
              {description = "application launcher", group = "launcher"}),
    awful.key({ modkey,           }, "x", function () awful.spawn("rofi -show run") end,
              {description = "run command", group = "launcher"}),
    awful.key({ modkey }, "p", function() awful.spawn("setmonitor") end,
              {description = "set display", group = "screen"}),
    awful.key({ }, "XF86Display", function() awful.spawn("setmonitor") end,
              {description = "set display", group = "screen"}),

    -- Application launching
    awful.key({ modkey }, "r", function () awful.spawn(config.terminal_run("ranger")) end,
              {description = "launch file manager", group = "launcher"}),
    awful.key({ modkey }, "e", function () awful.spawn(config.terminal_run("neomutt")) end,
              {description = "launch email client", group = "launcher"})
})

local clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
              function (c) c.fullscreen = not c.fullscreen c:raise() end,
              {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",
              function (c) c:kill() end,
              {description = "close client", group = "client"}),
    awful.key({ modkey, "Control" }, "space",
              awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return",
              function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",
              function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",
              function (c) c.ontop = not c.ontop end,
              {description = "toggle ontop", group = "client"}),
    awful.key({ modkey,           }, "n",
              -- The client currently has the input focus, so it cannot be
              -- minimized, since minimized clients can't have the focus.
              function (c) c.minimized = true end ,
              {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
              function (c) c.maximized = not c.maximized c:raise() end ,
              {description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    }
})

local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
ruled.client.append_rules {
    { -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            size_hints_honor = true,
            shape = config.client_shape,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    { -- Add titlebars to normal clients and dialogs
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = {
            titlebars_enabled = true
        }
    },

    { -- Floating clients
        rule_any = {
            instance = {
              "DTA",                  -- Firefox addon DownThemAll.
              "copyq",                -- Includes session name in class.
              "Popup",
              "file_progress",        -- Nemo file operation
            },

            name = {
              "Event Tester",           -- xev.
              "Select a Template",      -- LibreOffice
              "Screen Layout Editor",   -- arandr
              "File Operation Progress" -- thunar file operation
            },
            role = {
              "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
              "page-info",    -- Firefox's image info
              "About",        -- Firefox's about page
              "GtkFileChooserDialog"
            },
            class = {
                "Galculator",
                "xpad",
                "Screenkey",
            }
        },
        properties = {
            floating = true,
            ontop = true,
            placement = awful.placement.centered
        },
    },

    { -- Fullscreen and screen management for pdfpc
        rule = { class = "Pdfpc" },
        -- properties = { fullscreen = true },
        -- This callback will *magically* put presentation to the secondary
        -- screen and leave the presenter console on the current screen.
        callback = function(c) c:move_to_screen() end
    },

    { -- Set Firefox (browser) to always map on the tag 2.
        rule = {
            class = "firefox",
            role = "browser",
            instance = "Navigator"
        },
        properties = {
            tag = beautiful.tag_icons[2][1],
            shape = gears.shape.rectangle,
            titlebars_enabled = false,
        }
    },

    { -- firefox picture-in-picture window
        rule = {
            class = "firefox",
            instance = "Toolkit",
            role = "PictureInPicture",
        },
        properties = {
            ontop = true,
            sticky = true,
            floating = true,
            shape = gears.shape.rectangle,
            placement = awful.placement.bottom_right
        },
    },

    { -- floating hack for st
      -- TODO: not perfect. E.g. change from floating to tiling, then restart awesome, it will be floating again
      -- https://github.com/awesomeWM/awesome/issues/2517#issuecomment-578724877
        rule = {
            class = "St-float"
        },
        properties = {
            floating = true,
            ontop = true,
            placement = awful.placement.centered
        },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- set fallback icon
    -- TODO: lookup_icon only looks in apps and one or two more folders, not legacy, actions, mimetypes or others
    --       so maybe extend my find_symbolic_icon to find any icon as well?
    local t = {}
    local default_icon = menu_utils.lookup_icon("application-default-icon")  -- application-x-executable
    local terminal_icon = menu_utils.lookup_icon("utilities-terminal")
    t["URxvt"] = terminal_icon
    t["St"] = terminal_icon
    t["St-float"] = terminal_icon

    -- https://www.reddit.com/r/awesomewm/comments/b5rmeo/how_to_add_fallback_icon_to_the_tasklist/
    c.icon = c.icon or gears.surface(t[c.class] or default_icon)._native
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"   }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize" }
        end),
    }

    awful.titlebar(c, { size = beautiful.titlebar_height, }):setup {
        nil,
        { -- Middle
            { -- Title
                align  = "center",
                font = beautiful.titlebar_font,
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.minimizebutton (c),
                awful.titlebar.widget.closebutton    (c),
                spacing = beautiful.titlebar_height / 2,
                layout = wibox.layout.fixed.horizontal
            },
            margins = beautiful.titlebar_height / 4,
            layout = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- hide bars for fullscreen windows
local function fullscreen_toggle(c)
    for _, panel in ipairs({c.screen.topbar, c.screen.leftbar}) do
        if (c.active and c.fullscreen == panel.visible)  -- has focus
        or (not c.active and c.fullscreen and not panel.visible) then -- losing focus
            panel.visible = not panel.visible
        end
    end
end
-- when change either focus or fullscreen state (I guess that covers all, but might be resource consuming?)
client.connect_signal("focus", fullscreen_toggle)
client.connect_signal("unfocus", fullscreen_toggle)
client.connect_signal("property::fullscreen", fullscreen_toggle)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        c.shape = gears.shape.rectangle
    else
        c.shape = config.client_shape
    end
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)
-- }}}

-- Log {{{
collectgarbage('setpause', 100)
local t = gears.timer({
    timeout = 5,
    autostart = true,
    callback = function()
        collectgarbage()
        collectgarbage()
        -- print(os.date(), "\nLua memory usage:", collectgarbage("count"))
        -- print("Objects alive:")
        -- for name, obj in pairs{ button = button,
        --                         client = client,
        --                         drawable = drawable,
        --                         drawin = drawin,
        --                         key = key,
        --                         screen = screen,
        --                         tag = tag } do
        --     print(name, ": ", obj.instances())
        -- end
    end
})
t:emit_signal("timeout")
os.execute("echo end: ; date +%s.%N")
-- }}}

-- vim:foldmethod=marker:foldlevel=0
