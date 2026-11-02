return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.9 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13682532502",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.075 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13682532502",
        0.5,
        2,
        true,
        10
    )
end
