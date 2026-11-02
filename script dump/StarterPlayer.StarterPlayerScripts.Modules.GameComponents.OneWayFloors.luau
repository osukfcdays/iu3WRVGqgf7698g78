local CollectionService = game:GetService("CollectionService")
local SpectateController_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local t = {}
t.__index = t

function t._new() -- line: 9
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._one_way_floors = {}
    t_1._enabled = false
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 24
    -- upvalues:
    --  [1] SpectateController_m (copy)

    if not arg1._enabled then
        return
    end

    local v1 = SpectateController_m.CurrentSubject and SpectateController_m.CurrentSubject.Entity and SpectateController_m.CurrentSubject.Entity.RootPart and SpectateController_m.CurrentSubject.Entity.RootPart.Position

    for key, _ in pairs(arg1._one_way_floors) do
        local v2 = v1 and v1.Y < key.Position.Y + 2
        local v3 = if not v2 then 0 else 1
        key.LocalTransparencyModifier = v3
        key.CanCollide = not v2
    end
end

function t._CheckEnabled(arg3) -- line: 43
    arg3._enabled = next(arg3._one_way_floors) ~= nil
end

function t._ObjectRemoved(arg4, arg5) -- line: 47
    arg4._one_way_floors[arg5] = nil
    arg4:_CheckEnabled()
end

function t._ObjectAdded(arg6, arg7) -- line: 52
    arg6._one_way_floors[arg7] = true
    arg6:_CheckEnabled()
end

function t._Init(arg8) -- line: 57
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceRemovedSignal("OneWayFloor"):Connect(function(arg9) -- line: 58
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_ObjectRemoved(arg9)
    end)
    CollectionService:GetInstanceAddedSignal("OneWayFloor"):Connect(function(arg10) -- line: 62
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_ObjectAdded(arg10)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("OneWayFloor")) do
        task.spawn(arg8._ObjectAdded, arg8, val_1)
    end
end

return t._new()
