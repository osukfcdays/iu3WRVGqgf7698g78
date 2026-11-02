return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.95 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://108879620126710",
        1.25,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 2.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14000023581",
        1,
        0.75,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://86510987016114",
        0.75,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.82 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://90310901394527",
        1.25,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.33 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427782350",
        1,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://118906938239363",
        1,
        0.9 + 0.2 * math.random(),
        true,
        10
    )
end
