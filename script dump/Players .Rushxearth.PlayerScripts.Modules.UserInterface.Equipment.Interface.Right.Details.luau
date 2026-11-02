local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local EquipmentDetailsDescription = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentDetailsDescription"
)
local t = { "Lookin' good!" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.Right = arg1
    t_2.Frame = t_2.Right.Container:WaitForChild("Details")
    t_2.Container = t_2.Frame:WaitForChild("Container")
    t_2.Title = t_2.Container:WaitForChild("Title")
    t_2.Icon = t_2.Container:WaitForChild("Icon")
    t_2.Headshot = t_2.Container:WaitForChild("Headshot")
    t_2.DescriptionsFrame = t_2.Container:WaitForChild("Descriptions")
    t_2.DescriptionsLayout = t_2.DescriptionsFrame:WaitForChild("Layout")
    t_2.FavoritedFrame = t_2.Container:WaitForChild("Favorited")
    t_2.FavoritedButton = t_2.FavoritedFrame:WaitForChild("Button")
    t_2.FavoritedFilled = t_2.FavoritedButton:WaitForChild("Filled")
    t_2.FavoritedEmpty = t_2.FavoritedButton:WaitForChild("Empty")
    t_2._cleanup = {}
    t_2:_Init()

    return t_2
end

function t_1.OnStateChanged(arg2) -- line: 46
    arg2:_Generate()
end

function t_1._Generate(arg3) -- line: 54
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] Players (copy)
    --  [6] ComplianceController_m (copy)
    --  [7] t (copy)
    --  [8] ItemLibrary_m (copy)
    --  [9] StatisticsLibrary_m (copy)

    for _, val in pairs(arg3._cleanup) do
        WeaponStatusHandler_m:ClearStatusElements(val)
        val:Destroy()
    end

    arg3._cleanup = {}
    WeaponStatusHandler_m:ClearStatusElements(arg3.Title)
    local v1 = arg3.Right.Interface.Equipment:IsCareerPageOpen()
    local v2 = arg3.Right.Interface.Equipment:GetSelectedWeapon()
    local _, v6, v7, _ = ShopLibrary_m:GetWeaponKeyPriceInfo(
        v2,
        PlayerDataController_m:Get("UnlockTokens"),
        PlayerDataController_m:Get("FreeWeaponUnlockCheck")
    )
    local v9 = ShopLibrary_m:GetTimeUntilWeaponRelease(v2)
    v6 = not v7

    if v6 then
        v6 = v9 > 0
    end

    v9 = v1 or v2 and not v6
    arg3.Frame.Visible = v9

    if not v9 then
        return
    end

    v9 = v2

    if v9 then
        v9 = if PlayerDataController_m:GetWeaponData(v2) == nil then false else true
    end

    v7 = v2

    if v7 then
        v7 = PlayerDataController_m:GetFavoritedWeapons()[v2]
    end

    arg3.FavoritedFrame.Visible = v9
    arg3.FavoritedFilled.Visible = v7
    arg3.FavoritedEmpty.Visible = not v7

    if v1 then
        arg3.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, Players.LocalPlayer.UserId)
        arg3.Icon.Image = ""
        arg3.Title.AutoLocalize = false
        arg3.Title.Text = ComplianceController_m:GetName(Players.LocalPlayer)

        if Players.LocalPlayer.Name ~= Players.LocalPlayer.DisplayName then
            v9 = "\226\128\162 Also known as @" .. Players.LocalPlayer.Name
            arg3:_CreateDescription(v9, if #v9 > 34 then 2 else 1)
        end

        arg3:_CreateDescription("\226\128\162 " .. t[math.random(#t)], 1)

        return
    end

    if v2 then
        v6 = ItemLibrary_m.Items[v2]
        local v12 = StatisticsLibrary_m.Items[v2]
        local v13 = PlayerDataController_m:GetWeaponData(v2)
        arg3.Headshot.Image = ""
        local Icon = arg3.Icon
        Icon.Image = v13 and ItemLibrary_m:GetViewModelImageFromWeaponData(v13) or ""
        arg3.Title.Text = v2
        arg3.Title.AutoLocalize = true
        WeaponStatusHandler_m:ApplyItemStatusToText(arg3.Title, v6.Status)
        WeaponStatusHandler_m:ApplyItemStatusToText(
            arg3:_CreateDescription("\226\128\162 " .. v6.Status .. " " .. v6.Class, 1),
            v6.Status
        )
        local v17 = pairs
        local v18 = v12 and v12.Descriptions or {}

        for _, val_1 in v17(v18) do
            local v19, v20 = table.unpack(val_1)
            arg3:_CreateDescription("\226\128\162 " .. v20, v19)
        end
    end
end

function t_1._CreateDescription(arg4, arg5, arg6) -- line: 120
    -- upvalues:
    --  [1] EquipmentDetailsDescription (copy)

    local v23 = EquipmentDetailsDescription:Clone()
    v23.Text = arg5
    v23.Size = UDim2.new(0.75, 0, 0.05 * arg6, 0)
    v23.LayoutOrder = #arg4._cleanup
    v23.Parent = arg4.DescriptionsFrame
    table.insert(arg4._cleanup, v23)

    return v23
end

function t_1._Update(arg7) -- line: 131
    arg7.Frame.Size = UDim2.new(
        1,
        0,
        0,
        (arg7.DescriptionsFrame.AbsolutePosition.Y - arg7.Frame.AbsolutePosition.Y) * 1.25 + arg7.DescriptionsLayout.AbsoluteContentSize.Y
    )
end

function t_1._Init(arg8) -- line: 135
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg8.DescriptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 136
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Update()
    end)
    arg8.FavoritedButton.MouseButton1Click:Connect(function() -- line: 140
        -- upvalues:
        --  [1] arg8 (copy)

        arg8.Right.Interface.Equipment:FavoriteWeapon()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 144
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Generate()
    end)
    arg8:_Update()
    ButtonEffect_m:Add(arg8.FavoritedButton)
end

return t_1
