local Katana_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Katana
)
local t = setmetatable({}, Katana_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Katana_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Katana_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayDeflectHitSounds(arg1) -- line: 20
    arg1:CreateSound(
        "rbxassetid://18763556154",
        1.25,
        1 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://14776437962",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t._Init(_) -- line: 29
end

return t
