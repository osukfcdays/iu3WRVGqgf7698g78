return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://136485588193503",
        0.5,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
