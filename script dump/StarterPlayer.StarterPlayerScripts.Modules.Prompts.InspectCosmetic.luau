local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local UnlockedCosmeticWeaponSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "UnlockedCosmeticWeaponSlot"
)
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1) -- line: 18
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)
    --  [3] CosmeticLibrary_m (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.TitleText = t_1.PromptFrame:WaitForChild("Title")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._cosmetic_name = arg1
    t_1._cosmetic_info = CosmeticLibrary_m.Cosmetics[t_1._cosmetic_name]
    t_1._slots = {}
    t_1:_Init()

    return t_1
end

function t._IsEquipped(arg2, arg3) -- line: 46
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v6 = PlayerDataController_m:GetWeaponData(arg3)
    local v7 = v6

    if v7 then
        v7 = v6[arg2._cosmetic_info.Type] and v6[arg2._cosmetic_info.Type].Name == arg2._cosmetic_name
    end

    return v7
end

function t._UpdateEquipped(arg4) -- line: 53
    for key, val in pairs(arg4._slots) do
        val.Button.Equipped.Visible = arg4:_IsEquipped(key)
    end
end

function t._Setup(arg5) -- line: 59
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] CosmeticLibrary_m (copy)
    --  [6] UnlockedCosmeticWeaponSlot (copy)
    --  [7] ButtonEffect_m (copy)
    --  [8] WeaponStatusHandler_m (copy)
    --  [9] ReplicatedStorage (copy)

    arg5.TitleText.Text = arg5._cosmetic_name .. " " .. arg5._cosmetic_info.Type
    local v8 = PlayerDataController_m:Get("CosmeticInventory")
    local v12

    for key_1, val_1 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(
            CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET,
            ShopLibrary_m.OwnableWeaponsAlphabetized
        )
    ) do
        local v10 = ItemLibrary_m.Items[val_1]

        if arg5._cosmetic_info.Type ~= "Finisher" or v10.CanEliminate then
            local v11 = PlayerDataController_m:GetWeaponData(val_1)
            local v13 = CosmeticLibrary_m:OwnsCosmetic(v8, arg5._cosmetic_name, val_1)
            local v14 = not v11

            if v14 then
                v14 = not v13
            end

            local v12 = UnlockedCosmeticWeaponSlot:Clone()
            v12.LayoutOrder = key_1 + (if not v13 then 999999 else 0)
            v12.Button.Icon.Image = v10.Image
            local Icon = v12.Button.Icon
            local v16 = if not v14 then if v13 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(
                32,
                32,
                32
            ) or Color3.fromRGB(255, 255, 255) else Color3.fromRGB(32, 32, 32) or (if v13 then Color3.fromRGB(
                255,
                255,
                255
            ) else Color3.fromRGB(32, 32, 32) or Color3.fromRGB(255, 255, 255))
            Icon.ImageColor3 = v16
            local Button = v12.Button.Title
            Button.Visible = not v14
            local Button_1 = v12.Button.Title
            Button_1.Text = val_1
            local Button_2 = v12.Button.Title
            v16 = if v13 then 0 else 0.875
            Button_2.TextTransparency = v16
            local v17 = v12.Button.Locked
            v17.Visible = v14
            v17 = if not v14 then if v13 then 2 else 1 else 0
            v12.ZIndex = v17
            v12.Parent = arg5.Container
            arg5._slots[val_1] = v12
            ButtonEffect_m:Add(v12.Button)
            WeaponStatusHandler_m:ApplyItemStatusToText(
                v12.Button.Title,
                ItemLibrary_m.Items[val_1].Status
            )
            v12.Button.MouseButton1Click:Connect(function() -- line: 89
                -- upvalues:
                --  [1] v11 (copy)
                --  [2] v13 (copy)
                --  [3] ReplicatedStorage (ref)
                --  [4] val_1 (copy)
                --  [5] arg5 (copy)
                --  [6] PlayerDataController_m (ref)

                if not v11 or not v13 then
                    return
                end

                ReplicatedStorage.Remotes.Data.EquipCosmetic:FireServer(
                    val_1,
                    arg5._cosmetic_info.Type,
                    if not arg5:_IsEquipped(val_1) then arg5._cosmetic_name else nil
                )
                PlayerDataController_m:SilenceCosmeticNotification(arg5._cosmetic_name, val_1)
            end)
            local v22 = false
            v12.Button.MouseEnter:Connect(function() --[[ hover ]] -- line: 100
                -- upvalues:
                --  [1] v22 (ref)
                --  [2] v12 (copy)

                if v22 then
                    return
                end

                v22 = true
                local v23 = v12
                v23.ZIndex += 10
            end)
            v12.Button.MouseLeave:Connect(function() --[[ unhover ]] -- line: 111
                -- upvalues:
                --  [1] v22 (ref)
                --  [2] v12 (copy)

                if not v22 then
                    return
                end

                v22 = false
                local v24 = v12
                v24.ZIndex -= 10
            end)
        end
    end
end

function t._Init(arg6) -- line: 124
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg6.CloseButton.MouseButton1Click:Connect(function() -- line: 125
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:CloseRequest()
    end)
    arg6.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 129
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.List.CanvasSize = UDim2.new(0, 0, 0, arg6.Layout.AbsoluteContentSize.Y)
    end)
    local Connections = arg6._connections
    local WeaponInventory = PlayerDataController_m:GetDataChangedSignal("WeaponInventory")
    table.insert(Connections, WeaponInventory:Connect(function() -- line: 133
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateEquipped()
    end))
    arg6:_Setup()
    arg6:_UpdateEquipped()
    ButtonEffect_m:Add(arg6.CloseButton)
end

return t
