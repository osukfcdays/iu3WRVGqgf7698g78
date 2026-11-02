local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ClientCustomEntity_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientCustomEntity
)
local ShatterVisuals = Players.LocalPlayer.PlayerScripts.Assets.Destructables.ShatterVisuals
local Visuals = Players.LocalPlayer.PlayerScripts.Assets.Destructables.Visuals
local cframe = CFrame.Angles(0, 1.5707963267948966, 0)
local t = setmetatable({}, ClientCustomEntity_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] ClientCustomEntity_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] ShatterVisuals (copy)

    local t_1 = setmetatable(ClientCustomEntity_m.new(...), t)
    t_1.ShatterModelAdded = Signal_m.new()
    t_1.AimAssistBlacklist = true
    t_1.PlayRubbleEffectOnDeath = nil
    t_1._shatter_template = ShatterVisuals:FindFirstChild(t_1.Model.Name)
    t_1._death_animation_override = true
    t_1._death_sound_override = true
    t_1._visual = nil
    t_1._always_face_camera = t_1.Model:GetAttribute("AlwaysFaceCamera") or false
    local v2 = t_1.Model:GetAttribute("ShatterSoundID")

    if not v2 then
        v2 = t_1._shatter_template and t_1._shatter_template:GetAttribute("ShatterSoundID") or "rbxassetid://14441658101"
    end

    t_1._shatter_sound_id = v2
    t_1._next_update = 0
    t_1._shatter_effect_chance = 1
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 54
    -- upvalues:
    --  [1] ClientCustomEntity_m (copy)

    arg1.ShatterModelAdded:Destroy()
    ClientCustomEntity_m.Destroy(arg1)
end

function t._RubbleEffect(arg2, _) -- line: 63
    for _, descendant in pairs(arg2.Model:GetDescendants()) do
        local v4 = descendant:HasTag("IsRubble")

        if descendant:IsA("BasePart") or descendant:IsA("Decal") or descendant:IsA("Texture") then
            local v5 = if not v4 then 1 else 0
            descendant.Transparency = v5
        end

        if descendant:IsA("BasePart") then
            descendant.CanCollide = v4
        end
    end
end

function t._ShatterEffect(arg4, arg5) -- line: 77
    -- upvalues:
    --  [1] cframe (copy)
    --  [2] Utility_m (copy)

    local v8 = arg4._visual and arg4._visual.CFrame * cframe:Inverse() * CFrame.Angles(
        0,
        6.283185307179586 * math.random(),
        0
    ) or arg4.Model:GetPivot()
    arg4.Model:ClearAllChildren()

    if
        math.random() > arg4._shatter_effect_chance
        and (workspace.CurrentCamera.CFrame.Position - v8.Position).Magnitude > 24
    then
        return
    end

    local v9 = arg4._shatter_template:Clone()
    v9.Parent = arg4.Model
    v9.PrimaryPart = v9.Primary
    v9:PivotTo(v8)
    v9.PrimaryPart:Destroy()
    local v10 = v9:GetAttribute("ShatterStrength") or 1
    local rng = Random.new()

    for _, child in pairs(v9:GetChildren()) do
        local LookVector = CFrame.new(arg4.RootPart.Position, child.Position).LookVector
        local v12 = Vector3.new(LookVector.X, math.max(0, LookVector.Y) * 2, LookVector.Z) * (10 + 10 * math.random()) * v10
        child.CanCollide = true
        child.CanTouch = false
        child.Anchored = false
        child.RotVelocity = rng:NextUnitVector() * 25 * math.random()
        child.Velocity = v12
        local v14 = pairs
        local _ = math.random()

        for _, val in v14(v9:GetChildren()) do
            if val ~= child then
                local NoCollisionConstraint = Instance.new("NoCollisionConstraint")
                NoCollisionConstraint.Part0 = child
                NoCollisionConstraint.Part1 = val
                NoCollisionConstraint.Parent = child
            end
        end
    end

    if not arg5 then
        Utility_m:CreateSound(
            arg4._shatter_sound_id,
            0.625 + 0.25 * math.random(),
            1.5 + 0.5 * math.random(),
            v8.Position,
            true,
            10
        )
    end

    if arg4._visual then
        arg4._visual:Destroy()
        arg4._visual = nil
    end

    arg4.ShatterModelAdded:Fire(v9)
end

function t._CheckDead(arg6, arg7) -- line: 132
    if arg6:IsAlive() then
        return
    end

    if arg6.PlayRubbleEffectOnDeath then
        arg6:_RubbleEffect(arg7)

        return
    end

    arg6:_ShatterEffect(arg7)
end

function t._Setup(arg8) -- line: 144
    -- upvalues:
    --  [1] Visuals (copy)

    local v18 = Visuals:FindFirstChild(arg8.Model.Name)

    if v18 then
        arg8._visual = v18:Clone()
        arg8._visual.CanCollide = false
        arg8._visual.CanQuery = false
        arg8._visual.CanTouch = false
        arg8._visual.Anchored = true
        arg8._visual.Parent = arg8.Model
    end
end

function t._Init(arg9) -- line: 157
    arg9.Died:Connect(function() -- line: 158
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_CheckDead()
    end)
    arg9:_Setup()
    task.defer(arg9._CheckDead, arg9, true)
end

return t
