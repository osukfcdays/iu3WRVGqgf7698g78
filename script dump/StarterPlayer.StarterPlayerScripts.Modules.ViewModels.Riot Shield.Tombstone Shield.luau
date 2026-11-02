local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local RiotShield_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild("Riot Shield")
)
local t = setmetatable({}, RiotShield_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] RiotShield_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(RiotShield_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.AbsorbedHit(arg1) -- line: 22
    arg1:CreateSound(
        "rbxassetid://126398565710312",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.ShieldBroken(arg2) -- line: 26
    arg2:CreateSound(
        "rbxassetid://90752806876857",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t._Init(_) -- line: 34
end

return t
