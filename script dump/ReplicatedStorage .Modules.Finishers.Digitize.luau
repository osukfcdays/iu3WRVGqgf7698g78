local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
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
    --  [2] DuelLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] Spring_m (copy)
    --  [5] RunService (copy)

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

    local v6 = v5

    if v6 then
        v6 = v5:GetAttribute("TeamID")

        if v6 then
            v6 = DuelLibrary_m:GetTeamColor(v5:GetAttribute("TeamID"))
        end
    end

    local v8 = script.Model:Clone()
    v8.Part.BillboardGui.Headshot.Image = if v5 then string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        v5.UserId
    ) else ""
    v8.Parent = arg1._subject

    if v6 then
        v8.Extra.Neon.Color = v6
        v8.Extra.Ring.Color = v6
        v8.Extra.NeonCone.Color = v6
        v8.Extra.Model["Meshes/HandLamp_01c"].Beam.Color = ColorSequence.new(v6)
    end

    v6 = arg1:_GetObjects(true)
    v5 = Spring_m.new(v3.Position, 1, 2)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 54
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] arg1 (copy)
        --  [3] v3 (copy)
        --  [4] v6 (copy)
        --  [5] v8 (copy)
        --  [6] cframe (copy)

        v5.Target = arg1:_GetGroundPosition(v3.Position, v6)
        v8:PivotTo(CFrame.new(v5.Value.X, v5.Target.Y, v5.Value.Z) * cframe)
    end)
    table.insert(arg1._connections, RenderSteppedConnection)
    arg1:CreateSound(
        "rbxassetid://80428386536466",
        1.25,
        1,
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://138661631832263",
        1.5,
        1,
        nil,
        true,
        5
    )
    wait(3)
    RenderSteppedConnection:Disconnect()
    wait(7)
end

function t._Init(_) -- line: 75
end

return t
