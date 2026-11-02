local _ = game:GetService("CollectionService")
local Players = game:GetService("Players")
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._connections = {}
    t_1._local_fighter = nil
    t_1:_Init()

    return t_1
end

function t._ObjectAdded(_, arg2) -- line: 34
    -- upvalues:
    --  [1] SpectateController_m (copy)

    if
        not SpectateController_m.CurrentSubject
        or not SpectateController_m.CurrentSubject.FighterInterface
        or not arg2:IsDescendantOf(workspace)
        or not arg2.Parent:IsA("BasePart")
    then
        return
    end

    SpectateController_m.CurrentSubject.FighterInterface.AudioVisualizers:Create(
        arg2,
        arg2.RollOffMinDistance,
        arg2.RollOffMaxDistance
    )
end

function t._UpdateEnabled(arg3) -- line: 46
    for _, val in pairs(arg3._connections) do
        val:Disconnect()
    end

    arg3._connections = {}
end

function t._HookLocalFighter(arg4) -- line: 62
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg4._local_fighter = FighterController_m:WaitForLocalFighter()
    arg4._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 65
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateEnabled()
    end)
    arg4._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 69
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateEnabled()
    end)
    arg4:_UpdateEnabled()
end

function t._Init(arg5) -- line: 76
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    PlayerDataController_m:GetSettingChangedSignal("Audio Visualizers"):Connect(function() -- line: 77
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateEnabled()
    end)
    arg5:_UpdateEnabled()
    task.defer(arg5._HookLocalFighter, arg5)
end

return t._new()
