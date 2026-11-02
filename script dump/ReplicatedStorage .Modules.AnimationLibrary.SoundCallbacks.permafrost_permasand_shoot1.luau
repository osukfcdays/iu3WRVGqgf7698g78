return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://108185335541864",
        0.875,
        1.25 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://100912632191313",
        0.875,
        1.5 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://87740786635301",
        0.375 + 0.25 * math.random(),
        0.9 + 0.4 * math.random(),
        true,
        5
    )
end
