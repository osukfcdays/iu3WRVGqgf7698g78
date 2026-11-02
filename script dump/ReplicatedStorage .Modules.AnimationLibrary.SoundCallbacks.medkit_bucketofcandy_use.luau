return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://125248293081026",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://110013540349061",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://125248293081026",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96411310492226",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://92333760834779",
        0.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://127123065378139",
        1,
        1,
        true,
        10
    )
end
