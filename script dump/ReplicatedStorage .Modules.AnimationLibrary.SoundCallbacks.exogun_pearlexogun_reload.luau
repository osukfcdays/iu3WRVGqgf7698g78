return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17266070911",
        0.75,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://121938614359106",
        0.75,
        0.75,
        true,
        10
    )
end
