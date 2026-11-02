return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13160401062",
        1,
        0.375 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://18763594759",
        0.375,
        1.25,
        true,
        10
    )
end
