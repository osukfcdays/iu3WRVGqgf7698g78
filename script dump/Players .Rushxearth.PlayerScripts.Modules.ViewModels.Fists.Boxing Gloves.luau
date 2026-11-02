local Fists_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Fists
)
local t = setmetatable({}, Fists_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Fists_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Fists_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayHitmarkerSound(arg1, arg2, arg3) -- line: 20
    -- upvalues:
    --  [1] Fists_m (copy)

    if arg2 then
        Fists_m.PlayHitmarkerSound(arg1, arg2, arg3)

        return
    end

    arg1:_CreateHitmarkerSound(
        "rbxassetid://17650289572",
        1.5 / arg3,
        1.25 + 0.25 * math.random(),
        script,
        true,
        1
    )
end

function t._Init(_) -- line: 32
end

return t
