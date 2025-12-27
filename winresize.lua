-- winresize.lua
-- resize the active window
-- 
hs.hotkey.bind({"cmd", "option"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.w = f.w - 23 -- Grow width by 50px
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "option"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.w = f.w + 23 -- Grow width by 50px
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "option"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.h = f.h - 23 -- Grow height by 50px
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "option"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.h = f.h + 23 -- Grow height by 50px
  win:setFrame(f)
end)
