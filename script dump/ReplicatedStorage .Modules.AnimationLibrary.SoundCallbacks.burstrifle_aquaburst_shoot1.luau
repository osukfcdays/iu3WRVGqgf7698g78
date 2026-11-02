return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13087362838",
        0.5,
        1.2 + 0.4 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://18763517194",
        1,
        1 + 0.25 * math.random(),
        true,
        5
    )
end
