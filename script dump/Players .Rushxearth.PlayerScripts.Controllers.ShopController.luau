local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t._new() -- line: 12
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.DailyShopRefreshed = Signal_m.new()
    t_1.DailyShop = {}
    t_1.DailyShopDay = nil
    t_1._fetched_daily_shop = false
    t_1._refresh_time = 0
    t_1:_Init()

    return t_1
end

function t.GetDailyShopRefreshTimeRemaining(arg1) -- line: 32
    local ceiling = math.ceil(arg1._refresh_time - tick())

    return (math.max(0, ceiling))
end

function t.GetDailyShop(arg2) -- line: 36
    if not arg2._fetched_daily_shop then
        task.defer(arg2._FetchDailyShop, arg2)
    end

    return arg2.DailyShop
end

function t.GetShopEntry(arg3, arg4) -- line: 44
    -- upvalues:
    --  [1] ShopLibrary_m (copy)

    if ShopLibrary_m.Entries[arg4] then
        return ShopLibrary_m.Entries[arg4]
    end

    for _, val in pairs(arg3:GetDailyShop()) do
        if val.EntryName == arg4 then
            return val
        end
    end
end

function t.UpdateDailyShop(arg5, arg6) -- line: 56
    local v2 = arg6 or {}
    arg5.DailyShop = v2
    arg5.DailyShopRefreshed:Fire()
end

function t.UpdateDailyShopCountdown(arg7, arg8) -- line: 61
    arg7._refresh_time = tick() + (arg8 or 0)
end

function t.PurchaseShopEntry(arg9, arg10, arg11, arg12) -- line: 65
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    local v3 = arg9:GetShopEntry(arg10)
    assert(if v3 == nil then false else true)

    if arg11 then
        ReplicatedStorage.Remotes.Data.BuyShopEntry:FireServer(
            v3.EntryName,
            arg11,
            1,
            arg9:_GetIntendedDailyShopDay()
        )

        return
    end

    ReplicatedStorage.Remotes.Data.BuyShopEntryRobux:FireServer(
        v3.EntryName,
        arg12,
        arg9:_GetIntendedDailyShopDay()
    )
end

function t.BuyDailyShopRefresh(arg13) -- line: 77
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Data.RefreshDailyShop:FireServer(arg13:_GetIntendedDailyShopDay())
end

function t._GetIntendedDailyShopDay(arg14) -- line: 85
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if not arg14.DailyShopDay then
        warn("self.DailyShopDay is nil")
        task.spawn(arg14._FetchDailyShop, arg14)

        return -1
    end

    return arg14.DailyShopDay + PlayerDataController_m:Get("DailyShopSeedShift")
end

function t._UpdateDailyShop(arg15, arg16) -- line: 95
    local v5 = arg16 or {}
    arg15.DailyShopDay = v5.Day
    arg15:UpdateDailyShopCountdown(v5.TimeRemaining)
    arg15:UpdateDailyShop(v5.Data)
end

function t._FetchDailyShop(arg17) -- line: 103
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if arg17._fetched_daily_shop then
        return
    end

    arg17._fetched_daily_shop = true

    while true do
        local Success, Result = pcall(
            ReplicatedStorage.Remotes.Data.RequestDailyShop.InvokeServer,
            ReplicatedStorage.Remotes.Data.RequestDailyShop
        )

        if not Success then
            continue
        end

        arg17:_UpdateDailyShop(Result)

        return
    end
end

function t._Init(arg18) -- line: 120
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Data.UpdateDailyShop.OnClientEvent:Connect(function(...) -- line: 121
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateDailyShop(...)
    end)
end

return t._new()
