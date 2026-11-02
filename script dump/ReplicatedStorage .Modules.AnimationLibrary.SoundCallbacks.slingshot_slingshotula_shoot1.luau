return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxasset://sounds//Rubber band sling shot.mp3",
        1,
        1 + 0.375 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://122106573913822",
        2,
        3 + 0.5 * math.random(),
        true,
        10
    )
end
