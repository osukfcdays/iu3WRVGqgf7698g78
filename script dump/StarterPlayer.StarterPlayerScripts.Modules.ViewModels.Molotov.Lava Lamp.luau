local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Molotov_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Molotov)
local t = setmetatable({}, Molotov_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Molotov_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Molotov_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(arg1, arg2, arg3) -- line: 22
    -- upvalues:
    --  [1] Molotov_m (copy)
    --  [2] Utility_m (copy)

    local v2 = Molotov_m.ExplosionEffect(arg1, arg2, arg3)
    Utility_m:CreateSound(
        "rbxassetid://100889848836357",
        1,
        1 + 0.25 * math.random(),
        v2,
        true,
        10
    )
end

function t._Init(_) -- line: 31
end

return t
