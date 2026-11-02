return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://81581333373301",
        0.5,
        1 + 0.2 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://98628701005071",
        0.5,
        1 + 0.2 * math.random(),
        true,
        10
    )
end
