return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://100354903585817",
        0.5,
        1.5 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://17812566584",
        1,
        2 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://17812566721",
        1,
        2 + 0.2 * math.random(),
        true,
        5
    )
end
