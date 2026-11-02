return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13682532502",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://127610347219152",
        0.75,
        1.75,
        true,
        10
    )
end
