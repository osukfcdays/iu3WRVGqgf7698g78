local Katana_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Katana
)
local t = { "rbxassetid://78366036290786", "rbxassetid://94469349981552" }
local t_1 = setmetatable({}, Katana_m)
t_1.__index = t_1

function t_1.new(...) -- line: 10
    -- upvalues:
    --  [1] Katana_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Katana_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.PlayDeflectHitSounds(arg1) -- line: 22
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        "rbxassetid://14776414133",
        1,
        1.5 + 0.5 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://14776437962",
        0.75,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        t[math.random(#t)],
        1.25,
        1 + 0.25 * math.random(),
        true,
        5
    )
end

function t_1._Init(_) -- line: 32
end

return t_1
