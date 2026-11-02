return function(arg1, _, _) -- line: 1
    local v1, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local clampedValue = math.clamp(v1 / 1.3962634015954636, -1, 1)
    arg1:CreateSound(
        "rbxassetid://77594993345414",
        0.875,
        clampedValue * 0.4 + 0.9,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://132970131270232",
        0.875,
        clampedValue * 0.2 + 0.95,
        true,
        5
    )
end
