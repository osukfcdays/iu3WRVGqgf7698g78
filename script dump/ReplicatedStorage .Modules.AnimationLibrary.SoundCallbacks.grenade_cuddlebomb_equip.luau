return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://89929936303974",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
