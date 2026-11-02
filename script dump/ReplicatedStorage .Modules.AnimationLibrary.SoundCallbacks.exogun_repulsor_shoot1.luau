return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://85840257279125",
        1,
        0.9 + 0.35 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://93945588254405",
        0.75,
        1 + 0.25 * math.random(),
        true,
        5
    )
end
