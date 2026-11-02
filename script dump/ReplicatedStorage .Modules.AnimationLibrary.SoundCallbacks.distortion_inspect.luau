return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://139955889483895",
        0.75,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 2.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://139955889483895",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://132926867312544",
        0.25,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )
end
