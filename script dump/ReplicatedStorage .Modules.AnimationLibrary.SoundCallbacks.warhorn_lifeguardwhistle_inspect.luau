return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 3.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.75,
        1.125,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.25,
        1.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.5,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 2.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.75,
        1.125,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.25,
        1.75,
        true,
        10
    )
end
