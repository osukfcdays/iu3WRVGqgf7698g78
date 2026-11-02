return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17662574783",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.4,
        2 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
