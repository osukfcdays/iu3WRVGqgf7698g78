return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.95 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://134815282110155",
        0.75,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://134815282110155",
        0.5,
        1,
        true,
        10
    )
end
