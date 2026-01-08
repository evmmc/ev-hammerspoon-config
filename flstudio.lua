-- flstudio.lua
local flstudio = {}

-- Move the current Pattern UP via the Menu
function fl_move_pattern_up()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        -- Tries to select Patterns -> Move up
        if not app:selectMenuItem({ "Patterns", "Move up" }) then
            hs.alert.show("Unable to find 'Patterns > Move up'")
        end
    end
end

-- Move the current Pattern DOWN via the Menu
function fl_move_pattern_down()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        -- Tries to select Patterns -> Move down
        if not app:selectMenuItem({ "Patterns", "Move down" }) then
            hs.alert.show("Unable to find 'Patterns > Move down'")
        end
    end
end

-- trigger "Remove all edisons" in FL Studio
function fl_remove_edisons()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        app:selectMenuItem({ "Tools", "Macros", "Remove all Edison instances" })
        hs.alert.show("🧹 Removed all Edisons")
    else
        hs.alert.show("FL Studio not running")
    end
end

-- Table to store FL Studio hotkeys
local flStudioHotkeys = {}

-- Function to activate hotkeys when FL Studio is active
function flstudio.activateHotkeys()
    -- Settings
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "cmd" }, ",", function()
        hs.eventtap.keyStroke({}, "F10")
    end))

    -- Mixer
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "cmd" }, "m", function()
        hs.eventtap.keyStroke({}, "F9")
    end))

    -- Plugin picker
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "p", function()
        hs.eventtap.keyStroke({}, "F8")
    end))

    -- toggle browser
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "b", function()
        hs.eventtap.keyStroke({ "option" }, "F8")
    end))

    -- piano roll
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "cmd" }, "r", function()
        hs.eventtap.keyStroke({}, "F7")
    end))

    -- channel rack
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "cmd" }, "c", function()
        hs.eventtap.keyStroke({}, "F6")
    end))
    -- option-c == new channel

    -- Playlist
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "cmd" }, "p", function()
        hs.eventtap.keyStroke({}, "F5")
    end))

    -- create new pattern
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "n", function()
        hs.eventtap.keyStroke({}, "F4")
    end))

    -- tool picker
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "t", function()
        hs.eventtap.keyStroke({}, "F3")
    end))

    -- tool picker
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "3", function()
        hs.eventtap.keyStroke({}, "F3")
    end))

    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "2", function()
        hs.eventtap.keyStroke({}, "F2")
    end))
    -- Move Pattern Up (Option + Up Arrow)
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "up", fl_move_pattern_up))

    -- Move Pattern Down (Option + Down Arrow)
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "down", fl_move_pattern_down))

    -- Move Pattern Up (Option + Up Arrow)
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "cmd" }, "[", fl_move_pattern_up))

    -- Move Pattern Down (Option + Down Arrow)
    table.insert(flStudioHotkeys, hs.hotkey.bind({ "cmd" }, "]", fl_move_pattern_down))

    table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "x", fl_remove_edisons))

    -- table.insert(flStudioHotkeys, hs.hotkey.bind({ "option" }, "i", function()
    --     hs.eventtap.keyStroke({ "shift", "cmd" }, "insert")
    -- end))
end

-- Function to deactivate hotkeys when FL Studio is inactive
function flstudio.deactivateHotkeys()
    for _, hotkey in pairs(flStudioHotkeys) do
        hotkey:delete()
    end
    flStudioHotkeys = {}
end

-- Watcher to handle FL Studio activation and deactivation
flstudio.watcher = hs.application.watcher.new(function(appName, eventType, app)
    if appName == "FL Studio" and eventType == hs.application.watcher.activated then
        flstudio.activateHotkeys()
    elseif appName == "FL Studio" and eventType == hs.application.watcher.deactivated then
        flstudio.deactivateHotkeys()
    end
end)

-- -- Map Option + 1 to 9 → Numpad 1 to 9 (Pattern 1 to 9 in FL Studio)
-- local patternKeys = {
--     ["1"] = "pad1",
--     ["2"] = "pad2",
--     ["3"] = "pad3",
--     ["4"] = "pad4",
--     ["5"] = "pad5",
--     ["6"] = "pad6",
--     ["7"] = "pad7",
--     ["8"] = "pad8",
--     ["9"] = "pad9"
-- }

-- for numKey, padKey in pairs(patternKeys) do
--     hs.hotkey.bind({ "option" }, numKey, function()
--         hs.eventtap.keyStroke({}, padKey)
--     end)
-- end

-- Start the watcher
function flstudio.start()
    flstudio.watcher:start()
end

return flstudio
