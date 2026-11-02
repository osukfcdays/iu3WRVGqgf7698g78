return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13455968853",
        1,
        1.5 + 0.5 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.75,
        1.75 + 0.5 * math.random(),
        true,
        10
    )
end
