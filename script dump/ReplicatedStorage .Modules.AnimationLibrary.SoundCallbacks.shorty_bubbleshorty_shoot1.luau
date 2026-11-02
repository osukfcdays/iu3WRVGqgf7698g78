return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13479562219",
        0.875,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://113753648748200",
        1.125,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
