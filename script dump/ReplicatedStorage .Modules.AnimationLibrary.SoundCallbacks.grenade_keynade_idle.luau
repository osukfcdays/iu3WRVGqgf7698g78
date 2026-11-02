return function(arg1, _, _) -- line: 1
    local v1 = arg1:CreateSound(
        "rbxassetid://122734338191015",
        0.1,
        1,
        true,
        nil,
        8,
        24
    )

    if v1 then
        v1.Looped = true
    end
end
