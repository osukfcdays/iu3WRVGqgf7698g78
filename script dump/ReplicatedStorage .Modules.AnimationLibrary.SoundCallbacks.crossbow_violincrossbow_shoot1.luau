return function(arg1, _, _) -- line: 1
    local v1, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local clampedValue = math.clamp(v1 / 1.3962634015954636, -1, 1)
    arg1:CreateSound(
        "rbxassetid://82715240396507",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://100943371677728",
        1,
        clampedValue * 0.5 + 1,
        true,
        10
    )
end
