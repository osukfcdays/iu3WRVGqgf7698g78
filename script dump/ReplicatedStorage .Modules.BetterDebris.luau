local RunService = game:GetService("RunService")
local t = {}
t.__index = t

function t._new() -- line: 6
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._items = {}
    t_1:_Init()

    return t_1
end

function t.AddItem(arg1, arg2, arg3) -- line: 20
    if arg2 then
        arg1._items[arg2] = tick() + arg3
    end
end

function t._Init(arg4) -- line: 30
    -- upvalues:
    --  [1] RunService (copy)

    RunService.Heartbeat:Connect(function() -- line: 31
        -- upvalues:
        --  [1] arg4 (copy)

        local t_2 = {}

        for key, val in pairs(arg4._items) do
            if val < tick() then
                key:Destroy()
                t_2[key] = true
            end
        end

        for key_1, _ in pairs(t_2) do
            arg4._items[key_1] = nil
        end
    end)
end

return t._new()
