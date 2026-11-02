return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://83017428892049",
        0.75,
        0.95 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://99837158417289",
        0.875,
        1.25,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://83017428892049",
        0.75,
        1.1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://99837158417289",
        0.5,
        1.5,
        true,
        10
    )
end
