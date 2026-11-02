return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://123968428540207",
        1.2,
        0.95 + 0.1 * math.random(),
        true,
        5
    )
end
