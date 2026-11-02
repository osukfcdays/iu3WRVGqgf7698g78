local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local SmokeClouds = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild(
    "SmokeClouds"
)
local t = {}
t.__index = t

function t.new(arg1, _) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Part = arg1
    t_1.Name = t_1.Part.Name
    t_1.EnvironmentID = t_1.Part:GetAttribute("EnvironmentID")
    t_1.Model = nil
    t_1._destroyed = false
    t_1._start_spring = Spring_m.new(0, 0.875, 10)
    t_1._finish_spring = Spring_m.new(0, 1, 2)
    t_1._position_spring = Spring_m.new(t_1.Part.Position, 1, 20)
    t_1._speed = 0.75 + 0.25 * math.random()
    t_1._spin = 6.283185307179586 * math.random()
    t_1._last_size = t_1.Part.Size
    t_1._idle_sound = nil
    t_1._idle_sound_original_volume = nil
    t_1:_Init()

    return t_1
end

function t.IsDestroyed(arg3) -- line: 40
    return arg3._destroyed
end

function t.Update(arg4, arg5) -- line: 44
    if arg4:_UpdateCoreLogic() then
        return true
    end

    arg4._position_spring.Target = arg4.Part.Position
    arg4:_StepSpin(arg5)
    arg4.Model:PivotTo(CFrame.new(arg4._position_spring.Value) * CFrame.Angles(0, arg4._spin, 0))
end

function t.Clear(arg6) -- line: 54
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    arg6._finish_spring.Target = 1
    BetterDebris_m:AddItem(arg6, 10)
end

function t.Destroy(arg7) -- line: 59
    if arg7._destroyed then
        return
    end

    arg7._destroyed = true
    arg7.Model:Destroy()
end

function t._CreateIdleSound(_) -- line: 72
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:CreateSound(
        "rbxassetid://16540273153",
        0.1,
        1,
        nil,
        true
    )
end

function t._StepSpin(arg9, arg10) -- line: 76
    arg9._spin = (arg9._spin + arg9._speed * (1 + 5 * arg9._start_spring.Velocity) * arg10) % 6.283185307179586
end

function t._UpdateCoreLogic(arg11) -- line: 80
    if not arg11._idle_sound then
        arg11._idle_sound = arg11:_CreateIdleSound()
        arg11._idle_sound.Parent = arg11.Part
        arg11._idle_sound_original_volume = arg11._idle_sound.Volume
    end

    arg11.Model:ScaleTo(arg11.Part.Size.Y * arg11._start_spring.Value)

    if arg11._finish_spring.Target > 0 then
        if arg11._finish_spring.Value >= 1 then
            arg11:Destroy()

            return true
        end

        for _, val in pairs(arg11.Model:GetDescendants()) do
            val.LocalTransparencyModifier = math.clamp(
                arg11._finish_spring.Value * (val:GetAttribute("DecaySpeed") or 1) + (val:GetAttribute(
                    "DecayOffset"
                ) or 0),
                0,
                1
            )
        end

        arg11._idle_sound.Volume = arg11._idle_sound_original_volume * math.clamp(
            1 - arg11._finish_spring.Value * 2,
            0,
            1
        )

        return
    else
        arg11._idle_sound.Volume = arg11._start_spring.Value * arg11._idle_sound_original_volume

        return
    end
end

function t._AppearSound(arg12) -- line: 105
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://16540273321",
        1,
        1 + 0.1 * math.random(),
        arg12.Part,
        true,
        5
    )
end

function t._Setup(arg13) -- line: 109
    -- upvalues:
    --  [1] SmokeClouds (copy)

    local Template = arg13.Part:GetAttribute("Template")
    local v7 = SmokeClouds:FindFirstChild(arg13.Part.Name)
    local v8 = if v7 then if v7:IsA("Folder") then Template and v7[Template] or v7:GetChildren()[math.random(
        #v7:GetChildren()
    )] or v7 or SmokeClouds.Default else v7 or SmokeClouds.Default else v7 or SmokeClouds.Default
    arg13.Model = v8:Clone()
    arg13.Model.Destroying:Connect(function() -- line: 115
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:Destroy()
    end)
    arg13._start_spring.Target = 1
end

function t._Init(arg14) -- line: 122
    arg14.Part:GetPropertyChangedSignal("Size"):Connect(function() -- line: 123
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_AppearSound()
        arg14._start_spring.Value = arg14._last_size.Magnitude / arg14.Part.Size.Magnitude
        arg14._last_size = arg14.Part.Size
    end)
    arg14:_Setup()
    arg14:_AppearSound()
end

return t
