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

-- Show the name of the active application while switching
hs.application.watcher.new(function(appName, eventType, app)
    if eventType == hs.application.watcher.activated then
        hs.alert.show("Active Application: " .. appName)
        print("Active Application: " .. appName) -- Logs to Hammerspoon console
    end
end):start()

-- Toggle Hammerspoon Console with Cmd + Option + Y
hs.hotkey.bind({ "cmd", "option", "control" }, "h", function()
    hs.toggleConsole()
end)



function showActiveBindings()
    local activeHotkeys = hs.hotkey.getHotkeys()
    local choices = {}

    for _, hk in ipairs(activeHotkeys) do
        -- Only show bindings that are currently enabled
        if hk.enabled then
            local shortcut = hk.idx or "Unknown binding"
            local description = hk.msg or "No description"

            -- Hammerspoon defaults the message to the keystroke if left blank.
            -- This cleans up the UI for unlabeled bindings.
            if description == shortcut then
                description = "Unlabeled Binding"
            end

            table.insert(choices, {
                text = shortcut,
                subText = description
            })
        end
    end

    -- Create the chooser
    local chooser = hs.chooser.new(function(choice)
        -- We just want to view them, so we do nothing on selection
        -- (Though you could theoretically trigger the hotkey from here if you wanted!)
    end)

    chooser:choices(choices)
    chooser:placeholderText("Active Hammerspoon Bindings (Type to search...)")

    -- Display the searchable list
    chooser:show()
end

hs.hotkey.bind({ "cmd", "option", "ctrl" }, "`", "Show Active Bindings", showActiveBindings)

-- hs.hotkey.showHotkeys({ "cmd", "option", "ctrl" }, "`")
