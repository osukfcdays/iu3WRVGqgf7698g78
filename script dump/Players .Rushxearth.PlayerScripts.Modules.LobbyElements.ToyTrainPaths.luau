local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ToyTrainPath_m = require(Players.LocalPlayer.PlayerScripts.Modules.ToyTrainPath)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 10
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1.Objects = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 24
    for _, val in pairs(arg1.Objects) do
        val:Update(arg2)
    end
end

function t._ObjectAdded(arg3, arg4) -- line: 34
    -- upvalues:
    --  [1] ToyTrainPath_m (copy)

    local v3 = ToyTrainPath_m.new(arg4)
    table.insert(arg3.Objects, v3)
end

function t._Init(arg5) -- line: 39
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyToyTrainPath"):Connect(function(arg6) -- line: 40
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectAdded(arg6)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyToyTrainPath")) do
        task.defer(arg5._ObjectAdded, arg5, val_1)
    end
end

return t._new()
