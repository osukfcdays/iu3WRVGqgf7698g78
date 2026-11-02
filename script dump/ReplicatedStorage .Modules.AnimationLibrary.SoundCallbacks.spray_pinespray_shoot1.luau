return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://100354903585817",
        0.5,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://127946504679537",
        1.125,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
