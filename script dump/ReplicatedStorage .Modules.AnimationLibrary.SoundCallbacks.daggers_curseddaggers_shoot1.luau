return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://101759165907297",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://121822438000546",
        0.75,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
