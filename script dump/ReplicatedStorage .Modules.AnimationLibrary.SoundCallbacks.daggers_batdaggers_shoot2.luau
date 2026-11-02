return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://76357741438822",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://122106573913822",
        1,
        3 + 0.5 * math.random(),
        true,
        10
    )
end
