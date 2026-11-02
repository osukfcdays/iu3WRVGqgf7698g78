local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
t.__index = t

function t.new(arg1) -- line: 9
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.CooldownAdded = Signal_m.new()
    t_1.CooldownRemoved = Signal_m.new()
    t_1.ClientItem = arg1
    t_1.Cooldowns = {}
    t_1:_Init()

    return t_1
end

function t.Get(arg2, arg3) -- line: 27
    for key, val in pairs(arg2.Cooldowns) do
        if val.Name == arg3 then
            return val, key
        end
    end
end

function t.Create(
    arg4,
    arg5,
    arg6,
    arg7,
    arg8
) -- line: 35
    -- upvalues:
    --  [1] HttpService (copy)

    if arg4._destroyed then
        return
    end

    arg4:Clear(arg7)

    if not arg7 then
        return
    end

    local t_2 = {
        Name = arg7,
        ID = HttpService:GenerateGUID(),
        Start = tick(),
        Finish = tick() + arg6,
        Duration = arg6,
        IsReversed = arg8,
        Image = arg5,
        Cleanup = {},
        GetVariables = nil
    }

    function t_2.GetVariables() -- line: 58
        -- upvalues:
        --  [1] t_2 (copy)

        local v1 = t_2.Finish - tick()
        local v2 = (tick() - t_2.Start) / t_2.Duration
        local v3 = if not t_2.IsReversed then 1 - v2 else v2
        v2 = if not t_2.IsReversed then 0 else 1

        return v1, v3, v2
    end

    table.insert(arg4.Cooldowns, t_2)
    arg4.CooldownAdded:Fire(t_2)
    task.delay(arg6, function() -- line: 70
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] arg7 (copy)
        --  [3] t_2 (copy)

        local v5 = arg4:Get(arg7)

        if v5 and v5.ID == t_2.ID then
            arg4:Clear(arg7)
        end
    end)
end

function t.Clear(arg9, arg10) -- line: 81
    local v6, v7 = arg9:Get(arg10)

    if not v6 then
        return
    end

    for _, val_1 in pairs(v6.Cleanup) do
        val_1:Destroy()
    end

    table.remove(arg9.Cooldowns, v7)
    arg9.CooldownRemoved:Fire(v6)
end

function t.Destroy(arg11) -- line: 96
    arg11.CooldownAdded:Destroy()
    arg11.CooldownRemoved:Destroy()

    for index = #arg11.Cooldowns, 1, -1 do
        arg11:Clear(arg11.Cooldowns[index].Name)
    end
end

function t._Init(_) -- line: 109
end

return t
