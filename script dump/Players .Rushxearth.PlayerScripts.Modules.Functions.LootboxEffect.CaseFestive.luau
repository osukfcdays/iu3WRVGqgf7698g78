local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)

return function(arg1) -- line: 5
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://116041480514859",
        1,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.9)
    Utility_m:CreateSound(
        "rbxassetid://18184413727",
        1,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.55)
    Utility_m:CreateSound(
        "rbxassetid://18184413727",
        1,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.3)
    Utility_m:CreateSound(
        "rbxassetid://140156477314761",
        1,
        1,
        arg1.HumanoidRootPart,
        true
    )
end
