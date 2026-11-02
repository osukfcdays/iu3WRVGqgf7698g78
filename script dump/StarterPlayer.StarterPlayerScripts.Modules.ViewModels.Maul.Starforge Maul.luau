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
        0.75 + 0.25 * math.random(),
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://129922197154277",
        0.75 + 0.25 * math.random(),
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://122278439418848",
        1.25 + 0.125 * math.random(),
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://118428196202943",
        1.25 + 0.125 * math.random(),
        0.95 + 0.1 * math.random(),
        arg2,
        true,
        10
    )
end

function t._Init(_) -- line: 33
end

return t
