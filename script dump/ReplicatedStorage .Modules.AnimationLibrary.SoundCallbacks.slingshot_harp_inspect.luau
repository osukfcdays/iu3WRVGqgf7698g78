return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 3.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://106485622539697",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
