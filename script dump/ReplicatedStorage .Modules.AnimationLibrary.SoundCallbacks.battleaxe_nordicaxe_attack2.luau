return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://77594993345414",
        0.875,
        1.1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://127353554164693",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
