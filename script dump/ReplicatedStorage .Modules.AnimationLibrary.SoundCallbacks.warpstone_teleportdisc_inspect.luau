return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.58 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.75,
        1.5,
        true,
        10
    )
end
