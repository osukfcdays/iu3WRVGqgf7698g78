local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)

return function(arg1) -- line: 5
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://18184524463",
        0.8,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(1.1)
    Utility_m:CreateSound(
        "rbxassetid://18184413892",
        0.7,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.65)
end
