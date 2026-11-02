local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local DropdownSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.DropdownSlot)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local t = { "loose_glorycharm", "loose_glorywrap", "loose_gloryfinisher", "loose_gloryemote" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 21
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.Pages = arg1
    t_2.Frame = t_2.Pages.Frame:WaitForChild("Ranked")
    t_2.Container = t_2.Frame:WaitForChild("Container")
    t_2.LooseFrame = t_2.Container:WaitForChild("Loose")
    t_2.LooseSlotsFrame = t_2.LooseFrame:WaitForChild("Slots")
    t_2.WeaponFrame = t_2.Container:WaitForChild("Weapon")
    t_2.WeaponSlotsFrame = t_2.WeaponFrame:WaitForChild("Slots")
    t_2.WeaponHeaderFrame = t_2.WeaponFrame:WaitForChild("Header")
    t_2.WeaponIcon = t_2.WeaponHeaderFrame:WaitForChild("Icon")
    t_2.WeaponDropdownFrame = t_2.WeaponHeaderFrame:WaitForChild("Dropdown")
    t_2.WeaponDropdownButton = t_2.WeaponDropdownFrame:WaitForChild("Button")
    t_2.WeaponDropdownTitle = t_2.WeaponDropdownButton:WaitForChild("Title")
    t_2._shop_slots = {}
    t_2._selected_weapon_name = t_2:_GetWeaponsWithGloriousCosmetics()[1]
    t_2._dropdown_slot = nil
    t_2._play_glorious_cosmetic_animation = false
    t_2._update_cleanup = {}
    t_2:_Init()

    return t_2
end

function t_1.SetSelectedWeaponName(arg2, arg3) -- line: 52
    arg2._selected_weapon_name = arg3
    arg2:_Update()
end

function t_1.Open(arg4) -- line: 57
    arg4:_Update()
end

function t_1.Close(arg5) -- line: 61
    arg5:_Update()
    arg5:_StopDropdown()
end

function t_1.Setup(_) -- line: 66
end

function t_1._GetWeaponsWithGloriousCosmetics(_) -- line: 74
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] CosmeticLibrary_m (copy)

    local v1 = PlayerDataController_m:GetUnlockedWeapons()
    local t_3 = {}

    for _, val in pairs(ShopLibrary_m.OwnableWeaponsAlphabetized) do
        if v1[val] and CosmeticLibrary_m.Cosmetics["Glorious " .. val] then
            table.insert(t_3, val)
        end
    end

    return t_3
end

function t_1._StopDropdown(arg8) -- line: 87
    if arg8._dropdown_slot then
        arg8._dropdown_slot:Cancel()
        arg8._dropdown_slot = nil
    end

    arg8.WeaponDropdownButton.Visible = true
end

function t_1._StartDropdown(arg9) -- line: 96
    -- upvalues:
    --  [1] DropdownSlot_m (copy)

    arg9:_StopDropdown()
    arg9.WeaponDropdownButton.Visible = false
    arg9._dropdown_slot = DropdownSlot_m.new(
        arg9.WeaponDropdownFrame,
        arg9:_GetWeaponsWithGloriousCosmetics(),
        9
    )
    arg9._dropdown_slot.Selected:Connect(function(mouse: Instance) -- line: 103
        -- upvalues:
        --  [1] arg9 (copy)

        if mouse then
            arg9._play_glorious_cosmetic_animation = true
            arg9:SetSelectedWeaponName(mouse)
        end

        arg9:_StopDropdown()
    end)
end

function t_1._Update(arg11) -- line: 113
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] t (copy)
    --  [4] ShopLibrary_m (copy)
    --  [5] tweenInfo (copy)
    --  [6] BetterDebris_m (copy)
    --  [7] TweenService (copy)

    for _, val_1 in pairs(arg11._shop_slots) do
        val_1:Destroy()
    end

    for _, val_2 in pairs(arg11._update_cleanup) do
        val_2:Destroy()
    end

    arg11._shop_slots = {}
    arg11._update_cleanup = {}
    WeaponStatusHandler_m:ClearStatusElements(arg11.WeaponDropdownTitle)

    if not arg11.Pages.Shop:IsOpen() then
        return
    end

    local WeaponIcon = arg11.WeaponIcon
    WeaponIcon.Image = ItemLibrary_m.Items[arg11._selected_weapon_name] and ItemLibrary_m.Items[arg11._selected_weapon_name].Image or ""
    arg11.WeaponDropdownTitle.Text = arg11._selected_weapon_name
    local v3 = WeaponStatusHandler_m
    local WeaponDropdownTitle = arg11.WeaponDropdownTitle
    local v4 = ItemLibrary_m.Items[arg11._selected_weapon_name]

    if v4 then
        v4 = ItemLibrary_m.Items[arg11._selected_weapon_name].Status
    end

    v3:ApplyItemStatusToText(WeaponDropdownTitle, v4)

    for _, val_3 in pairs(t) do
        local v6 = arg11.Pages.Shop:CreateShopSlot(
            nil,
            arg11.LooseSlotsFrame:WaitForChild(val_3),
            val_3
        )

        if v6 then
            table.insert(arg11._shop_slots, v6)
        end
    end

    local v7 = true
    local v8 = ShopLibrary_m.NUM_GLORIOUS_COSMETICS[arg11._selected_weapon_name] or 0
    local v9

    for index = 1, math.huge do
        v9 = arg11.WeaponSlotsFrame:FindFirstChild(index)
        local v11 = arg11.WeaponSlotsFrame:FindFirstChild("Arrow" .. index)

        if v9 then
            v9.Visible = false
        end

        if v11 then
            v11.Visible = false
        end

        if not v9 and not v11 then
            break
        end
    end

    for index_1 = 1, v8 do
        v9 = arg11.WeaponSlotsFrame:WaitForChild(index_1)
        local v13 = arg11.Pages.Shop:CreateShopSlot(
            nil,
            v9,
            "loose_gloriouscosmetic_" .. index_1 .. "_" .. arg11._selected_weapon_name,
            not v7
        )
        local v14 = v13

        if v14 then
            v14 = v13.IsOwned
        end

        v7 = v14

        if v13 then
            v9.Visible = true
            local _ = {}

            for _, val_4 in pairs(
                { v13.Frame, arg11.WeaponSlotsFrame:FindFirstChild("Arrow" .. index_1 - 1) }
            ) do
                val_4.Visible = true

                if arg11._play_glorious_cosmetic_animation then
                    v14 = (index_1 - 1) * tweenInfo.Time * 0.5
                    local UIScale = Instance.new("UIScale")
                    UIScale.Scale = 0
                    UIScale.Parent = val_4
                    table.insert(arg11._update_cleanup, UIScale)
                    BetterDebris_m:AddItem(UIScale, v14 + tweenInfo.Time)
                    task.delay(v14, function() -- line: 190
                        -- upvalues:
                        --  [1] TweenService (ref)
                        --  [2] UIScale (copy)
                        --  [3] tweenInfo (ref)

                        TweenService:Create(UIScale, tweenInfo, { Scale = 1 }):Play()
                    end)
                end
            end

            table.insert(arg11._shop_slots, v13)
        end
    end
end

function t_1._Init(arg12) -- line: 199
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg12.WeaponDropdownButton.MouseButton1Click:Connect(function() -- line: 200
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_StartDropdown()
    end)
    PlayerDataController_m:GetDataChangedSignal("CosmeticInventory"):Connect(function() -- line: 204
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_Update()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 208
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_Update()
    end)
    ButtonEffect_m:Add(
        arg12.WeaponDropdownButton,
        nil,
        { ReleaseRatio = 1.025, HoverRatio = 1.025 }
    )
end

return t_1
