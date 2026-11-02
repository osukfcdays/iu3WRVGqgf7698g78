local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local t = {}
t.__index = t

function t._new() -- line: 14
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._objects = {}
    t_1._next_update = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 29
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] Utility_m (copy)

    if tick() < arg1._next_update then
        return
    end

    arg1._next_update = tick() + 0.25
    local v2 = FighterController_m.LocalFighter and FighterController_m.LocalFighter.Entity and FighterController_m.LocalFighter.Entity.Humanoid
    local v3 = v2

    if v3 then
        v3 = v2.RootPart
    end

    if not v3 then
        return
    end

    for key, val in pairs(arg1._objects) do
        if
            val.MathHitboxCheckEnabled
            and Utility_m:IsWithinPart(key, v3.Position, Vector3.new(2, 2, 2))
        then
            task.spawn(val.TouchedCallback, v3, true)
        end
    end
end

function t._ObjectAdded(arg3, arg4) -- line: 54
    -- upvalues:
    --  [1] Players (copy)
    --  [2] FighterController_m (copy)
    --  [3] Utility_m (copy)

    local t_2 = {
        Connections = {},
        Cooldowns = {},
        TouchedCallback = nil,
        MathHitboxCheckEnabled = arg4:GetAttribute("MathHitboxCheckEnabled")
    }

    function t_2.TouchedCallback(arg5, arg6) -- line: 62
        -- upvalues:
        --  [1] Players (ref)
        --  [2] t_2 (copy)
        --  [3] FighterController_m (ref)
        --  [4] arg4 (copy)
        --  [5] Utility_m (ref)

        local v4 = arg5.AssemblyRootPart or arg5

        if
            arg5.Parent ~= Players.LocalPlayer.Character
            or tick() < (t_2.Cooldowns[v4] or 0)
            or not FighterController_m.LocalFighter
            or not FighterController_m.LocalFighter:IsAlive()
        then
            return
        end

        local v5 = arg4:GetAttribute("Velocity")
        local v6 = arg4:GetAttribute("LocalTo")
        local MinimumYVelocity = arg4:GetAttribute("MinimumYVelocity")
        local v7 = if v6 then arg4.CFrame[v6] * v5 else v5

        if MinimumYVelocity then
            local X = v7.X
            local v8 = if math.abs(v7.Y) < 0.001 then MinimumYVelocity else math.max(
                MinimumYVelocity,
                (math.abs(v7.Y))
            ) * math.sign(v7.Y)
            v7 = Vector3.new(X, v8, v7.Z)
        end

        local HasToBeInFront = arg4:GetAttribute("HasToBeInFront")
        v6 = if typeof(HasToBeInFront) == "CFrame" then HasToBeInFront else CFrame.identity

        if
            not arg6
            and HasToBeInFront
            and Utility_m:AngleBetweenVectors(
                (v4.Position - (arg4.CFrame * v6).Position).Unit,
                v7.Unit
            ) > 1.5707963267948966
        then
            return
        end

        t_2.Cooldowns[v4] = tick() + (arg4:GetAttribute("Cooldown") or 0.5)
        local Velocity = FighterController_m.LocalFighter.Entity.RootPart.Velocity
        v5 = true
        local WalkSpeed = FighterController_m.LocalFighter.Entity.Humanoid.WalkSpeed

        if not (Utility_m:AngleBetweenVectors(v7, Vector3.new(0, 1, 0)) < 0.08726646259971647) then
            v5 = Utility_m:AngleBetweenVectors(v7, Vector3.new(-0, -1, -0)) < 0.08726646259971647 and true
        end

        local v9 = arg4:GetAttribute("SpringSpeed") or 12
        local v10 = if not v5 then nil else Velocity.Unit * math.max(
            (Velocity * (Vector3.new(1, 0, 1)).Unit).Magnitude,
            WalkSpeed
        )
        local v11 = if not v10 then nil else if v10 ~= v10 then nil else v10.Magnitude > 0.001 and v10 or nil

        if arg4:GetAttribute("Override") then
            FighterController_m.LocalFighter.Entity:AirborneCancel()
        end

        FighterController_m.LocalFighter.Entity:AirborneTrigger(v7, v9, nil, v11)
        local SoundID = arg4:GetAttribute("SoundID")
        v7 = arg4:GetAttribute("SoundVolume") or 1

        if SoundID then
            Utility_m:CreateSound(
                SoundID,
                1 * v7,
                1,
                script,
                true,
                10
            )

            return
        end

        Utility_m:CreateSound(
            "rbxassetid://17835965717",
            1 * v7,
            1.25,
            script,
            true,
            5
        )
    end

    local function from_touched(arg7) -- line: 120
        -- upvalues:
        --  [1] t_2 (copy)

        t_2.TouchedCallback(arg7)
    end

    table.insert(t_2.Connections, arg4.Touched:Connect(from_touched))
    table.insert(t_2.Connections, arg4.TouchEnded:Connect(from_touched))
    arg3._objects[arg4] = t_2
end

function t._ObjectRemoved(arg8, arg9) -- line: 130
    local v14 = arg8._objects[arg9]

    if not v14 then
        return
    end

    for _, val_1 in pairs(v14.Connections) do
        val_1:Disconnect()
    end

    arg8._objects[arg9] = nil
end

function t._Init(arg10) -- line: 144
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("CustomKnockbackPart"):Connect(function(arg11) -- line: 145
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_ObjectAdded(arg11)
    end)
    CollectionService:GetInstanceRemovedSignal("CustomKnockbackPart"):Connect(function(arg12) -- line: 149
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_ObjectRemoved(arg12)
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("CustomKnockbackPart")) do
        task.defer(arg10._ObjectAdded, arg10, val_2)
    end
end

return t._new()
