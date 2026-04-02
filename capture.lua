-- capture.lua

local function appendEntryToOrgFile(heading, body, tag, orgfile, orgdir)
    local filename = orgfile or "capture.org"
    local dir = orgdir or "org"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local orgEntry = string.format(
        "* %s\n:PROPERTIES:\n:CREATED: [%s]\n:TAGS: %s\n:END:\n\n%s\n\n",
        heading, timestamp, tag, body
    )
    local orgFilePath = os.getenv("HOME") .. "/" .. dir .. "/" .. filename
    local file = io.open(orgFilePath, "a")
    if file then
        file:write(orgEntry)
        file:close()
        hs.alert.show("Captured to " .. filename)
    else
        hs.alert.show("ERROR: cannot open " .. filename)
    end
end

function captureTextToOrg(orgfile, orgdir)
    hs.eventtap.keyStroke({ "cmd" }, "c", 0)
    hs.timer.doAfter(0.15, function()
        local text = hs.pasteboard.getContents()
        if not text or text == "" then
            hs.alert.show("No text selected.")
            return
        end
        local lines = {}
        for line in text:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        local heading = string.sub(lines[1] or "Clipboard Capture", 1, 100)
        local tag = ":clipboard_capture:"
        appendEntryToOrgFile(heading, text, tag, orgfile, orgdir)
    end)
end

function captureQuickNote(orgfile, orgdir)
    local button, text = hs.dialog.textPrompt("Quick Win", "What did you achieve?")
    if button == "OK" and text and text ~= "" then
        local heading = text
        local tag = ":quick_win:"
        local body = ""
        appendEntryToOrgFile(heading, body, tag, orgfile, orgdir)
    end
end
hs.hotkey.bind({ "ctrl", "cmd" }, "9", captureTextToOrg)
hs.hotkey.bind({ "option", "cmd" }, "`", captureQuickNote)