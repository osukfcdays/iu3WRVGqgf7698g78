return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://116036720670471",
        0.75,
        1.25 + 0.1 * math.random(),
        true,
        10
    )
end
