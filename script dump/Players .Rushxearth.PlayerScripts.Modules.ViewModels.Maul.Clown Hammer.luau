local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Maul_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild("Maul")
)
local t = setmetatable({}, Maul_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Maul_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Maul_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.SlamSoundEffect(_, arg2, _) -- line: 22
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://72483809453170",
        1 + 0.25 * math.random(),
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://129922197154277",
        1 + 0.25 * math.random(),
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://84868739299715",
        1.25 + 0.25 * math.random(),
        0.75 + 0.125 * math.random(),
        arg2,
        true,
        10
    )
end

function t.PlayHitmarkerSound(arg4, arg5, arg6) -- line: 28
    -- upvalues:
    --  [1] Maul_m (copy)

    Maul_m.PlayHitmarkerSound(arg4, arg5, arg6)
    arg4:_CreateHitmarkerSound(
        "rbxassetid://84868739299715",
        1.25 / arg6,
        1 + 0.25 * math.random(),
        script,
        true,
        2
    )
end

function t._Init(_) -- line: 37
end

return t
