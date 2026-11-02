return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://92914419322840",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://92914419322840",
        0.875,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://18128896162",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://78700624599503",
        1.25,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    for index = 1, 5 do
        arg1:CreateSound(
            "rbxassetid://18128896325",
            1 - index * 0.15,
            index * 0.1 + 1,
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
            return
        end
    end
end
