local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local MechanicsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MechanicsController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local t = {}
local Vortexes = Players.LocalPlayer.PlayerScripts.Assets.Misc.Vortexes
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._vortexes = {}
    t_1._forces = {}
    t_1._was_sitting = false
    t_1:_Init()

    return t_1
end

function t.UpdateForces(arg1) -- line: 34
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] Players (copy)
    --  [3] MechanicsController_m (copy)

    local v1 = FighterController_m.LocalFighter and FighterController_m.LocalFighter.Entity and FighterController_m.LocalFighter.Entity.Humanoid
    local v2 = v1

    if v2 then
        v2 = v1.RootPart
    end

    if not v2 then
        for _, val in pairs(arg1._forces) do
            arg1:_Cleanup(val)
        end

        arg1._forces = {}

        return
    end

    for key_1, val_1 in pairs(arg1._vortexes) do
        local Magnitude = (key_1.Position - v2.Position).Magnitude

        if Magnitude > key_1.Size.X / 2 then
            if if not (Magnitude > key_1.Size.X * 1) then false else true then
                local v4 = arg1._forces[key_1]

                if v4 then
                    arg1:_Cleanup(v4)
                    arg1._forces[key_1] = nil
                end
            end
        else
            local TeamID = val_1.TeamID

            if
                val_1.UserID ~= Players.LocalPlayer.UserId
                and (if not val_1.TeamID then not arg1._forces[key_1] else not (TeamID == Players.LocalPlayer:GetAttribute(
                    "TeamID"
                )) and not arg1._forces[key_1])
            then
                local VectorForce = Instance.new("VectorForce")
                VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
                VectorForce.Attachment0 = v2.RootRigAttachment
                VectorForce.Parent = nil
                local BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                BodyVelocity.Parent = v2
                arg1._forces[key_1] = {
                    RootPart = v2,
                    VectorForce = VectorForce,
                    BodyVelocity = BodyVelocity
                }
            end
        end
    end

    if next(arg1._forces) then
        if MechanicsController_m.IsSliding then
            MechanicsController_m:StopSliding()
        end

        for key_2, val_2 in pairs(arg1._forces) do
            if not v2.Position:FuzzyEq(key_2.Position) then
                local cframe = CFrame.new(v2.Position, key_2.Position)
                local v5 = (cframe.RightVector * 0.15 + cframe.LookVector) * 5000
                val_2.VectorForce.Force = v5.Unit * math.min(v5.Magnitude, 5000)
                val_2.BodyVelocity.Velocity = cframe.LookVector * 50
            end

            v1.Sit = true
            arg1._was_sitting = true
        end

        return
    end

    if arg1._was_sitting then
        arg1._was_sitting = false
        v1.Sit = false
    end
end

function t.UpdateVisuals(arg2, arg3) -- line: 124
    for key_3, val_3 in pairs(arg2._vortexes) do
        local clampedValue = math.clamp((tick() - val_3.Start) / val_3.Lifetime, 0, 1)
        val_3.Clock += arg3 * (clampedValue ^ 4 + 1)
        local maximum = math.max(0.01, 1 - clampedValue ^ 4)
        local v7 = CFrame.new(key_3.Position, workspace.CurrentCamera.CFrame.Position) * CFrame.Angles(
            -1.5707963267948966,
            0,
            0
        ) * CFrame.Angles(0, val_3.Clock * (clampedValue ^ 4 * 4 + 4) % 6.283185307179586, 0)
        local v8 = v7 * CFrame.Angles((1 - clampedValue ^ 6 * 3) * 0.7853981633974483, 0, 0)
        local v9 = v8 * CFrame.Angles(
            0,
            val_3.Clock * (clampedValue ^ 4 * 4 + 4) % 6.283185307179586,
            0
        )
        val_3.Visual:ScaleTo(val_3.OriginalScale * val_3.ScaleSpring.Value * maximum)
        val_3.Visual:PivotTo(v9)

        if tick() > val_3.NextShrink then
            val_3.NextShrink = tick() + 0.25
            local ScaleSpring = val_3.ScaleSpring
            ScaleSpring.Value -= 0.125
        end
    end
end

function t.Update(arg4, arg5) -- line: 147
    arg4:UpdateForces(arg5)
    arg4:UpdateVisuals(arg5)
end

function t._Cleanup(_, arg7) -- line: 156
    arg7.VectorForce:Destroy()
    arg7.BodyVelocity:Destroy()
end

function t._ObjectAdded(arg8, arg9) -- line: 161
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Vortexes (copy)
    --  [3] Spring_m (copy)

    arg8:_ObjectRemoved(arg9)
    Utility_m:CreateSound(
        "rbxassetid://90138246017443",
        1.25,
        0.75 + 0.1 * math.random(),
        arg9,
        true
    )
    local v15 = Vortexes:FindFirstChild(arg9:GetAttribute("ViewModelName") or "Default") or Vortexes.Default
    local v16 = v15:Clone()
    v16:ScaleTo(v16:GetScale() * arg9.Size.X / 24)
    v16.Parent = arg9
    v15 = Spring_m.new(1, 0.75, 20)
    v15.Value = 0
    arg8._vortexes[arg9] = {
        Visual = v16,
        OriginalScale = v16:GetScale(),
        ScaleSpring = v15,
        NextShrink = tick() + 0.5,
        Start = tick(),
        Clock = 0,
        Lifetime = arg9:GetAttribute("Lifetime"),
        TeamID = arg9:GetAttribute("TeamID"),
        UserID = arg9:GetAttribute("UserID")
    }
end

function t._ObjectRemoved(arg10, arg11) -- line: 187
    arg10._vortexes[arg11] = nil

    if arg10._forces[arg11] then
        arg10:_Cleanup(arg10._forces[arg11])
        arg10._forces[arg11] = nil
    end
end

function t._Init(arg12) -- line: 196
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceRemovedSignal("Vortex"):Connect(function(arg13) -- line: 197
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_ObjectRemoved(arg13)
    end)
    CollectionService:GetInstanceAddedSignal("Vortex"):Connect(function(arg14) -- line: 201
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_ObjectAdded(arg14)
    end)

    for _, val_4 in pairs(CollectionService:GetTagged("Vortex")) do
        task.defer(arg12._ObjectAdded, arg12, val_4)
    end
end

return t._new()
