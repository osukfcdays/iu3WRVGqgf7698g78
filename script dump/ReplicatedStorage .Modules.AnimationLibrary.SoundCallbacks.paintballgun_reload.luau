return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17092564046",
        0.5,
        1.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        0.75,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13456860578",
        1.25,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.95 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17092564046",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
        return
    end
end
