
local lstg_debug = require("lib.Ldebug")
local imgui_exist, imgui = pcall(require, "imgui")

local ImGui = imgui.ImGui
local ImVec2 = imgui.ImVec2
local ImKey = imgui.ImGuiKey
local ImWindowFlags = imgui.ImGuiWindowFlags
local ImInputTextFlags = imgui.ImGuiInputTextFlags
local ImTextBuffer = imgui.ImGuiTextBuffer
local ImStyleVar = imgui.ImGuiStyleVar

local ImBack = imgui.backend

-- update the logging function in order to hook the console into it

local oldLog = lstg.Log
local logs = {}
local levels = {'[D] ', '[I] ', '[W] ', '[E] ', '[F] '}

function lstg.Log(level, text)
    oldLog(level, text)

    logs[#logs+1] = levels[level] .. text
end

local log = lstg.Log

-- i saw lstg's print implementation and i hate it.
function print(...)
    local s = tostring(select(1, ...))
    for i = 2, select('#', ...) do
        s = s .. '\t' .. tostring(select(i, ...))
    end
    log(2, s)
end

-- local oldPrint = print


lstg.Print = print

local inputbuf = ImTextBuffer()
inputbuf:clear()
inputbuf:reserve(256)
inputbuf:append('\0')

local function xpcall_handler(err)
    return debug.traceback(err)
end

local enable = false
---@class lstg.debug.ConsoleView : lstg.debug.View
local ConsoleView = {}

function ConsoleView:getWindowName() return "Lua Console" end
function ConsoleView:getMenuItemName() return "Console" end
function ConsoleView:getMenuGroupName() return "Tool" end
function ConsoleView:getEnable() return enable end
---@param v boolean
function ConsoleView:setEnable(v) enable = v end
function ConsoleView:update() end
function ConsoleView:layout()
    ImGui.Text('enter lua code, prefix with "=" to return its value')

    local footer_h = ImGui.GetStyle().ItemSpacing.y + ImGui.GetFrameHeightWithSpacing()
    if ImGui.BeginChild('ScrollRegion', ImVec2(0, -footer_h), 0, ImWindowFlags.HorizontalScrollbar) then
        ImGui.PushStyleVar(ImStyleVar.ItemSpacing, ImVec2(4, 1))
        for i = 1, #logs do
            ImGui.TextUnformatted(logs[i])
        end
        ImGui.PopStyleVar()
    end
    ImGui.EndChild()

    ImGui.Separator()

    local input_text_flags = ImInputTextFlags.EnterReturnsTrue

    local reclaim_focus = false
    if ImGui.InputText('Input', inputbuf, 256, input_text_flags) then
        ---@type string
        local s = inputbuf:c_str()
        local r = s:sub(1, 1) == '='
        if r then
            s = 'return ' .. s:sub(2)
        end
        if #s > 0 then
            logs[#logs+1] = '> ' .. s

            local f, err = loadstring(s)
            if f == nil then
                logs[#logs+1] = err
                return
            end
            local success, result = xpcall(f, xpcall_handler)
            if not success then
                logs[#logs+1] = result
                return
            end
            if r then
                logs[#logs+1] = '= ' .. tostring(result)
            else
                logs[#logs+1] = '  success'
            end
            inputbuf:clear()
            inputbuf:reserve(256)
            inputbuf:append('\0')
            reclaim_focus = true
        end
    end

    ImGui.SetItemDefaultFocus()
    if reclaim_focus then
        ImGui.SetKeyboardFocusHere(-1)
    end
end

lstg_debug.addView("lstg.debug.ConsoleView", ConsoleView)
