return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.125 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14522189766",
        2,
        1 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://137900058595276",
        1,
        1.25,
        true,
        10
    )
end
