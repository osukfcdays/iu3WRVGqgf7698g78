return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17131614494",
        1,
        1.5 + 0.25 * math.random(),
        true,
        10
    )
end
