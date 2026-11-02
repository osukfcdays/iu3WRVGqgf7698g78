return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14000023581",
        0.5,
        0.75,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://118319832364364",
        0.875,
        1 + 0.125 * math.random(),
        true,
        5
    )
end
