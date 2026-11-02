return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxasset://sounds//Rubber band sling shot.mp3",
        0.75,
        1 + 0.375 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.4 + 0.1 * math.random(),
        true,
        5
    )
end
