
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

local enable = false
---@class lstg.debug.CameraSetterView : lstg.debug.View
local CameraSetterView = {}

function CameraSetterView:getWindowName() return "Camera Setter" end
function CameraSetterView:getMenuItemName() return "Camera" end
function CameraSetterView:getMenuGroupName() return "Tool" end
function CameraSetterView:getEnable() return enable end
---@param v boolean
function CameraSetterView:setEnable(v) enable = v end
function CameraSetterView:update() end
function CameraSetterView:layout()
    local _

    ImGui.DragFloat3('eye', lstg.view3d.eye, 0.1)
    ImGui.DragFloat3('at', lstg.view3d.at, 0.1)
    ImGui.DragFloat3('up', lstg.view3d.up, 0.1)

    ImGui.DragFloat2('z', lstg.view3d.z, 0.1)
    ImGui.DragFloat2('fog', lstg.view3d.fog, 0.1)
    lstg.view3d.fog[3]:ARGB(unpack(select(2, ImGui.DragInt4('fog color', {lstg.view3d.fog[3]:ARGB()}, 1, 0, 255))))

    _, lstg.view3d.fovy = ImGui.DragFloat('fovy', lstg.view3d.fovy, 0.05)
end

lstg_debug.addView("lstg.debug.CameraSetterView", CameraSetterView)
