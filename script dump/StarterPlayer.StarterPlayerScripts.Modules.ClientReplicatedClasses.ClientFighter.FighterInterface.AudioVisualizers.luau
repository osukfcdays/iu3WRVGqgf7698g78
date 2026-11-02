local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local AudioVisualizerIcon = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "AudioVisualizerIcon"
)
local t = {
    "rbxassetid://131616644976154",
    "rbxassetid://101856596290673",
    "rbxassetid://78940013186909"
}
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 20
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.FighterInterface = arg1
    t_2.Frame = t_2.FighterInterface.Frame:WaitForChild("AudioVisualizers")
    t_2._current_visualizers = {}
    t_2:_Init()

    return t_2
end

function t_1.Create(arg2, arg3, arg4, arg5) -- line: 38
    -- upvalues:
    --  [1] AudioVisualizerIcon (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Spring_m (copy)
    --  [4] t (copy)
    --  [5] Utility_m (copy)

    if not arg2.FighterInterface:IsActive() then
        return
    end

    local v1 = arg2:_GetSourcePosition(arg3)

    if not v1 then
        return
    end

    local v2 = arg2.FighterInterface.ClientFighter.Entity and (v1 - arg2.FighterInterface.ClientFighter.Entity.RootPart.Position).Magnitude <= 4

    if v2 or (if not (arg2:_GetEffectiveVolume(v1, arg4, arg5) <= 0) then false else true) then
        return
    end

    local v7 = pairs
    local CurrentVisualizers = arg2._current_visualizers

    for key, val in v7(CurrentVisualizers) do
        local Source = val.Source
        local Source2 = val.Source2

        if Source == arg3 or Source2 == arg3 then
            key:Destroy()
            arg2._current_visualizers[key] = nil
        end
    end

    local v9 = AudioVisualizerIcon:Clone()
    v9.Parent = arg2.Frame
    BetterDebris_m:AddItem(v9, 30)
    local v11 = false
    v2 = workspace.CurrentCamera.CFrame
    local v12 = v1
    local v15 = Spring_m.new(0, 1, 40)
    local v19 = Spring_m.new(0.5, 1, 40)
    local Target = nil
    local v21 = 0
    local v22 = 0
    local _ = false

    local function update(arg6) -- line: 79
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] arg3 (copy)
        --  [3] _ (ref)
        --  [4] v12 (ref)
        --  [5] v9 (copy)
        --  [6] v15 (copy)
        --  [7] v19 (copy)
        --  [8] Target (ref)
        --  [9] v11 (ref)
        --  [10] AudioVisualizerIcon (ref)
        --  [11] arg4 (copy)
        --  [12] arg5 (copy)
        --  [13] v22 (ref)
        --  [14] v21 (ref)
        --  [15] t (ref)

        local v24 = arg2:_GetSourcePosition(arg3)

        if not v24 then
            _ = true
            v24 = v12
        else
            v12 = v12
        end

        local v25 = workspace.CurrentCamera.CFrame
        local v26 = (v24 - v25.Position) * Vector3.new(1, 0, 1)
        local v27 = v25.LookVector * Vector3.new(1, 0, 1)
        v25 = if not (v27.Magnitude <= 0.01) then v27.Unit else Vector3.new(1, 0, 0)

        if v26 ~= v26 or v26.Magnitude == 0 then
            v9.Visible = false

            return
        end

        v9.Visible = true
        local v28 = v26:Dot(v25)
        local angle = math.acos(v28 / v26.Magnitude)
        local v29 = v15
        local v30 = math.sign(v25:Cross(v26).Y) == 1 and 6.283185307179586 - angle or angle
        v29.Target = v30 + 1.5707963267948966
        v19.Target = math.max(0.125, 0.5 / math.max(1, (v26.Magnitude - 5) / 25))

        if not arg6 then
            v19.Value = v19.Target
            v15.Value = v15.Target
        elseif Target then
            local v32 = v15.Target - Target

            if v32 > 3.141592653589793 then
                local v33 = v15
                v33.Value += 6.283185307179586
            elseif v32 < -3.141592653589793 then
                local v34 = v15
                v34.Value -= 6.283185307179586
            end
        end

        local v35 = Vector2.new(0.5, 0.5) - Vector2.new(math.cos(v15.Value), (math.sin(v15.Value))) * 0.75 / 2
        v9.Position = UDim2.new(v35.X, 0, v35.Y, 0)
        v9.Rotation = math.deg(v15.Value - 1.5707963267948966)
        v9.Size = UDim2.new(v19.Value, 0, v19.Value, 0)

        if not v11 then
            v9.ImageTransparency = AudioVisualizerIcon.ImageTransparency + (1 - AudioVisualizerIcon.ImageTransparency) * (1 - arg2:_GetEffectiveVolume(
                v24,
                arg4,
                arg5
            ))
        end

        Target = v15.Target

        if tick() > v22 then
            v22 = tick() + 0.04
            v21 += 1
            v9.Image = t[v21 % #t + 1]
        end
    end

    local t_3 = { Source = arg3, Update = update, Source2 = nil }
    local v41 = false
    local CurrentVisualizers_2 = arg2._current_visualizers

    if typeof(arg3) == "Instance" then
        v41 = arg3:IsA("Sound")

        if v41 then
            v41 = arg3.Parent
        end
    end

    t_3.Source2 = v41
    CurrentVisualizers_2[v9] = t_3
    update(nil)
    wait(0)
    v11 = true
    local ImageTransparency_1 = v9.ImageTransparency
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg7) -- line: 167
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] ImageTransparency_1 (copy)

        v9.ImageTransparency = ImageTransparency_1 + (1 - ImageTransparency_1) * (1 - (1 - arg7 / 100) ^ 4)
    end)
    v9:Destroy()
    arg2._current_visualizers[v9] = nil
end

function t_1.Update(arg8, arg9, _) -- line: 175
    for _, val_1 in pairs(arg8._current_visualizers) do
        pcall(val_1.Update, arg9)
    end
end

function t_1.Clear(arg11) -- line: 181
    for key_2, _ in pairs(arg11._current_visualizers) do
        key_2:Destroy()
    end

    arg11._current_visualizers = {}
end

function t_1.Destroy(arg12) -- line: 189
    arg12:Clear()
end

function t_1._GetSourcePosition(_, arg14) -- line: 197
    if typeof(arg14) == "Vector3" then
        return arg14
    end

    if arg14:IsA("BasePart") then
        return arg14.Position
    end

    if arg14.Parent and arg14.Parent:IsA("BasePart") then
        return arg14.Parent.Position
    end
end

function t_1._GetEffectiveVolume(_, arg16, arg17, arg18) -- line: 207
    return (1 - math.clamp(
        ((workspace.CurrentCamera.CFrame.Position - arg16).Magnitude - arg17) / (arg18 - arg17),
        0,
        1
    )) ^ 2
end

function t_1._Init(_) -- line: 211
end

return t_1
