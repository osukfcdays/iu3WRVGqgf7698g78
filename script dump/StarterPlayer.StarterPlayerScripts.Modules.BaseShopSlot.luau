local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local CurrencyLibrary_m = require(ReplicatedStorage.Modules.CurrencyLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] PlayerDataController_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.ShopEntry = arg1
    t_1.FirstRewardData = t_1.ShopEntry.Rewards[1]
    t_1.IsOwned = CosmeticLibrary_m:OwnsCosmetic(
        PlayerDataController_m:Get("CosmeticInventory"),
        t_1.FirstRewardData.Name,
        t_1.FirstRewardData.Weapon
    )
    local v5 = t_1.FirstRewardData.Weapon

    if v5 then
        v5 = if t_1.FirstRewardData.Weapon ~= "IsRandom" then if t_1.FirstRewardData.Weapon ~= "IsUniversal" then not PlayerDataController_m:GetWeaponData(
            t_1.FirstRewardData.Weapon
        ) else false else false
    end

    t_1.IsLockedRaw = v5
    t_1.IsLocked = arg2 or false
    t_1:_Init()

    return t_1
end

function t.OnClick(_, _) -- line: 31
    assert(false, "Not implemented")
end

function t.Destroy(_) -- line: 35
end

function t._GetLowestQuantityProductID(arg6) -- line: 43
    if not arg6.ShopEntry.ProductIDs then
        return nil
    end

    local t_2 = {}

    for key, val in pairs(arg6.ShopEntry.ProductIDs) do
        table.insert(t_2, { val, key })
    end

    table.sort(t_2, function(arg7, arg8) -- line: 54
        return arg7[1] < arg8[1]
    end)

    return t_2[1][2]
end

function t._SetupBuyButton(arg9, arg10, arg11) -- line: 61
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] CurrencyLibrary_m (copy)
    --  [3] Utility_m (copy)
    --  [4] MonetizationController_m (copy)

    local v7 = CurrencyLibrary_m.Info[arg9.ShopEntry.MainCurrency]
    local v8 = arg9.ShopEntry.Prices[arg9.ShopEntry.MainCurrency]
    local v9 = CosmeticLibrary_m.Cosmetics[arg9.FirstRewardData.Name]
    local v10 = arg9:_GetLowestQuantityProductID()

    if arg11 then
        arg11.Visible = arg9.IsOwned
    end

    arg10.Visible = not arg9.IsOwned
    arg10.Limited.Visible = false
    local Locked = arg10.Locked
    local v11 = not arg10.Limited.Visible

    if v11 then
        v11 = arg9.IsLocked
    end

    Locked.Visible = v11
    local Price = arg10.Price
    v11 = not arg10.Limited.Visible and not arg9.IsLocked and arg9.ShopEntry.MainCurrency and v8 > 0
    Price.Visible = v11
    local Free = arg10.Free
    v11 = not arg10.Limited.Visible and not arg9.IsLocked and arg9.ShopEntry.MainCurrency and v8 == 0
    Free.Visible = v11
    local Robux = arg10.Robux
    v11 = not arg10.Limited.Visible and not arg9.IsLocked and v10
    Robux.Visible = v11
    arg10.Size = v9 and UDim2.new(0.5, 0, 0.25, 0) or UDim2.new(0.625, 0, 0.3125, 0)

    if arg10.Price.Visible then
        arg10.Price.Value.Text = Utility_m:PrettyNumber(v8)
        arg10.Price.Value.Icon.Image = v7.ImageFlatOutline
        arg10.Price.Value.Icon.ImageLabel.Image = v7.ImageFlat
        arg10.Price.Background.ImageColor3 = v7.Color
        arg10.Price.Background.UIGradient.Color = v7.ColorGradient
    end

    if v10 then
        MonetizationController_m:SetRobuxText(arg10.Robux.Value, v10, Enum.InfoType.Product)
    end

    for _, val_1 in pairs({ "Locked", "Price", "Free", "Robux", "Limited" }) do
        if not arg10[val_1].Visible then
            arg10[val_1]:Destroy()
        end
    end

    if arg10:FindFirstChild("Price") then
        local Value_1 = arg10.Price.Value
        local Icon = Value_1.Icon

        local function update() -- line: 101
            -- upvalues:
            --  [1] Icon (copy)
            --  [2] Value_1 (copy)

            Icon.Position = UDim2.new(0.5, Value_1.TextBounds.X / 2, 0.5, 0)
        end

        Value_1:GetPropertyChangedSignal("TextBounds"):Connect(update)
        arg10.AncestryChanged:Connect(update)
        Icon.Position = UDim2.new(0.5, Value_1.TextBounds.X / 2, 0.5, 0)
    end
end

function t._Init(_) -- line: 111
end

return t
