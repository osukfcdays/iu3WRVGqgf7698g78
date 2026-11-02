return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13455968853",
        1,
        1.875 + 0.5 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://136174258344321",
        1,
        2.125 + 0.25 * math.random(),
        true,
        10
    )
end
