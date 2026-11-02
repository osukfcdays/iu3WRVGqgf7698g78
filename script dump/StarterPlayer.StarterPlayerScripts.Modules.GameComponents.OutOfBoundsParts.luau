local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OutOfBoundsMachine_m = require(ReplicatedStorage.Modules.OutOfBoundsMachine)
local t = setmetatable({}, OutOfBoundsMachine_m)
t.__index = t

function t._new() -- line: 8
    -- upvalues:
    --  [1] OutOfBoundsMachine_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(OutOfBoundsMachine_m.new(nil, nil), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg1.Kill:Connect(function(arg2, arg3) -- line: 27
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        local v2 = arg3 and arg3:Get("ObjectID") or nil
        ReplicatedStorage.Remotes.Replication.Fighter.OutOfBounds:FireServer(arg2, v2)
    end)
end

return t._new()
