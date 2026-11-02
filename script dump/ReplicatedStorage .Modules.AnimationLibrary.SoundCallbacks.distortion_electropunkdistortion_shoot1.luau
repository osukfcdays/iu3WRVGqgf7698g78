return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://126144885809059",
        0.5,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://138109667994070",
        0.5,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://78079958008757",
        1.25,
        1 + 0.25 * math.random(),
        true,
        10
    )
end
