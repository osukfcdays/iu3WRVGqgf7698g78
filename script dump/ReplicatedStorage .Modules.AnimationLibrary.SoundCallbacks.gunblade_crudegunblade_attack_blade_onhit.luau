return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.38 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96886470957330",
        0.875,
        1 + 0.125 * math.random(),
        true,
        5
    )
end
