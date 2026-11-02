local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local ChombieEgg = Players.LocalPlayer.PlayerScripts.Assets.Misc.ChombieEgg
local t = setmetatable({}, ClientEnemy_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientEnemy_m.new(...), t)
    t_1._current_egg_thread = nil
    t_1._current_egg_model = nil
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 29
    -- upvalues:
    --  [1] ClientEnemy_m (copy)

    if arg2 == "ChombieEggPhase" then
        if not arg1:IsRendered() then
            return
        end

        arg1._current_egg_thread = task.spawn(arg1._EggPhase, arg1, ...)

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t.Destroy(arg3) -- line: 41
    -- upvalues:
    --  [1] ClientEnemy_m (copy)

    if arg3._current_egg_thread then
        pcall(task.cancel, arg3._current_egg_thread)
    end

    ClientEnemy_m.Destroy(arg3)
end

function t._BrokenEggEffect(arg4) -- line: 53
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg4._current_egg_thread then
        pcall(task.cancel, arg4._current_egg_thread)
    end

    if not arg4._current_egg_model then
        return
    end

    arg4._current_egg_model:ScaleTo(arg4._current_egg_model:GetScale() * 0.75)
    arg4._current_egg_model.Full.Transparency = 1
    arg4._current_egg_model.Broken.Transparency = 0
    Utility_m:CreateSound(
        "rbxassetid://99730126765749",
        1,
        1 + 0.125 * math.random(),
        arg4.RootPart,
        true,
        10
    )
    wait(2)
    arg4._current_egg_model.Broken.Anchored = false
end

function t._EggPhase(arg5, arg6) -- line: 73
    -- upvalues:
    --  [1] ChombieEgg (copy)
    --  [2] Spring_m (copy)
    --  [3] RunService (copy)
    --  [4] Utility_m (copy)

    local t_2 = {}

    for _, descendant in pairs(arg5.Model:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            descendant.LocalTransparencyModifier = 1
            t_2[descendant] = true
        end
    end

    arg5._current_egg_model = ChombieEgg:Clone()
    arg5._current_egg_model.Parent = arg5.Model
    local v6 = Spring_m.new(0, 0.75, 10)
    local scale = arg5._current_egg_model:GetScale()
    local Identity = CFrame.identity
    local v7 = 1
    local v8 = 0
    local now = tick()
    task.spawn(function() -- line: 93
        -- upvalues:
        --  [1] now (copy)
        --  [2] arg6 (copy)
        --  [3] v8 (ref)
        --  [4] v6 (copy)
        --  [5] Identity (ref)
        --  [6] v7 (ref)

        wait(1)

        while true do
            if not (tick() < now + arg6 - 0.5) then
                break
            end

            v8 = tick()
            v6.Value = 1
            Identity = CFrame.Angles(0, 6.283185307179586 * math.random(), 0)
            v7 = -v7
            wait((math.min(1, (now + arg6 - tick()) * 0.25)))
        end
    end)

    while true do
        if not (tick() < now + arg6) then
            break
        end

        local clampedValue = math.clamp((tick() - now) / arg6, 0, 1)
        local clampedValue_1 = math.clamp((tick() - v8) / 0.5, 0, 1)
        local v10 = 1 - (1 - math.clamp((tick() - now) / 1, 0, 1)) ^ 4
        local v12 = arg5.RootPart.CFrame * CFrame.new(0, -3, 0)
        local v13 = Identity * CFrame.Angles(0, 6.283185307179586 * clampedValue_1 * v7, 0)
        local cframe = CFrame.Angles(0, 0, 0.6108652381980153 * v6.Value)
        local v14 = Random.new():NextUnitVector() * 1 * clampedValue ^ 8
        arg5._current_egg_model:ScaleTo(scale * v10)
        arg5._current_egg_model:PivotTo(v12 * v13 * cframe * v13:Inverse() + v14)
        RunService.RenderStepped:Wait()
    end

    for key_1, _ in pairs(t_2) do
        key_1.LocalTransparencyModifier = 0
    end

    Utility_m:CreateSound(
        "rbxassetid://94881601487773",
        1,
        1 + 0.125 * math.random(),
        arg5.RootPart,
        true,
        10
    )
    arg5._current_egg_model:Destroy()
    arg5._current_egg_model = nil
end

function t._Init(arg7) -- line: 133
    arg7.Died:Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_BrokenEggEffect()
    end)
end

return t
