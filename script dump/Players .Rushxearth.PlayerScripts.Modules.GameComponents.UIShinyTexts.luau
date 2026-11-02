local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {}
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._objects = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 25
    -- upvalues:
    --  [1] Utility_m (copy)

    for key, val in pairs(arg1._objects) do
        if Utility_m:IsUIElementVisible(key) then
            local v1 = if not val.IsDoubleFlash then tick() * 0.25 % 1 else if not (tick() * 0.25 * 8 % 6 < 1) then if not (tick() * 0.25 * 8 % 6 < 2) then 0 else tick() * 0.25 * 8 % 6 - 1 else tick() * 0.25 * 8 % 6
            local sine = math.sin(6.283185307179586 * (v1 - 0.5))
            val.Gradient.Offset = Vector2.new(
                ((sine + 6.283185307179586 * (v1 - 0.5)) / 6.283185307179586 + 0.5 - 0.5) * 2,
                0
            )
        end
    end
end

function t._ObjectRemoved(arg3, arg4) -- line: 57
    if not arg3._objects[arg4] then
        return
    end

    arg3._objects[arg4] = nil
end

function t._ObjectAdded(arg5, arg6) -- line: 65
    arg5:_ObjectRemoved(arg6)
    arg5._objects[arg6] = {
        Gradient = arg6:WaitForChild("UIGradient"),
        IsDoubleFlash = arg6:GetAttribute("IsDoubleFlash")
    }
end

function t._Init(arg7) -- line: 74
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceRemovedSignal("UIShinyText"):Connect(function(arg8) -- line: 75
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectRemoved(arg8)
    end)
    CollectionService:GetInstanceAddedSignal("UIShinyText"):Connect(function(arg9) -- line: 79
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectAdded(arg9)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("UIShinyText")) do
        task.spawn(arg7._ObjectAdded, arg7, val_1)
    end
end

return t._new()
