return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://77594993345414",
        0.875,
        1.1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://107162559513589",
        0.375,
        0.5 + 0.125 * math.random(),
        true,
        5
    )
end
