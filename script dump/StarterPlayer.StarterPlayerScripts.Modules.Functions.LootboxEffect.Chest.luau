local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)

return function(arg1) -- line: 5
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://7384906695",
        0.8,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(2.75)
    Utility_m:CreateSound(
        "rbxassetid://7384913560",
        0.6,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.5)
    Utility_m:CreateSound(
        "rbxassetid://7384913560",
        0.8,
        1.5,
        arg1.HumanoidRootPart,
        true
    )
end
