return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://93178963908825",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.625,
        2 + 0.5 * math.random(),
        true,
        10
    )
end
