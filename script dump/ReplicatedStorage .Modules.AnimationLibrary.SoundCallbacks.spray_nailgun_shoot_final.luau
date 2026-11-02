return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://72698186314258",
        0.875,
        1 + 0.2 * math.random(),
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
end
