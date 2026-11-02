local v1 = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local TestLibrary_m = require(v1.Modules.TestLibrary)
local Utility_m = require(v1.Modules.Utility)
v1 = CONSTANTS_m.IS_SERVER

if v1 then
    v1 = require(ServerStorage.Services.CollisionsService)
end

local v2

if CONSTANTS_m.IS_CLIENT then
    v2 = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
end

v2 = CONSTANTS_m.IS_CLIENT and require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local StudioPing = TestLibrary_m:GetTestAttribute("StudioPing")
local ISSTUDIO = CONSTANTS_m.IS_STUDIO
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 21
    -- upvalues:
    --  [1] t (copy)

    assert(
        if typeof(arg1) == "Instance" then arg1:IsA("Humanoid") or arg1:IsA("BasePart") else false,
        "Argument 1 invalid, expected a Humanoid or BasePart"
    )
    local t_1 = setmetatable({}, t)
    t_1._subject = arg1
    t_1._is_humanoid = t_1._subject:IsA("Humanoid")
    t_1._is_final_finisher = arg2
    t_1._eliminator = arg3
    t_1._anchor_model_hash = 0
    t_1._destroy_these = {}
    t_1._connections = {}
    t_1._threads = {}
    t_1._destroyed = false
    t_1._serial = nil
    t_1._seed = math.random(1, 1000000)
    t_1._original_collision_groups = {}
    t_1._ragdolled = false
    t_1:_Init()

    return t_1
end

function t.CreateSound(
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    _,
    arg14
) -- line: 49
    -- upvalues:
    --  [1] Utility_m (copy)

    local v7 = Utility_m:CreateSound(
        arg5,
        arg6,
        arg7,
        arg8 or arg4._is_humanoid and arg4._subject.RootPart,
        arg9,
        arg10,
        arg11,
        arg12,
        arg4:_GetSoundGroup(),
        arg14
    )
    table.insert(arg4._destroy_these, v7)

    return v7
end

function t.Simulate(arg15, arg16) -- line: 58
    -- upvalues:
    --  [1] ISSTUDIO (copy)
    --  [2] StudioPing (copy)

    local BindableEvent = Instance.new("BindableEvent")
    table.insert(arg15._destroy_these, BindableEvent)
    local v8 = 0
    task.spawn(function() -- line: 64
        -- upvalues:
        --  [1] arg15 (copy)
        --  [2] arg16 (copy)
        --  [3] ISSTUDIO (ref)
        --  [4] v8 (ref)
        --  [5] BindableEvent (copy)

        local Success, Result = pcall(arg15.PlayServer, arg15, true)

        if not Success and arg16 then
            arg16(Result)
        end

        if not Success and ISSTUDIO then
            error(Result)
        end

        v8 += 1
        BindableEvent:Fire()
    end)
    task.spawn(function() -- line: 79
        -- upvalues:
        --  [1] StudioPing (ref)
        --  [2] arg15 (copy)
        --  [3] arg16 (copy)
        --  [4] ISSTUDIO (ref)
        --  [5] v8 (ref)
        --  [6] BindableEvent (copy)

        if StudioPing and StudioPing > 0 then
            wait(StudioPing / 1000)
        end

        local Success_1, Result_1 = pcall(arg15.PlayClient, arg15, true)

        if not Success_1 and arg16 then
            arg16(Result_1)
        end

        if not Success_1 and ISSTUDIO then
            error(Result_1)
        end

        v8 += 1
        BindableEvent:Fire()
    end)

    while true do
        if not (v8 < 2) then
            break
        end

        BindableEvent.Event:Wait()
    end
end

function t.PlayServer(_, _) -- line: 103
end

function t.PlayClient(_, _) -- line: 107
end

function t.SetSerial(arg21, arg22) -- line: 111
    arg21._serial = arg22
end

function t.Serialize(arg23) -- line: 115
    return { Seed = arg23._seed }
end

function t.Destroy(arg24) -- line: 123
    arg24._destroyed = true

    for _, val in pairs(arg24._connections) do
        val:Disconnect()
    end

    for _, val_1 in pairs(arg24._destroy_these) do
        val_1:Destroy()
    end

    for _, val_2 in pairs(arg24._threads) do
        pcall(task.cancel, val_2)
    end
end

function t._SetupProp(arg25, arg26) -- line: 143
    if not arg25._is_humanoid then
        return
    end

    local function get_motor6d(arg27) -- line: 148
        -- upvalues:
        --  [1] arg26 (copy)

        for _, child in pairs(arg26:GetChildren()) do
            if child.Name == arg27 and child:IsA("Motor6D") then
                return child
            end
        end
    end

    local t_3 = {}

    for _, val_3 in pairs(arg26:GetChildren()) do
        if val_3:IsA("BasePart") then
            local v11 = val_3:Clone()
            table.insert(arg25._destroy_these, v11)
            local v12 = get_motor6d(v11.Name):Clone()
            table.insert(arg25._destroy_these, v12)
            v12.Part1 = v11
            v12.Part0 = arg25._subject.RootPart
            v12:SetAttribute("IgnoreWhenRagdolling", true)
            v12.Parent = arg25._subject.RootPart

            local _ = function(arg28) --[[ format ]] -- line: 174
                if not arg28:IsA("BasePart") then
                    return
                end

                arg28.CanCollide = false
                arg28.CanTouch = false
                arg28.CanQuery = false
                arg28.Massless = true
            end

            for _, val_4 in pairs(v11:GetDescendants()) do
                if val_4:IsA("BasePart") then
                    val_4.CanCollide = false
                    val_4.CanTouch = false
                    val_4.CanQuery = false
                    val_4.Massless = true
                end
            end

            if v11:IsA("BasePart") then
                v11.CanCollide = false
                v11.CanTouch = false
                v11.CanQuery = false
                v11.Massless = true
            end

            v11:PivotTo(arg25._subject.RootPart.CFrame)
            v11.Parent = arg25._subject.Parent

            for _, val_5 in pairs(v11:GetDescendants()) do
                if val_5:IsA("ParticleEmitter") then
                    val_5:SetAttribute("IgnoreVisibilityCheck", true)
                end
            end

            table.insert(t_3, v11)
        end
    end

    return table.unpack(t_3)
end

function t._GetSoundGroup(arg29) -- line: 206
    -- upvalues:
    --  [1] v2 (copy)

    local v15 = if typeof(arg29._eliminator) == "Instance" then arg29._eliminator else false
    local v16 = v2 and v2.CurrentSubject and v2.CurrentSubject.Player

    return if not v15 then "Finisher" else if v15 == v16 then "Finisher" else "FinisherFromOthers"
end

function t._GetGroundPosition(_, arg31, arg32) -- line: 213
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:Raycast(
        arg31,
        arg31 + Vector3.new(0, -100, 0),
        100,
        arg32,
        Enum.RaycastFilterType.Exclude
    ).Position
end

function t._HideBody(arg33, arg34) -- line: 217
    for _, val_6 in pairs(arg33:_GetObjects(true)) do
        if not arg34 or not table.find(arg34, val_6) then
            if val_6:IsA("BasePart") then
                val_6.Transparency = 1
                val_6.Size = Vector3.new(0, 0, 0)
            elseif val_6 ~= arg33._subject then
                val_6:Destroy()
            end
        end
    end
end

function t._GetObjects(arg35, arg36) -- line: 232
    local v19

    if arg35._is_humanoid then
        local v20

        if not arg35._subject.Parent then
            v19 = {}

            if not v19 then
                v20 = if not arg36 then "GetChildren" else "GetDescendants"
                v19 = arg35._subject.Parent[v20](arg35._subject.Parent) or { arg35._subject }
            end
        else
            v20 = if not arg36 then "GetChildren" else "GetDescendants"
            v19 = arg35._subject.Parent[v20](arg35._subject.Parent) or { arg35._subject }
        end
    else
        v19 = { arg35._subject }
    end

    return v19
end

function t._SetAnimationConstraintsEnabled(arg37, arg38) -- line: 236
    arg37._are_animation_constraints_enabled = arg38

    for _, descendant in pairs(arg37._subject.Parent:GetDescendants()) do
        if descendant:IsA("AnimationConstraint") then
            descendant.Enabled = arg37._are_animation_constraints_enabled
        end
    end
end

function t._IsBodyMotor6D(_, arg40) -- line: 246
    local v22 = arg40:IsA("Motor6D")

    if v22 then
        v22 = not arg40:GetAttribute("IgnoreWhenRagdolling")
    end

    return v22
end

function t._BreakJoints(arg41) -- line: 250
    if not arg41._is_humanoid or not arg41._subject.Parent then
        return
    end

    for _, descendant_1 in pairs(arg41._subject.Parent:GetDescendants()) do
        if arg41:_IsBodyMotor6D(descendant_1) then
            descendant_1.Part0 = nil
            descendant_1.Part1 = nil
            descendant_1:Destroy()
        elseif descendant_1:IsA("MeshPart") then
            descendant_1.AssemblyLinearVelocity = arg41._subject.RootPart.AssemblyLinearVelocity
            descendant_1.AssemblyAngularVelocity = arg41._subject.RootPart.AssemblyAngularVelocity

            if descendant_1.Name == "Head" and descendant_1.Parent == arg41._subject.Parent then
                descendant_1.CanCollide = true
            end
        end
    end

    arg41._subject.Parent.DescendantAdded:Connect(function(descendant_2: Instance) -- line: 270
        -- upvalues:
        --  [1] arg41 (copy)

        if not arg41:_IsBodyMotor6D(descendant_2) then
            return
        end

        descendant_2.Part0 = nil
        descendant_2.Part1 = nil
        task.defer(descendant_2.Destroy, descendant_2)
    end)
end

function t._AnchorModel(arg43, arg44, arg45) -- line: 281
    -- upvalues:
    --  [1] v1 (copy)

    arg43._anchor_model_hash += 1

    if not arg43._is_humanoid then
        return
    end

    local v24 = arg44 or 3
    local v25 = if arg45 ~= nil then arg45 else true
    local AnchorModelHash = arg43._anchor_model_hash

    local function anchor() -- line: 292
        -- upvalues:
        --  [1] arg43 (copy)
        --  [2] AnchorModelHash (copy)
        --  [3] v1 (ref)
        --  [4] v25 (copy)

        if not arg43._subject.Parent or AnchorModelHash ~= arg43._anchor_model_hash then
            return
        end

        for _, descendant_3 in pairs(arg43._subject.Parent:GetDescendants()) do
            if descendant_3:IsA("BasePart") then
                if v1 then
                    v1:ClearSetDescendantsLogic(descendant_3, true)
                end

                local v27 = arg43._original_collision_groups[descendant_3]
                local OriginalCollisionGroups = arg43._original_collision_groups

                if not v27 then
                    v27 = descendant_3.CollisionGroup
                end

                OriginalCollisionGroups[descendant_3] = v27
                local v28 = if not v25 then arg43._original_collision_groups[descendant_3] or descendant_3.CollisionGroup else "Noclip"
                descendant_3.CollisionGroup = v28
                descendant_3.Anchored = v25
            end
        end
    end

    if v24 <= 0 then
        task.spawn(anchor)

        return
    end

    task.delay(v24 or 3, anchor)
end

function t._Ragdoll(arg46) -- line: 319
    if not arg46._is_humanoid or not arg46._subject.Parent then
        return
    end

    arg46._ragdolled = true
    arg46:_SetAnimationConstraintsEnabled(false)

    for _, descendant_4 in pairs(arg46._subject.Parent:GetDescendants()) do
        if arg46:_IsBodyMotor6D(descendant_4) then
            local Attachment = Instance.new("Attachment")
            Attachment.CFrame = descendant_4.C0
            Attachment.Name = descendant_4.Name .. " - A0"
            Attachment.Parent = descendant_4.Part0
            local Attachment_1 = Instance.new("Attachment")
            Attachment_1.CFrame = descendant_4.C1
            Attachment_1.Name = descendant_4.Name .. " - A1"
            Attachment_1.Parent = descendant_4.Part1
            local RagdollBSC_BallSocketConstraint = Instance.new("BallSocketConstraint")
            RagdollBSC_BallSocketConstraint.Attachment0 = Attachment
            RagdollBSC_BallSocketConstraint.Attachment1 = Attachment_1
            RagdollBSC_BallSocketConstraint.Name = "RagdollBSC"
            RagdollBSC_BallSocketConstraint.LimitsEnabled = true
            RagdollBSC_BallSocketConstraint.TwistLimitsEnabled = true
            RagdollBSC_BallSocketConstraint.MaxFrictionTorque = 10
            RagdollBSC_BallSocketConstraint.Parent = descendant_4.Part0
            descendant_4:Destroy()
        end
    end

    arg46._subject.Parent.DescendantAdded:Connect(function(descendant_5: Instance) -- line: 354
        -- upvalues:
        --  [1] arg46 (copy)

        if arg46:_IsBodyMotor6D(descendant_5) then
            task.defer(descendant_5.Destroy, descendant_5)
        end
    end)
end

function t._InternalThread(arg48, arg49, ...) -- line: 361
    -- upvalues:
    --  [1] ISSTUDIO (copy)

    local v30 = nil

    if ISSTUDIO then
        v30 = arg49(...)
    else
        pcall(function(...) -- line: 367
            -- upvalues:
            --  [1] v30 (ref)
            --  [2] arg49 (copy)

            v30 = arg49(...)
        end, ...)
    end

    table.insert(arg48._threads, v30)

    return v30
end

function t._Setup(arg50) -- line: 377
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    if not arg50._is_humanoid or not CONSTANTS_m.IS_SERVER then
        return
    end

    for _, descendant_6 in pairs(arg50._subject.Parent:GetDescendants()) do
        if descendant_6:IsA("AnimationConstraint") then
            descendant_6:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 385
                -- upvalues:
                --  [1] descendant_6 (copy)
                --  [2] arg50 (copy)

                descendant_6.Enabled = arg50._are_animation_constraints_enabled
            end)
        end
    end

    for _, child_1 in pairs(arg50._subject:GetChildren()) do
        if child_1:IsA("NumberValue") then
            task.defer(child_1.Destroy, child_1)
        end
    end
end

function t._Init(arg51) -- line: 399
    arg51._subject.Destroying:Connect(function() -- line: 400
        -- upvalues:
        --  [1] arg51 (copy)

        arg51:Destroy()
    end)
    arg51:_Setup()
    arg51:_SetAnimationConstraintsEnabled(true)
end

return t
