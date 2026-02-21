--- modals.lua

local function reloadHammerspoon()
    hs.reload()
    hs.notify.new({ title = "Hammerspoon", informativeText = "Config Reloaded" }):send()
end

local function runShazamShortcut()
    hs.notify.new({ title = "Hammerspoon", informativeText = "Running 'Shazam to Note'..." }):send()
    hs.task.new("/usr/bin/shortcuts", nil, { "run", "Shazam to Note" }):start()
end

local function emptyTrash()
    hs.osascript.applescript([[
        tell application "Finder"
            empty the trash without asking
        end tell
    ]])
    hs.notify.new({ title = "Hammerspoon", informativeText = "Trash Emptied Instantly" }):send()
end

local masterModal = hs.hotkey.modal.new()

-- We define the list here. Note: "usage" is handled separately to avoid
-- circular references during table initialization.
local bindings = {
    { key = "h", desc = "Reload HS Configuration", fn = reloadHammerspoon },
    { key = "s", desc = "Shazam to Note",          fn = runShazamShortcut },
    { key = "t", desc = "Empty Trash Instantly",   fn = emptyTrash },
}

-- The Usage Function: Now it can safely see the 'bindings' table
local function showUsage()
    local text = "Available Commands:\n"
    for _, b in ipairs(bindings) do
        text = text .. string.upper(b.key) .. ": " .. b.desc .. "\n"
    end
    text = text .. "U: Show usage\nESC: Exit"
    hs.alert.show(text, 4)
end

for _, b in ipairs(bindings) do
    masterModal:bind({}, b.key, function()
        b.fn()
        masterModal:exit()
    end)
end

-- Bind Manual Actions (No Auto-Exit)
masterModal:bind({}, "u", showUsage)
masterModal:bind({}, "escape", function()
    masterModal:exit()
    hs.alert.show("Exited Modal")
end)

-- Entry Point: Cmd + Option + §
hs.hotkey.bind({ "cmd", "option" }, "§", function()
    hs.notify.new({
        title = "Command Mode Active",
        informativeText = "Press U for Usage Options"
    }):send()
    masterModal:enter()
end)

return masterModal
