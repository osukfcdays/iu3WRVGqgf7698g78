local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local LootLibrary_m = require(ReplicatedStorage.Modules.LootLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local LootboxChanceSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "LootboxChanceSlot"
)
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1, arg2, arg3, ...) -- line: 20
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._root_name = arg1
    t_1._root_weapon = arg2 or "IsRandom"
    t_1._back_to_prompt_name = arg3
    t_1._back_to_prompt_args = { ... }
    t_1:_Init()

    return t_1
end

function t.CloseRequest(arg4) -- line: 42
    -- upvalues:
    --  [1] Prompt_m (copy)

    if arg4._back_to_prompt_name then
        arg4.OpenPrompt:Fire(arg4._back_to_prompt_name, table.unpack(arg4._back_to_prompt_args))

        return
    end

    Prompt_m.CloseRequest(arg4)
end

function t._GenerateOddsData(
    arg5,
    arg6,
    arg7,
    arg8,
    arg9
) -- line: 54
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] LootLibrary_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] ShopLibrary_m (copy)
    --  [5] CONSTANTS_m (copy)
    --  [6] ItemLibrary_m (copy)
    --  [7] LootboxChanceSlot (copy)
    --  [8] WeaponStatusHandler_m (copy)
    --  [9] RewardSlot_m (copy)
    --  [10] ButtonEffect_m (copy)

    local RewardData = arg7.RewardData
    local DisplayType = arg7.DisplayType
    local Name = RewardData.Name
    local v7 = RewardData.Quantity and RewardData.Quantity > 1 and " [\195\151" .. RewardData.Quantity .. "]" or ""
    local v8 = Name .. v7
    local v9 = Color3.fromRGB(255, 255, 255)
    v7 = nil
    local v10 = ""
    local color = Color3.fromRGB(255, 255, 255)
    local v11 = nil
    local v12 = CosmeticLibrary_m.Cosmetics[RewardData.Name]
    local v13 = CosmeticLibrary_m.Rewards[RewardData.Name]
    local t_3 = {}

    if v12 then
        v9 = CosmeticLibrary_m.Rarities[v12.Rarity].Color
        v10 = v12.Rarity .. " " .. v12.Type

        if RewardData.Weapon == "IsUniversal" then
            v10 = v10 .. " for all weapons"
        elseif RewardData.Weapon == "IsRandom" then
            v10 = v10 .. " for a random weapon"
            local v16 = LootLibrary_m:GetUnlockedWeaponsForSelection(
                PlayerDataController_m:Get("WeaponInventory"),
                true,
                RewardData.Name,
                PlayerDataController_m:Get("CosmeticInventory")
            )
            local t_4 = {}
            local t_5 = {}
            local v18 = pairs
            local _ = PlayerDataController_m:Get("CosmeticInventory")

            for _, val in v18(
                ShopLibrary_m:GetReleasedOwnableWeapons(
                    CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET,
                    ShopLibrary_m.OwnableWeaponsAlphabetized
                )
            ) do
                if not table.find(v16, val) then
                    if not PlayerDataController_m:GetWeaponData(val) then
                        table.insert(t_5, val)
                    else
                        table.insert(t_4, val)
                    end
                end
            end

            local function add_these(arg10, arg11) -- line: 93
                -- upvalues:
                --  [1] RewardData (copy)
                --  [2] t_3 (copy)

                for _, val_1 in pairs(arg10) do
                    local t_6 = { Name = nil, Weapon = nil }
                    t_6.Name, t_6.Weapon = RewardData.Name, val_1
                    table.insert(t_3, { Weight = 1, RewardData = t_6, DisplayType = arg11 })
                end
            end

            add_these(v16, "Default")
            add_these(t_4, "Owned")
            add_these(t_5, "Locked")
        elseif RewardData.Weapon then
            v10 = v10 .. " for " .. RewardData.Weapon
            v11 = ItemLibrary_m.Items[RewardData.Weapon].Status
        end
    elseif v13 then
        if v13.Type == "Weapon" then
            local v25 = ItemLibrary_m.Items[RewardData.Name]
            v10 = v25.Status .. " Weapon"
            v7 = v25.Status
        else
            v10 = v13.Type

            if RewardData.Weapon == "IsUniversal" then
                v10 = v10 .. " for all weapons"
            elseif RewardData.Weapon ~= "IsRandom" then
                if RewardData.Weapon then
                    v10 = v10 .. " for " .. RewardData.Weapon
                    v11 = ItemLibrary_m.Items[RewardData.Weapon].Status
                end
            end

            if v13.Type == "Lootbox" then
                local v32 = LootLibrary_m
                local v36, v37
                v32, v36, v37 = v32:GetLootboxPossibilities(
                    v13.SmartRestrictionsEnabled,
                    v13.GetContents(RewardData.Weapon),
                    PlayerDataController_m:Get("CosmeticInventory"),
                    PlayerDataController_m:GetUnlockedWeapons(),
                    RewardData.Weapon
                )

                local function add_these_1(arg12, arg13) --[[ add_these ]] -- line: 129
                    -- upvalues:
                    --  [1] t_3 (copy)

                    for _, val_2 in pairs(arg12) do
                        local t_8 = { Weight = val_2.Weight, RewardData = nil, DisplayType = nil }
                        t_8.RewardData, t_8.DisplayType = val_2.Reward, arg13
                        table.insert(t_3, t_8)
                    end
                end

                add_these_1(v32, "Default")
                add_these_1(v37, "Owned")
                add_these_1(v36, "Locked")
            end
        end
    end

    v13 = if DisplayType ~= "Default" then false else #t_3 > 0
    local v42 = LootboxChanceSlot:Clone()
    local Container = v42.Container.TitleContainer.Value
    Container.Text = v8
    local Container_1 = v42.Container.TitleContainer.Value
    Container_1.TextColor3 = v9
    local Container_2 = v42.Container.DescriptionContainer.Value
    Container_2.Text = v10
    local Container_3 = v42.Container.DescriptionContainer.Value
    Container_3.TextColor3 = color
    local Container_4 = v42.Container.Details.Chance
    local v43 = string.format("%.2f%%", arg8 * 100)
    Container_4.Text = v43
    local Container_5 = v42.Container.Details.Chance
    v43 = if DisplayType ~= "Default" then false else true
    Container_5.Visible = v43
    local Container_6 = v42.Container.Details.Locked
    v43 = DisplayType == "Locked"
    Container_6.Visible = v43
    local Container_7 = v42.Container.Details.Owned
    v43 = DisplayType == "Owned"
    Container_7.Visible = v43
    local Container_8 = v42.Container.Button
    Container_8.Visible = v13
    local Container_9 = v42.Container.Arrow
    Container_9.Visible = v13
    v42.Parent = arg6
    WeaponStatusHandler_m:ApplyItemStatusToText(v42.Container.TitleContainer.Value, v7)
    WeaponStatusHandler_m:ApplyItemStatusToText(v42.Container.DescriptionContainer.Value, v11)
    v11 = RewardSlot_m.new(RewardData)
    v11:SetNameText("")
    v11:HideWeaponVisual()
    v11:SetParent(v42.Container.RewardContainer)
    local Children = v42.Container.Children
    local Layout = Children.Layout

    function v10() --[[ update ]] -- line: 169
        -- upvalues:
        --  [1] v42 (copy)
        --  [2] Children (copy)
        --  [3] Layout (copy)

        local v48 = v42
        local New = UDim2.new
        local v49 = if Children.Visible then Layout.AbsoluteContentSize.Y else 0
        v48.Size = New(1, 0, 0.075, v49)
    end

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v10)
    Children:GetPropertyChangedSignal("Visible"):Connect(v10)
    local New_1 = UDim2.new(
        1,
        0,
        0.075,
        if not Children.Visible then 0 else Layout.AbsoluteContentSize.Y
    )
    v42.Size = New_1
    local v52 = false
    local v53 = false

    local function set_children_visible(arg14) -- line: 181
        -- upvalues:
        --  [1] v13 (copy)
        --  [2] v52 (ref)
        --  [3] t_3 (copy)
        --  [4] arg8 (copy)
        --  [5] arg5 (copy)
        --  [6] v42 (copy)
        --  [7] v53 (ref)

        local v54 = arg14

        if v54 then
            v54 = v13
        end

        if v54 and not v52 then
            v52 = true
            local v55 = 0
            local v56

            for _, val_3 in pairs(t_3) do
                v56 = if val_3.DisplayType ~= "Default" then 0 else val_3.Weight or 0
                v55 += v56
            end

            for _, val_4 in pairs(t_3) do
                v56 = if val_4.DisplayType ~= "Default" then 0 else arg8 * val_4.Weight / v55
                arg5:_GenerateOddsData(v42.Container.Children, val_4, v56)
            end
        end

        v53 = v54
        v42.Container.Children.Visible = v53
        v42.Container.Details.Visible = not v53
        local Arrow = v42.Container.Arrow
        Arrow.Image = if not v53 then "rbxassetid://17654548862" else "rbxassetid://17654601337"
    end

    if not arg9 then
        v42.Container.Button.MouseButton1Click:Connect(function() -- line: 207
            -- upvalues:
            --  [1] set_children_visible (copy)
            --  [2] v53 (ref)

            set_children_visible(not v53)
        end)
        ButtonEffect_m:Add(v42.Container.Button)
    end

    set_children_visible(arg9)
end

function t._Init(arg15) -- line: 217
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg15.CloseButton.MouseButton1Click:Connect(function() -- line: 218
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:CloseRequest()
    end)
    arg15.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 222
        -- upvalues:
        --  [1] arg15 (copy)

        arg15.List.CanvasSize = UDim2.new(0, 0, 0, arg15.Layout.AbsoluteContentSize.Y)
    end)
    local t_9 = { RewardData = nil, DisplayType = "Default" }
    local t_10 = { Name = arg15._root_name, Weapon = arg15._root_weapon }
    t_9.RewardData = t_10
    task.defer(
        arg15._GenerateOddsData,
        arg15,
        arg15.Container,
        t_9,
        1,
        true
    )
    ButtonEffect_m:Add(arg15.CloseButton)
end

return t
