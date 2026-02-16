-- modals.lua
--
-- This creates a single "command mode" for various system actions.
-- Pressing the keybind enters the mode, after which you can press a
-- single key to trigger a specific action.

-- Create the single, master modal object
local masterModal = hs.hotkey.modal.new()

-- Define the "Polite" AppleScript for clearing notifications
-- Note: This requires Accessibility permissions for Hammerspoon
local politeClearScript = [[
tell application "System Events"
    try
        tell process "NotificationCenter"
            set _groups to groups of UI element 1 of scroll area 1 of window "Notification Center"
            repeat with _group in _groups
                try
                    perform action "AXPress" of button "Clear All" of _group
                end try
            end repeat
        end tell
    on error
        -- Notification Center likely closed or empty
    end try
end tell
]]

-- Define bindings in a table to support auto-generated help
-- fn: The function to run
-- exit: Whether to close the modal after running (default true)
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
        key = "n",
        desc = "Nuclear Banish Notifications (Kill Service)",
        fn = function()
            hs.execute("killall NotificationCenter")
            hs.alert.show("💥 Notifications Killed")
        end
    },
    {
        key = "c",
        desc = "Polite Clear Notifications (Close All)",
        fn = function()
            hs.osascript.applescript(politeClearScript)
            hs.alert.show("🧹 Clearing Notifications...")
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
    }
}

-- Helper function to generate help text from the table above
local function getHelpText()
    local text = "Available Commands:\n"
    for _, b in ipairs(bindings) do
        text = text .. string.upper(b.key) .. ": " .. b.desc .. "\n"
    end
    -- Add U manually since it's added later
    text = text .. "U: Show Usage"
    return text
end

-- Add 'u' (Usage) to the bindings table explicitly
table.insert(bindings, {
    key = "u",
    desc = "Show Usage",
    fn = function()
        hs.alert.show(getHelpText(), 4)
        return false -- Do not exit modal
    end
})

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
