return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        1,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.92 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        1,
        1,
        true,
        10
    )
end
