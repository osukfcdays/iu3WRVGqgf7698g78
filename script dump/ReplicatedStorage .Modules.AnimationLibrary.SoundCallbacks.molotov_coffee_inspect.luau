return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.9 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17814389291",
        1,
        1.25,
        true,
        10
    )
end
