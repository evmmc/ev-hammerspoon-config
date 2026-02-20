-- flstudio.lua
local flstudio = {}

-- In your table:
-- { { "cmd", "ctrl" }, "left", pressPad0() },
-- Generic function to trigger a key press
local function pressKey(keyName)
    return function()
        hs.eventtap.keyStroke({}, keyName, 1000)
    end
end

-- view patterns
function view_patterns()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        -- Tries to select Patterns -> Move up
        if not app:selectMenuItem({ "View", "Patterns" }) then
            hs.alert.show('oops')
        end
    end
end

-- view fx in use
function view_fx_in_use()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        -- Tries to select Patterns -> Move up
        if not app:selectMenuItem({ "View", "Effects in use" }) then
            hs.alert.show('oops')
        end
    end
end

-- view generators in use
function view_gen_in_use()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        -- Tries to select Patterns -> Move up
        if not app:selectMenuItem({ "View", "Generators in use" }) then
            hs.alert.show('oops')
        end
    end
end

-- Move the current Pattern UP via the Menu
function fl_move_pattern_up()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        if not app:selectMenuItem({ "Patterns", "Move up" }) then
            hs.alert.show("Unable to find 'Patterns > Move up'")
        end
    end
end

-- Move the current Pattern DOWN via the Menu
function fl_move_pattern_down()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        if not app:selectMenuItem({ "Patterns", "Move down" }) then
            hs.alert.show("Unable to find 'Patterns > Move down'")
        end
    end
end

-- trigger "Remove all edisons" in FL Studio
function fl_remove_edisons()
    local app = hs.appfinder.appFromName("FL Studio")
    if app then
        app:selectMenuItem({ "Tools", "Remove all Edison instances" })
        hs.alert.show("🧹 Removed all Edisons")
    else
        hs.alert.show("FL Studio not running")
    end
end

-- Table to store FL Studio hotkeys
local flStudioHotkeys = {}
function flstudio.activateHotkeys()
    -- 1. Define the configuration table
    -- Format: { {modifiers}, "trigger_key", action }
    -- Action can be:
    --    "KEY"       -> Simple keystroke (e.g., "F10")
    --    {"MOD", "K"}-> Keystroke with modifiers (e.g., {"option", "F8"})
    --    function    -> A custom function variable
    local definitions = {
        { { "cmd" },            ",",     "F10" },
        { { "cmd" },            "m",     "F9" },               -- Mixer
        { { "option" },         "p",     "F8" },               -- Plugin picker
        { { "option" },         "s",     { "option", "F8" } }, -- Toggle browser
        { { "option" },         "r",     "F7" },               -- Piano roll
        { { "cmd" },            "r",     "F6" },               -- Channel rack (overrides export)
        { { "cmd" },            "p",     "F5" },               -- Playlist (overrides metronome)
        { { "cmd" },            "n",     "F4" },               -- New pattern (overrides save new version)
        { { "option" },         "t",     "F3" },               -- Tool picker
        { { "ctrl", "option" }, "s",     "F2" },               -- Sample properties
        { { "cmd" },            "[",     fl_move_pattern_up },
        { { "cmd" },            "]",     fl_move_pattern_down },
        { { "option" },         "x",     fl_remove_edisons },
        { { "cmd", "ctrl" },    "e",     view_fx_in_use },
        { { "cmd", "ctrl" },    "g",     view_gen_in_use },
        { { "cmd", "ctrl" },    "p",     view_patterns },
        { { "cmd", "ctrl" },    "up",    pressKey("pageup") },
        { { "cmd", "ctrl" },    "down",  pressKey("pagedown") },
        { { "cmd", "ctrl" },    "left",  pressKey("pad0") },
        { { "cmd", "ctrl" },    "right", pressKey("pad.") }
    }
    -- 2. Iterate once and insert
    for _, def in ipairs(definitions) do
        local mods, key, action = def[1], def[2], def[3]
        local handler

        -- Determine how to handle the action based on its type
        if type(action) == "string" then
            -- Simple Key: F10
            handler = function() hs.eventtap.keyStroke({}, action) end
        elseif type(action) == "table" then
            -- Complex Key: { "option", "F8" }
            handler = function() hs.eventtap.keyStroke(action[1], action[2]) end
        elseif type(action) == "function" then
            -- Custom Function
            handler = action
        end

        if handler then
            table.insert(flStudioHotkeys, hs.hotkey.bind(mods, key, handler))
        end
    end
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

-- Start the watcher
function flstudio.start()
    flstudio.watcher:start()
end

return flstudio
