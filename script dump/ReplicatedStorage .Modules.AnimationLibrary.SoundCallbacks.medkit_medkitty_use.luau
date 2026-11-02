return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://128632959026124",
        1.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://106320000244648",
        1.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://103145233607638",
        1.5,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://103145233607638",
        1.35,
        0.9,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://103145233607638",
        1.2,
        0.925,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://103145233607638",
        1,
        0.95,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://81623846775515",
        0.75,
        2.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.375 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://128990235337969",
        1.5,
        1,
        true,
        10
    )
end
