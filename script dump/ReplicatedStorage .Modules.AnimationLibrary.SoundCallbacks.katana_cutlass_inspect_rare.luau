return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.9 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://95394392315850",
        0.5,
        1,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://14000023581",
        0.125,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.9 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://113130804676761",
        0.5,
        1,
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.36 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://113130804676761",
        0.4,
        1.25,
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 3.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://92660146054151",
        0.5,
        1,
        true,
        5
    )
end
