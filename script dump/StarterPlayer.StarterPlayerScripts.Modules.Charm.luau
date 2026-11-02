local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Charms = Players.LocalPlayer.PlayerScripts.Assets.Charms
local cframe = CFrame.Angles(0.7853981633974483, 0, 0)
local t = { 6.283185307179586, -6.283185307179586 }
local t_1 = {}
local t_2 = { X = Vector3.new(1, 0, 0), Y = Vector3.new(0, 1, 0), Z = Vector3.new(0, 0, 1) }
t_1.__index = t_1

function t_1.new(arg1, arg2, arg3) -- line: 15
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Charms (copy)
    --  [3] Spring_m (copy)

    local t_3 = setmetatable({}, t_1)
    t_3.ClientViewModel = arg1
    t_3.EquippedData = arg2
    t_3.Name = t_3.EquippedData.Name
    t_3.Model = Charms[t_3.Name]:Clone()
    t_3._original_scale = t_3.Model:GetScale()
    t_3._charm_pivot_attachment = arg3
    t_3._pivot_attachment = t_3.Model:FindFirstChild("_pivot_attachment", true)
    t_3._pivot_charm_scale = t_3._charm_pivot_attachment:GetAttribute("CharmScale") or 1
    t_3._orientation_spring = Spring_m.new(Vector3.new(0, 0, 0), 0.25, 10)
    t_3._no_physics = t_3._charm_pivot_attachment:GetAttribute("NoPhysics")
    t_3._hide_until = 0
    t_3:_Init()

    return t_3
end

function t_1.SetParent(arg4, arg5) -- line: 40
    arg4.Model.Parent = arg5
end

function t_1.ScaleTo(arg6, arg7) -- line: 44
    arg6.Model:ScaleTo(arg6._original_scale * arg6._pivot_charm_scale * arg7)
end

function t_1.SetHidden(arg8, arg9) -- line: 48
    local v2 = if not arg9 then 0 else 1

    for _, descendant in pairs(arg8.Model:GetDescendants()) do
        if
            descendant:IsA("BasePart")
            or descendant:IsA("Texture")
            or descendant:IsA("Beam")
            or descendant:IsA("ParticleEmitter")
            or descendant:IsA("Trail")
            or descendant:IsA("Decal")
        then
            descendant.LocalTransparencyModifier = v2
        end
    end
end

function t_1.Update(arg10, _, arg12) -- line: 58
    -- upvalues:
    --  [1] cframe (copy)
    --  [2] t_2 (copy)
    --  [3] t (copy)

    if arg12 or arg10._no_physics then
        arg10.Model:PivotTo(arg10._charm_pivot_attachment.WorldCFrame)

        return
    end

    local vec3_1 = Vector3.new(
        arg10._charm_pivot_attachment.WorldCFrame.LookVector.X,
        -1,
        arg10._charm_pivot_attachment.WorldCFrame.LookVector.Z
    )
    local v5 = CFrame.new(Vector3.new(0, 0, 0), vec3_1) * cframe
    local v6 = arg10.ClientViewModel and CFrame.Angles(
        0,
        0,
        -arg10.ClientViewModel.CurrentSwayValue.Y * 5
    ) or CFrame.identity
    local v8 = arg10._charm_pivot_attachment.WorldCFrame.Rotation:ToObjectSpace(v5 * v6)
    arg10._orientation_spring.Target = Vector3.new(v8:ToOrientation())
    local _ = v8:ToOrientation()

    for key_1, val in pairs(t_2) do
        for _, val_1 in pairs(t) do
            if math.abs(
                arg10._orientation_spring.Value[key_1] - (arg10._orientation_spring.Target[key_1] + val_1)
            ) < math.abs(
                arg10._orientation_spring.Value[key_1] - arg10._orientation_spring.Target[key_1]
            ) then
                local OrientationSpring_1 = arg10._orientation_spring
                OrientationSpring_1.Value -= val * val_1
            end
        end
    end

    local Value = arg10._orientation_spring.Value
    local v10 = arg10._charm_pivot_attachment.WorldCFrame * CFrame.fromOrientation(
        Value.X,
        Value.Y,
        Value.Z
    )
    arg10.Model:PivotTo(v10)
end

function t_1.Destroy(arg13) -- line: 84
    arg13.Model:Destroy()
end

function t_1._SetupSeasonRankCharm(arg14) -- line: 92
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)

    if #arg14.Name < 8 or string.sub(arg14.Name, 1, 7) ~= "Season " then
        return
    end

    local num = tonumber((string.sub(arg14.Name, 8)))

    if not num then
        return
    end

    local Name = SeasonLibrary_m.SeasonsByVersion[num].Name
    local v11 = arg14.EquippedData.Metadata and arg14.EquippedData.Metadata.SeasonELO or nil
    local v12 = arg14.EquippedData.Metadata and arg14.EquippedData.Metadata.SeasonLeaderboardRank or nil
    SeasonLibrary_m:FormatSeasonRankCharm(arg14.Model, Name, v11, v12)
end

function t_1._Setup(arg15) -- line: 110
    assert(arg15._pivot_attachment ~= nil, arg15.Name)

    if arg15._no_physics and arg15.Model:FindFirstChild("Hook") then
        arg15.Model.Hook:Destroy()
    end

    local Model = arg15.Model
    Model.WorldPivot = arg15._no_physics and arg15.Model.Primary.CFrame or arg15._pivot_attachment.WorldCFrame
    arg15.Model.PrimaryPart = nil

    for _, descendant_1 in pairs(arg15.Model:GetDescendants()) do
        if descendant_1:IsA("BasePart") then
            descendant_1.CastShadow = false
            descendant_1.CanCollide = false
            descendant_1.CanTouch = false
            descendant_1.CanQuery = false
            descendant_1.Massless = true
            descendant_1.Anchored = true
        end
    end

    if arg15.Model:FindFirstChild("Hook") and arg15.Model.Hook:FindFirstChild("Ring") then
        arg15.Model.Hook.Ring.Material = Enum.Material.Glass
    end

    if arg15._pivot_charm_scale ~= 1 then
        arg15:ScaleTo(1)
    end
end

function t_1._Init(arg16) -- line: 142
    arg16:_Setup()
    task.defer(arg16._SetupSeasonRankCharm, arg16)
end

return t_1
