local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Customize = arg1
    t_1.Frame = t_1.Customize.BottomContainer:WaitForChild("Options")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1:_Init()

    return t_1
end

function t.OnCustomizingStateChanged(arg2) -- line: 29
    arg2:_Update()
end

function t.OnStateChanged(arg3) -- line: 33
    arg3:_Update()
end

function t._UpdateBackground(arg4) -- line: 41
    arg4.Background.Size = UDim2.new(0, arg4.Layout.AbsoluteContentSize.X, 1, 0)
    local Background_1 = arg4.Background
    Background_1.Visible = arg4.Layout.AbsoluteContentSize.X > 1
end

function t._OnOptionClicked(arg5, arg6, arg7) -- line: 46
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    local Button = arg5.Container:WaitForChild(arg6):WaitForChild("Container"):WaitForChild(
        "Button"
    )
    Button.MouseButton1Click:Connect(arg7)
    ButtonEffect_m:Add(Button)
end

function t._SetOption(arg8, arg9, arg10, arg11) -- line: 52
    local v2 = arg8.Container:WaitForChild(arg9)
    local Button_1 = v2:WaitForChild("Container"):WaitForChild("Button")
    local Empty = Button_1:WaitForChild("Empty")
    local Filled = Button_1:WaitForChild("Filled")
    v2.Visible = arg10
    Filled.Visible = arg11
    Empty.Visible = not arg11
end

function t._Update(arg12) -- line: 63
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)

    if not arg12.Customize.Interface.Equipment.IsOpen then
        return
    end

    local v3 = arg12.Customize.Interface.Equipment:GetSelectedWeapon()
    local v4 = arg12.Customize.Interface.Equipment:GetSelectedCosmetic()
    local v5 = arg12.Customize.Interface.Equipment:GetCustomizingType()
    local v6 = PlayerDataController_m:GetWeaponData(v3)
    local v7 = v6

    if v7 then
        v7 = v4

        if v7 then
            v7 = CosmeticLibrary_m:OwnsCosmetic(
                PlayerDataController_m:Get("CosmeticInventory"),
                v4,
                v3
            )
        end
    end

    local v10 = PlayerDataController_m:Get("FavoritedCosmetics")
    local v11 = if not v4 and v5 then "NONE_COSMETIC" else v4
    local v12 = v7 or v11 == "NONE_COSMETIC"
    v7 = v12

    if v7 then
        v7 = v10[v3]

        if v7 then
            v7 = v10[v3][CosmeticLibrary_m:GetNoneSpecificCosmeticName(v11, v5)]
        end
    end

    arg12:_SetOption("Favorited", v12, v7)
    v12 = false

    if v5 == "Wrap" then
        v12 = v4 and v4 ~= "RANDOM_COSMETIC"
    end

    v11 = if arg12.Customize.Interface.Equipment.EquipmentState.CosmeticInverted == nil then v6 and v6.Wrap and v6.Wrap.Inverted else arg12.Customize.Interface.Equipment.EquipmentState.CosmeticInverted
    arg12:_SetOption("Inverted", v12, v11)
    v12 = if v4 ~= "RANDOM_COSMETIC" then false else true
    v11 = v12 and v6 and v6[v5] and v6[v5].OnlyUseFavorites
    arg12:_SetOption("OnlyUseFavorites", v12, v11)
end

function t._Init(arg13) -- line: 90
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] ReplicatedStorage (copy)

    arg13.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 91
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateBackground()
    end)
    arg13:_OnOptionClicked("Favorited", function() -- line: 95
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] PlayerDataController_m (ref)
        --  [3] CosmeticLibrary_m (ref)
        --  [4] ReplicatedStorage (ref)

        local v14 = arg13.Customize.Interface.Equipment:GetSelectedWeapon()
        local v15 = arg13.Customize.Interface.Equipment:GetSelectedCosmetic()
        local v16 = arg13.Customize.Interface.Equipment:GetCustomizingType()
        local v17 = PlayerDataController_m:Get("FavoritedCosmetics")
        local v18 = v15 or "NONE_COSMETIC"
        v15 = v17[v14]

        if v15 then
            v15 = v17[v14][CosmeticLibrary_m:GetNoneSpecificCosmeticName(v18, v16)]
        end

        ReplicatedStorage.Remotes.Data.FavoriteCosmetic:FireServer(
            v14,
            v18,
            not v15,
            if v18 == "NONE_COSMETIC" then arg13.Customize.Interface.Equipment:GetCustomizingType() else nil
        )
    end)
    arg13:_OnOptionClicked("Inverted", function() -- line: 109
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] PlayerDataController_m (ref)
        --  [3] CosmeticLibrary_m (ref)
        --  [4] ReplicatedStorage (ref)

        local v21 = arg13.Customize.Interface.Equipment:GetSelectedWeapon()
        local v22 = arg13.Customize.Interface.Equipment:GetSelectedCosmetic()
        local v23 = arg13.Customize.Interface.Equipment:GetCustomizingType()
        local CosmeticInverted = arg13.Customize.Interface.Equipment.EquipmentState.CosmeticInverted
        local v24 = PlayerDataController_m:GetWeaponData(v21)
        local v25 = v24

        if v25 then
            v25 = v22

            if v25 then
                v25 = CosmeticLibrary_m:OwnsCosmetic(
                    PlayerDataController_m:Get("CosmeticInventory"),
                    v22,
                    v21
                )
            end
        end

        v22 = if CosmeticInverted == nil then v24 and v24.Wrap and v24.Wrap.Inverted else CosmeticInverted
        local v28 = not v22
        arg13.Customize.Interface.Equipment.EquipmentState:SetCosmeticInvertedState(v28)

        if v25 then
            ReplicatedStorage.Remotes.Data.EquipCosmetic:FireServer(
                v21,
                v23,
                v24.Wrap.Name,
                { IsInverted = v28 }
            )
        end
    end)
    arg13:_OnOptionClicked("OnlyUseFavorites", function() -- line: 127
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] PlayerDataController_m (ref)
        --  [3] ReplicatedStorage (ref)

        local v30 = arg13.Customize.Interface.Equipment:GetSelectedWeapon()
        local v31 = arg13.Customize.Interface.Equipment:GetCustomizingType()
        local v32 = PlayerDataController_m:GetWeaponData(v30)
        ReplicatedStorage.Remotes.Data.EquipCosmetic:FireServer(
            v30,
            v31,
            v32[v31].Name,
            { OnlyUseFavorites = not v32[v31].OnlyUseFavorites }
        )
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 138
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Update()
    end)
    PlayerDataController_m:GetDataChangedSignal("CosmeticInventory"):Connect(function() -- line: 142
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Update()
    end)
    PlayerDataController_m:GetDataChangedSignal("FavoritedCosmetics"):Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Update()
    end)
    arg13:_UpdateBackground()
end

return t
