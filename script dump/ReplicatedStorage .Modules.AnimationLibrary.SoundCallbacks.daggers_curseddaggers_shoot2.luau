return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://76357741438822",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://121822438000546",
        0.75,
        1.1 + 0.1 * math.random(),
        true,
        10
    )
end
