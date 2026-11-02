local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1) -- line: 25
    -- upvalues:
    --  [1] Players (copy)
    --  [2] Utility_m (copy)
    --  [3] Spring_m (copy)
    --  [4] RunService (copy)

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.LocalTransparencyModifier = 1
        elseif
            val:IsA("Decal")
            or val:IsA("Texture")
            or val:IsA("Beam")
            or val:IsA("ParticleEmitter")
            or val:IsA("Trail")
            or val:IsA("SurfaceAppearance")
        then
            val:Destroy()
        end
    end

    local v3 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v5 = arg1._is_humanoid

    if v5 then
        v5 = Players:GetPlayerFromCharacter(arg1._subject.Parent)
    end

    local v6 = script.Model:Clone()
    local TextLabel = v6.Extra.Screen.SurfaceGui.TextLabel
    TextLabel.Text = v5 and v5.DisplayName or "RIP"
    v6.Parent = arg1._subject
    Utility_m:PlayParticles(v6.Extra.Particles)
    v5 = arg1:_GetObjects(true)
    local v8 = Spring_m.new(v3.Position, 1, 2)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 47
        -- upvalues:
        --  [1] v8 (copy)
        --  [2] arg1 (copy)
        --  [3] v3 (copy)
        --  [4] v5 (copy)
        --  [5] v6 (copy)
        --  [6] cframe (copy)

        v8.Target = arg1:_GetGroundPosition(v3.Position, v5)
        v6:PivotTo(CFrame.new(v8.Value.X, v8.Target.Y, v8.Value.Z) * cframe)
    end)
    table.insert(arg1._connections, RenderSteppedConnection)
    local v12 = 0.95 + 0.1 * math.random()
    arg1:CreateSound(
        "rbxassetid://123329322643049",
        1,
        v12,
        v3,
        true,
        10
    )
    wait(3)
    RenderSteppedConnection:Disconnect()
    wait(7)
end

function t._Init(_) -- line: 67
end

return t
