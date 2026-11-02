return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 3.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.75,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://95394392315850",
        0.25,
        1,
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        2,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://88960734678343",
        0.25,
        1.25,
        true,
        5
    )
end
