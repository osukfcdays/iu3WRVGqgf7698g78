local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local RiotShield_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild("Riot Shield")
)
local t = {
    { "rbxassetid://105059726931047", "rbxassetid://79914271483818" },
    { "rbxassetid://77461546699017", "rbxassetid://76552313877907" }
}
local t_3 = setmetatable({}, RiotShield_m)
t_3.__index = t_3

function t_3.new(...) -- line: 15
    -- upvalues:
    --  [1] RiotShield_m (copy)
    --  [2] t_3 (copy)
    --  [3] t (copy)

    local t_4 = setmetatable(RiotShield_m.new(...), t_3)
    t_4._painting_data = t[math.random(#t)]
    t_4:_Init()

    return t_4
end

function t_3.GetImage(arg1) -- line: 29
    return arg1._painting_data[2]
end

function t_3.AbsorbedHit(arg2) -- line: 33
    arg2:CreateSound(
        "rbxassetid://134671375134755",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t_3._Setup(arg3) -- line: 41
    arg3.ItemModel:WaitForChild("Body"):WaitForChild("Canvas"):WaitForChild("Decal").Texture = arg3._painting_data[1]
end

function t_3._Init(arg4) -- line: 45
    arg4:_Setup()
end

return t_3
