return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://136633555539199",
        1,
        0.625,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://21343225",
        0.25 + 0.125 * math.random(),
        0.9 + 0.2 * math.random(),
        true,
        10
    )
end
