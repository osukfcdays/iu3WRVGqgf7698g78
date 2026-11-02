return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://104396544264853",
        0.375,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
