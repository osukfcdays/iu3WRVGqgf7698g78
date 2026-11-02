return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.28 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1.125,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.42 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://12222208",
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

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://12222208",
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

    if not arg1:_AnimationWait(script.Name, arg3, 0.58 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://12222208",
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
end
