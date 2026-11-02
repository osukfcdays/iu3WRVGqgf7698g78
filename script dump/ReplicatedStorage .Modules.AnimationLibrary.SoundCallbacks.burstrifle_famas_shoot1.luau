return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17662574783",
        0.75,
        1.2 + 0.4 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://18764343961",
        1.125,
        1.4 + 0.4 * math.random(),
        true,
        5
    )
end
