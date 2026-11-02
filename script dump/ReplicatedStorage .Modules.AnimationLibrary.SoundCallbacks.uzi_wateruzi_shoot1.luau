return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://16526185100",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://17812566584",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://17812566721",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
