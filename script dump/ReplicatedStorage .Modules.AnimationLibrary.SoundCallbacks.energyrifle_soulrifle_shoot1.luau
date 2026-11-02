return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://73644074370077",
        0.75,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://72989650712897",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
