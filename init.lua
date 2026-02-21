dofile("capture.lua")
dofile("appdial.lua")
dofile("utils.lua")
dofile("winresize.lua")

local mainModal = require("modals")
hs.hotkey.bind({ "cmd", "option", "ctrl" }, "§", function()
    mainModal:exit()
end)

local flstudio = require("flstudio")
flstudio.start()
