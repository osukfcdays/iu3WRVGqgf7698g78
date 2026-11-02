return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://100354903585817",
        0.75,
        0.75 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://13158330479",
        1,
        1.5,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://104731232227748",
        0.75,
        1.5 + 0.25 * math.random(),
        true,
        10
    )
end
