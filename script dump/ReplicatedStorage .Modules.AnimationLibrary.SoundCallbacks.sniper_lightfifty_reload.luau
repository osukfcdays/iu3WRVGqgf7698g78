return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455229044",
        1,
        0.8,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455229188",
        1,
        0.8,
        true,
        10
    )
end
