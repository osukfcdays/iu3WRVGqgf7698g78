local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)

return function(arg1) -- line: 5
    -- upvalues:
    --  [1] Utility_m (copy)

    wait(0.1)
    Utility_m:CreateSound(
        "rbxassetid://18184413727",
        1,
        1,
        arg1.HumanoidRootPart,
        true
    )
    wait(2.4)
    Utility_m:CreateSound(
        "rbxassetid://18184413521",
        1,
        1.75,
        arg1.HumanoidRootPart,
        true
    )
    wait(0.4)
    arg1.Tape:Destroy()
    wait(0.85)
    Utility_m:CreateSound(
        "rbxassetid://18184413295",
        1.25,
        1,
        arg1.HumanoidRootPart,
        true
    )
end
