return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14241444681",
        1.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.75,
        1.25 + 0.25 * math.random(),
        true,
        5
    )
end
