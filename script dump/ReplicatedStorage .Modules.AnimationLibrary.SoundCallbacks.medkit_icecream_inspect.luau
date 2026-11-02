return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://122265646069920",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
