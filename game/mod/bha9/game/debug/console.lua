local M = Class()
local console = M
local left = false
local left_pre = false
local left_press = false
local right = false
local right_pre = false
local right_press = false
local enter = false 
local enter_press = false
local enter_pre = false

function console:init()
    lstg.Window.clearTextInput()
    lstg.Window.setTextInputEnable(true)
    self.layer = 100000
    self.str = ""
    self.dying = false
end

function console:frame()
end

function console:render()
    if self.dying then
        return
    end
    SetSuperPause(1)
    -- update key states
    left_pre = left
    left = KEY.GetKeyState(KEY.Left)
    left_press = left and not left_pre
    right_pre = right
    right = KEY.GetKeyState(KEY.Right)
    right_press = right and not right_pre
    enter_pre = enter
    enter = KEY.GetKeyState(KEY.Enter)
    enter_press = enter and not enter_pre

    -- move the input cursor
    local move = 0

    if left_press then
        move = move - 1
    end
    if right_press then
        move = move + 1
    end

    -- clamp input cursor between 0 and the total text length
    local pos = math.min(math.max(lstg.Window.getTextCursorPos() + move, 0), lstg.Window.getTextInputLength())

    lstg.Window.setTextCursorPos(pos)
    if enter_press then
        lstg.Window.clearTextInput()
        local status, error = pcall(loadstring(self.str))
        print("Status = " .. tostring(status))
        print("Return = " .. tostring(error))
        Del(self)
        SetSuperPause(0)
        self.dying = true
    end
    self.str = lstg.Window.getTextInput()
    
    SetImageState("debug_white", "mul+alpha", Color(255,0,0,0))
    local prev_view_mode = lstg.viewmode
    SetViewMode("ui")
    SetFontState("menu","mul+alpha",Color(255,255,255,255))
    RenderRect("debug_white",0,screen.width,0,lstg.world.scrb)
    RenderText("menu",self.str,0,0,0.5,"bottom","left")
    SetViewMode(prev_view_mode)
end

function console:del()
    lstg.Window.setTextInputEnable(false)
    lstg.Window.clearTextInput()
end


return M