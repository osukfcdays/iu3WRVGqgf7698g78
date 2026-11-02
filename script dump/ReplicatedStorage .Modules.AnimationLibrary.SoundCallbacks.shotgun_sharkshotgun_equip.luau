return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.75,
        0.75 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://107381185026224",
        0.5,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
