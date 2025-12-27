-- flstudio.lua
local flstudio = {}

-- trigger "Remove all edisons" in FL Studio
function fl_remove_edisons()
  local app = hs.appfinder.appFromName("FL Studio")
  if app then
    app:selectMenuItem({"Tools", "Macros", "Remove all Edison instances"})
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
    table.insert(flStudioHotkeys, hs.hotkey.bind({"cmd"}, ",", function()
        hs.eventtap.keyStroke({}, "F10")
    end))

    -- Mixer
    table.insert(flStudioHotkeys, hs.hotkey.bind({"cmd"}, "m", function()
        hs.eventtap.keyStroke({}, "F9")
    end))

    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "p", function()
        hs.eventtap.keyStroke({}, "F8")
    end))

    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "b", function()
        hs.eventtap.keyStroke({"option"}, "F8")
    end))

    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "r", function()
        hs.eventtap.keyStroke({}, "F7")
    end))

    table.insert(flStudioHotkeys, hs.hotkey.bind({"cmd"}, "c", function()
        hs.eventtap.keyStroke({}, "F6")
    end))

    -- Playlist
    table.insert(flStudioHotkeys, hs.hotkey.bind({"cmd"}, "p", function()
        hs.eventtap.keyStroke({}, "F5")
    end))

    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "n", function()
        hs.eventtap.keyStroke({}, "F4")
    end))

    -- Notice: passing the function reference directly here
    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "x", fl_remove_edisons))

    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "i", function()
        hs.eventtap.keyStroke({"shift", "cmd"}, "insert")
    end))

    -- FL Studio pattern navigation
    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "[", function()
        hs.eventtap.keyStroke({}, "pad-")   -- previous pattern
    end))

    table.insert(flStudioHotkeys, hs.hotkey.bind({"option"}, "]", function()
        hs.eventtap.keyStroke({}, "pad+")   -- next pattern
    end))

end
-- Function to deactivate hotkeys when FL Studio is inactive
function flstudio.deactivateHotkeys()
    -- for _, hotkey in ipairs(flStudioHotkeys) do
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

-- Map Option + 1 to 9 → Numpad 1 to 9 (Pattern 1 to 9 in FL Studio)
local patternKeys = {
  ["1"] = "pad1",
  ["2"] = "pad2",
  ["3"] = "pad3",
  ["4"] = "pad4",
  ["5"] = "pad5",
  ["6"] = "pad6",
  ["7"] = "pad7",
  ["8"] = "pad8",
  ["9"] = "pad9"
}

for numKey, padKey in pairs(patternKeys) do
  hs.hotkey.bind({"option"}, numKey, function()
    hs.eventtap.keyStroke({}, padKey)
  end)
end

-- Start the watcher
function flstudio.start()
    flstudio.watcher:start()
end

return flstudio
