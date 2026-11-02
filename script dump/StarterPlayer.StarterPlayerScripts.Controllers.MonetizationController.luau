local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.PurchaseStarted = Signal_m.new()
    t_1.PurchaseFinished = Signal_m.new()
    t_1._fetch_robux_price_hashes = {}
    t_1:_Init()

    return t_1
end

function t.PromptBulkPurchase(arg1, arg2) -- line: 30
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    assert(
        if typeof(arg2) ~= "table" then false else true,
        "Argument 1 invalid, expected a table, got " .. tostring(arg2)
    )
    ReplicatedStorage.Remotes.Misc.PromptBulkPurchase:FireServer(arg2)
    arg1:_StartPrompt()
end

function t.PromptPurchase(arg3, arg4) -- line: 37
    -- upvalues:
    --  [1] MarketplaceService (copy)
    --  [2] Players (copy)

    assert(
        if typeof(arg4) ~= "number" then false else true,
        "Argument 1 invalid, expected a number, got " .. tostring(arg4)
    )
    MarketplaceService:PromptPurchase(Players.LocalPlayer, arg4)
    arg3:_StartPrompt()
end

function t.PromptProductPurchase(arg5, arg6) -- line: 45
    -- upvalues:
    --  [1] MarketplaceService (copy)
    --  [2] Players (copy)

    assert(
        if typeof(arg6) ~= "number" then false else true,
        "Argument 1 invalid, expected a number, got " .. tostring(arg6)
    )
    MarketplaceService:PromptProductPurchase(Players.LocalPlayer, arg6)
    arg5:_StartPrompt()
end

function t.PromptGamePassPurchase(arg7, arg8) -- line: 53
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] MarketplaceService (copy)
    --  [4] Players (copy)

    assert(
        if typeof(arg8) ~= "number" then false else true,
        "Argument 1 invalid, expected a number, got " .. tostring(arg8)
    )

    if PlayerDataController_m:HasGamepass(MonetizationLibrary_m:GetGamepassName(arg8)) then
        return
    end

    MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, arg8)
    arg7:_StartPrompt()
end

function t.PromptSubscriptionPurchase(arg9, arg10) -- line: 65
    -- upvalues:
    --  [1] MarketplaceService (copy)
    --  [2] Players (copy)

    assert(
        if typeof(arg10) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg10)
    )
    MarketplaceService:PromptSubscriptionPurchase(Players.LocalPlayer, arg10)
    arg9:_StartPrompt()
end

function t.PromptCurrencyBundlePurchase(arg11, arg12, arg13) -- line: 72
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] MonetizationLibrary_m (copy)

    local v8 = arg12 - PlayerDataController_m:Get(arg13)

    if v8 <= 0 then
        return
    end

    local v9 = if arg13 ~= "WeaponKeys" then if arg13 ~= "EventCurrency" then nil else MonetizationLibrary_m.NUM_EVENT_CURRENCY_BUNDLES or nil else MonetizationLibrary_m.NUM_KEY_BUNDLES or (if arg13 ~= "EventCurrency" then nil else MonetizationLibrary_m.NUM_EVENT_CURRENCY_BUNDLES or nil)
    local v10 = if arg13 ~= "WeaponKeys" then if arg13 ~= "EventCurrency" then nil else "eventcurrencybundle_" else "keybundle_"

    if not v9 or not v10 then
        return
    end

    for index = 1, v9 do
        local v11 = MonetizationLibrary_m.Bundles[v10 .. index]

        if v8 <= v11.Rewards[1].Quantity then
            arg11:PromptProductPurchase(v11.ProductID)

            return true
        end
    end
end

function t.FetchRobuxPrice(_, arg15, arg16) -- line: 96
    -- upvalues:
    --  [1] MarketplaceService (copy)

    local GetProductInfoAsync = MarketplaceService.GetProductInfoAsync
    local Success, GetProductInfoAsync = pcall(
        GetProductInfoAsync,
        MarketplaceService,
        arg15,
        arg16 or Enum.InfoType.Product
    )

    if not Success then
        warn("Failed to fetch robux price:", GetProductInfoAsync)
    end

    return Success and GetProductInfoAsync and GetProductInfoAsync.PriceInRobux
end

function t.SetRobuxText(arg17, arg18, ...) -- line: 106
    arg17._fetch_robux_price_hashes[arg18] = (arg17._fetch_robux_price_hashes[arg18] or 0) + 1
    local v15 = arg17._fetch_robux_price_hashes[arg18]
    task.spawn(function(...) -- line: 110
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] arg17 (copy)
        --  [3] v15 (copy)

        arg18.Text = "\226\128\162 \226\128\162 \226\128\162"
        local v16 = arg18
        v16.Text = arg17:_GetRobuxText(v15, arg18, ...) or arg18.Text
    end, ...)
end

function t.SetRobuxTextWithFormat(arg19, arg20, arg21, ...) -- line: 116
    arg19._fetch_robux_price_hashes[arg21] = (arg19._fetch_robux_price_hashes[arg21] or 0) + 1
    local v18 = arg19._fetch_robux_price_hashes[arg21]
    task.spawn(function(...) -- line: 120
        -- upvalues:
        --  [1] arg21 (copy)
        --  [2] arg19 (copy)
        --  [3] v18 (copy)
        --  [4] arg20 (copy)

        arg21.Text = "\226\128\162 \226\128\162 \226\128\162"
        local v19 = arg19:_GetRobuxText(v18, arg21, ...)

        if not v19 then
            return
        end

        arg21.Text = string.format(arg20, v19)
    end, ...)
end

function t.VerifyUGC(_, arg23) -- line: 133
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Data.VerifyUGC:FireServer(arg23)
end

function t._GetRobuxText(arg24, arg25, arg26, ...) -- line: 141
    -- upvalues:
    --  [1] Utility_m (copy)

    local t_2 = { ... }
    local v21 = 0

    for index_1 = 1, #t_2, 2 do
        local v22 = arg24:FetchRobuxPrice(t_2[index_1], t_2[index_1 + 1])

        if arg25 ~= arg24._fetch_robux_price_hashes[arg26] or not v22 then
            return
        end

        v21 += v22
    end

    return utf8.char(57346) .. " " .. Utility_m:PrettyNumber(v21)
end

function t._StartPrompt(arg27) -- line: 160
    arg27.PurchaseStarted:Fire()
end

function t._FinishPrompt(arg28, arg29) -- line: 164
    arg28.PurchaseFinished:Fire(arg29)
end

function t._Init(arg30) -- line: 168
    -- upvalues:
    --  [1] MarketplaceService (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] ReplicatedStorage (copy)

    MarketplaceService.PromptBulkPurchaseFinished:Connect(function(_, _, arg33) -- line: 169
        -- upvalues:
        --  [1] arg30 (copy)
        --  [2] MonetizationLibrary_m (ref)

        local v23 = false

        for _, val in pairs(arg33.Items) do
            if val.status == Enum.MarketplaceItemPurchaseStatus.Success then
                v23 = true
                break
            end
        end

        arg30:_FinishPrompt(v23)

        if v23 then
            local t_3 = {}

            for _, val_1 in pairs(arg33.Items) do
                local v24 = MonetizationLibrary_m.UGCAssetIDToName[tostring(val_1.id)]

                if v24 then
                    table.insert(t_3, v24)
                end
            end

            if #t_3 > 0 then
                arg30:VerifyUGC(t_3)
            end
        end
    end)
    ReplicatedStorage.Remotes.Misc.StartPurchasePrompt.OnClientEvent:Connect(function() -- line: 198
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_StartPrompt()
    end)
    ReplicatedStorage.Remotes.Misc.FinishPurchasePrompt.OnClientEvent:Connect(function(arguments) -- line: 202
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_FinishPrompt(arguments)
    end)
end

return t._new()
