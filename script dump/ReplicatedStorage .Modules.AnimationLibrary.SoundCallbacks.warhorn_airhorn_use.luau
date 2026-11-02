return function(arg1, _, _) -- line: 1
    local v1 = arg1:CreateSound(
        "rbxassetid://128459467144728",
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
end
