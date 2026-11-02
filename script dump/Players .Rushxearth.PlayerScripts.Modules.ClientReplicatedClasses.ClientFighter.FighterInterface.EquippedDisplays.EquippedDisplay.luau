local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local InfiniteParticles_m = require(Players.LocalPlayer.PlayerScripts.Modules.InfiniteParticles)
local _ = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local EquippedDisplay = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquippedDisplay"
)
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 17
    -- upvalues:
    --  [1] t (copy)
    --  [2] EquippedDisplay (copy)
    --  [3] InfiniteParticles_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.EquippedDisplays = arg1
    t_1.ClientItem = arg2
    t_1.Frame = EquippedDisplay:Clone()
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.WeaponFrame = t_1.Container:WaitForChild("Weapon")
    t_1.WeaponIcon = t_1.WeaponFrame:WaitForChild("Icon")
    t_1.DetailsFrame = t_1.Container:WaitForChild("Details")
    t_1.NameContainer = t_1.DetailsFrame:WaitForChild("NameContainer")
    t_1.ItemNameText = t_1.NameContainer:WaitForChild("Title")
    t_1.AmmoContainer = t_1.DetailsFrame:WaitForChild("AmmoContainer")
    t_1.AmmoLayout = t_1.AmmoContainer:WaitForChild("Layout")
    t_1.AmmoFrame = t_1.AmmoContainer:WaitForChild("Ammo")
    t_1.AmmoText = t_1.AmmoFrame:WaitForChild("Title")
    t_1.AmmoReserveFrame = t_1.AmmoContainer:WaitForChild("Reserve")
    t_1.AmmoReserveText = t_1.AmmoReserveFrame:WaitForChild("Title")
    t_1.AmmoIconFrame = t_1.AmmoContainer:WaitForChild("Icon")
    t_1.AmmoIcon = t_1.AmmoIconFrame:WaitForChild("Icon")
    t_1._connections = {}
    t_1._infinite_particles = InfiniteParticles_m.new(t_1.AmmoText, t_1.AmmoReserveText)
    t_1:_Init()

    return t_1
end

function t.UpdateParent(arg3) -- line: 51
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    task.defer(pcall, function() -- line: 52
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] arg3 (copy)

        local v1 = if PlayerDataController_m:GetSetting("Equipped Weapon Display") ~= "Legacy" then false else true
        local v2 = true

        if PlayerDataController_m:GetSetting("Equipped Weapon Display") ~= "Bottom Left" then
            v2 = v1

            if v2 then
                v2 = if PlayerDataController_m:GetSetting("Hotbar Display") ~= "Bottom Left" then false else true
            end
        end

        arg3.WeaponFrame.Visible = PlayerDataController_m:GetSetting("Equipped Weapon Icon")
        arg3.AmmoContainer.Visible = PlayerDataController_m:GetSetting("Equipped Weapon Ammo")
        arg3.DetailsFrame.LayoutOrder = if v2 then 2 else 0
        local AmmoContainer_1 = arg3.AmmoContainer
        AmmoContainer_1.AnchorPoint = v2 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
        local AmmoContainer_2 = arg3.AmmoContainer
        AmmoContainer_2.Position = v2 and UDim2.new(0.075, 0, 0.28, 0) or UDim2.new(
            0.925,
            0,
            0.28,
            0
        )
        local NameContainer = arg3.NameContainer
        NameContainer.AnchorPoint = v2 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
        local NameContainer_1 = arg3.NameContainer
        NameContainer_1.Position = v2 and UDim2.new(0.05, 0, 0.75, 0) or UDim2.new(0.95, 0, 0.75, 0)
        local ItemNameText = arg3.ItemNameText
        ItemNameText.AnchorPoint = v2 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
        local ItemNameText_1 = arg3.ItemNameText
        ItemNameText_1.Position = v2 and UDim2.new(0, 0, 0.5, 0) or UDim2.new(1, 0, 0.5, 0)
        local ItemNameText_2 = arg3.ItemNameText
        ItemNameText_2.TextXAlignment = v2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
        local AmmoLayout = arg3.AmmoLayout
        AmmoLayout.HorizontalAlignment = v2 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
        local Layout = arg3.Layout
        Layout.HorizontalAlignment = v2 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
        local Frame = arg3.Frame
        Frame.Parent = v1 and arg3.EquippedDisplays.FighterInterface.Hotbar.EquippedDisplayFrame or v2 and arg3.EquippedDisplays.FighterInterface.BottomLeft.Container or arg3.EquippedDisplays.FighterInterface.BottomRight.Container
        arg3:_UpdateSize()
    end)
end

function t.UpdateVisibility(arg4) -- line: 74
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local Frame_1 = arg4.Frame
    local v4 = arg4.ClientItem:IsMainItem()

    if v4 then
        v4 = if PlayerDataController_m:GetSetting("Equipped Weapon Display") == "Disabled" then false else true
    end

    Frame_1.Visible = v4
end

function t.UpdateAmmo(arg5) -- line: 78
    local v5, v6, v7, v8 = arg5.ClientItem:GetAmmoVariables()
    local v9 = arg5.ClientItem:IsMainItem()
    local AmmoReserveText = arg5.AmmoReserveText
    AmmoReserveText.Text = if v6 then if v8 then "\226\136\158" else v5 and " " .. v6 or "" else ""
    local AmmoReserveText_1 = arg5.AmmoReserveText
    AmmoReserveText_1.TextColor3 = v6 and v6 <= 0 and Color3.fromRGB(255, 50, 50) or v9 and Color3.fromRGB(
        255,
        255,
        255
    ) or Color3.fromRGB(0, 0, 0)
    arg5.AmmoText.Text = if not v7 then v5 or "" else "\226\136\158"
    local AmmoText_1 = arg5.AmmoText
    AmmoText_1.TextColor3 = v5 and v5 <= 0 and Color3.fromRGB(255, 50, 50) or v9 and Color3.fromRGB(
        255,
        255,
        255
    ) or Color3.fromRGB(0, 0, 0)
    local AmmoIcon = arg5.AmmoIcon
    AmmoIcon.Visible = v5 ~= nil
    local AmmoIcon_1 = arg5.AmmoIcon
    AmmoIcon_1.ImageColor3 = v6 and arg5.AmmoReserveText.TextColor3 or arg5.AmmoText.TextColor3
    local AmmoIcon_2 = arg5.AmmoIcon
    AmmoIcon_2.ImageTransparency = v6 and arg5.AmmoReserveText.TextTransparency or arg5.AmmoText.TextTransparency
    arg5._infinite_particles:SetActive(v7, v8)
    arg5:_UpdateSize()
end

function t.UpdateVisuals(arg6) -- line: 99
    local v11 = arg6.ClientItem:IsMainItem()
    local ItemNameText_3 = arg6.ItemNameText
    ItemNameText_3.TextColor3 = v11 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    arg6.ItemNameText.TextTransparency = if not v11 then 0.7 else 0
    arg6.AmmoText.TextTransparency = if not v11 then 0.7 else 0
    arg6.AmmoReserveText.TextTransparency = if not v11 then 0.7 else 0
    arg6:UpdateAmmo()
    arg6:UpdateVisibility()
    arg6:_UpdateSize()
end

function t.Update(arg7, arg8, _) -- line: 113
    arg7._infinite_particles:Update(arg8)
end

function t.Destroy(arg10) -- line: 117
    arg10._infinite_particles:Destroy()

    for _, val in pairs(arg10._connections) do
        val:Disconnect()
    end

    arg10.Frame:Destroy()
end

function t._UpdateSize(arg11) -- line: 131
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v13 = if PlayerDataController_m:GetSetting("Equipped Weapon Display") == "Legacy" then 1 else 0.275
    local v14 = if arg11.ClientItem:IsMainItem() then 1 else 0.5
    local v15 = if not arg11.AmmoIcon.Visible then 0.5 else 1
    arg11.Frame.Size = UDim2.new(v13 * v14, 0, v13 * v14 * v15, 0)
end

function t._UpdateLayouts(arg12) -- line: 139
    arg12.AmmoFrame.Size = UDim2.new(0, arg12.AmmoText.TextBounds.X, 1, 0)
    arg12.AmmoReserveFrame.Size = UDim2.new(0, arg12.AmmoReserveText.TextBounds.X, 1, 0)
end

function t._Setup(arg13) -- line: 144
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] WeaponStatusHandler_m (copy)

    arg13.WeaponIcon.Image = arg13.ClientItem.ViewModel:GetImage()
    local AmmoIcon_3 = arg13.AmmoIcon
    AmmoIcon_3.Image = arg13.ClientItem.Info.AmmoType and ItemLibrary_m.Ammos[arg13.ClientItem.Info.AmmoType].Image or ""
    arg13.ItemNameText.Text = arg13.ClientItem.Name
    arg13.NameContainer.ClipsDescendants = false
    WeaponStatusHandler_m:ApplyItemStatusToText(arg13.ItemNameText, arg13.ClientItem.Info.Status)
end

function t._Init(arg14) -- line: 156
    arg14.AmmoText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 157
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateLayouts()
    end)
    arg14.AmmoReserveText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateLayouts()
    end)
    local Connections = arg14._connections
    local Ammo = arg14.ClientItem:GetDataChangedSignal("Ammo")
    table.insert(Connections, Ammo:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:UpdateAmmo()
    end))
    local Connections_1 = arg14._connections
    local AmmoReserve = arg14.ClientItem:GetDataChangedSignal("AmmoReserve")
    table.insert(Connections_1, AmmoReserve:Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:UpdateAmmo()
    end))
    table.insert(arg14._connections, arg14.ClientItem.EquippedChanged:Connect(function() -- line: 173
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:UpdateVisuals()
    end))
    arg14:_Setup()
    arg14:_UpdateLayouts()
    arg14:UpdateAmmo()
    arg14:UpdateVisuals()
    arg14:UpdateVisibility()
    arg14:UpdateParent()
end

return t
