return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14798337918",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.75,
        1 + 0.125 * math.random(),
        true,
        5
    )
end
