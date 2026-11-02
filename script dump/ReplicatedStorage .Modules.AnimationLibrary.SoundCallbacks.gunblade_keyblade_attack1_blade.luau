return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://77594993345414",
        0.875,
        1.15 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://135836738518083",
        0.75,
        1.25,
        true,
        10
    )
end
