local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local SpeedLines_m = require(script:WaitForChild("SpeedLines"))
local Mouse_m = require(script:WaitForChild("Mouse"))
local Other_m = require(script:WaitForChild("Other"))
local ItemInterface = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ItemInterface")
local t = {}
t.__index = t

function t.new(arg1) -- line: 25
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] ItemInterface (copy)
    --  [4] SpeedLines_m (copy)
    --  [5] Mouse_m (copy)
    --  [6] Other_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.ActiveChanged = Signal_m.new()
    t_1.ClientItem = arg1
    t_1.Frame = ItemInterface:Clone()
    t_1.SpeedLines = SpeedLines_m.new(t_1)
    t_1.Mouse = Mouse_m.new(t_1)
    t_1.Other = Other_m.new(t_1)
    t_1._destroyed = false
    t_1._connections = {}
    t_1._fighter_interface_connections = {}
    t_1._is_equipped = false
    t_1._original_sizings = {}
    t_1._current_duel_subject = nil
    t_1._current_duel_subject_connections = {}
    t_1:_Init()

    return t_1
end

function t.SetScopeActive(arg2, ...) -- line: 53
    return arg2.Mouse.Scope:SetActive(...)
end

function t.IsScopeActive(arg3, ...) -- line: 57
    return arg3.Mouse.Scope:IsActive(...)
end

function t.PlaySpeedLines(arg4, ...) -- line: 61
    return arg4.SpeedLines:Create(...)
end

function t.DamageEffect(arg5, ...) -- line: 65
    return arg5.Mouse.MouseCrosshair:DamageEffect(...)
end

function t.IsActive(arg6) -- line: 69
    local v4 = arg6.ClientItem.ClientFighter.FighterInterface

    if v4 then
        v4 = arg6.ClientItem.ClientFighter.FighterInterface:IsActive()
    end

    return v4
end

function t.CreateSound(arg7, ...) -- line: 73
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg7:IsActive() then
        return
    end

    return Utility_m:CreateSound(...)
end

function t.Equip(arg8) -- line: 81
    arg8._is_equipped = true
end

function t.Unequip(arg9) -- line: 85
    arg9._is_equipped = false
    arg9.Mouse.Scope:SetActive(false)
end

function t.Update(arg10, arg11, arg12, arg13) -- line: 90
    if not arg12.IsSpectating or arg12.IsHiddenByCutscene or not arg13.IsActive then
        arg10.Frame.Visible = false

        return
    end

    arg10.Other:Update(arg11, arg12, arg13)
    arg10.Mouse:Update(arg11, arg12, arg13)
    arg10.SpeedLines:Update(arg11, arg12, arg13)
    arg10.Frame.Visible = true
end

function t.Destroy(arg14) -- line: 102
    arg14._destroyed = true

    for _, val in pairs(arg14._connections) do
        val:Disconnect()
    end

    for _, val_1 in pairs(arg14._fighter_interface_connections) do
        val_1:Disconnect()
    end

    arg14._connections = {}
    arg14._fighter_interface_connections = {}
    arg14:_UpdateCurrentDuelSubject()
    arg14.ActiveChanged:Destroy()
    arg14.SpeedLines:Destroy()
    arg14.Mouse:Destroy()
    arg14.Other:Destroy()
    arg14.Frame:Destroy()
end

function t._UpdateSizing(arg15) -- line: 130
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local v5 = UILibrary_m.MainGui.AbsoluteSize.X / arg15.Frame.AbsoluteSize.X
    local v6 = UILibrary_m.MainGui.AbsoluteSize.Y / arg15.Frame.AbsoluteSize.Y

    for _, val_2 in pairs({ "AimingVignette", "SpeedLinesThick", "SpeedLinesThin" }) do
        local v7 = arg15.Frame[val_2]
        local v8 = arg15._original_sizings[v7]
        local OriginalSizings = arg15._original_sizings

        if not v8 then
            v8 = { Position = v7.Position, Size = v7.Size }
        end

        OriginalSizings[v7] = v8
        local udim2 = UDim2.new(
            arg15._original_sizings[v7].Size.X.Scale * v5,
            arg15._original_sizings[v7].Size.X.Offset * v5,
            arg15._original_sizings[v7].Size.Y.Scale * v6,
            arg15._original_sizings[v7].Size.Y.Offset * v6
        )
        v7.Size = udim2
        local udim2_1 = UDim2.new(
            0.5 + (arg15._original_sizings[v7].Position.X.Scale - 0.5) * v5,
            0,
            0.5 + (arg15._original_sizings[v7].Position.Y.Scale - 0.5) * v6,
            0
        )
        v7.Position = udim2_1
    end
end

function t._UpdateVisibility(arg16) -- line: 158
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] GuiService (copy)
    --  [3] SpectateController_m (copy)

    local v9 = not Pages_m.PageSystem.CurrentPage

    if v9 then
        v9 = not GuiService.MenuIsOpen

        if v9 then
            v9 = not SpectateController_m:IsSubjectEmoting()

            if v9 then
                v9 = not arg16._current_duel_subject or not arg16._current_duel_subject.DuelInterface or not arg16._current_duel_subject.DuelInterface.Scoreboard:IsOpen()
            end
        end
    end

    arg16.Mouse:SetVisible(v9)
end

function t._UpdateCurrentDuelSubject(arg17) -- line: 167
    -- upvalues:
    --  [1] SpectateController_m (copy)

    for _, val_3 in pairs(arg17._current_duel_subject_connections) do
        val_3:Disconnect()
    end

    arg17._current_duel_subject_connections = {}

    if arg17._destroyed then
        return
    end

    arg17._current_duel_subject = SpectateController_m.CurrentDuelSubject
    arg17:_UpdateVisibility()

    if not arg17._current_duel_subject then
        return
    end

    table.insert(arg17._current_duel_subject_connections, arg17._current_duel_subject.DuelInterface.Scoreboard.VisibilityChanged:Connect(
        function() -- line: 185
            -- upvalues:
            --  [1] arg17 (copy)

            arg17:_UpdateVisibility()
        end
    ))
end

function t._FighterInterfaceRemoved(arg18) -- line: 190
    for _, val_4 in pairs(arg18._fighter_interface_connections) do
        val_4:Disconnect()
    end

    arg18._fighter_interface_connections = {}
end

function t._FighterInterfaceAdded(arg19, arg20) -- line: 198
    arg19:_FighterInterfaceRemoved()
    table.insert(arg19._fighter_interface_connections, arg20.ActiveChanged:Connect(function() -- line: 201
        -- upvalues:
        --  [1] arg19 (copy)

        arg19.ActiveChanged:Fire()
    end))
    arg19.ActiveChanged:Fire()
end

function t._Setup(arg21) -- line: 208
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg21.Frame.Visible = false
    arg21.Frame.Name = arg21.ClientItem.ClientFighter.Player.Name .. " - " .. arg21.ClientItem.Name
    arg21.Frame.Parent = UILibrary_m:GetTo("MainFrame", "ItemInterfaces")
end

function t._Init(arg22) -- line: 214
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] CameraController_m (copy)
    --  [3] Pages_m (copy)
    --  [4] GuiService (copy)
    --  [5] SpectateController_m (copy)
    --  [6] SettingsLibrary_m (copy)
    --  [7] PlayerDataController_m (copy)

    arg22.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 215
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateSizing()
    end)
    table.insert(arg22._connections, arg22.ClientItem.ClientFighter.InterfaceAdded:Connect(function(
        arg23
    ) -- line: 219
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_FighterInterfaceAdded(arg23)
    end))
    table.insert(arg22._connections, arg22.ClientItem.ClientFighter.InterfaceRemoved:Connect(function() -- line: 223
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_FighterInterfaceRemoved()
    end))
    local Connections_2 = arg22._connections
    local MouseIconEnabled = UserInputService:GetPropertyChangedSignal("MouseIconEnabled")
    table.insert(Connections_2, MouseIconEnabled:Connect(function() -- line: 227
        -- upvalues:
        --  [1] arg22 (copy)

        arg22.Mouse:Refresh()
    end))
    local Connections_3 = arg22._connections
    local MouseBehavior = UserInputService:GetPropertyChangedSignal("MouseBehavior")
    table.insert(Connections_3, MouseBehavior:Connect(function() -- line: 231
        -- upvalues:
        --  [1] arg22 (copy)

        arg22.Mouse:Refresh()
    end))
    table.insert(arg22._connections, CameraController_m.POVStateChanged:Connect(function() -- line: 235
        -- upvalues:
        --  [1] arg22 (copy)

        arg22.Mouse:Refresh()
    end))
    table.insert(arg22._connections, Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 239
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateVisibility()
    end))
    local Connections_6 = arg22._connections
    local MenuIsOpen = GuiService:GetPropertyChangedSignal("MenuIsOpen")
    table.insert(Connections_6, MenuIsOpen:Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateVisibility()
    end))
    table.insert(arg22._connections, SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateCurrentDuelSubject()
    end))
    table.insert(arg22._connections, SpectateController_m.SubjectEmoteStatusChanged:Connect(function() -- line: 251
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateVisibility()
    end))

    if arg22.ClientItem.ClientFighter.IsLocalPlayer then
        local _ = SpectateController_m.SubjectEmoteStatusChanged:Connect(function() -- line: 251
            -- upvalues:
            --  [1] arg22 (copy)

            arg22:_UpdateVisibility()
        end)

        for key_5, val_5 in pairs(SettingsLibrary_m.Info) do
            if val_5.Section == "Crosshair" then
                table.insert(arg22._connections, PlayerDataController_m:GetSettingChangedSignal(
                    key_5
                ):Connect(function() -- line: 258
                    -- upvalues:
                    --  [1] arg22 (copy)

                    arg22.Mouse.MouseCrosshair:Refresh()
                end))
            end
        end
    else
        table.insert(arg22._connections, arg22.ClientItem.ClientFighter:GetDataChangedSignal(
            "CompressedCrosshairAppearance"
        ):Connect(function() -- line: 264
            -- upvalues:
            --  [1] arg22 (copy)

            arg22.Mouse.MouseCrosshair:Refresh()
        end))
    end

    if arg22.ClientItem.ClientFighter.FighterInterface then
        task.defer(
            arg22._FighterInterfaceAdded,
            arg22,
            arg22.ClientItem.ClientFighter.FighterInterface
        )
    end

    arg22:_Setup()
    arg22:_UpdateSizing()
    arg22:_UpdateVisibility()
    arg22.Mouse.MouseCrosshair:Refresh()
    arg22.Mouse:Refresh()
    arg22:Unequip()
    task.defer(arg22._UpdateCurrentDuelSubject, arg22)
end

return t
