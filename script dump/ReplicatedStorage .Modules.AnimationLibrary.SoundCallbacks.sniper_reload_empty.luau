return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        2,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.233 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395090",
        0.25,
        0.75 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455229044",
        1,
        1.1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455229188",
        1,
        1.1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.78 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455394948",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455394948",
        1,
        2,
        true,
        10
    )
end
