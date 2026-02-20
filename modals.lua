-- modals.lua
--
-- This creates a single "command mode" for various system actions.
-- Pressing the keybind enters the mode, after which you can press a single key to trigger a specific action.

-- Create the single, master modal object
local masterModal = hs.hotkey.modal.new()

local bindings = {
    {
        key = "h",
        desc = "Reload HS Configuration",
        fn = function()
            hs.reload()
            hs.notify.new({ title = "Hammerspoon", informativeText = "Config Reloaded" }):send()
        end
    },
    {
        key = "s",
        desc = "Shazam to Note",
        fn = function()
            hs.notify.new({ title = "Hammerspoon", informativeText = "Running 'Shazam to Note'..." }):send()
            hs.task.new("/usr/bin/shortcuts", nil, { "run", "Shazam to Note" }):start()
        end
    },
    {
        key = "t",
        desc = "Empty Trash Instantly",
        fn = function()
            hs.osascript.applescript([[
                tell application "Finder"
                    empty the trash without asking
                end tell
            ]])
            hs.notify.new({ title = "Hammerspoon", informativeText = "Trash Emptied Instantly" }):send()
        end
    },
    {
        key = "u",
        desc = "Show usage",
        fn = function()
            local text = "Available Commands:\n"
            for _, b in ipairs(bindings) do
                text = text .. string.upper(b.key) .. ": " .. b.desc .. "\n"
            end
            hs.alert.show(text, 4)
            return false -- Do not exit modal
        end
    }
}

-- Apply all bindings
for _, b in ipairs(bindings) do
    masterModal:bind({}, b.key, function()
        -- Execute the function
        local shouldStayOpen = b.fn()

        -- Exit modal unless the function explicitly returned false (like Usage)
        if shouldStayOpen ~= false then
            masterModal:exit()
        end
    end)
end

-- Define the single "entry" hotkey that activates the modal.
-- Current Bind: Cmd + Option + §
hs.hotkey.bind({ "cmd", "option" }, "§", function()
    masterModal:enter()
    hs.notify.new({
        title = "Command Mode Active",
        informativeText = "Press U for Usage Options"
    }):send()
end)

-- Optional: Add an escape key to just close the modal without doing anything
masterModal:bind({}, "escape", function()
    masterModal:exit()
    hs.alert.show("Exited Mode")
end)
