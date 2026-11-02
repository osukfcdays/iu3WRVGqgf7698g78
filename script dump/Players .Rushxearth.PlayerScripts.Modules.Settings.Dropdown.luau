local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local DropdownSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local SettingSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SettingSlot"))
local t = setmetatable({}, SettingSlot_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] SettingSlot_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SettingSlot_m.new(...), t)
    t_1.DropdownContainer = t_1.ControlsSettingFrame:WaitForChild("Container")
    t_1.DropdownButton = t_1.DropdownContainer:WaitForChild("Button")
    t_1.DropdownText = t_1.DropdownButton:WaitForChild("Title")
    t_1._dropdown_slot = nil
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 31
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)
    --  [2] SettingSlot_m (copy)

    if arg1._dropdown_slot then
        arg1._dropdown_slot:Destroy()
    end

    WeaponStatusHandler_m:ClearStatusElements(arg1.DropdownText)
    SettingSlot_m.Destroy(arg1)
end

function t._Update(arg2) -- line: 45
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)
    --  [2] ItemLibrary_m (copy)

    arg2.DropdownText.Text = arg2.Value
    arg2.DropdownText.Position = UDim2.new(0.05, 0, 0.5, 0)
    WeaponStatusHandler_m:ClearStatusElements(arg2.DropdownText)
    local v6 = ItemLibrary_m.Items[arg2.Value]
    local v7 = WeaponStatusHandler_m
    local DropdownText_1 = arg2.DropdownText

    if v6 then
        v6 = ItemLibrary_m.Items[arg2.Value].Status
    end

    v7:ApplyItemStatusToText(DropdownText_1, v6)
end

function t._Init(arg3) -- line: 52
    -- upvalues:
    --  [1] DropdownSlot_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg3.Changed:Connect(function() -- line: 53
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_Update()
    end)
    arg3.DropdownButton.MouseButton1Click:Connect(function() -- line: 57
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] DropdownSlot_m (ref)

        arg3.DropdownButton.Visible = false

        if arg3._dropdown_slot then
            arg3._dropdown_slot:Cancel()
            arg3._dropdown_slot = nil
        end

        arg3._dropdown_slot = DropdownSlot_m.new(arg3.DropdownContainer, arg3.SettingsInfo.Options)
        arg3._dropdown_slot.Selected:Connect(function(mouse: Instance) -- line: 67
            -- upvalues:
            --  [1] arg3 (ref)

            arg3.DropdownButton.Visible = true

            if mouse then
                arg3:InputValue(mouse)
            end

            arg3._dropdown_slot = nil
        end)
    end)
    arg3:_Update()
    ButtonEffect_m:Add(arg3.DropdownButton, nil, { ReleaseRatio = 1.025, HoverRatio = 1.025 })
end

return t
