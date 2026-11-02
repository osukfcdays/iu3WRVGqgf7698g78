return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://126069605787926",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.03 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://126069605787926",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.12 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://126069605787926",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.083 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://126069605787926",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://126069605787926",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )
end
