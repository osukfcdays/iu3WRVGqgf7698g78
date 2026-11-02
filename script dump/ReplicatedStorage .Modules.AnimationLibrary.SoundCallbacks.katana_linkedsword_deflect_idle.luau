return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14798337918",
        0.75,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://12222208",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end
