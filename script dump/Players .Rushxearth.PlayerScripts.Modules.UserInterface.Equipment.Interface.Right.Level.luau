local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local LootLibrary_m = require(ReplicatedStorage.Modules.LootLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Right = arg1
    t_1.Frame = t_1.Right.Container:WaitForChild("Level")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.BarFrame = t_1.Container:WaitForChild("Bar")
    t_1.BarFrameGoal = t_1.BarFrame:WaitForChild("Goal")
    t_1.BarFrameLevel = t_1.BarFrame:WaitForChild("Level")
    t_1.BarFrameProgress = t_1.BarFrame:WaitForChild("Progress")
    t_1.BarFrameContainer = t_1.BarFrame:WaitForChild("Container")
    t_1.BarFrameContainerBar = t_1.BarFrameContainer:WaitForChild("Bar")
    t_1.ComponentsFrame = t_1.Container:WaitForChild("Components")
    t_1.ComponentsLayout = t_1.ComponentsFrame:WaitForChild("Layout")
    t_1.NextRewardFrame = t_1.ComponentsFrame:WaitForChild("NextReward")
    t_1.NextRewardTitle = t_1.NextRewardFrame:WaitForChild("Title")
    t_1.NextRewardContainer = t_1.NextRewardFrame:WaitForChild("Container")
    t_1.LevelUpFrame = t_1.ComponentsFrame:WaitForChild("LevelUp")
    t_1.LevelUpDescription = t_1.LevelUpFrame:WaitForChild("Description")
    t_1.LevelUpButton = t_1.LevelUpFrame:WaitForChild("Button")
    t_1.LevelUpButtonPrice = t_1.LevelUpButton:WaitForChild("Price")
    t_1._cleanup = {}
    t_1._double_clicked = false
    t_1:_Init()

    return t_1
end

function t.OnStateChanged(arg2) -- line: 49
    arg2:_SetDoubleClicked(false)
    arg2:_UpdateInformation()
end

function t._SetDoubleClicked(arg3, arg4) -- line: 58
    arg3._double_clicked = arg4
    arg3.LevelUpDescription.Text = if not arg4 then "Level up now!" else "Are you sure?"
end

function t._GetInformation(arg5) -- line: 63
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] LootLibrary_m (copy)

    if arg5.Right.Interface.Equipment:IsCareerPageOpen() then
        local v2 = PlayerDataController_m:Get("Level")

        return v2, PlayerDataController_m:Get("XP"), LootLibrary_m:GetCareerLevelsRewardData(), math.ceil(
            (v2 + 1) / LootLibrary_m:GetCareerLevelsRewardMilestone()
        ) * LootLibrary_m:GetCareerLevelsRewardMilestone()
    end

    local v7 = PlayerDataController_m:GetWeaponData(
        (arg5.Right.Interface.Equipment:GetSelectedWeapon())
    )

    if not v7 then
        return
    end

    local Level = v7.Level
    local XP = v7.XP
    local v8, v9 = LootLibrary_m:GetNextWeaponLevelReward(Level, v7.Name)

    return Level, XP, v8, v9
end

function t._UpdateInformation(arg6) -- line: 87
    -- upvalues:
    --  [1] LootLibrary_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] ComplianceController_m (copy)
    --  [4] Utility_m (copy)
    --  [5] RewardSlot_m (copy)

    for _, val in pairs(arg6._cleanup) do
        val:Destroy()
    end

    arg6._cleanup = {}
    local v10, v11, v12, v13 = arg6:_GetInformation()
    local v14 = if v10 == nil then false else true
    arg6.Frame.Visible = v14

    if not v14 then
        return
    end

    v14 = arg6.Right.Interface.Equipment:IsCareerPageOpen()
    local v15 = LootLibrary_m:GetXPRequiredToLevelUp(v10)
    local v16 = v12

    if v16 then
        v16 = v13

        if v16 then
            v16 = false

            if v10 == v13 - 1 then
                v16 = CosmeticLibrary_m.Rewards[v12.Name]

                if v16 then
                    v16 = if CosmeticLibrary_m.Rewards[v12.Name].Type == "Lootbox" then ComplianceController_m:ArePaidRandomItemsRestricted() else false
                end
            end
        end
    end

    arg6.BarFrameGoal.Text = if v11 >= v15 then "" else Utility_m:PrettyNumber(v15)
    arg6.BarFrameProgress.Text = if v11 >= v15 then "" else Utility_m:PrettyNumber(v11)
    arg6.BarFrameLevel.Text = if v11 >= v15 then "MAX" else Utility_m:PrettyNumber(v10)
    arg6.BarFrameContainer.Size = UDim2.new(math.clamp(v11 / v15, 0, 1), 0, 1, 0)
    local v17 = not v14
    local LevelUpFrame = arg6.LevelUpFrame

    if v17 then
        v17 = v11 < v15 and not v16
    end

    LevelUpFrame.Visible = v17
    arg6.LevelUpButtonPrice.Text = LootLibrary_m:GetCostToLevelUp(v10, v11)
    arg6.NextRewardFrame.Visible = if v12 == nil then false else true
    arg6.NextRewardTitle.Text = if not v13 then "" else "Reward at Level " .. Utility_m:PrettyNumber(
        v13
    )

    if v12 then
        v16 = RewardSlot_m.new(v12)
        v16:SetParent(arg6.NextRewardContainer)
        table.insert(arg6._cleanup, v16)
    end
end

function t._Update(arg7) -- line: 124
    local v18 = if not (arg7.ComponentsLayout.AbsoluteContentSize.Y > 0) then 1 else 1.25
    arg7.Frame.Size = UDim2.new(
        1,
        0,
        0,
        (arg7.ComponentsFrame.AbsolutePosition.Y - arg7.Frame.AbsolutePosition.Y) * v18 + arg7.ComponentsLayout.AbsoluteContentSize.Y
    )
end

function t._Init(arg8) -- line: 130
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg8.ComponentsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 131
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Update()
    end)
    arg8.LevelUpButton.MouseButton1Click:Connect(function() -- line: 135
        -- upvalues:
        --  [1] arg8 (copy)

        if not arg8._double_clicked then
            arg8:_SetDoubleClicked(true)

            return
        end

        arg8.Right.Interface.Equipment:LevelUpWeapon()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 144
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("Level"):Connect(function() -- line: 148
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateInformation()
    end)
    arg8:_Update()
    local t_2 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg8.LevelUpButton, nil, t_2)
end

return t
