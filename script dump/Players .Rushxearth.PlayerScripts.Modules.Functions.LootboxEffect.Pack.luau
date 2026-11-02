local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)

return function(arg1) -- line: 5
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://83402774833713",
        1,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(1)
    Utility_m:CreateSound(
        "rbxassetid://139804361555491",
        1.5,
        1,
        arg1.HumanoidRootPart,
        true
    )
    Utility_m:PlayParticles(arg1.R)
    wait(0.1)
    Utility_m:CreateSound(
        "rbxassetid://78951730047565",
        0.75,
        1,
        arg1.HumanoidRootPart,
        true
    )
end
