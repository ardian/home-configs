---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.font          = "Terminus 8"

theme.bg_normal     = "#191919"
theme.bg_focus      = "#343434"
theme.bg_urgent     = "#9ACD32"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize  = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#191919"
theme.border_focus  = "#000000"
--theme.border_focus  = "#556B2F"
theme.border_marked = "#9ACD32"

-- There are another variables sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- Example:
--taglist_bg_focus = #ff0000

-- Display the taglist squares
theme.taglist_squares_sel = "/home/wut/.config/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/home/wut/.config/awesome/themes/default/taglist/squarew.png"

theme.tasklist_floating_icon = "/home/wut/.config/awesome/themes/default/float.png"

theme.rss_icon = "/home/wut/.config/awesome/icons/rss.png"
theme.vol_icon = "/home/wut/.config/awesome/icons/vol.png"
theme.bat_icon = "/home/wut/.config/awesome/icons/bat.png"
theme.tmp_icon = "/home/wut/.config/awesome/icons/temp.png"
theme.mem_icon = "/home/wut/.config/awesome/icons/mem.png"
theme.cpu_icon = "/home/wut/.config/awesome/icons/cpu.png"
theme.mpd_icon = "/home/wut/.config/awesome/icons/music.png"
theme.time_icon = "/home/wut/.config/awesome/icons/time.png"

-- Variables set for theming menu
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/home/wut/.config/awesome/themes/default/submenu.png"
theme.menu_height   = "16"
theme.menu_width    = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--bg_widget    = #cc0000

-- Define the image to load
theme.titlebar_close_button_normal = "/home/wut/.config/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = "/home/wut/.config/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/home/wut/.config/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = "/home/wut/.config/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/home/wut/.config/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = "/home/wut/.config/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/home/wut/.config/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = "/home/wut/.config/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/home/wut/.config/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = "/home/wut/.config/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/home/wut/.config/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = "/home/wut/.config/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/home/wut/.config/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = "/home/wut/.config/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/home/wut/.config/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = "/home/wut/.config/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/home/wut/.config/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = "/home/wut/.config/awesome/themes/default/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "awsetbg /home/wut/.config/awesome/themes/default/background.png" }

-- You can use your own layout icons like this:
theme.layout_fairh = "/home/wut/.config/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "/home/wut/.config/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating = "/home/wut/.config/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "/home/wut/.config/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "/home/wut/.config/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/home/wut/.config/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/home/wut/.config/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft = "/home/wut/.config/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "/home/wut/.config/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/home/wut/.config/awesome/themes/default/layouts/tiletopw.png"

theme.awesome_icon = "/home/wut/.config/awesome/icons/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
