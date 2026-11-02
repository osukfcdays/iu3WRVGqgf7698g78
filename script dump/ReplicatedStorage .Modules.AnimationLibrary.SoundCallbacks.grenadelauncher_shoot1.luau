return function(arg1, _, _) -- line: 1
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
end
