-- utils.lua

-- List all running apps
function listAllApps()
    local apps = hs.application.runningApplications() -- running apps
    local names = {}
    for _, app in ipairs(apps) do
        local name = app:name()
        if name then
            table.insert(names, name)
        end
    end

    table.sort(names)
    for i, name in ipairs(names) do
        print(i .. ": " .. name)
    end
end

-- Empty Trash instantly, system-wide
hs.hotkey.bind({ "cmd", "option", "ctrl" }, "delete", function()
    hs.osascript.applescript([[
        tell application "Finder"
            empty the trash without asking
        end tell
    ]])
    hs.notify.new({ title = "Hammerspoon", informativeText = "Trash Emptied Instantly" }):send()
end)

-- Show the name of the active application while switching
hs.application.watcher.new(function(appName, eventType, app)
    if eventType == hs.application.watcher.activated then
        hs.alert.show("Active Application: " .. appName)
        print("Active Application: " .. appName) -- Logs to Hammerspoon console
    end
end):start()

-- Toggle Hammerspoon Console with Cmd + Option + Y
hs.hotkey.bind({ "cmd", "option" }, "5", function()
    hs.toggleConsole()
end)
