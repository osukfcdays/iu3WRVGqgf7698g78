return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxasset://sounds//Rubber band sling shot.mp3",
        1,
        1 + 0.375 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://93884348190930",
        0.75,
        1 + 0.375 * math.random(),
        true,
        5
    )
end
