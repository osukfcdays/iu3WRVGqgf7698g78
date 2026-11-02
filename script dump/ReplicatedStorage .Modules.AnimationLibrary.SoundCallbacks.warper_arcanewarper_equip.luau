return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://107539891279940",
        0.75,
        1 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://114718006479081",
        0.75,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
