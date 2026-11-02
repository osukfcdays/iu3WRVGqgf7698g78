local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientCustomEntity_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientCustomEntity
)
local t = setmetatable({}, ClientCustomEntity_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] ClientCustomEntity_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientCustomEntity_m.new(...), t)
    t_1._original_cframe_before_shaking = nil
    t_1._death_vfx = t_1.Model:FindFirstChild("DeathVFX", true)
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 27
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] ClientCustomEntity_m (copy)

    if arg2 == "StoredMonsterDieOnPresence" then
        if not arg1:IsRendered() then
            return
        end

        local v2 = ...
        local pivot = arg1.Model:GetPivot()
        local rng = Random.new()
        local now = tick()
        arg1._original_cframe_before_shaking = arg1.RootPart.CFrame

        while true do
            if arg1._destroyed or not arg1.RootPart:IsDescendantOf(workspace) then
                break
            end

            arg1.Model:PivotTo(
                pivot + rng:NextUnitVector() * Vector3.new(1, 0, 1) * math.min(
                    1,
                    (tick() - now) / v2
                ) ^ 4
            )
            RunService.RenderStepped:Wait()
        end
    else
        ClientCustomEntity_m.ReplicateFromServer(arg1, arg2, ...)
    end
end

function t._PlayDeathVFX(arg3) -- line: 57
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)

    if not arg3._death_vfx then
        return
    end

    local Part = Instance.new("Part")
    local v4 = arg3._original_cframe_before_shaking or arg3.RootPart.CFrame
    Part.CFrame = v4
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0, 0, 0)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 10)
    arg3._death_vfx.Parent = Part
    Utility_m:PlayParticles(arg3._death_vfx)
end

function t._Init(arg4) -- line: 77
    arg4.Died:Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_PlayDeathVFX()
    end)
end

return t
