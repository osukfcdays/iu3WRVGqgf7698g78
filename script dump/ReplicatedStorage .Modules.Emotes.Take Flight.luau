local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local _ = arg1:_SetupProp(script.WingsProp)
    arg1:_PlayAnimation("rbxassetid://93066817376368")
    arg1:_InternalThread(function() -- line: 28
        -- upvalues:
        --  [1] arg1 (copy)

        while true do
            wait(0.25)
            arg1:CreateSound(
                "rbxassetid://128361063555965",
                0.8 + 0.2 * math.random(),
                0.9 + 0.2 * math.random(),
                nil,
                true,
                5
            )
            wait(0.85)
            arg1:CreateSound(
                "rbxassetid://128361063555965",
                0.8 + 0.2 * math.random(),
                0.9 + 0.2 * math.random(),
                nil,
                true,
                5
            )
            wait(0.55)
        end
    end)
end

function t._Init(_) -- line: 43
end

return t
