return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://78700624599503",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://120187119176806",
        1.5,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
