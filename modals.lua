-- modals.lua
--
-- This creates a single "command mode" for various system actions.
-- Pressing the keybind enters the mode, after which you can press a
-- single key to trigger a specific action.

-- Create the single, master modal object
local masterModal = hs.hotkey.modal.new()

-- Bind actions to keys within the modal.

-- Press 'h' (for Hammerspoon) to reload the configuration.
masterModal:bind({}, "h", function()
    masterModal:exit() -- Crucial: always exit the modal after an action
    hs.reload()
    hs.notify.new({ title = "Hammerspoon", informativeText = "Config Reloaded" }):send()
end)

-- Press 's' (for Shazam) to run the "Shazam to Note" macOS Shortcut.
masterModal:bind({}, "s", function()
    masterModal:exit()
    hs.notify.new({ title = "Hammerspoon", informativeText = "Running 'Shazam to Note'..." }):send()
    hs.task.new("/usr/bin/shortcuts", nil, { "run", "Shazam to Note" }):start()
end)

-- Define the single "entry" hotkey that activates the modal.
hs.hotkey.bind({ "cmd", "option" }, "§", function()
    masterModal:enter()
    -- provide a hint about what can be pressed.
    hs.notify.new({
        title = "Binds in Modal Mode",
        informativeText = "Press key: H (reload), S (Shazam), ? (help)"
    }):send()
end)
