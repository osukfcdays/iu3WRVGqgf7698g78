return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17672502716",
        0.75,
        0.75 + 0.05 * math.random(),
        true,
        10
    )
end
