local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local FighterKeybindSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "FighterKeybindSlot"
)
local t = {
    { "QuickUtility", "Quick Utility" },
    { "QuickMelee", "Quick Melee" },
    { "OpenPlayerList", "Scoreboard" },
    { "SwitchCameraPOV", "Camera" },
    { "UseEmote", "Emote" },
    { "LeaveDuel", "Leave Shooting Range" }
}
local t_7 = {}
t_7.__index = t_7

function t_7.new(arg1) -- line: 22
    -- upvalues:
    --  [1] t_7 (copy)

    local t_8 = setmetatable({}, t_7)
    t_8.FighterInterface = arg1
    t_8.KeybindGamepadEquipLastFrame = t_8.FighterInterface.Hotbar.Container:WaitForChild(
        "KeybindGamepadEquipLast"
    )
    t_8.KeybindGamepadEquipNextFrame = t_8.FighterInterface.Hotbar.Container:WaitForChild(
        "KeybindGamepadEquipNext"
    )
    t_8.Frame = t_8.FighterInterface.BottomRight.Container:WaitForChild("Keybinds")
    t_8.Layout = t_8.Frame:WaitForChild("Layout")
    t_8._destroyed = false
    t_8._connections = {}
    t_8._slots = {}
    t_8:_Init()

    return t_8
end

function t_7.Refresh(arg2) -- line: 44
    -- upvalues:
    --  [1] Players (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ControlsController_m (copy)
    --  [4] CameraController_m (copy)

    if arg2._destroyed then
        return
    end

    local EmoteController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.EmoteController)
    local v1 = false
    local Frame = arg2.Frame

    if PlayerDataController_m:GetSetting("Keybinds Interface") ~= "Disabled" then
        v1 = #arg2.FighterInterface.ClientFighter.Items > 0 and (ControlsController_m.CurrentControls == "MouseKeyboard" or ControlsController_m.CurrentControls == "Gamepad")
    end

    Frame.Visible = v1
    arg2._slots.QuickUtility.Visible = arg2:_IsQuickAttackKeybindVisible("Utility")
    arg2._slots.QuickMelee.Visible = arg2:_IsQuickAttackKeybindVisible("Melee")
    arg2._slots.OpenPlayerList.Visible = arg2.FighterInterface.ClientFighter:Get("IsInDuel")
    arg2._slots.SwitchCameraPOV.Visible = CameraController_m:HasThirdPersonAccess()
    arg2._slots.UseEmote.Visible = EmoteController_m:CanEmote()
    arg2._slots.LeaveDuel.Visible = arg2.FighterInterface.ClientFighter:Get("IsInShootingRange")
    arg2:_UpdateGamepad()
    arg2:_UpdateParent()
end

function t_7.Destroy(arg3) -- line: 64
    arg3._destroyed = true

    for _, val in pairs(arg3._connections) do
        val:Disconnect()
    end

    arg3._connections = {}
    arg3._slots = {}
end

function t_7._UpdateParent(arg4) -- line: 79
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    task.defer(pcall, function() -- line: 80
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] arg4 (copy)

        local v2 = if PlayerDataController_m:GetSetting("Keybinds Interface") ~= "Bottom Left" then false else true

        for _, val_1 in pairs(arg4._slots) do
            local Container = val_1.Container
            local v3 = v2 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
            Container.AnchorPoint = v3
            local Container_1 = val_1.Container
            v3 = v2 and UDim2.new(0, 0, 0.5, 0) or UDim2.new(1, 0, 0.5, 0)
            Container_1.Position = v3
            local Title = val_1.Container.Title
            v3 = v2 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
            Title.AnchorPoint = v3
            local Title_1 = val_1.Container.Title
            v3 = v2 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
            Title_1.Position = v3
            local Title_2 = val_1.Container.Title
            v3 = v2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
            Title_2.TextXAlignment = v3
        end

        local Layout = arg4.Layout
        Layout.HorizontalAlignment = v2 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
        local Frame_1 = arg4.Frame
        Frame_1.Parent = v2 and arg4.FighterInterface.BottomLeft.Container or arg4.FighterInterface.BottomRight.Container
    end)
end

function t_7._IsQuickAttackKeybindVisible(arg5, arg6) -- line: 96
    local v5 = arg5.FighterInterface.ClientFighter:GetQuickAttackIndex(arg6)
    local v6 = arg5.FighterInterface.ClientFighter.IsLocalPlayer

    if v6 then
        v6 = v5 <= #arg5.FighterInterface.ClientFighter.Items and arg5.FighterInterface.ClientFighter.EquippedItem ~= arg5.FighterInterface.ClientFighter.Items[v5]
    end

    return v6
end

function t_7._UpdateGamepad(arg7) -- line: 104
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local v7 = if ControlsController_m.CurrentControls ~= "Gamepad" then false else #arg7.FighterInterface.ClientFighter.Items > 1
    arg7.KeybindGamepadEquipLastFrame.Visible = v7
    arg7.KeybindGamepadEquipNextFrame.Visible = v7
end

function t_7._UpdateBackground(arg8) -- line: 111
    arg8.Frame.Size = UDim2.new(0, arg8.Layout.AbsoluteContentSize.X, 0.0934, 0)
end

function t_7._Setup(arg9) -- line: 115
    -- upvalues:
    --  [1] t (copy)
    --  [2] FighterKeybindSlot (copy)

    for key_2, val_2 in pairs(t) do
        local v8, Title_3 = table.unpack(val_2)
        local v10 = FighterKeybindSlot:Clone()
        v10.Container.Keybind:SetAttribute("InputName", v8)
        v10.Container.Title.Text = Title_3
        v10.LayoutOrder = -key_2
        v10.Parent = arg9.Frame
        arg9._slots[v8] = v10
        local Title_3 = v10.Container.Title
        Title_3:GetPropertyChangedSignal("TextBounds"):Connect(function() --[[ update ]] -- line: 128
            -- upvalues:
            --  [1] v10 (copy)
            --  [2] Title_3 (copy)

            v10.Size = UDim2.new(1.3, Title_3.TextBounds.X, 1, 0)
        end)
    end
end

function t_7._Init(arg10) -- line: 136
    arg10.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 137
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateBackground()
    end)
    arg10:_Setup()
    arg10:_UpdateGamepad()
    arg10:_UpdateBackground()
end

return t_7
