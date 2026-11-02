return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1.125,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14000023581",
        0.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://14427782350",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://118319832364364",
        0.875,
        1 + 0.125 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14000023581",
        0.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://14427782350",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://118319832364364",
        0.875,
        1.125 + 0.125 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14000023581",
        0.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://14427782350",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://118319832364364",
        0.875,
        1.25 + 0.125 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://70883497288606",
        0.625,
        1.25 + 0.1 * math.random(),
        true,
        5
    )
end
