return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://88834968924220",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://99788947795556",
        1.25,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
