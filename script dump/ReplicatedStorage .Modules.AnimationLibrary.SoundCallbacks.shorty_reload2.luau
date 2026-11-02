return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.2833333333333333 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        1,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    if not arg1:_AnimationWait(script.Name, arg3, 1.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13235979356",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6166666666666667 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        1,
        1,
        true,
        10
    )
end
