-- appdial.lua

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
    "FL Studio",
    "Finder",
    "Tiny Player",
    "Skim"
}

for i, appName in ipairs(appList) do
    hs.hotkey.bind({ "option" }, tostring(i), function()
        toggleApp(appName)
    end)
end

local function openEmacsEverywhere()
    local output, status, type, rc = hs.execute("/opt/homebrew/bin/emacsclient --eval '(emacs-everywhere)'")
    if not status then
        hs.alert.show("Error: Could not connect to Emacs server")
    end
end

-- Example Binding: Hyper + E
hs.hotkey.bind({ "cmd", "option" }, "e", openEmacsEverywhere)
