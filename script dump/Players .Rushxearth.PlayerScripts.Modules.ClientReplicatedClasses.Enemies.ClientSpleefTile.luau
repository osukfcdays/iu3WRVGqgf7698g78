local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Utility)
local ClientDestructable_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientCustomEntity.ClientDestructable
)
local _ = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ExplosiveZombieExplosionEffect"
)
local t = setmetatable({}, ClientDestructable_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientDestructable_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientDestructable_m.new(...), t)
    t_1._shatter_effect_chance = 0.5
    t_1._colored_tile_part = t_1.Model:FindFirstChild("ColoredTile")
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 29
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] ClientDestructable_m (copy)

    if arg2 == "SpleefTileShake" then
        if not arg1:IsRendered() or not arg1._colored_tile_part then
            return
        end

        local _ = ...
        local pivot = arg1._colored_tile_part:GetPivot()
        local now = tick()

        while true do
            if not arg1:IsAlive() then
                break
            end

            local clampedValue = math.clamp(tick() - now, 0, 1)
            local ColoredTilePart = arg1._colored_tile_part
            local v3 = math.random() - 0.5
            ColoredTilePart:PivotTo(
                pivot + Vector3.new(v3, math.random() - 0.5, math.random() - 0.5) * clampedValue * 2
            )
            RunService.RenderStepped:Wait()
        end
    else
        ClientDestructable_m.ReplicateFromServer(arg1, arg2, ...)
    end
end

function t._Init(arg3) -- line: 59
    arg3.ShatterModelAdded:Connect(function(arg4) -- line: 60
        -- upvalues:
        --  [1] arg3 (copy)

        if not arg3._colored_tile_part then
            return
        end

        for _, val in pairs(arg4:GetChildren()) do
            if val:IsA("BasePart") then
                val.Color = arg3._colored_tile_part.Color
            end
        end
    end)
end

return t
