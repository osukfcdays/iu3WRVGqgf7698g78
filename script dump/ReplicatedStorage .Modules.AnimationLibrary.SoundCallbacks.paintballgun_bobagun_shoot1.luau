return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17641356840",
        0.75,
        2 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://18763517194",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
