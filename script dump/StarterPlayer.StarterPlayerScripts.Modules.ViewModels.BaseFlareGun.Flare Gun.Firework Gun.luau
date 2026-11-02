local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FlareGun_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseFlareGun["Flare Gun"]
)
local t = setmetatable({}, FlareGun_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] FlareGun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(FlareGun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 29
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] RunService (copy)

    task.defer(function() -- line: 30
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] Utility_m (ref)
        --  [3] RunService (ref)

        arg1.ClientItem.ProjectileShot:Connect(function(arg2, arg3) -- line: 31
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] arg1 (ref)
            --  [3] RunService (ref)

            local Primary = arg3.Primary
            local Explode = arg3.Primary.explode
            Utility_m:CreateSound(
                "rbxassetid://17684836623",
                1.25,
                1,
                Primary,
                true,
                5
            )
            local v2 = tick() + 0.5

            while true do
                if
                    arg1._destroyed
                    or not arg3:IsDescendantOf(workspace)
                    or not (v2 > tick()) and not (arg2.Velocity.Y >= 0)
                then
                    break
                end

                RunService.RenderStepped:Wait()
            end

            Utility_m:PlayParticles(Explode)
            Utility_m:CreateSound(
                "rbxassetid://17684836889",
                1.25,
                1,
                Primary,
                true,
                5
            )
        end)
    end)
end

return t
