return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13479562219",
        0.75,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://108887853497578",
        1.25,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
