return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://114610550422028",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )
end
