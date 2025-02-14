local imgui_exist, imgui = pcall(require, "imgui")

---@class HolosLib.Debug.StageDebugView : lstg.debug.View
local M = {}

function M:getWindowName() return "Nicki Minaj" end
function M:getMenuItemName() return "View" end
function M:getMenuGroupName() return "Housangela" end
function M:getEnable() return self.enable end
---@param v boolean
function M:setEnable(v) self.enable = v end

function M:initialize(view_stack_manager)
end

function M:update()
end

function M:layout()
    local ImGui = imgui.ImGui
    if ImGui.Button("press the yass button") then
        print("yass")
    end
end

local Ldebug = require("lib.Ldebug")
Ldebug.addView("Hrlp", M)

return M