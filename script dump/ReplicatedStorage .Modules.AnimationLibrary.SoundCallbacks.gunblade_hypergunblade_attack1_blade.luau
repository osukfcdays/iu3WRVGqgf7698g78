return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://77594993345414",
        0.875,
        1.15 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://81817529955162",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
