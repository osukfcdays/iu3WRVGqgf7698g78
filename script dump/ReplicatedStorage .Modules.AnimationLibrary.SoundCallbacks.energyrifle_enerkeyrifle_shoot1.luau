return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://73644074370077",
        0.875,
        2 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://78127132024186",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
