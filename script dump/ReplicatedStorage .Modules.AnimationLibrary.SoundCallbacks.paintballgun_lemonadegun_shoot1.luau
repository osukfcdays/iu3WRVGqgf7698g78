return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxasset://sounds//paintball.wav",
        0.5,
        1 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://74462162324970",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
