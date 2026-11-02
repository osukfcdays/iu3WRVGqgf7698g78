return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17266070755",
        0.875,
        0.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://126250530419268",
        0.875,
        0.9 + 0.1 * math.random(),
        true,
        10
    )
end
