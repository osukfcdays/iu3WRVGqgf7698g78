return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://98081733365737",
        0.5,
        1 + 0.25 * math.random(),
        true,
        10
    )
end
