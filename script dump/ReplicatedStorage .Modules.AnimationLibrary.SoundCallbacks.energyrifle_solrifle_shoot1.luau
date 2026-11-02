return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://73644074370077",
        0.5,
        1.2 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://119904392413280",
        1.5,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
