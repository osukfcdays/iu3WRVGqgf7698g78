local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local QuaternionSpring_m = require(ReplicatedStorage.Modules.QuaternionSpring)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local Quaternion_m = require(ReplicatedStorage.Modules.Quaternion)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local t = {}
local SpearTightropes = Players.LocalPlayer.PlayerScripts.Assets.SpearTightropes
t.__index = t

function t.new(arg1, arg2) -- line: 25
    -- upvalues:
    --  [1] t (copy)
    --  [2] HttpService (copy)
    --  [3] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.TightropeController = arg1
    t_1.Part = arg2
    t_1.Active = false
    t_1.Character = nil
    t_1._destroyed = false
    t_1._id = HttpService:GenerateGUID(false)
    t_1._connections = {}
    t_1._active_connections = {}
    t_1._align_position = Instance.new("AlignPosition")
    t_1._spring = Spring_m.new(0, 0.25, 8)
    t_1._cooldown = 0
    t_1._platform = Instance.new("Part")
    t_1._visuals = {}
    t_1._beam0 = nil
    t_1._beam1 = nil
    t_1._start_time = 0
    t_1._touched_cooldowns = {}
    t_1._object_id = t_1.Part:GetAttribute("ObjectID")
    t_1._minimum_momentum_percentage = t_1.Part:GetAttribute("MinimumMomentumPercentage") or 0
    t_1._is_spear = t_1.Part:GetAttribute("IsSpear")
    t_1._viewmodel_name = t_1.Part:GetAttribute("ViewModelName")
    t_1._spear_model = nil
    t_1._spear_spin = nil
    t_1._spear_spring = nil
    t_1:_Init()

    return t_1
end

function t.IsTooVertical(arg3) -- line: 65
    -- upvalues:
    --  [1] Utility_m (copy)

    return if not (Utility_m:AngleBetweenVectors(arg3.Part.CFrame.UpVector, Vector3.new(0, 1, 0)) < 0.1308996938995747) then Utility_m:AngleBetweenVectors(
        arg3.Part.CFrame.UpVector,
        Vector3.new(-0, -1, -0)
    ) < 0.1308996938995747 and true else true
end

function t.JumpOff(arg4) -- line: 69
    if not arg4.Active then
        return
    end

    local maximum = math.max(
        arg4._minimum_momentum_percentage,
        math.max(0, arg4._spring.Velocity) ^ 2 * 0.25 / 25
    )
    arg4.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1, 0) * (math.clamp(maximum, 0, 1) * 25 + 25)
    arg4._cooldown = tick() + 0.5
    arg4:Disable()
end

function t.Enable(arg5) -- line: 85
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] Players (copy)
    --  [3] UserInputService (copy)
    --  [4] RunService (copy)

    if
        arg5.Active
        or arg5:IsTooVertical()
        or not FighterController_m.LocalFighter
        or not FighterController_m.LocalFighter:IsAlive()
        or FighterController_m.LocalFighter.Entity:Get("IsFrozen")
    then
        return
    end

    FighterController_m.LocalFighter.Entity:AirborneCancel()
    arg5.Active = true
    arg5.Character = Players.LocalPlayer.Character
    arg5._spring.Value = arg5.Character.HumanoidRootPart.Velocity.Y / 20
    arg5.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    arg5._platform.CanCollide = true
    arg5._platform.CFrame = arg5.Character.HumanoidRootPart.CFrame - Vector3.new(0, 3, 0)
    arg5._beam0.Width1 = arg5._beam0.Width0 * 0.25
    arg5._beam1.Width1 = arg5._beam1.Width0 * 0.25
    arg5._start_time = tick()
    table.insert(arg5._active_connections, UserInputService.JumpRequest:Connect(function() -- line: 103
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:JumpOff()
    end))
    table.insert(arg5._active_connections, arg5.Character.Humanoid.StateChanged:Connect(function(
        _,
        arg7
    ) -- line: 107
        -- upvalues:
        --  [1] arg5 (copy)

        if arg7 == Enum.HumanoidStateType.Climbing then
            arg5:Disable()
        end
    end))
    table.insert(arg5._active_connections, arg5.Character.Humanoid.Died:Connect(function() -- line: 113
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:Disable()
    end))
    table.insert(arg5._active_connections, arg5.Character.AncestryChanged:Connect(function() -- line: 117
        -- upvalues:
        --  [1] arg5 (copy)

        if not arg5.Character:IsDescendantOf(workspace) then
            arg5:Disable()
        end
    end))
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = { arg5._platform }
    raycastParams.CollisionGroup = "Players"
    raycastParams.RespectCanCollide = true
    raycastParams.IgnoreWater = true
    RunService:BindToRenderStep("Tightrope - " .. arg5._id, Enum.RenderPriority.Camera.Value - 1, function(
        _
    ) -- line: 130
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] raycastParams (copy)

        local v4 = arg5:_GetC0()
        local v5 = arg5:_GetC1()
        local Magnitude = ((v4.Position - v5.Position) * Vector3.new(1, 0, 1)).Magnitude
        local v6 = arg5._spring.Value - 2
        local v7 = arg5.Character.HumanoidRootPart.CFrame
        local v8 = ((v7.Position - v4.Position) * Vector3.new(1, 0, 1)).Magnitude / Magnitude
        local v9 = v4.Position:Lerp(v5.Position, v8)
        local v10 = 0.25 / Magnitude
        local v13 = CFrame.new(v9) * arg5.Part.CFrame.Rotation + Vector3.new(0, v6, 0)
        local v14 = arg5._platform.CFrame:Lerp(v13, 0.1)

        if v10 > v8 or v8 > 1 - v10 then
            arg5:Disable()

            return
        end

        local New = CFrame.new
        local Position = v7.Position
        local now = tick()
        local v15 = New(
            Position:Lerp(v9, (math.min(1, 2 * (now - arg5._start_time)))) * Vector3.new(1, 0, 1)
        )
        v4 = v15 * CFrame.new(0, v14.Y + 3, 0) * v7.Rotation

        if not v4.Position:FuzzyEq(v7.Position) then
            local raycastResult = workspace:Raycast(
                v7.Position,
                v4.Position - v7.Position,
                raycastParams
            )

            if raycastResult then
                if math.abs(v4.Y - raycastResult.Position.Y) > 0.01 then
                    arg5:Disable()

                    return
                end

                v4 = CFrame.new(raycastResult.Position) * v4.Rotation
            end

            local v18 = workspace:Raycast(
                v7.Position,
                (v4.Position - v7.Position).Unit * ((v4.Position - v7.Position).Magnitude + 1),
                raycastParams
            )
            local v19 = if not v18 then Vector3.new(0, 0, 0) else arg5.Character.HumanoidRootPart.Position - v18.Position
            v18 = if v19:FuzzyEq(Vector3.new(0, 0, 0)) then Vector3.new(0, 0, 0) else v19.Unit * math.min(
                v19.Magnitude,
                1
            )
            v4 += v18
        end

        if (v4.Position - v7.Position).Magnitude > 32 then
            arg5:Disable()

            return
        end

        arg5.Character.HumanoidRootPart.CFrame = v4
        arg5._platform.CFrame = CFrame.new(v9.X, v14.Y, v9.Z) * arg5.Part.CFrame.Rotation
        arg5:_UpdateSpearCFrame()
    end)
    arg5:_UpdateSpearCFrame()
end

function t.Disable(arg9) -- line: 183
    -- upvalues:
    --  [1] RunService (copy)

    if not arg9.Active then
        return
    end

    arg9.Active = false
    arg9.Character = nil
    arg9._platform.CFrame = arg9.Part.CFrame
    arg9._platform.CanCollide = false
    arg9._beam0.Width1 = arg9._beam0.Width0
    arg9._beam1.Width1 = arg9._beam1.Width0

    for _, val in pairs(arg9._active_connections) do
        val:Disconnect()
    end

    arg9._active_connections = {}
    RunService:UnbindFromRenderStep("Tightrope - " .. arg9._id)
    arg9:_UpdateSpearCFrame()
end

function t.Destroy(arg10) -- line: 205
    arg10._destroyed = true

    for _, val_1 in pairs(arg10._connections) do
        val_1:Disconnect()
    end

    arg10:Disable()
    arg10._platform:Destroy()

    for _, val_2 in pairs(arg10._visuals) do
        val_2:Destroy()
    end

    arg10._visuals = {}
end

function t._GetC0(arg11) -- line: 226
    return arg11.Part.CFrame * CFrame.new(0, -arg11.Part.Size.Y / 2, 0)
end

function t._GetC1(arg12) -- line: 230
    return arg12.Part.CFrame * CFrame.new(0, arg12.Part.Size.Y / 2, 0)
end

function t._GetPositionAlongTightrope(arg13, arg14) -- line: 234
    local v23 = arg13:_GetC0()
    local Position_1 = v23.Position
    local v24 = arg13:_GetC1().Position - Position_1
    local v25 = Ray.new(v23.Position, v24.Unit):ClosestPoint(arg14)

    return Position_1 + v24.Unit * math.min(v24.Magnitude, (v25 - Position_1).Magnitude)
end

function t._Touched(arg15, arg16) -- line: 244
    -- upvalues:
    --  [1] Players (copy)
    --  [2] GameplayUtility_m (copy)
    --  [3] Utility_m (copy)

    local v26 = arg16.AssemblyRootPart or arg16

    if arg15.Active or arg15._touched_cooldowns[v26] or tick() < arg15._cooldown then
        return
    end

    arg15._touched_cooldowns[v26] = true
    task.delay(0.25, function() -- line: 253
        -- upvalues:
        --  [1] arg15 (copy)
        --  [2] v26 (copy)

        arg15._touched_cooldowns[v26] = nil
    end)
    local playerFromCharacter = Players:GetPlayerFromCharacter(v26.Parent)

    if
        playerFromCharacter ~= Players.LocalPlayer
        or not v26.Parent:FindFirstChild("Humanoid")
        or v26.Parent.Humanoid.Health <= 0
        or v26.Parent.Humanoid:GetState() == Enum.HumanoidStateType.Climbing
        or arg15.TightropeController:GetActiveTightrope()
    then
        return
    end

    local v27 = arg15:_GetPositionAlongTightrope(v26.Position)
    local v30 = GameplayUtility_m:GetRaycastWhitelist(v26.Parent:GetAttribute("EnvironmentID"))
    local raycastResult_1 = Utility_m:Raycast(
        v26.Position,
        v27,
        (v27 - v26.Position).Magnitude,
        v30,
        Enum.RaycastFilterType.Include
    )

    if
        not raycastResult_1.Instance
        or raycastResult_1.Instance == arg15.Part
        or raycastResult_1.Instance == arg15._platform
    then
        arg15:Enable()
    end
end

function t._UpdateSpearCFrame(arg17) -- line: 270
    if not arg17._spear_model then
        return
    end

    local Position_2 = (arg17.Part.CFrame * CFrame.new(0, arg17.Part.Size.Y / 2, 0)).Position
    local Position_3 = if Position_2:FuzzyEq(arg17._platform.Position) then arg17.Part.Position else arg17._platform.Position
    local v33 = if arg17._spear_spring then arg17._spear_spring.Position:ToCFrame() else CFrame.identity
    arg17._spear_model:PivotTo(
        CFrame.new(Position_2, Position_3) * CFrame.Angles(1.5707963267948966, 0, 0) * arg17._spear_spin * v33
    )
end

function t._SetupSpear(arg18) -- line: 282
    -- upvalues:
    --  [1] SpearTightropes (copy)
    --  [2] FighterController_m (copy)
    --  [3] WrapController_m (copy)
    --  [4] Utility_m (copy)
    --  [5] RunService (copy)
    --  [6] QuaternionSpring_m (copy)
    --  [7] Quaternion_m (copy)

    if not arg18._is_spear then
        return
    end

    local v35 = SpearTightropes:FindFirstChild(arg18._viewmodel_name) or SpearTightropes.Spear
    arg18._spear_model = v35:Clone()

    for _, val_3 in pairs(arg18._spear_model:GetDescendants()) do
        if val_3:IsA("BasePart") then
            val_3.CanCollide = false
            val_3.CanTouch = false
            val_3.CanQuery = false
            val_3.Anchored = true
        end
    end

    arg18._spear_model.Parent = arg18.Part
    v35 = FighterController_m:GetWrap(arg18._object_id)

    if v35 then
        WrapController_m:ApplyWrap(
            WrapController_m:RecordOriginalWrapProperties(arg18._spear_model),
            v35,
            true
        )
    end

    if arg18._viewmodel_name == "Plunger" then
        Utility_m:CreateSound(
            "rbxassetid://78976757664560",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://104596277305324",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://71181338073339",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
    elseif arg18._viewmodel_name == "Thunderpike" then
        Utility_m:CreateSound(
            "rbxassetid://78976757664560",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://86096630213185",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://71162611852857",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
    elseif arg18._viewmodel_name == "Fork" then
        Utility_m:CreateSound(
            "rbxassetid://78976757664560",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://140166764131349",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://136877803636502",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
    else
        Utility_m:CreateSound(
            "rbxassetid://78976757664560",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://86096630213185",
            1,
            0.9 + 0.2 * math.random(),
            arg18.Part,
            true,
            5
        )
    end

    if not (arg18.Part.AssemblyRootPart or arg18.Part).Anchored then
        table.insert(arg18._connections, RunService.RenderStepped:Connect(function() -- line: 333
            -- upvalues:
            --  [1] arg18 (copy)

            if not arg18.Active then
                arg18._platform.CFrame = arg18.Part.CFrame
            end

            arg18:_UpdateSpearCFrame()
        end))
    end

    arg18._spear_spin = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    arg18._spear_spring = QuaternionSpring_m.new(Quaternion_m.identity, 0.5, 20)
    local SpearSpring = arg18._spear_spring
    local FromCFrame = Quaternion_m.fromCFrame
    local cframe_4 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    SpearSpring.Position = FromCFrame(
        cframe_4 * CFrame.Angles((0.25 + 0.75 * math.random()) * 0.4363323129985824, 0, 0)
    )
    task.spawn(function() -- line: 347
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] RunService (ref)

        local now_1 = tick()

        while true do
            if not (tick() < now_1 + 5) then
                break
            end

            arg18:_UpdateSpearCFrame()
            RunService.RenderStepped:Wait()

            if not arg18._destroyed then
                continue
            end

            return
        end

        arg18._spear_spring = nil
        arg18:_UpdateSpearCFrame()
    end)
end

function t._Setup(arg19) -- line: 365
    arg19.Part.Transparency = 1
    arg19.Part.CanCollide = false
    arg19._platform.Color = Color3.fromRGB(200, 200, 200)
    arg19._platform.Transparency = 1
    arg19._platform.Anchored = true
    arg19._platform.CanCollide = false
    arg19._platform.Size = Vector3.new(0.1, 1, 1)
    arg19._platform.CFrame = arg19.Part.CFrame
    arg19._platform.CollisionGroup = "CollideWithPlayersOnly"
    arg19._platform:AddTag("Barrier")
    arg19._platform.Parent = arg19.Part
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = arg19.Part
    Attachment.WorldPosition = arg19:_GetC0().Position
    table.insert(arg19._visuals, Attachment)
    local Attachment_1 = Instance.new("Attachment")
    Attachment_1.Parent = arg19.Part
    Attachment_1.WorldPosition = arg19:_GetC1().Position
    table.insert(arg19._visuals, Attachment_1)
    local Attachment_2 = Instance.new("Attachment")
    Attachment_2.Parent = arg19._platform
    table.insert(arg19._visuals, Attachment_2)
    local Beam = Instance.new("Beam")
    Beam.Width0 = arg19.Part.Size.X
    Beam.Width1 = arg19.Part.Size.X
    Beam.FaceCamera = true
    Beam.Transparency = NumberSequence.new(0)
    Beam.Color = ColorSequence.new(arg19.Part.Color)
    Beam.LightInfluence = 1
    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment_2
    Beam.Enabled = not arg19._is_spear
    Beam.Parent = arg19._platform
    table.insert(arg19._visuals, Beam)
    local v63 = Beam:Clone()
    v63.Attachment0 = Attachment_1
    v63.Parent = arg19._platform
    table.insert(arg19._visuals, v63)
    arg19._beam0 = Beam
    arg19._beam1 = v63
end

function t._Init(arg20) -- line: 416
    table.insert(arg20._connections, arg20.Part.Destroying:Connect(function() -- line: 417
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:Destroy()
    end))
    table.insert(arg20._connections, arg20.Part.Touched:Connect(function(otherPart: BasePart) -- line: 421
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_Touched(otherPart)
    end))
    arg20:_Setup()
    arg20:_SetupSpear()
end

return t
