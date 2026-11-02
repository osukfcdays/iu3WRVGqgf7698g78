return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://137209644295911",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://135586619814232",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
