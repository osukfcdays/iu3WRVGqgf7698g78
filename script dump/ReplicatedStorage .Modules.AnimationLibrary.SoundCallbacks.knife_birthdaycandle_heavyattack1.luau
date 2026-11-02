return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13160400909",
        1,
        0.9 + 0.2 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://96691716528954",
        0.75,
        1.25 + 0.1 * math.random(),
        true,
        10
    )
end
