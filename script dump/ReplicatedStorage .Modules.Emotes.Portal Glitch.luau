local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_SetupProp(script.PortalProp)
    arg1:_PlayAnimation("rbxassetid://114622720984788", "rbxassetid://100757699753241", 1.15)
    arg1:_InternalThread(task.spawn, function() -- line: 30
        -- upvalues:
        --  [1] arg1 (copy)

        wait(0.9)
        arg1:CreateSound(
            "rbxassetid://81610952487049",
            0.375,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        arg1:CreateSound(
            "rbxassetid://7127702569",
            0.25,
            1 + 0.25 * math.random(),
            nil,
            true,
            5
        )
        wait(0.266)

        for index = 1, math.huge do
            arg1:CreateSound(
                "rbxassetid://81610952487049",
                0.25,
                1 + 0.1 * math.random(),
                nil,
                true,
                5
            )
            arg1:CreateSound(
                "rbxassetid://7127702569",
                0.5 / ((index - 1) * 0.25 + 1),
                1 + 0.25 * math.random(),
                nil,
                true,
                5
            )
            wait(0.26666666666666666)
        end
    end)
end

function t._Init(_) -- line: 51
end

return t
