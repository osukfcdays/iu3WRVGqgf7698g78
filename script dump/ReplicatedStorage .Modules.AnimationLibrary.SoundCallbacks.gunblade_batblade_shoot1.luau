return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://96886470957330",
        0.875,
        1.25 + 0.125 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://122106573913822",
        2,
        1.25 + 0.125 * math.random(),
        true,
        10
    )
end
