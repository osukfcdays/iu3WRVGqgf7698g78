return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13455968853",
        1,
        1.75 + 0.5 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://136174258344321",
        1,
        2 + 0.25 * math.random(),
        true,
        10
    )
end
