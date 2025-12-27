-- appdial.lua

hs.loadSpoon("LeftRightHotkey")
spoon.LeftRightHotkey:start()

local function toggleApp(appName)
    local app = hs.application.find(appName)

    if not app then
        -- 1. Not running: Launch it
        hs.application.launchOrFocus(appName)
    elseif app:isFrontmost() then
        -- 2. Running & Focused: Hide it
        app:hide()
    else
        -- 3. Running & Background: Focus it
        app:activate()
    end
end

local appList = {
    "Emacs",
    "Google Chrome",
    "Ghostty",
    "Notes",
    "Finder",
    "Tiny Player",
    "Skim",
}

for i, appName in ipairs(appList) do
    spoon.LeftRightHotkey:bind({"rCmd"}, tostring(i), function()
        toggleApp(appName)
    end)
end
