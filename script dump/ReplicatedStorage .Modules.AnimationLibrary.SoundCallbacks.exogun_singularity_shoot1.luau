return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17672502566",
        0.875,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
