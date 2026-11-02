return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13160400909",
        1,
        1.4 + 0.2 * math.random(),
        true,
        10
    )
end
