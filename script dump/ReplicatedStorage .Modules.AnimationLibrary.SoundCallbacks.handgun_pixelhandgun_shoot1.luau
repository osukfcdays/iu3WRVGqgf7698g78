return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17650837718",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        1.5 + 0.25 * math.random(),
        true,
        10
    )
end
