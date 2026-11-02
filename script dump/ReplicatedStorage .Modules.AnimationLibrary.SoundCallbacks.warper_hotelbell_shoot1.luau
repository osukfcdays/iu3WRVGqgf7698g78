return function(arg1, _, _) -- line: 1
    local v1, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    arg1:CreateSound(
        "rbxassetid://120936003285451",
        0.875,
        math.clamp(v1 / 1.3962634015954636, -1, 1) * 0.25 + 1,
        true,
        5
    )
end
