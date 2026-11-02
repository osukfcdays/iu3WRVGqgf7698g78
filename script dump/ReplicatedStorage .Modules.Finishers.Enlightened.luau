local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local color = Color3.fromRGB(255, 255, 255)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 26
    arg1:_AnchorModel(0)
    arg1:_InternalThread(task.delay, 2, function() -- line: 29
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_AnchorModel(0, false)
        arg1:_AnchorModel()
        arg1:_BreakJoints()

        for _, val in pairs(arg1:_GetObjects()) do
            if val:IsA("Clothing") then
                val:Destroy()
            end

            if val:IsA("BasePart") then
                for _, val_1 in pairs(val:GetChildren()) do
                    if val_1:IsA("Texture") or val_1:IsA("Decal") then
                        val_1:Destroy()
                    end
                end

                val.Material = Enum.Material.Neon
                local BodyForce = Instance.new("BodyForce")
                BodyForce.Force = Vector3.new(0, 1, 0) * workspace.Gravity * val:GetMass() * (1.25 + 0.5 * math.random())
                BodyForce.Parent = val
                val.Velocity = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5).Unit * 80 * math.random()
                local v8 = math.random() - 0.5
                val.RotVelocity = Vector3.new(v8, math.random() - 0.5, math.random() - 0.5) * 180 * math.random()
                val.CFrame = val.CFrame * CFrame.Angles(
                    math.random() * 3.141592653589793 * 2,
                    math.random() * 3.141592653589793 * 2,
                    math.random() * 3.141592653589793 * 2
                )
            end
        end
    end)
end

function t.PlayClient(arg2, ...) -- line: 62
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] color (copy)
    --  [3] Utility_m (copy)

    local v14 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    local v15 = arg2._is_humanoid and arg2._subject.Parent.Head or arg2._subject
    local v16 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local pivot = v14:GetPivot()
    local now = tick()
    local t_2 = {}
    local t_3 = {}
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function(_) -- line: 72
        -- upvalues:
        --  [1] now (copy)
        --  [2] v14 (copy)
        --  [3] pivot (copy)
        --  [4] arg2 (copy)
        --  [5] t_3 (copy)
        --  [6] color (ref)
        --  [7] t_2 (copy)

        if tick() >= now + 2 then
            return
        end

        local clampedValue = math.clamp((tick() - now) / 2, 0, 1)
        local v17 = v14
        local v18 = pivot
        local v19 = math.random() - 0.5
        v17:PivotTo(
            v18 + Vector3.new(v19, math.random() - 0.5, math.random() - 0.5) * 3 * clampedValue ^ 3
        )

        for _, val_2 in pairs(arg2:_GetObjects(true)) do
            if val_2:IsA("BasePart") then
                local v23 = t_3
                local v24 = t_3[val_2] or val_2.Color
                v23[val_2] = v24
                val_2.Color = t_3[val_2]:Lerp(color, clampedValue)
            end
        end

        for _, val_3 in pairs(t_2) do
            local clampedValue_1 = math.clamp((tick() - now - val_3.AppearDelay) / 0.5, 0, 1)

            for _, val_4 in pairs(val_3.Object:GetDescendants()) do
                if val_4:IsA("ParticleEmitter") or val_4:IsA("Beam") then
                    val_4.LocalTransparencyModifier = 1 - clampedValue_1
                end
            end
        end
    end))

    local _ = function(arg4) --[[ add_effect ]] -- line: 99
        -- upvalues:
        --  [1] t_2 (copy)

        local t_4 = { AppearDelay = 1.5 * math.random(), Object = arg4 }
        table.insert(t_2, t_4)
    end

    for _, child in pairs(script.Head:GetChildren()) do
        local v28 = child:Clone()
        v28.Parent = v15
        table.insert(arg2._destroy_these, v28)
        table.insert(t_2, { AppearDelay = 1.5 * math.random(), Object = v28 })
    end

    for _, val_5 in pairs(arg2:_GetObjects(true)) do
        if val_5:IsA("BasePart") and val_5.Name ~= "Head" and not (val_5.Transparency > 0.5) then
            for _ = 1, math.random(2, 6) do
                v15 = Vector3.FromNormalId(
                    Enum.NormalId:GetEnumItems()[math.random(#Enum.NormalId:GetEnumItems())]
                )
                local v31 = val_5.Size * v15 / 2
                local v33 = val_5.Size * (Vector3.new(1, 1, 1) - v15 * v15) * math.sign(
                    v15.Magnitude
                )
                local v34 = math.random() - 0.5
                local v36 = v31 + v33 * Vector3.new(v34, math.random() - 0.5, math.random() - 0.5)
                local v37 = script.Beam.Finish:Clone()
                v37.Parent = val_5
                table.insert(arg2._destroy_these, v37)
                local v38 = script.Beam.Start:Clone()
                v38.Position = v36
                v38.Beam1.Attachment1 = v37
                v38.Beam2.Attachment1 = v37
                v38.Beam3.Attachment1 = v37
                v38.Parent = val_5
                table.insert(arg2._destroy_these, v38)
                table.insert(t_2, { AppearDelay = 1.5 * math.random(), Object = v38 })
                v37.Position = v38.Position + v15 * (0.5 + 1.5 * math.random())
            end
        end
    end

    arg2:CreateSound(
        "rbxassetid://104941307595770",
        1,
        1,
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://137299793298455",
        1,
        1,
        nil,
        true,
        5
    )
    wait(2)

    for _, val_6 in pairs(t_2) do
        val_6.Object:Destroy()
    end

    local v39 = script.Explosion:Clone()
    v39.CFrame = pivot
    v39.Parent = v16
    table.insert(arg2._destroy_these, v39)
    Utility_m:PlayParticles(v39)
    arg2:CreateSound(
        "rbxassetid://79678979817013",
        1.5,
        1,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 161
end

return t
