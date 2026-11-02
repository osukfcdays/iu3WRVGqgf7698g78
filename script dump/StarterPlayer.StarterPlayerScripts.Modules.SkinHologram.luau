local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ShopController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.ShopController)
local StaticViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Part = arg1
    t_1.HologramViewModel = nil
    t_1.SkinViewModel = nil
    t_1._connections = {}
    t_1._index = 0
    t_1._next_increment = 0
    t_1._last_change = 0
    t_1:_Init()

    return t_1
end

function t.Set(arg2, arg3) -- line: 34
    -- upvalues:
    --  [1] StaticViewModel_m (copy)

    if arg2.HologramViewModel then
        arg2.HologramViewModel:Destroy()
        arg2.HologramViewModel = nil
    end

    if arg2.SkinViewModel then
        arg2.SkinViewModel:Destroy()
        arg2.SkinViewModel = nil
    end

    if not arg3 then
        return
    end

    arg2._last_change = tick()
    arg2.HologramViewModel = StaticViewModel_m.new(arg3)
    arg2.HologramViewModel:SetWrap({ Name = "Hologram" })
    arg2.HologramViewModel:ScaleTo(4)
    arg2.SkinViewModel = StaticViewModel_m.new(arg3)
    arg2.SkinViewModel:ScaleTo(4)
    arg2:Update(0)
end

function t.Increment(arg4, arg5) -- line: 61
    local v1 = arg4:_GetSkinNames()

    if #v1 == 0 then
        arg4:Set(nil)

        return
    end

    arg4._index = if not arg5 then arg4._index % #v1 + 1 else (arg4._index - 1) % #v1 + 1
    arg4:Set(v1[arg4._index])
end

function t.Update(arg6, _) -- line: 72
    if tick() > arg6._next_increment then
        arg6._next_increment = tick() + 10
        arg6:Increment()
    end

    local v4 = tick() - arg6._last_change
    local v3 = if v4 > 1.5 then false else if math.floor(10 * v4 - v4 ^ 3) % 2 ~= 1 then false else true

    if arg6.HologramViewModel then
        arg6.HologramViewModel:PivotTo(arg6.Part.CFrame)
        arg6.HologramViewModel:SetParent(if v3 then arg6.Part else nil)
    end

    if arg6.SkinViewModel then
        arg6.SkinViewModel:PivotTo(arg6.Part.CFrame)
        arg6.SkinViewModel:SetParent(if v3 then nil else arg6.Part)
    end
end

function t.Destroy(arg8) -- line: 92
    for _, val in pairs(arg8._connections) do
        val:Disconnect()
    end

    arg8._connections = {}
    arg8:Set(nil)
end

function t._GetSkinNames(_) -- line: 106
    -- upvalues:
    --  [1] ShopController_m (copy)
    --  [2] CosmeticLibrary_m (copy)

    local t_2 = {}

    for _, val_1 in pairs(ShopController_m:GetDailyShop()) do
        local v7 = val_1.Rewards[1]

        if CosmeticLibrary_m.Cosmetics[v7.Name].Type == "Skin" then
            table.insert(t_2, v7.Name)
        end
    end

    return t_2
end

function t._Init(arg10) -- line: 121
    -- upvalues:
    --  [1] ShopController_m (copy)

    table.insert(arg10._connections, ShopController_m.DailyShopRefreshed:Connect(function() -- line: 122
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Increment(true)
    end))
end

return t
