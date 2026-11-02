local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local LeaderboardDisplay_m = require(Players.LocalPlayer.PlayerScripts.Modules.LeaderboardDisplay)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 10
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1.Displays = {}
    t_1:_Init()

    return t_1
end

function t._DisplayAdded(arg1, arg2) -- line: 30
    -- upvalues:
    --  [1] LeaderboardDisplay_m (copy)

    local v3 = LeaderboardDisplay_m.new(arg2)
    table.insert(arg1.Displays, v3)
end

function t._Init(arg3) -- line: 35
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LeaderboardDisplay"):Connect(function(arg4) -- line: 36
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_DisplayAdded(arg4)
    end)

    for _, val in pairs(CollectionService:GetTagged("LeaderboardDisplay")) do
        task.defer(arg3._DisplayAdded, arg3, val)
    end
end

return t._new()
