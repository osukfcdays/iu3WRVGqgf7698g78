return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://90300689645572",
        0.75,
        1 + 0.25 * math.random(),
        true,
        10
    )
end
