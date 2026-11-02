local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = { 6.15, 6.35, 6.6, 6.8, 7.15, 7.45, 7.8, 8.25, 8.8, 9.6, 11.05 }

return function(arg1) -- line: 8
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] RunService (copy)
    --  [3] t (copy)

    local v1 = arg1:FindFirstChild("HumanoidRootPart") or arg1:FindFirstChild("RootPart")
    Utility_m:CreateSound(
        "rbxassetid://97748906880096",
        1,
        1,
        v1,
        true
    )
    wait(1.45)
    Utility_m:CreateSound(
        "rbxassetid://103519956736851",
        1,
        1.25,
        v1,
        true
    )
    wait(0.6)
    local now = tick()

    local _ = function() --[[ get_pitch ]] -- line: 24
        -- upvalues:
        --  [1] now (copy)

        return (1.5 + -0.3999999999999999 * ((tick() - now) / 9) ^ 2) * (0.975 + 0.05 * math.random())
    end

    local v3 = tick() + 4
    local v4 = 0

    while true do
        if not (v3 > tick()) then
            break
        end

        if v4 < tick() then
            Utility_m:CreateSound(
                "rbxassetid://103519956736851",
                0.8,
                (1.5 + -0.3999999999999999 * ((tick() - now) / 9) ^ 2) * (0.975 + 0.05 * math.random()),
                v1,
                true
            )
            v4 = tick() + 0.08
        end

        RunService.RenderStepped:Wait()
    end

    for key, val in pairs(t) do
        wait(val - (t[key - 1] or 6.05))
        Utility_m:CreateSound(
            "rbxassetid://103519956736851",
            0.8,
            (1.5 + -0.3999999999999999 * ((tick() - now) / 9) ^ 2) * (0.975 + 0.05 * math.random()),
            v1,
            true
        )
    end

    wait(3.95)
end
