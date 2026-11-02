return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14000023392",
        0.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://118319832364364",
        0.875,
        1.25 + 0.125 * math.random(),
        true,
        5
    )
end
