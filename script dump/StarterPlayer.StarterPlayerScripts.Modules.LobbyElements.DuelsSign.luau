local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 13
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 25
    -- upvalues:
    --  [1] CollectionService (copy)

    for _, val in pairs(CollectionService:GetTagged("LobbyDuelsSign")) do
        local now = tick()
        local Yellow = val.Yellow
        local v5 = arg1:_GetOriginalPivot(val.Yellow) + Vector3.new(
            0,
            math.cos(now) ^ 3 - math.sin(now) ^ 3,
            0
        ) * 0.5
        Yellow:PivotTo(v5)
        local Purple = val.Purple
        local v6 = arg1:_GetOriginalPivot(val.Purple)
        local v8 = v6 + Vector3.new(
            0,
            math.cos(now - 3.141592653589793) ^ 3 - math.sin(now - 3.141592653589793) ^ 3,
            0
        ) * 0.5
        Purple:PivotTo(v8)
    end
end

function t._Setup(_) -- line: 38
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] CollectionService (copy)

    local function object_added(arg4) -- line: 50
        -- upvalues:
        --  [1] CONSTANTS_m (ref)

        arg4:WaitForChild("Screen"):WaitForChild("Duels").Enabled = CONSTANTS_m.QUEUES_ACTIVE
        arg4:WaitForChild("Screen"):WaitForChild("Play").Enabled = not CONSTANTS_m.QUEUES_ACTIVE
    end

    CollectionService:GetInstanceAddedSignal("LobbyDuelsSign"):Connect(object_added)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyDuelsSign")) do
        val_1:WaitForChild("Screen"):WaitForChild("Duels").Enabled = CONSTANTS_m.QUEUES_ACTIVE
        val_1:WaitForChild("Screen"):WaitForChild("Play").Enabled = not CONSTANTS_m.QUEUES_ACTIVE
    end
end

function t._Init(arg5) -- line: 63
    arg5:_Setup()
end

return t._new()
