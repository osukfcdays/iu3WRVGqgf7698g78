return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://96886470957330",
        0.875,
        1.25 + 0.125 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://135836738518083",
        0.5,
        1.25,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://115657023572170",
        0.875,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
