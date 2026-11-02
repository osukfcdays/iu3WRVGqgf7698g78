local DuelLibrary_m = require(game:GetService("ReplicatedStorage").Modules.DuelLibrary)
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientDuel = arg1
    t_1:_Init()

    return t_1
end

function t.Destroy(_) -- line: 22
end

function t._Highlight(arg3) -- line: 30
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    if not arg3.ClientDuel.LocalDueler or not arg3.ClientDuel:Get("IsSpectating") then
        return
    end

    local v1 = arg3.ClientDuel:Get("QueueName")

    if
        not v1
        or not DuelLibrary_m.MatchmakingQueues[v1]
        or DuelLibrary_m.MatchmakingQueues[v1].TitleName ~= "Beginner"
    then
        return
    end

    for _, val in pairs(arg3.ClientDuel.Duelers) do
        if
            val.ClientFighter
            and val.ClientFighter.Entity
            and (not arg3.ClientDuel.LocalDueler:Get("TeamID") or arg3.ClientDuel.LocalDueler:Get(
                "TeamID"
            ) ~= val:Get("TeamID"))
        then
            val.ClientFighter.Entity:SetRedFigureMode(true, true)
        end
    end
end

function t._Init(arg4) -- line: 50
    arg4.ClientDuel:GetDataChangedSignal("IsSpectating"):Connect(function() -- line: 51
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Highlight()
    end)
    arg4.ClientDuel:GetDataChangedSignal("Status"):Connect(function() -- line: 55
        -- upvalues:
        --  [1] arg4 (copy)

        if
            arg4.ClientDuel:Get("Status") == "RoundStarted"
            or arg4.ClientDuel:Get("Status") == "RoundStarting"
        then
            arg4:_Highlight()
        end
    end)
    task.defer(arg4._Highlight, arg4)
end

return t
