local wibox = require 'wibox'
local vicious = require 'vicious'

local battery_widget = wibox.widget.textbox()
local battery_widget_ = wibox.widget.textbox()

local function update_battery_widget(widget, args)
  local percent = args[2]
  local icon = '󱊣'
  local color = '#00FF00'
  if args[1] == '+' then
    color = '#00FF00' -- Green for charging
    if args[2] < 20 then
      icon = '󱊤'
    elseif args[2] < 80 then
      icon = '󱊥'
    else
      icon = '󱊦'
    end
  else
    if args[2] < 20 then
      color = '#FF0000' -- Red for low battery
      icon = '󱊡'
    elseif args[2] < 80 then
      color = '#FFFF00' -- Yellow for medium battery
      icon = '󱊢'
    else
      color = '#00FF00' -- Green for charging
      icon = '󱊣'
    end
  end

  local markup = string.format("<span foreground='%s'>%d%s </span>", color, percent, icon)
  battery_widget.markup = markup
  return ''
end

vicious.register(battery_widget_, vicious.widgets.bat, update_battery_widget, 61, 'BAT0')

return battery_widget
