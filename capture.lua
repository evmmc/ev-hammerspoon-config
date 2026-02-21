-- capture.lua

-- Helper function: Handles the actual writing to the file
-- This ensures both functions use the exact same logic for file paths and formatting
local function appendEntryToOrgFile(heading, body, tag, orgfile, orgdir)
    -- Ensure we have a filename, default to "capture.org"
    local filename = orgfile or "capture.org"
    local dir = orgdir or "org"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    -- Build Org entry
    local orgEntry = string.format(
        "* %s\n:PROPERTIES:\n:CREATED: [%s]\n:TAGS: %s\n:END:\n\n%s\n\n",
        heading, timestamp, tag, body
    )

    -- Path to Org file
    local orgFilePath = os.getenv("HOME") .. "/" .. dir .. "/" .. filename

    -- Append to the file
    local file = io.open(orgFilePath, "a")
    if file then
        file:write(orgEntry)
        file:close()
        hs.alert.show("Captured to " .. filename)
    else
        hs.alert.show("ERROR: cannot open " .. filename)
    end
end

-- 1. Original Function: Capture selected text into Org file
function captureTextToOrg(orgfile, orgdir)
    -- Step 1: simulate Cmd+C to copy the selected text
    hs.eventtap.keyStroke({ "cmd" }, "c", 0)

    -- small delay to allow clipboard update
    hs.timer.doAfter(0.15, function()
        local text = hs.pasteboard.getContents()

        if not text or text == "" then
            hs.alert.show("No text selected.")
            return
        end

        -- Split into lines to find a heading
        local lines = {}
        for line in text:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local heading = string.sub(lines[1] or "Clipboard Capture", 1, 100)
        local tag = ":clipboard_capture:"

        -- Call the helper to save
        appendEntryToOrgFile(heading, text, tag, orgfile, orgdir)
    end)
end

-- 2. New Function: Quick Win Dialog
function captureQuickNote(orgfile, orgdir)
    -- Opens a native macOS text prompt dialog
    -- button is "OK" or "Cancel", text is what you wrote
    local button, text = hs.dialog.textPrompt("Quick Win", "What did you achieve?")

    if button == "OK" and text and text ~= "" then
        -- For a Quick Win, the Heading is the text itself.
        -- We leave the body empty (or you could duplicate the text if you prefer)
        local heading = text
        local tag = ":quick_win:"
        local body = ""

        -- Call the helper to save
        appendEntryToOrgFile(heading, body, tag, orgfile, orgdir)
    end
end

-- Existing bindings
hs.hotkey.bind({ "ctrl", "cmd" }, "9", captureTextToOrg)
hs.hotkey.bind({ "ctrl" }, "§", captureTextToOrg)

-- New binding for Quick Win (Example: Ctrl + Cmd + 0)
hs.hotkey.bind({ "option", "cmd" }, "c", captureQuickNote)
