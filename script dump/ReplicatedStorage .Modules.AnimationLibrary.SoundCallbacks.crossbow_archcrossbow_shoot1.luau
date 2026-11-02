return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://81230732872783",
        0.5,
        1.5 + 0.5 * math.random(),
        true,
        10
    )
end
