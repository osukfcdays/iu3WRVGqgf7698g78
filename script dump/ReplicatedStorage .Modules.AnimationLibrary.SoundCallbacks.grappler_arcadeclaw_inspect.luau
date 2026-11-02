return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://75469098017470",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://75469098017470",
        1,
        1.1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.2,
        1.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
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
