return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://103973278699608",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
