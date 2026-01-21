-- modals.lua
--
-- This creates a single "command mode" for various system actions.
-- Pressing the keybind enters the mode, after which you can press a
-- single key to trigger a specific action.

-- Create the single, master modal object
local masterModal = hs.hotkey.modal.new()

-- Define bindings in a table to support auto-generated help
local bindings = {
    {
        key = "h",
        desc = "Reload Configuration",
        fn = function()
            masterModal:exit()
            hs.reload()
            hs.notify.new({ title = "Hammerspoon", informativeText = "Config Reloaded" }):send()
        end
    },
    {
        key = "s",
        desc = "Shazam to Note",
        fn = function()
            masterModal:exit()
            hs.notify.new({ title = "Hammerspoon", informativeText = "Running 'Shazam to Note'..." }):send()
            hs.task.new("/usr/bin/shortcuts", nil, { "run", "Shazam to Note" }):start()
        end
    },
    {
        key = "n",
        desc = "Banish Notifications",
        fn = function()
            masterModal:exit()
            hs.execute("killall NotificationCenter")
        end
    },
    {
        key = "t",
        desc = "Empty Trash Instantly",
        fn = function()
            -- masterModal:exit() -- Keeping your original logic (no exit) for Trash
            hs.osascript.applescript([[
                tell application "Finder"
                    empty the trash without asking
                end tell
            ]])
            hs.notify.new({ title = "Hammerspoon", informativeText = "Trash Emptied Instantly" }):send()
        end
    }
}

-- Helper function to generate help text
local function getHelpText()
    local text = "Available Commands:\n"
    for _, b in ipairs(bindings) do
        text = text .. string.upper(b.key) .. ": " .. b.desc .. "\n"
    end
    -- Add 'u' explicitly to help text
    text = text .. "U: Show Usage"
    return text
end

-- Add 'u' (Usage) to the bindings table
table.insert(bindings, {
    key = "u",
    desc = "Show Usage",
    fn = function()
        -- Show alert, keeping modal open so user can press the next key
        hs.alert.show(getHelpText(), 4)
    end
})


-- Apply all bindings
for _, b in ipairs(bindings) do
    masterModal:bind({}, b.key, b.desc, b.fn)
end


-- Define the single "entry" hotkey that activates the modal.
hs.hotkey.bind({ "cmd", "option" }, "§", function()
    masterModal:enter()
    -- provide a hint about what can be pressed.
    hs.notify.new({
        title = "Binds in Modal Mode",
        informativeText = "Press U for Usage Options"
    }):send()
end)
