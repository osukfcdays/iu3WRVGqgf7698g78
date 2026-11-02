return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14798337918",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://118748685078128",
        1,
        1.5 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://125777995479531",
        1.25,
        1 + 0.25 * math.random(),
        true,
        10
    )
end
