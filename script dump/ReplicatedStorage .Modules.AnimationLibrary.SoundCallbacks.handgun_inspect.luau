return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330666",
        1,
        1.4,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.63 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330666",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.03 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13907558696",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.66 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13907558634",
        1,
        1,
        true,
        10
    )
end
