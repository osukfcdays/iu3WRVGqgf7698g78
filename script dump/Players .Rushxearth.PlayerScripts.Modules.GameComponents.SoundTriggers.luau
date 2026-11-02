local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._objects = {}
    t_1:_Init()

    return t_1
end

function t._ObjectAdded(arg1, arg2) -- line: 33
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] Utility_m (copy)

    local SoundID = arg2:GetAttribute("SoundID")
    local Volume = arg2:GetAttribute("Volume")
    local t_2 = { Connections = {}, Cooldowns = {} }
    table.insert(t_2.Connections, arg2.Touched:Connect(function(otherPart: BasePart) -- line: 42
        -- upvalues:
        --  [1] FighterController_m (ref)
        --  [2] t_2 (copy)
        --  [3] Utility_m (ref)
        --  [4] SoundID (copy)
        --  [5] Volume (copy)
        --  [6] arg2 (copy)

        local v2 = otherPart.AssemblyRootPart or otherPart
        local v3 = v2

        if v3 then
            v3 = FighterController_m:GetFighter(v2.Parent)
        end

        if not v3 or not v3:IsAlive() or tick() < (t_2.Cooldowns[v2] or 0) then
            return
        end

        t_2.Cooldowns[v2] = tick() + 1
        Utility_m:CreateSound(
            SoundID,
            Volume or 1,
            0.95 + 0.1 * math.random(),
            arg2,
            true,
            10
        )
    end))
    arg1._objects[arg2] = t_2
end

function t._ObjectRemoved(arg4, arg5) -- line: 58
    local v8 = arg4._objects[arg5]

    if not v8 then
        return
    end

    for _, val in pairs(v8.Connections) do
        val:Disconnect()
    end

    arg4._objects[arg5] = nil
end

function t._Init(arg6) -- line: 72
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("SoundTrigger"):Connect(function(arg7) -- line: 73
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_ObjectAdded(arg7)
    end)
    CollectionService:GetInstanceRemovedSignal("SoundTrigger"):Connect(function(arg8) -- line: 77
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_ObjectRemoved(arg8)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("SoundTrigger")) do
        task.defer(arg6._ObjectAdded, arg6, val_1)
    end
end

return t._new()
