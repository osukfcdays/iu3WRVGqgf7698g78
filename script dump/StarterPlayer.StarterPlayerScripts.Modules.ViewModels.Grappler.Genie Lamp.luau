local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Grappler_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Grappler)
local t = setmetatable({}, Grappler_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Grappler_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Grappler_m.new(...), t)
    t_1._shoot_particles_attachment = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Black"):WaitForChild(
        "ShootParticles"
    )
    t_1:_Init()

    return t_1
end

function t.PlayShootSounds(arg1) -- line: 24
    -- upvalues:
    --  [1] Utility_m (copy)

    arg1:CreateSound(
        "rbxassetid://139881930563519",
        1.5,
        1 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://119208207944073",
        0.875,
        1 + 0.1 * math.random(),
        true,
        5
    )
    Utility_m:PlayParticles(arg1._shoot_particles_attachment)
end

function t.PlayPullSounds(arg2) -- line: 30
    arg2:CreateSound(
        "rbxassetid://80351710007259",
        1.5,
        1 + 0.1 * math.random(),
        true,
        5
    )
end

function t._Init(_) -- line: 38
end

return t
