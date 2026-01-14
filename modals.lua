-- modals.lua
--
-- This creates a single "command mode" for various system actions.
-- Pressing the keybind enters the mode, after which you can press a
-- single key to trigger a specific action.

-- Create the single, master modal object
local masterModal = hs.hotkey.modal.new()

-- Define bindings in a table to support auto-generated help
local bindings = {
    {
        key = "h",
        desc = "Reload Configuration",
        fn = function()
            masterModal:exit()
            hs.reload()
            hs.notify.new({ title = "Hammerspoon", informativeText = "Config Reloaded" }):send()
        end
    },
    {
        key = "s",
        desc = "Shazam to Note",
        fn = function()
            masterModal:exit()
            hs.notify.new({ title = "Hammerspoon", informativeText = "Running 'Shazam to Note'..." }):send()
            hs.task.new("/usr/bin/shortcuts", nil, { "run", "Shazam to Note" }):start()
        end
    },
    {
        key = "t",
        desc = "Empty Trash Instantly",
        fn = function()
            -- masterModal:exit() -- Optional: stay in modal? Usage implied usually exit.
            -- Original code didn't exit for 't' but 'h' and 's' did.
            -- Wait, original 't' did NOT exit.
            -- I will keep original behavior: 't' stays in modal (maybe?) or I should unify.
            -- Looking at original code:
            -- h -> exit, s -> exit, t -> NO exit.
            -- I will preserve that behavior.
            hs.osascript.applescript([[
                tell application "Finder"
                    empty the trash without asking
                end tell
            ]])
            hs.notify.new({ title = "Hammerspoon", informativeText = "Trash Emptied Instantly" }):send()
        end
    }
}

-- Helper function to generate help text
local function getHelpText()
    local text = "Available Commands:\n"
    for _, b in ipairs(bindings) do
        text = text .. string.upper(b.key) .. ": " .. b.desc .. "\n"
    end
    -- Add 'u' itself to help?
    text = text .. "U: Show Usage"
    return text
end

-- Bind the 'u' usage key separately or add to table?
-- If I add to table, it shows up in help automatically.
-- But 'u' self-referencing might be cleaner if manual or just added to table.
-- Let's add 'u' to the table for completeness.
table.insert(bindings, {
    key = "u",
    desc = "Show Usage",
    fn = function()
        -- Show alert, don't exit modal immediately so user can read it?
        -- Or exit? Usually help is momentary.
        -- User said "triggered by modal 'u' which shows usage"
        -- Let's use hs.alert.show which is nice overlay.
        -- And keep modal open so they can then press the key they wanted.
        hs.alert.show(getHelpText(), 4)
    end
})


-- Apply all bindings
for _, b in ipairs(bindings) do
    masterModal:bind({}, b.key, b.desc, b.fn)
end


-- Define the single "entry" hotkey that activates the modal.
hs.hotkey.bind({ "cmd", "option" }, "§", function()
    masterModal:enter()
    -- provide a hint about what can be pressed.
    hs.notify.new({
        title = "Binds in Modal Mode",
        informativeText = "Press U for Usage Options"
    }):send()
end)
