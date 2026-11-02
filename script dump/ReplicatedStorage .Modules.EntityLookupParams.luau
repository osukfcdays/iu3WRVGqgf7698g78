local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.TeamID = arg1
    t_1.TeamkillEnabled = arg2
    t_1.GrabSmallHitboxes = arg3
    t_1.SourceEntity = nil
    t_1.CanHurtSelf = nil
    t_1:_Init()

    return t_1
end

function t.IsValidTarget(arg4, arg5) -- line: 22
    if
        not arg5
        or (if arg4.CanHurtSelf then not arg5:IsAlive() else arg5 == arg4.SourceEntity or not arg5:IsAlive())
        or not arg4.TeamkillEnabled and arg4.TeamID and arg5 ~= arg4.SourceEntity and arg5:Get(
            "TeamID"
        ) == arg4.TeamID
    then
        return false
    end

    return true
end

function t._Init(_) -- line: 38
end

return t
