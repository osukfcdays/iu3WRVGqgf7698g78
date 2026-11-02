return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13682898881",
        1,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13682223944",
        0.75,
        1 + 0.5 * math.random(),
        true,
        10
    )
end
