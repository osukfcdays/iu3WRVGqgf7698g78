return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17803231833",
        0.875,
        1 + 0.4 * math.random(),
        true,
        5
    )
end
