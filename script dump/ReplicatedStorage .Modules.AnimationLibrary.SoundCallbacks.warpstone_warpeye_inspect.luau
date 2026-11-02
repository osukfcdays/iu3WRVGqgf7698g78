return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://111876623538044",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
