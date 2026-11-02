return function(arg1, arg2, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17274369233",
        0.75,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17274368912",
        0.75,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://117326796133738",
        0.375,
        1,
        true,
        0.4 / arg2
    )
end
