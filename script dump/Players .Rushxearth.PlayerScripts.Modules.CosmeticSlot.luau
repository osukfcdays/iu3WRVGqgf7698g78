local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("StaticModel"):WaitForChild(
        "StaticViewModel"
    )
)
local CosmeticViewportFrame_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticViewportFrame")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local EmoteViewportFrame_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteViewportFrame")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local CosmeticSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CosmeticSlot")
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 21
    -- upvalues:
    --  [1] t (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] CosmeticSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.Name = arg1
    t_1.Info = CosmeticLibrary_m.Cosmetics[t_1.Name]
    t_1.IsLocked = arg2
    t_1.Frame = CosmeticSlot:Clone()
    t_1._destroyed = false
    t_1._cleanup = {}
    t_1._owned_connections = {}
    t_1._ignore_button_effects = arg3
    t_1._quantity = 1
    t_1._name_text_override = nil
    t_1._emote_viewport_frame = nil
    t_1._cosmetic_viewport_frame = nil
    t_1._owned_gradients = {}
    t_1:_Init()

    return t_1
end

function t.SetWeapon(arg4, arg5) -- line: 48
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] WeaponStatusHandler_m (copy)

    local v6 = ItemLibrary_m.Items[arg5]
    local v7 = ItemLibrary_m.ViewModels[arg5]
    local v8 = arg5 == "IsUniversal" or arg5 == "IsRandom"
    local v9 = if arg5 ~= "IsUniversal" then if arg5 ~= "IsRandom" then if not v7 then "" else v7.ImageCentered or v7.Image else ItemLibrary_m.RANDOM_WEAPON_ICON else ItemLibrary_m.UNIVERSAL_WEAPON_ICON
    arg4.Frame.Button.Weapon.Visible = not arg4.IsLocked and arg5
    arg4.Frame.Button.Weapon.Container.IconCanvas.Icon.Image = v9
    arg4.Frame.Button.Weapon.Container.IconCanvas.Icon.ImageTransparency = if not v8 then 0 else 0.25
    local Icon_1 = arg4.Frame.Button.Weapon.Container.IconCanvas.Icon
    Icon_1.Size = v8 and UDim2.new(0.75, 0, 1, 0) or UDim2.new(4, 0, 4, 0)
    local v11 = WeaponStatusHandler_m
    local Background = arg4.Frame.Button.Weapon.Container.Background
    v11:ApplyItemStatusToBackground(
        Background,
        arg4.Frame.Button.Weapon.Container.Outline.UIStroke,
        v6 and v6.Status or "Standard"
    )
end

function t.SetQuantity(arg6, arg7) -- line: 66
    arg6._quantity = arg7 or 1
    arg6:_UpdateNameText()
end

function t.SetInteractable(arg8, arg9) -- line: 71
    arg8.Frame.Button.Interactable = arg9
end

function t.EnableOwnedLogic(arg10, arg11) -- line: 75
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    for _, val in pairs(arg10._owned_connections) do
        val:Disconnect()
    end

    arg10._owned_connections = {}
    arg10:_UpdateOwned(false)

    if not arg11 then
        return
    end

    table.insert(arg10._owned_connections, PlayerDataController_m:GetDataChangedSignal(
        "CosmeticInventory"
    ):Connect(function() -- line: 87
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateOwned()
    end))
    arg10:_UpdateOwned()
end

function t.OverrideNameText(arg12, arg13) -- line: 94
    arg12._name_text_override = arg13
    arg12:_UpdateNameText()
end

function t.UseHighResolutionImage(arg14) -- line: 99
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ItemLibrary_m (copy)

    local v13 = CONSTANTS_m.COSMETIC_IMAGES[arg14.Name]
    local Icon_2 = arg14.Frame.Button.Icon
    v13 = v13 or ItemLibrary_m.ViewModels[arg14.Name] and ItemLibrary_m.ViewModels[arg14.Name].ImageHighResolution or arg14.Info.Image
    Icon_2.Image = v13
end

function t.HideBackground(arg15) -- line: 103
    arg15.Frame.Button.Background.Visible = false

    if arg15._cosmetic_viewport_frame then
        arg15._cosmetic_viewport_frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end

    if arg15._emote_viewport_frame then
        arg15._emote_viewport_frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end
end

function t.ZoomOutViewportFrame(arg16) -- line: 115
    if arg16._cosmetic_viewport_frame then
        arg16._cosmetic_viewport_frame:ZoomOut()
    end

    if arg16._emote_viewport_frame then
        arg16._emote_viewport_frame:ZoomOut()
    end
end

function t.Destroy(arg17) -- line: 125
    if arg17._destroyed then
        return
    end

    arg17._destroyed = true
    pcall(function() -- line: 132
        -- upvalues:
        --  [1] arg17 (copy)

        arg17.Frame:Destroy()
    end)

    for _, val_1 in pairs(arg17._owned_connections) do
        val_1:Disconnect()
    end

    for _, val_2 in pairs(arg17._cleanup) do
        val_2:Destroy()
    end

    if arg17._cosmetic_viewport_frame then
        arg17._cosmetic_viewport_frame:Destroy()
    end

    if arg17._emote_viewport_frame then
        arg17._emote_viewport_frame:Destroy()
    end
end

function t._UpdateOwned(arg18, arg19) -- line: 157
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    for _, val_3 in pairs(arg18._owned_gradients) do
        val_3:Destroy()
    end

    arg18._owned_gradients = {}
    local v14 = if arg19 ~= nil then arg19 else CosmeticLibrary_m:OwnsCosmeticForSomething(
        PlayerDataController_m:Get("CosmeticInventory"),
        arg18.Name
    )
    arg18.Frame.Button.Owned.Visible = v14

    if v14 then
        local v17 = pairs
        local v18 = arg18._emote_viewport_frame
        local Icon_3 = arg18.Frame.Button.Icon
        v18 = v18 and arg18._emote_viewport_frame.Frame
        local v19 = arg18._cosmetic_viewport_frame and arg18._cosmetic_viewport_frame.Frame

        for _, val_4 in v17({ Icon_3, v18, v19 }) do
            if val_4 then
                v19 = Instance.new("UIGradient")
                v19.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
                v19.Parent = val_4
                table.insert(arg18._owned_gradients, v19)
            end
        end
    end
end

function t._UpdateNameText(arg20) -- line: 182
    -- upvalues:
    --  [1] Utility_m (copy)

    local Title = arg20.Frame.Button.Title
    local v20 = if arg20._name_text_override then UDim2.new(0.9, 0, 0.2, 0) or UDim2.new(
        0.9,
        0,
        0.4,
        0
    ) else if arg20._quantity == 1 then UDim2.new(0.9, 0, 0.2, 0) or UDim2.new(0.9, 0, 0.4, 0) else if arg20._quantity ~= 0 then UDim2.new(
        0.9,
        0,
        0.4,
        0
    ) else UDim2.new(0.9, 0, 0.2, 0) or UDim2.new(0.9, 0, 0.4, 0)
    Title.Size = v20
    v20 = arg20._name_text_override
    local Title_1 = arg20.Frame.Button.Title

    if not v20 then
        v20 = if arg20.Name == "RANDOM_COSMETIC" then "Random" else if arg20.Name == "NONE_COSMETIC" then "None" else if arg20._quantity ~= 1 then arg20._quantity == 0 and arg20.Name or "\195\151" .. Utility_m:PrettyNumber(
            arg20._quantity
        ) else arg20.Name or "\195\151" .. Utility_m:PrettyNumber(arg20._quantity)
    end

    Title_1.Text = v20
end

function t._Setup(arg21) -- line: 191
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] EmoteViewportFrame_m (copy)
    --  [5] CosmeticViewportFrame_m (copy)

    local v21 = arg21.Info and CosmeticLibrary_m.Rarities[arg21.Info.Rarity].Color or Color3.fromRGB(
        0,
        0,
        0
    )
    local Icon_4 = arg21.Frame.Button.Icon
    local v22 = if not arg21.Info then arg21.Frame.Button.Icon.ZIndex else if arg21.Info.Type ~= "Skin" then arg21.Frame.Button.Icon.ZIndex else if arg21.IsLocked then arg21.Frame.Button.Icon.ZIndex else 3
    Icon_4.ZIndex = v22
    local Icon_5 = arg21.Frame.Button.Icon
    v22 = if arg21.Name == "RANDOM_COSMETIC" then UDim2.new(0.45, 0, 0.45, 0) or UDim2.new(
        0.75 * arg21.Info.ImageScale,
        0,
        0.75 * arg21.Info.ImageScale,
        0
    ) else if arg21.Name ~= "NONE_COSMETIC" then UDim2.new(
        0.75 * arg21.Info.ImageScale,
        0,
        0.75 * arg21.Info.ImageScale,
        0
    ) else UDim2.new(0.45, 0, 0.45, 0) or UDim2.new(
        0.75 * arg21.Info.ImageScale,
        0,
        0.75 * arg21.Info.ImageScale,
        0
    )
    Icon_5.Size = v22
    v22 = CONSTANTS_m.COSMETIC_IMAGES[arg21.Name]
    local Icon_6 = arg21.Frame.Button.Icon
    v22 = v22 or arg21.Info.Image
    Icon_6.Image = v22
    local Icon_7 = arg21.Frame.Button.Icon
    v22 = if arg21.Name == "RANDOM_COSMETIC" then 0.875 else if arg21.Name ~= "NONE_COSMETIC" then if not arg21.IsLocked then 0 else 0.5 else 0.875
    Icon_7.ImageTransparency = v22
    local Icon_8 = arg21.Frame.Button.Icon
    v22 = arg21.IsLocked and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    Icon_8.ImageColor3 = v22
    local Title_2 = arg21.Frame.Button.Title
    v22 = if not arg21.IsLocked then 0 else 0.5
    Title_2.TextTransparency = v22
    arg21.Frame.Button.Locked.Visible = arg21.IsLocked
    arg21.Frame.Button.Background.UIStroke.Color = v21
    arg21.Frame.Button.Background.BackgroundColor3 = v21

    if not arg21._ignore_button_effects then
        ButtonEffect_m:Add(arg21.Frame.Button)
    end

    if arg21.IsLocked and arg21.Info then
        arg21.Frame.Button.Icon.ZIndex = 1
        arg21.Frame.Button.Icon.Size = UDim2.new(0.6, 0, 0.6, 0)
        arg21.Frame.Button.Icon.Image = CosmeticLibrary_m.Types[arg21.Info.Type].Image
        arg21.Frame.Button.Icon.ImageTransparency = 0.5
        arg21.Frame.Button.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)

        return
    end

    if arg21.Info then
        if arg21.Info.Type == "Emote" then
            arg21._emote_viewport_frame = EmoteViewportFrame_m.new(arg21.Name)
            local Frame_2 = arg21._emote_viewport_frame.Frame
            Frame_2.ZIndex = if not arg21.IsLocked then 1 else 0
            arg21._emote_viewport_frame:SetParent(arg21.Frame.Button)
            arg21._emote_viewport_frame:SetLocked(arg21.IsLocked)

            return
        end

        arg21._cosmetic_viewport_frame = CosmeticViewportFrame_m.new(arg21.Name, arg21.IsLocked)
        arg21._cosmetic_viewport_frame.Frame.BackgroundColor3 = v21
        arg21._cosmetic_viewport_frame.Frame.Parent = arg21.Frame.Button
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = arg21._cosmetic_viewport_frame.Frame
    end
end

function t._Init(arg22) -- line: 232
    arg22.Frame.Destroying:Connect(function() -- line: 233
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:Destroy()
    end)
    arg22:_Setup()
    arg22:_UpdateNameText()
    arg22:SetWeapon(nil)
    arg22:SetQuantity(nil)
    arg22:EnableOwnedLogic(false)
end

return t
