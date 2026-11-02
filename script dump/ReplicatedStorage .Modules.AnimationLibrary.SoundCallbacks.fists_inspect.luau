return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3333333333333333 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160489311",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160489311",
        0.5,
        0.75,
        true,
        10
    )
end
