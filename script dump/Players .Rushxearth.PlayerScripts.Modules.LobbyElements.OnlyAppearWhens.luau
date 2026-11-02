local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 11
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1._stored_objects = {}
    t_1:_Init()

    return t_1
end

function t._CheckParent(arg1, arg2) -- line: 31
    -- upvalues:
    --  [1] ServerOsTime_m (copy)

    task.defer(function() -- line: 32
        -- upvalues:
        --  [1] ServerOsTime_m (ref)
        --  [2] arg1 (copy)
        --  [3] arg2 (copy)

        local v2 = ServerOsTime_m:Get()
        local v3 = arg1._stored_objects[arg2]
        local v4 = if v2 >= v3.StartTime then v2 < v3.EndTime else false
        arg2.Parent = if not (if v3.Inverse then not v4 else v4) then nil else v3.OriginalParent
    end)
end

function t._DelayedCheck(arg3, arg4, arg5) -- line: 43
    if arg5 > 0 and arg5 < math.huge then
        task.delay(arg5, arg3._CheckParent, arg3, arg4)
    end
end

function t._ObjectAdded(arg6, arg7) -- line: 49
    -- upvalues:
    --  [1] ServerOsTime_m (copy)

    if arg6._stored_objects[arg7] then
        return
    end

    local t_2 = {
        OriginalParent = arg7.Parent,
        StartTime = arg7:GetAttribute("StartTime") or 0,
        EndTime = arg7:GetAttribute("EndTime") or math.huge,
        Inverse = arg7:GetAttribute("Inverse") or false
    }
    local v5
    arg6._stored_objects[arg7], v5 = t_2, arg7
    arg6:_DelayedCheck(v5, t_2.StartTime - ServerOsTime_m:Get())
    arg6:_DelayedCheck(arg7, t_2.EndTime - ServerOsTime_m:Get())
    arg6:_CheckParent(arg7)
end

function t._Init(arg8) -- line: 68
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyOnlyAppearWhen"):Connect(function(arg9) -- line: 69
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_ObjectAdded(arg9)
    end)

    for _, val in pairs(CollectionService:GetTagged("LobbyOnlyAppearWhen")) do
        task.spawn(arg8._ObjectAdded, arg8, val)
    end
end

return t._new()
