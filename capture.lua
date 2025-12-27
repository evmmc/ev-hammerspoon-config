-- capture.lua

-- Capture selected text into Org file
function captureTextToOrg(orgfile, orgdir)
    -- Ensure we have a filename, default to "capture.org" if orgfile is nil
    local filename = orgfile or "capture.org"

    -- Step 1: simulate Cmd+C to copy the selected text
    hs.eventtap.keyStroke({"cmd"}, "c", 0)

    -- small delay to allow clipboard update
    hs.timer.doAfter(0.15, function()
        local text = hs.pasteboard.getContents()

        if not text or text == "" then
            hs.alert.show("No text selected.")
            return
        end

        -- Split into lines
        local lines = {}
        for line in text:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local heading = string.sub(lines[1] or "Clipboard Capture", 1, 100)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local tag = ":clipboard_capture:"

        -- Build Org entry
        local orgEntry = string.format(
            "* %s\n:PROPERTIES:\n:CREATED: [%s]\n:TAGS: %s\n:END:\n\n%s\n\n",
            heading, timestamp, tag, text
        )

        -- Path to Org file
        -- Now uses the variable 'filename' instead of the hardcoded string
        local orgFilePath = os.getenv("HOME") .. "/" .. orgdir .. "/" .. filename

        -- Append to the file
        local file = io.open(orgFilePath, "a")
        if file then
            file:write(orgEntry)
            file:close()
            hs.alert.show("Captured to " .. filename)
        else
            hs.alert.show("ERROR: cannot open " .. filename)
        end
    end)
end

hs.hotkey.bind({"ctrl", "cmd"}, "9", captureTextToOrg)
hs.hotkey.bind({"option", "cmd"}, "c", captureTextToOrg)


