return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17247639614",
        0.25,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
