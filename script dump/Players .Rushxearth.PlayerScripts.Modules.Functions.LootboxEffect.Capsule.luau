local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)

return function(arg1) -- line: 5
    -- upvalues:
    --  [1] Utility_m (copy)

    wait(0.4)
    Utility_m:CreateSound(
        "rbxassetid://18184509157",
        6,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.25)
    Utility_m:CreateSound(
        "rbxassetid://18184509157",
        6,
        1.25,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.25)
    Utility_m:CreateSound(
        "rbxassetid://18184509157",
        6,
        1.125,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.25)
    Utility_m:CreateSound(
        "rbxassetid://18184509157",
        6,
        1.375,
        arg1.HumanoidRootPart,
        true
    )
    wait(1)
    Utility_m:CreateSound(
        "rbxassetid://18184414067",
        0.625,
        1,
        arg1.HumanoidRootPart,
        true
    )
end
