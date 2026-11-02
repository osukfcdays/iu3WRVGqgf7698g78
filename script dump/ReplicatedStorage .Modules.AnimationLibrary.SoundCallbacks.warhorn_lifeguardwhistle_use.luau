return function(arg1, arg2, arg3) -- line: 1
    local v1 = arg1:CreateSound(
        "rbxassetid://72342434543613",
        1,
        1,
        true,
        5,
        100,
        400
    )

    if v1 then
        v1:SetAttribute("DontClearSound", true)
    end

    local v2 = arg1:CreateSound(
        "rbxassetid://94406584083681",
        1,
        1,
        true,
        5,
        100,
        400
    )

    if v2 then
        v2:SetAttribute("DontClearSound", true)
    end

    if not arg1:_AnimationWait(script.Name, arg3, 0.07 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.5,
        1.25,
        true,
        10
    )
end
