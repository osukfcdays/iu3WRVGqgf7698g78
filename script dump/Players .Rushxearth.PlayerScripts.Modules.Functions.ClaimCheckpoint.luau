local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)

return function(arg1, arg2) -- line: 6
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] DuelLibrary_m (copy)

    Utility_m:PlayParticles(arg1.Primary)
    Utility_m:CreateSound(
        "rbxassetid://98948832050219",
        2,
        1,
        arg1.Primary,
        true,
        5
    )
    Utility_m:CreateSound(
        "rbxassetid://129130524317348",
        1.5,
        1,
        arg1.Primary,
        true,
        5
    )
    local Flag = arg1.Flag
    Flag.CFrame = Flag.CFrame * CFrame.new(0, 4, 0)
    arg1.Flag.Color = DuelLibrary_m:GetTeamColor(arg2)
    arg1.Flag.Transparency = 0
    local pivot = arg1:GetPivot()
    local cframe = CFrame.Angles(
        6.283185307179586 * math.random(),
        6.283185307179586 * math.random(),
        6.283185307179586 * math.random()
    )
    local scale = arg1:GetScale()
    local v5 = scale * 0.5
    Utility_m:RenderstepForLoop(0, 100, 2, function(arg3) -- line: 23
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] v5 (copy)
        --  [3] scale (copy)
        --  [4] pivot (copy)
        --  [5] cframe (copy)

        local v6 = 1 - (1 - arg3 / 100) ^ 3
        arg1:ScaleTo(v5 + (scale - v5) * v6)
        arg1:PivotTo(
            pivot * CFrame.Angles(0, 0 + 9.42477796076938 * v6, 0) * cframe:Lerp(
                CFrame.identity,
                v6
            )
        )
    end)
end
