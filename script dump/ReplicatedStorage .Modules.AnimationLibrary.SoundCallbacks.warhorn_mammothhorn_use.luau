return function(arg1, _, _) -- line: 1
    local v1 = arg1:CreateSound(
        "rbxassetid://116889597355364",
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
end
