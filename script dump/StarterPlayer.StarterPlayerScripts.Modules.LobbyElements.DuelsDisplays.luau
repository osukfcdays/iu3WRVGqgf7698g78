local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local DuelsDisplay_m = require(Players.LocalPlayer.PlayerScripts.Modules.DuelsDisplay)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 13
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1.Displays = {}
    t_1:_Init()

    return t_1
end

function t._UpdateEnabled(arg1) -- line: 33
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] Players (copy)

    local v2 = not DuelController_m:GetDuel(Players.LocalPlayer)

    for _, val in pairs(arg1.Displays) do
        val:SetEnabled(v2)
    end
end

function t._DisplayAdded(arg2, arg3, arg4) -- line: 41
    -- upvalues:
    --  [1] DuelsDisplay_m (copy)

    table.insert(arg2.Displays, DuelsDisplay_m.new(arg3))

    if not arg4 then
        arg2:_UpdateEnabled()
    end
end

function t._Init(arg5) -- line: 49
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] CollectionService (copy)

    DuelController_m.LocalPlayerJoinedOrLeftDuel:Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateEnabled()
    end)
    CollectionService:GetInstanceAddedSignal("DuelsDisplay"):Connect(function(arg6) -- line: 58
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_DisplayAdded(arg6)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("DuelsDisplay")) do
        arg5:_DisplayAdded(val_1, true)
    end

    arg5:_UpdateEnabled()
end

return t._new()
