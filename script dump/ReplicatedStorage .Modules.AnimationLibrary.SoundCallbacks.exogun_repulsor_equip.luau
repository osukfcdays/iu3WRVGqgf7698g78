return function(arg1, _, _) -- line: 1
    arg1:CreateSound(
        "rbxassetid://77653562642556",
        1,
        1.5 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://80245415527547",
        0.5,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
