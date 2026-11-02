return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://130511754869111",
        1.5,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://119684878895970",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
