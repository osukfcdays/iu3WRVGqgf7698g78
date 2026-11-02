return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://77594993345414",
        0.875,
        1.15 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://122106573913822",
        2,
        1.75 + 0.125 * math.random(),
        true,
        10
    )
end
