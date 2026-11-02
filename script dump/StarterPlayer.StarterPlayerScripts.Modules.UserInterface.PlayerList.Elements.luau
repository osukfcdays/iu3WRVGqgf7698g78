local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SettingsController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local PlayerListSlot_m = require(script:WaitForChild("PlayerListSlot"))
local Options = SettingsLibrary_m.Info["PlayerList Leaderstat"].Options
local t = {
    "rbxassetid://17094014569",
    "rbxassetid://112281518716191",
    "rbxassetid://117835427046796"
}
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Signal_m (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.PlayerListSlotAdded = Signal_m.new()
    t_2.PlayerListSlotRemoved = Signal_m.new()
    t_2.PlayerList = arg1
    t_2.Frame = t_2.PlayerList.Container:WaitForChild("Elements")
    t_2.Container = t_2.Frame:WaitForChild("Container")
    t_2.Layout = t_2.Container:WaitForChild("Layout")
    t_2.TopFrame = t_2.Container:WaitForChild("Top")
    t_2.TopCloseButton = t_2.TopFrame:WaitForChild("Close")
    t_2.TopLeaderstatFrame = t_2.TopFrame:WaitForChild("Leaderstat")
    t_2.TopLeaderstatIcon = t_2.TopLeaderstatFrame:WaitForChild("Icon")
    t_2.TopLeaderstatButton = t_2.TopLeaderstatFrame:WaitForChild("Button")
    t_2.MiddleFrame = t_2.Container:WaitForChild("Middle")
    t_2.MiddleList = t_2.MiddleFrame:WaitForChild("List")
    t_2.MiddleContainer = t_2.MiddleList:WaitForChild("Container")
    t_2.MiddleLayout = t_2.MiddleContainer:WaitForChild("Layout")
    t_2.BottomFrame = t_2.Container:WaitForChild("Bottom")
    t_2.PlayerListSlots = {}
    t_2._leaderstat_name = nil
    t_2:_Init()

    return t_2
end

function t_1.GetPlayerListSlot(arg2, arg3) -- line: 53
    for key, val in pairs(arg2.PlayerListSlots) do
        if key.Player == arg3 then
            return val
        end
    end
end

function t_1.SetLeaderstat(arg4, arg5) -- line: 61
    -- upvalues:
    --  [1] t (copy)
    --  [2] Options (copy)

    if arg5 == arg4._leaderstat_name then
        return
    end

    arg4._leaderstat_name = arg5
    arg4.TopLeaderstatIcon.Image = t[table.find(Options, arg4._leaderstat_name)] or ""

    for _, val_1 in pairs(arg4.PlayerListSlots) do
        val_1:SetLeaderstat(arg4._leaderstat_name)
    end
end

function t_1.OnOpened(arg6) -- line: 74
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] FighterController_m (copy)
    --  [3] Players (copy)

    arg6.PlayerList:AddOpenedConnection(arg6.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 75
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:_UpdateVisuals()
        end
    ))
    arg6.PlayerList:AddOpenedConnection(arg6.MiddleLayout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(function() -- line: 79
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateVisuals()
    end))
    arg6.PlayerList:AddOpenedConnection(arg6.PlayerList.Frame:GetPropertyChangedSignal(
        "AbsoluteSize"
    ):Connect(function() -- line: 83
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateVisuals()
    end))
    arg6.PlayerList:AddOpenedConnection(arg6.BottomFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(
        function() -- line: 87
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:_UpdateVisuals()
        end
    ))
    arg6.PlayerList:AddOpenedConnection(arg6.TopFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(
        function() -- line: 91
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:_UpdateVisuals()
        end
    ))
    arg6.PlayerList:AddOpenedConnection(PlayerDataController_m:GetSettingChangedSignal(
        "PlayerList Leaderstat"
    ):Connect(function() -- line: 95
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateLeaderstatFromSetting()
    end))
    arg6.PlayerList:AddOpenedConnection(FighterController_m.ObjectRemoved:Connect(function(arg7) -- line: 99
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_FighterRemoved(arg7)
    end))
    arg6.PlayerList:AddOpenedConnection(FighterController_m.ObjectAdded:Connect(function(arg8) -- line: 103
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_FighterAdded(arg8)
    end))
    arg6:_UpdateVisuals()
    arg6:_UpdateLeaderstatFromSetting()
    local _ = FighterController_m.ObjectAdded:Connect(function(arg8) -- line: 103
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_FighterAdded(arg8)
    end)

    for key_2, val_2 in pairs(arg6.PlayerListSlots) do
        if key_2.Player:IsDescendantOf(Players) then
            val_2:OnOpened()
        else
            task.spawn(arg6._FighterRemoved, arg6, key_2)
        end
    end

    for _, val_3 in pairs(FighterController_m.Objects) do
        if not arg6.PlayerListSlots[val_3] then
            task.spawn(arg6._FighterAdded, arg6, val_3)
        end
    end
end

function t_1._UpdateLeaderstatFromSetting(arg9) -- line: 131
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Options (copy)

    local v4 = PlayerDataController_m:GetSetting("PlayerList Leaderstat")
    arg9:SetLeaderstat(if not table.find(Options, v4) then Options[1] else v4)
end

function t_1._UpdateVisuals(arg10) -- line: 138
    arg10.MiddleList.CanvasSize = UDim2.new(0, 0, 0, arg10.MiddleLayout.AbsoluteContentSize.Y)
    arg10.MiddleFrame.Size = UDim2.new(
        1,
        0,
        0,
        (math.min(
            arg10.MiddleLayout.AbsoluteContentSize.Y,
            arg10.PlayerList.Frame.AbsoluteSize.Y - arg10.TopFrame.AbsoluteSize.Y - arg10.BottomFrame.AbsoluteSize.Y
        ))
    )
    arg10.Frame.Size = UDim2.new(1, 0, 0, arg10.Layout.AbsoluteContentSize.Y)
end

function t_1._FighterRemoved(arg11, arg12) -- line: 144
    local v6 = arg11.PlayerListSlots[arg12]

    if not v6 then
        return
    end

    v6:Destroy()
    arg11.PlayerListSlots[arg12] = nil
    arg11.PlayerListSlotRemoved:Fire(v6)
end

function t_1._FighterAdded(arg13, arg14) -- line: 156
    -- upvalues:
    --  [1] PlayerListSlot_m (copy)

    arg13:_FighterRemoved(arg14)

    if not arg14.Player then
        return
    end

    local v7 = PlayerListSlot_m.new(arg13, arg14)
    v7:SetLeaderstat(arg13._leaderstat_name)
    v7:SetParent(arg13.MiddleContainer)
    arg13.PlayerListSlots[arg14] = v7
    arg13.PlayerListSlotAdded:Fire(v7)
end

function t_1._Init(arg15) -- line: 170
    -- upvalues:
    --  [1] Options (copy)
    --  [2] SettingsController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg15.TopCloseButton.MouseButton1Click:Connect(function() -- line: 171
        -- upvalues:
        --  [1] arg15 (copy)

        arg15.PlayerList:SetClosedByInputs(true)
    end)
    arg15.TopLeaderstatButton.MouseButton1Click:Connect(function() -- line: 175
        -- upvalues:
        --  [1] Options (ref)
        --  [2] arg15 (copy)
        --  [3] SettingsController_m (ref)

        SettingsController_m:ChangeSetting(
            "PlayerList Leaderstat",
            Options[(table.find(Options, arg15._leaderstat_name) or 0) % #Options + 1]
        )
    end)
    ButtonEffect_m:Add(arg15.TopCloseButton, true)
    ButtonEffect_m:Add(arg15.TopLeaderstatButton, true)
end

return t_1
