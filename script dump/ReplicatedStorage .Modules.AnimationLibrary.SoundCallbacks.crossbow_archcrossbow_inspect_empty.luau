return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://130860307965581",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
