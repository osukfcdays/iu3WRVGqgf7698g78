return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://100664516053133",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455394948",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
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
