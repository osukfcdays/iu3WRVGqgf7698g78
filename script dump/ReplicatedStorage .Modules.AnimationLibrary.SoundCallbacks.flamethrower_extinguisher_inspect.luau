return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://137260230649042",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://137260230649042",
        0.875,
        1.25,
        true,
        10
    )
end
