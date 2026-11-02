return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13479562219",
        1,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
