local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local t = {}
t.__index = t

function t._new() -- line: 7
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._connections = {}
    t_1:_Init()

    return t_1
end

function t._ObjectRemoved(arg1, arg2) -- line: 27
    if arg1._connections[arg2] then
        arg1._connections[arg2]:Disconnect()
        arg1._connections[arg2] = nil
    end
end

function t._ObjectAdded(arg3, arg4) -- line: 34
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg3:_ObjectRemoved(arg4)
    arg3._connections[arg4] = arg4.Triggered:Connect(function() -- line: 37
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg4 (copy)

        ReplicatedStorage.Remotes.Replication.Fighter.SnowballGrab:FireServer(arg4)
    end)
end

function t._Init(arg5) -- line: 42
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbySnowballSource"):Connect(function(arg6) -- line: 43
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectAdded(arg6)
    end)
    CollectionService:GetInstanceRemovedSignal("LobbySnowballSource"):Connect(function(arg7) -- line: 47
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectRemoved(arg7)
    end)

    for _, val in pairs(CollectionService:GetTagged("LobbySnowballSource")) do
        task.spawn(arg5._ObjectAdded, arg5, val)
    end
end

return t._new()
