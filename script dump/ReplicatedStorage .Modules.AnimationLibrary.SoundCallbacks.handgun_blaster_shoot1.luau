return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17803104424",
        0.75,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
