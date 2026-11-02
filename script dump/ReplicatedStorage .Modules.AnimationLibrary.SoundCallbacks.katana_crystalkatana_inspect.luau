return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 2.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://134472359434980",
        0.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://108380234827963",
        0.5,
        1.75 + 0.25 * math.random(),
        true,
        10
    )
end
