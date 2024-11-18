local awful = require 'awful'
local gears = require 'gears'
local naughty = require 'naughty'

-- awful.spawn.with_shell 'xrandr --output eDP-1 --primary --output DP-2 --right-of eDP-1'
-- awful.spawn.with_shell 'xrandr --output eDP-1 --primary --output DP-1 --right-of eDP-1'

local function notify(msg)
  naughty.notify {
    preset = naughty.config.presets.critical,
    title = 'log',
    text = msg,
  }
end

-- Function to configure monitors
local function configure_monitors()
  local internal_monitor = 'eDP-1'
  local external_monitor = nil

  -- Use `xrandr` to detect connected outputs
  awful.spawn.easy_async_with_shell("xrandr --query | grep ' connected'", function(stdout)
    for line in stdout:gmatch '[^\r\n]+' do
      if not line:match(internal_monitor) then
        external_monitor = line:match '^(%S+)'
      end
    end

    local cmd
    if external_monitor then
      cmd = 'xrandr --output ' .. external_monitor .. ' --auto --primary --output ' .. internal_monitor .. ' --auto --left-of ' .. external_monitor
    else
      cmd = 'xrandr --output ' .. internal_monitor .. ' --auto --primary'
    end
    awesome.emit_signal('monitor::config', cmd)
  end)
end

-- Function to configure monitors based on the signal
awesome.connect_signal('monitor::config', function(connected_monitors)
  notify(connected_monitors)
  awful.spawn.with_shell(connected_monitors)
end)

-- Call the function on startup
return {
  configure_monitors = configure_monitors,
}
