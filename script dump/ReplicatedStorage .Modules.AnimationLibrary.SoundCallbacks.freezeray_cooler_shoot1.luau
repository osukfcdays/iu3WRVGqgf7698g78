return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://18431054958",
        0.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://130350823905316",
        1,
        1.25 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://115102837847414",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
