return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17803630344",
        1.25,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://14417089307",
        0.75,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13158330479",
        1,
        1,
        true,
        5
    )
end
