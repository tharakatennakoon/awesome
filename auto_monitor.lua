local awful = require 'awful'

-- awful.spawn.with_shell 'xrandr --output eDP-1 --primary --output DP-2 --right-of eDP-1'
-- awful.spawn.with_shell 'xrandr --output eDP-1 --primary --output DP-1 --right-of eDP-1'

-- Function to configure monitors
local function configure_monitors()
  -- Use `xrandr` to detect connected outputs
  awful.spawn.easy_async_with_shell("xrandr --query | grep ' connected'", function(stdout)
    local internal_monitor = 'eDP-1'
    local external_monitor = nil

    for line in stdout:gmatch '[^\r\n]+' do
      if not line:match(internal_monitor) then
        external_monitor = line:match '^(%S+)'
      end
    end

    if external_monitor then
      -- Configure the external monitor to the right of the internal monitor
      awful.spawn.with_shell(
        'xrandr --output ' .. internal_monitor .. ' --auto --primary --output ' .. external_monitor .. ' --auto --right-of ' .. internal_monitor
      )
    else
      -- Only internal monitor is connected
      awful.spawn.with_shell('xrandr --output ' .. internal_monitor .. ' --auto --primary')
    end
  end)
end

-- Call the function on startup
return {
  configure_monitors = configure_monitors,
}
