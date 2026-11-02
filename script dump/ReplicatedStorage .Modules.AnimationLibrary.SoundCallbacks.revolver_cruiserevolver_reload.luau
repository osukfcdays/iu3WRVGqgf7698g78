return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://134815282110155",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    for index = 1, 7 do
        arg1:CreateSound(
            "rbxassetid://134815282110155",
            1,
            index * 0.05 + 1,
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.1285714285714286 / arg2) then
            return
        end
    end
end
