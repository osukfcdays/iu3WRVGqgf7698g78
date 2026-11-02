local Signal_m = require(game:GetService("ReplicatedStorage").Modules.Signal)
local t = { Speed = true }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Signal_m (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.BoostsChanged = Signal_m.new()
    t_2.ClientFighterCharacter = arg1
    t_2._boosts = {}
    t_2:_Init()

    return t_2
end

function t_1.GetBoostByName(arg2, arg3) -- line: 29
    assert(
        if typeof(arg3) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg3)
    )
    arg2:_ClearExpiredBoosts()

    return arg2._boosts[arg3]
end

function t_1.GetBoost(arg4, arg5) -- line: 38
    -- upvalues:
    --  [1] t (copy)

    assert(t[arg5], "Argument 1 invalid, got " .. tostring(arg5))
    arg4:_ClearExpiredBoosts()
    local v3 = 0

    for _, val in pairs(arg4._boosts) do
        if val.Type == arg5 then
            v3 += val.Boost
        end
    end

    return v3
end

function t_1.SetBoost(
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11
) -- line: 59
    -- upvalues:
    --  [1] t (copy)

    assert(t[arg7], "Argument 1 invalid, got " .. tostring(arg7))
    assert(
        if typeof(arg8) ~= "string" then false else true,
        "Argument 2 invalid, expected a string, got " .. tostring(arg8)
    )
    assert(
        if typeof(arg9) ~= "number" then false else true,
        "Argument 3 invalid, expected a number, got " .. tostring(arg9)
    )
    assert(
        if typeof(arg10) ~= "number" then false else true,
        "Argument 4 invalid, expected a number, got " .. tostring(arg10)
    )
    local v5 = not arg11 or (if typeof(arg11) ~= "boolean" then false else true)
    assert(v5, "Argument 5 invalid, expected a boolean or nil, got " .. tostring(arg11))
    v5 = { Type = arg7, Window = tick() + arg9, Boost = arg10 }
    arg6._boosts[arg8] = v5

    if not arg11 then
        arg6.BoostsChanged:Fire()
    end
end

function t_1.RemoveBoost(arg12, arg13, arg14) -- line: 79
    assert(
        if typeof(arg13) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg13)
    )
    assert(
        not arg14 or (if typeof(arg14) ~= "boolean" then false else true),
        "Argument 2 invalid, expected a boolean or nil, got " .. tostring(arg14)
    )

    if not arg12._boosts[arg13] then
        return
    end

    arg12._boosts[arg13] = nil

    if not arg14 then
        arg12.BoostsChanged:Fire()
    end
end

function t_1.Update(_, _, _) -- line: 94
end

function t_1.Destroy(arg18) -- line: 98
    arg18.BoostsChanged:Destroy()
end

function t_1._ClearExpiredBoosts(arg19) -- line: 106
    local v7 = false

    for key_1, val_1 in pairs(arg19._boosts) do
        if tick() > val_1.Window then
            v7 = true
            arg19:RemoveBoost(key_1, true)
        end
    end

    if v7 then
        arg19.BoostsChanged:Fire()
    end
end

function t_1._Init(_) -- line: 121
end

return t_1
