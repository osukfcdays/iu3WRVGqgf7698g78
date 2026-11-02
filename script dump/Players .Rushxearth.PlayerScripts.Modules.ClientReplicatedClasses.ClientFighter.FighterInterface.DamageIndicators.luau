local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local DamageIndicatorIcon = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DamageIndicatorIcon"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.Frame = t_1.FighterInterface.Frame:WaitForChild("DamageIndicators")
    t_1._current_damage_indicators = {}
    t_1:_Init()

    return t_1
end

function t.Create(arg2, arg3) -- line: 33
    -- upvalues:
    --  [1] Spring_m (copy)
    --  [2] DamageIndicatorIcon (copy)
    --  [3] BetterDebris_m (copy)
    --  [4] Utility_m (copy)

    local v1 = arg3[utf8.char(2)]

    if not v1 or arg3[utf8.char(0)] == 0 or not arg2.FighterInterface:IsActive() then
        return
    end

    for key, val in pairs(arg2._current_damage_indicators) do
        if val.Source == v1 then
            key:Destroy()
            arg2._current_damage_indicators[key] = nil
        end
    end

    local v2 = if typeof(v1) ~= "Instance" then false else true
    local v3 = Spring_m.new(0, 1, 40)
    local v4 = Spring_m.new(0.5, 1, 40)
    local v5 = DamageIndicatorIcon:Clone()
    v5.Parent = arg2.Frame
    BetterDebris_m:AddItem(v5, 10)
    local v6 = v2 and v1.Position or v1
    local Target = nil

    function v2(arg4) --[[ update ]] -- line: 58
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] v5 (copy)
        --  [3] v3 (copy)
        --  [4] v4 (copy)
        --  [5] Target (ref)

        local v8 = (v6 - workspace.CurrentCamera.CFrame.Position) * Vector3.new(1, 0, 1)
        local v9 = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
        local v10 = if not (v9.Magnitude <= 0.01) then v9.Unit else Vector3.new(1, 0, 0)

        if v8 ~= v8 or v8.Magnitude == 0 then
            v5.Visible = false

            return
        end

        local v11
        v5.Visible, v11 = true, v10
        local v12 = v8:Dot(v11)
        local angle = math.acos(v12 / v8.Magnitude)
        local v13 = v3
        local v14 = math.sign(v10:Cross(v8).Y) == 1 and 6.283185307179586 - angle or angle
        v13.Target = v14 + 1.5707963267948966
        v4.Target = math.max(0.125, 0.5 / math.max(1, (v8.Magnitude - 5) / 25))

        if not arg4 then
            v4.Value = v4.Target
            v3.Value = v3.Target
        elseif Target then
            local v16 = v3.Target - Target

            if v16 > 3.141592653589793 then
                local v17 = v3
                v17.Value += 6.283185307179586
            elseif v16 < -3.141592653589793 then
                local v18 = v3
                v18.Value -= 6.283185307179586
            end
        end

        v10 = Vector2.new(0.5, 0.5) - Vector2.new(math.cos(v3.Value), (math.sin(v3.Value))) * 0.75 / 2
        v5.Position = UDim2.new(v10.X, 0, v10.Y, 0)
        v5.Rotation = math.deg(v3.Value - 1.5707963267948966)
        v5.Size = UDim2.new(v4.Value, 0, v4.Value, 0)
        Target = v3.Target
    end

    arg2._current_damage_indicators[v5] = { Source = v1, Update = v2 }
    v2(nil)
    wait(5)
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg5) -- line: 103
        -- upvalues:
        --  [1] v5 (copy)

        v5.ImageTransparency = (arg5 / 100) ^ 4
    end)
    v5:Destroy()
    arg2._current_damage_indicators[v5] = nil
end

function t.Update(arg6, arg7, _) -- line: 111
    for _, val_1 in pairs(arg6._current_damage_indicators) do
        pcall(val_1.Update, arg7)
    end
end

function t.Clear(arg9) -- line: 117
    for key_2, _ in pairs(arg9._current_damage_indicators) do
        key_2:Destroy()
    end

    arg9._current_damage_indicators = {}
end

function t.Destroy(arg10) -- line: 125
    arg10:Clear()
end

function t._Init(_) -- line: 133
end

return t
