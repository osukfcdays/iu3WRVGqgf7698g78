return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://100354903585817",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
