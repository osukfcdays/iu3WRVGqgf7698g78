return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://84239597144951",
        0.75,
        1.25 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://99734844867178",
        1.5,
        1.5 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://113753648748200",
        1.125,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
