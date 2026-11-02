return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13479562219",
        0.75,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://115048215905027",
        1.25,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
