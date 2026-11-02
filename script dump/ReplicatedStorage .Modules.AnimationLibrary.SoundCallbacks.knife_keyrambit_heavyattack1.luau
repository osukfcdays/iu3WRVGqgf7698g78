return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13160400909",
        1,
        0.9 + 0.2 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        1,
        1.75 + 0.5 * math.random(),
        true,
        10
    )
end
