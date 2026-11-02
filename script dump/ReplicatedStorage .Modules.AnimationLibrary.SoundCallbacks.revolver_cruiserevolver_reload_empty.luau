return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    for index = 1, 8 do
        arg1:CreateSound(
            "rbxassetid://134815282110155",
            1,
            (index - 1) * 0.05 + 1,
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.05625 / arg2) then
            return
        end
    end
end
