return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://73893914300609",
        1,
        1,
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://73893914300609",
        0.9,
        1.1,
        true,
        5
    )
end
