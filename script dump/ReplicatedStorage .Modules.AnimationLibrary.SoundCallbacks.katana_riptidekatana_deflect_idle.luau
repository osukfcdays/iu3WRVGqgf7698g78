return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14798337918",
        0.75,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://119694489557952",
        1.25,
        1.3 + 0.1 * math.random(),
        true,
        5
    )
end
