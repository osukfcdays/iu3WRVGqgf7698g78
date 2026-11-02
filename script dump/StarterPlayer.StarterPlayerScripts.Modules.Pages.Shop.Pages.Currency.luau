local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CurrencyLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Pages = arg1
    t_1.Frame = t_1.Pages.Frame:WaitForChild("Currency")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.WeaponKeysFrame = t_1.Container:WaitForChild("WeaponKeys")
    t_1.EventCurrencyFrame = t_1.Container:WaitForChild("EventCurrency")
    t_1.EventCurrencyHeaderIcon = t_1.EventCurrencyFrame:WaitForChild("Header"):WaitForChild("Icon")
    t_1:_Init()

    return t_1
end

function t.Open(_) -- line: 30
end

function t.Close(_) -- line: 34
end

function t.Setup(arg4) -- line: 38
    -- upvalues:
    --  [1] EventLibrary_m (copy)

    for index = 1, 5 do
        local v1 = "keybundle_" .. index
        arg4.Pages.Shop:CreateBundleSlot(v1):SetParent(arg4.WeaponKeysFrame:WaitForChild(v1))
    end

    if EventLibrary_m.IS_ACTIVE then
        for index_1 = 1, 5 do
            local v3 = "eventcurrencybundle_" .. index_1
            arg4.Pages.Shop:CreateBundleSlot(v3):SetParent(arg4.EventCurrencyFrame:WaitForChild(v3))
        end
    end
end

function t._UpdateEvent(arg5) -- line: 56
    -- upvalues:
    --  [1] EventLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    local v5 = EventLibrary_m.IS_ACTIVE

    if v5 then
        v5 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") >= EventLibrary_m.NUM_GAMES_NEEDED_TO_PARTICIPATE and true
    end

    arg5.EventCurrencyFrame.Visible = v5
    local v6 = if not v5 then 1 else 2.35
    arg5.Frame.Size = UDim2.new(1, 0, v6, 0)
end

function t._Setup(arg6) -- line: 63
    -- upvalues:
    --  [1] EventLibrary_m (copy)

    arg6.EventCurrencyHeaderIcon.Image = EventLibrary_m.EVENT_DETAILS.CURRENCY_IMAGE_FLAT
end

function t._Init(arg7) -- line: 67
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 68
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateEvent()
    end)
    arg7:_Setup()
    arg7:_UpdateEvent()
end

return t
