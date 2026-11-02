return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://107901458751913",
        1.5,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71608982627584",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 9.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://107901458751913",
        1.5,
        1.5,
        true,
        10
    )
end
