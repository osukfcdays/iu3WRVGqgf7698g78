local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local EquipmentMetricSeasonRewardsSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentMetricSeasonRewardsSlot"
)
local EquipmentMetricCard = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentMetricCard"
)
local EquipmentMetricSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentMetricSlot"
)
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] EquipmentMetricCard (copy)

    local t_1 = setmetatable({}, t)
    t_1.Clicked = Signal_m.new()
    t_1.Opened = Signal_m.new()
    t_1.Frame = EquipmentMetricCard:Clone()
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.HeaderFrame = t_1.Container:WaitForChild("Header")
    t_1.CloseButton = t_1.HeaderFrame:WaitForChild("Button")
    t_1.Title = t_1.HeaderFrame:WaitForChild("Title")
    t_1.Icon = t_1.HeaderFrame:WaitForChild("Icon")
    t_1._title = arg1
    t_1._icon = arg2
    t_1._elements = {}
    t_1._set_opened_hash = 0
    t_1._reward_slots = {}
    t_1:_Init()

    return t_1
end

function t.GetScrollToElement(arg3) -- line: 45
    return arg3.Container
end

function t.SetParent(arg4, arg5) -- line: 49
    arg4.Frame.Parent = arg5
end

function t.SetOpened(arg6, arg7) -- line: 53
    -- upvalues:
    --  [1] Players (copy)

    arg6._set_opened_hash += 1
    local SetOpenedHash = arg6._set_opened_hash
    arg6.Container.Visible = arg7

    if arg7 then
        arg6.Frame.Visible = true
        arg6.Opened:Fire()

        return
    end

    if arg6.Frame:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
        arg6.Frame:TweenSize(
            UDim2.new(1, 0, 0, 0),
            "Out",
            "Quint",
            0.25,
            true,
            function() -- line: 63
                -- upvalues:
                --  [1] SetOpenedHash (copy)
                --  [2] arg6 (copy)

                if SetOpenedHash ~= arg6._set_opened_hash then
                    return
                end

                arg6.Frame.Visible = false
            end
        )

        return
    end

    arg6.Frame.Visible = false
end

function t.Add(arg8, arg9, arg10) -- line: 75
    -- upvalues:
    --  [1] EquipmentMetricSlot (copy)
    --  [2] UILibrary_m (copy)

    local v1 = EquipmentMetricSlot:Clone()
    v1.TitleContainer.Title.Text = arg9
    v1.Value.RichText = string.find(arg10, "<")
    v1.Value.Text = arg10
    v1.LayoutOrder = #arg8._elements
    v1.Parent = arg8.Container
    table.insert(arg8._elements, v1)
    UILibrary_m:ScrollingTextLabel(v1.TitleContainer, v1.TitleContainer.Title, v1.Value)
end

function t.AddSeasonRewards(arg11, arg12) -- line: 86
    -- upvalues:
    --  [1] EquipmentMetricSeasonRewardsSlot (copy)
    --  [2] RewardSlot_m (copy)

    local v2 = EquipmentMetricSeasonRewardsSlot:Clone()
    v2.LayoutOrder = #arg11._elements

    for _, val in pairs(arg12) do
        local v3 = RewardSlot_m.new(val)
        v3:SetParent(v2.RewardContainer)
        table.insert(arg11._reward_slots, v3)
    end

    v2.Parent = arg11.Container
    table.insert(arg11._elements, v2)
end

function t.Clear(arg13) -- line: 100
    for _, val_1 in pairs(arg13._elements) do
        val_1:Destroy()
    end

    arg13._elements = {}
end

function t.Destroy(arg14) -- line: 108
    for _, val_2 in pairs(arg14._reward_slots) do
        val_2:Destroy()
    end

    arg14.Clicked:Destroy()
    arg14.Opened:Destroy()
    arg14.Frame:Destroy()
end

function t._Update(arg15) -- line: 122
    if not arg15.Container.Visible then
        return
    end

    arg15.Frame.Size = UDim2.new(
        1,
        0,
        0,
        arg15.Layout.AbsoluteContentSize.Y + arg15.Frame.AbsoluteSize.X * 0.05
    )
end

function t._Setup(arg16) -- line: 130
    arg16.Title.Text = arg16._title or ""
    arg16.Icon.Image = arg16._icon or ""
    arg16.Frame.Visible = false
end

function t._Init(arg17) -- line: 136
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg17.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 137
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_Update()
    end)
    arg17.Container:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 141
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_Update()
    end)
    arg17.CloseButton.MouseButton1Click:Connect(function() -- line: 145
        -- upvalues:
        --  [1] arg17 (copy)

        arg17.Clicked:Fire()
    end)
    arg17:_Setup()
    arg17:_Update()
    local t_2 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg17.CloseButton, nil, t_2)
end

return t
