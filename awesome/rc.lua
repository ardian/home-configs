-- REQUIRE
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
--require("wibox")
require("obvious.basic_mpd")
require("obvious.lib.mpd")
require("vicious")
require("eminent")
--TABLES
local mywiboxb = { }
local exec   = awful.util.spawn
--THEME
beautiful.init("/home/wut/.config/awesome/themes/default/theme.lua")
--DEFAULT MODKEY
modkey = "Mod4"

-- {{{ TABLE LAYOUT
--for awful.layout
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}
-- {{{ TAGS
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}, s,
      { layouts[1], layouts[9], layouts[1], -- Tags: 1, 2, 3
        layouts[1], layouts[12], layouts[2], --       4, 5 ,6
        layouts[2], layouts[1], layouts[3], layouts[1]  --       7, 8, 9, 10
      })
end
-- }}}
-- {{{ WIDGETS

obvious.basic_mpd.set_format("MPD: $title")

ciwidget     = widget({ type = 'imagebox' })
ciwidget.image = image(beautiful.cpu_icon)
cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, "$2% $3% ")

niwidget     = widget({ type = 'imagebox' })
niwidget.image = image(beautiful.nvidia_icon)

biwidget     = widget({ type = 'imagebox' })
biwidget.image = image(beautiful.bat_icon)
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$1$2% ", 5, "BAT1")

miwidget     = widget({ type = 'imagebox' })
miwidget.image = image(beautiful.mem_icon)
memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, "$2M ")

netup     = widget({ type = 'imagebox' })
netup.image = image(beautiful.up_icon)
netdn     = widget({ type = 'imagebox' })
netdn.image = image(beautiful.down_icon)
netwidget = widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net, '${wlan0 down_kb}/${wlan0 up_kb}', 3)
wifiwidget = widget({ type = "textbox" })
vicious.register(wifiwidget, vicious.widgets.wifi, 'R:${rate} L:${link}/70', 1, "wlan0")

viwidget     = widget({ type = 'imagebox' })
viwidget.image = image(beautiful.vol_icon)
volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume, "$1%$2", 2, "Master")
volwidget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () exec("amixer -q -c 0 sset Master toggle") end),
   awful.button({ }, 4, function () exec("amixer -q -c 0 sset Master 2%+", false) end),
   awful.button({ }, 5, function () exec("amixer -q -c 0 sset Master 2%-", false) end)
))

--space
spacewidget = widget({ type = 'textbox' })
spacewidget.text = " "

--right and left brackets
rbwidget = widget({ type = 'textbox' })
rbwidget.text = "}"
lbwidget = widget({ type = 'textbox' })
lbwidget.text = "{"

--btpd
function btpdnotify()
                local f = io.popen("btcli stat -n")
                local fr = ""
                for line in f:lines() do
                fr = fr .. line .. '\n'
                end
                f:close()
                naughty.notify({ text = fr, timeout = 0 })
end


--temp
function thermalcpu()
    cpufile = io.open("/sys/devices/platform/compal-laptop/temp1_input","r")
    cputemp = cpufile:read("*all")
    cputemp = string.match(cputemp, "(%d+)%d%d%d")
    return cputemp..'°C '..govern1..' '
end

function governor()
local f=io.popen("cpufreq-info")
local line=f:read()
while line do
  local govern = string.match(line, '.+%"(%l+)%".+')
   if govern then
    govern1 = govern
   end
  line=f:read()
end
end
governor()

function nvidia()
local f=io.popen("nvidia-smi -q 2>&1", "r")
local line=f:read()
while line do
 -- local gpu, load = string.match(line, "(Gpu).+: (%d+%%)")
  local gpu, temp = string.match(line, "(Gpu).+: (%d+) C$")
 -- local memory, used = string.match(line, "(Memory).+: (%d+%%)")
 --  if load then
 --   gpuload = load
 --  end
   if temp then
    gputemp = temp
   end
 --  if used then
 --   gpumem = used
 --  end
  line=f:read()
end
--return 'GPU:{'..gpuload..'/'..gputemp..'°C/'..gpumem..'M} '
return ' '..gputemp..'°C '
end

thermalcpuwidget = widget({ type = 'textbox', name = 'thermalcpuwidget' })
thermalcpuwidget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () exec("cpufreq-info") end),
   awful.button({ }, 4, function () exec("amixer -q -c 0 sset Master 2%+", false) end),
   awful.button({ }, 5, function () exec("amixer -q -c 0 sset Master 2%-", false) end)
))

nvidiawidget = widget({ type = 'textbox', name = 'nvidiawidget' })
tiwidget     = widget({ type = 'imagebox' })
tiwidget.image = image(beautiful.tmp_icon)

--mpd
mpdiwidget     = widget({ type = 'imagebox' })
mpdiwidget.image = image(beautiful.mpd_icon)

--currentclient/rtorrent memory usage
clmlwidget = widget({ type = 'textbox', name = 'clmlwidget' })
clslwidget = widget({ type = 'textbox', name = 'clslwidget' })
cldliwidget = widget({ type = 'imagebox' })
clmliwidget = widget({ type = 'imagebox' })
rtwidget = widget({ type = 'textbox', name = 'rtwidget' })

function clientmem (mode)
 if mode then
 local f = io.open('/proc/' ..mode.. '/status', "r")
 local line = f:read()
  while line do
   local memory, used = string.match(line, "(VmRSS):%s+(%d+).+")
    if used then
    for x in string.gmatch(used/1024, "(%d+).+") do return x .."M"
    end
   end
  line=f:read()
  end
 end
end

stationmenu = {}

function station_menu()
   local cmd = "cat /home/wut/.config/pianobar/stations"
   local f = io.popen(cmd)

   for l in f:lines() do
          local sn = string.match(l, "(%d+).+")
	  local item = { l, function () io.popen('echo s'.. sn ..' > /home/wut/.config/pianobar/ctl') end }
	  table.insert(stationmenu, item)
   end

   f:close()
end
station_menu()

--pandoramenu = awful.menu({ items = { { "Stations", stationmenu },
--                                    { "open terminal", terminal }
--                                  }
--                        })
pandoramenu = awful.menu({ items = stationmenu })

function pandora (mode)
 if mode == "pause" then
  io.popen("echo p > /home/wut/.config/pianobar/ctl")
 elseif mode == "love" then
  io.popen("echo + > /home/wut/.config/pianobar/ctl")
 elseif mode == "ban" then
  io.popen("echo - > /home/wut/.config/pianobar/ctl")
 elseif mode == "skip" then
  io.popen("echo n > /home/wut/.config/pianobar/ctl")
 else
  io.popen("echo p > /home/wut/.config/pianobar/ctl")
 end
end

pandoralove = widget({ type = 'textbox', name = 'pandoralove' })
pandoralove.text = "[+]"
pandoralove:buttons(awful.util.table.join(
   awful.button({ }, 1, function () pandora("love") end)
))
pandoraban = widget({ type = 'textbox', name = 'pandoraban' })
pandoraban.text = "[-]"
pandoraban:buttons(awful.util.table.join(
   awful.button({ }, 1, function () pandora("ban") end)
))


pandorawidget = widget({ type = 'textbox', name = 'pandorawidget' })
pandorawidget.text = "Pandora"
pandorawidget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () pandora("pause") end),
   awful.button({ }, 2, function () pandoramenu:toggle() end),
   --awful.button({ }, 2, function () exec("change-station-dmenu.sh") end),
   awful.button({ }, 4, function () pandora("skip") end),
   awful.button({ }, 5, function () pandora("skip") end)
))


--clock
mytextclock = awful.widget.textclock({ align = "right" })

--systray
mysystray = widget({ type = "systray" })
-- }}}
-- {{{ WIBOX
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
--      mytasklist[s] = awful.widget.tasklist(function(c)
--                                              return awful.widget.tasklist.label.currenttags(c, s)
--                                                end, mytasklist.buttons)
mytasklist[s] = awful.widget.tasklist.new(
  function(c)
    local text, bg, status_image, icon = 
awful.widget.tasklist.label.currenttags(c, s)
    return text, bg, status_image, icon, cdownmem
  end,
  mytasklist.buttons
)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = "14", screen = s })
    mywiboxb[s] = awful.wibox({ position = "bottom", height = "14", screen = s})

    -- Create a table with widgets that go to the right
    right_aligned = {
        layout = awful.widget.layout.horizontal.rightleft
    }
    table.insert(right_aligned, mysystray)
    table.insert(right_aligned, mytextclock)
    table.insert(right_aligned, mylayoutbox[s])
-- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        mytaglist[s],
        mypromptbox[s],
        right_aligned,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.leftright,
        height = mywibox[s].height
    }

    mywiboxb[s].widgets = {
        {
      --obvious.volume_alsa():set_layout(awful.widget.layout.horizontal.rightleft),
        {
        volwidget,
	viwidget,
        batwidget,
	biwidget,
	memwidget,
	miwidget,
	nvidiawidget,
	niwidget,
	--tiwidget,
	governwidget,
	thermalcpuwidget,
	cpuwidget,
	ciwidget,
	spacewidget,
	wifiwidget,
	spacewidget,
	netup,
	netwidget,
	netdn,
	spacewidget,
--	clpvolwidget,
	--viwidget,
	clmlwidget,
	miwidget,
	clslwidget,
	cldliwidget,
	--rtwidget,
        layout = awful.widget.layout.horizontal.rightleft,
        },
       },
--        mpdvolwidget,
        mpdiwidget,
        obvious.basic_mpd(),
	mpdiwidget,
	pandorawidget,
        pandoralove,
        pandoraban,
        --obvious.cpu.set_type("textbox"),
        --obvious.cpu(),
        --obvious.mem(used):set_type(textbox),
        --obvious.net.send(eth0):set_type(textbox),
        layout = awful.widget.layout.horizontal.leftright,
        height = mywiboxb[s].height
    }
end
-- }}}
-- {{{ MOUSE BINDINGS
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ KEY BINDINGS
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Shift"   }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "u", function () awful.util.spawn("urxvtc") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey,           }, "i", function () awful.util.spawn("uzbltab") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

awful.key({ modkey}, "d", function ()
        info = true
        awful.prompt.run({ prompt = "Dict: " }, 
        mypromptbox[mouse.screen].widget,
        function(word)
                local f = io.popen("dict -d wn " .. word .. " 2>&1")
                local fr = ""
                for line in f:lines() do
                fr = fr .. line .. '\n'
                end
                f:close()
                naughty.notify({ text = '<span font_desc="Terminus 8">'..fr..'</span>', timeout = 0, width = 400 })
        end,
        nil, awful.util.getdir("cache") .. "/dict") 
end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
   
    awful.key({ modkey }, "a", function ()
        awful.prompt.run({ prompt = "Chromium: " }, mypromptbox[mouse.screen].widget,
            function (command)
                --awful.util.spawn("chromium "..command.. false)
		awful.util.spawn("chromium --app=http://'"..command.."'", false)
                -- Switch to the web tag, where Firefox is, in this case tag 3
                if tags[mouse.screen][2] then awful.tag.viewonly(tags[mouse.screen][2]) end
            end)
    end)

)

--CLIENT KEY BINDINGS
clientkeys = awful.util.table.join(
    awful.key({ modkey,   "Shift" }, "]",      function () clpvolup() end),
    awful.key({ modkey,   "Shift" }, "[",      function () clpvoldown() end),
    awful.key({ modkey,   "Shift" }, "t",      function (c) awful.titlebar.add(c) end),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

--how many tags
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

--bind key number to tags
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end
-- }}}
-- {{{ CLIENT BUTTON BINDINGS
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ CLIENT RULES
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "qemu" },
      properties = { floating = true } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Chrome" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Wicd-client.py" },
      properties = { floating = true } },
    { rule = { class = "Linphone" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Uzbl-tabbed" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Uzbl-core" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Nvidia-settings" },
      properties = { floating = true } },
    { rule = { class = "Ossxmix" },
      properties = { floating = true } },
}
-- }}}
-- {{{ SIGNALS
client.add_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
            cldliwidget.image = c.icon
            clslwidget.text = c.class
	    clmlwidget.text = clientmem(c.pid)
            --awful.titlebar.add(c, { modkey = modkey })
	end
    end)
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
         --   awful.client.setslave(c)
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
    c.size_hints_honor = false
end)
client.add_signal("focus", function(c) clpid = c.pid end)
--client.add_signal("focus", function(c) pidvolume() end)
client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)-- }}}
-- {{{ HOOK

thermaltimer = timer { timeout = 10 }
thermaltimer:add_signal('timeout', function() nvidiawidget.text = nvidia() end)
thermaltimer:add_signal('timeout', function() governor() end)
thermaltimer:add_signal('timeout', function() thermalcpuwidget.text = thermalcpu() end)
thermaltimer:start()

-- }}}

