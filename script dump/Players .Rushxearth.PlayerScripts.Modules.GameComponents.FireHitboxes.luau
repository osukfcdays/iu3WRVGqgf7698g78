local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local _ = require(ReplicatedStorage.Modules.Spring)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local FireHitboxes = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild(
    "FireHitboxes"
)
local t = {}
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._fire_hitboxes = {}
    t_1:_Init()

    return t_1
end

function t.Extinguish(arg1, arg2) -- line: 31
    for key, val in pairs(arg1._fire_hitboxes) do
        if key:GetAttribute("FireHitboxID") == arg2 then
            val.Visual:Destroy()
            arg1._fire_hitboxes[key] = nil

            return val.Visual:GetPivot().Position
        end
    end
end

function t.Update(arg3, _) -- line: 41
    for key_1, val_1 in pairs(arg3._fire_hitboxes) do
        val_1.Visual:PivotTo(key_1.CFrame)
    end
end

function t._Setup(arg5) -- line: 51
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] TweenService (copy)
    --  [3] Utility_m (copy)
    --  [4] CollectionService (copy)
    --  [5] FireHitboxes (copy)
    --  [6] FighterController_m (copy)
    --  [7] WrapController_m (copy)

    local _ = {}

    local function fire_hitbox_removed(arg6) -- line: 54
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] BetterDebris_m (ref)
        --  [3] TweenService (ref)
        --  [4] Utility_m (ref)

        local v1 = arg5._fire_hitboxes[arg6]

        if not v1 then
            return
        end

        v1.Destroyed = true
        local v3 = pairs
        local Visual = v1.Visual

        for _, val_2 in v3(Visual:GetDescendants()) do
            if val_2:IsA("ParticleEmitter") then
                val_2.Enabled = false
            end
        end

        BetterDebris_m:AddItem(v1.Visual, 10)
        local Visual_1 = v1.Visual.Name
        local v5

        if Visual_1 == "Hot Coals" then
            v5 = pairs
            local Visual_2 = v1.Visual.Coals

            for _, val_3 in v5(Visual_2:GetChildren()) do
                val_3.Color = Color3.fromRGB(0, 0, 0)
                task.delay(0.5 * math.random(), function() -- line: 75
                    -- upvalues:
                    --  [1] TweenService (ref)
                    --  [2] val_3 (copy)

                    TweenService:Create(
                        val_3,
                        TweenInfo.new(
                            0.25 + 0.5 * math.random(),
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.In
                        ),
                        { Size = Vector3.new(0, 0, 0) }
                    ):Play()
                end)
            end
        end

        v5 = v1.Sound1 and v1.Sound1.Volume
        local v9 = v1.Sound2 and v1.Sound2.Volume
        local PointLight = v1.Visual.Primary.PointLight
        Utility_m:RenderstepForLoop(0, 100, 1, function(arg7) -- line: 85
            -- upvalues:
            --  [1] v1 (copy)
            --  [2] v5 (copy)
            --  [3] v9 (copy)
            --  [4] PointLight (copy)

            local v11 = 1 - (arg7 / 100) ^ 2

            if v1.Sound1 then
                v1.Sound1.Volume = v5 * v11
            end

            if v1.Sound2 then
                v1.Sound2.Volume = v9 * v11
            end

            PointLight.Brightness = 3 * v11
        end)
        arg5._fire_hitboxes[arg6] = nil
    end

    CollectionService:GetInstanceRemovedSignal("FireHitbox"):Connect(fire_hitbox_removed)

    local function fire_hitbox_added(arg8) -- line: 104
        -- upvalues:
        --  [1] FireHitboxes (ref)
        --  [2] FighterController_m (ref)
        --  [3] WrapController_m (ref)
        --  [4] Utility_m (ref)
        --  [5] arg5 (copy)
        --  [6] TweenService (ref)

        local IsMain = arg8:GetAttribute("IsMain")
        local v12 = arg8:GetAttribute("ObjectID")
        local v13 = arg8:GetAttribute("ViewModelName") or "Default"
        local v14 = (FireHitboxes:FindFirstChild(v13) or FireHitboxes.Default):Clone()
        v14.PrimaryPart = v14.Primary
        v14.Primary.Size = arg8.Size
        v14:PivotTo(arg8.CFrame)
        v14.Parent = workspace

        if IsMain and v14.Primary:FindFirstChild("Fire") then
            v14.Primary.Fire.Acceleration = Vector3.new(0, 10, 0)
        end

        local v16 = FighterController_m:GetWrap(v12)

        if v16 then
            WrapController_m:ApplyWrap(
                WrapController_m:RecordOriginalWrapProperties(v14),
                v16,
                true
            )
        end

        v16 = nil
        v12 = nil

        if IsMain then
            local v19 = math.max(arg8.Size.X, arg8.Size.Y, arg8.Size.Z) * 1.5
            v16 = Utility_m:CreateSound(
                "rbxassetid://13702989275",
                0.5,
                0.7 + 0.3 * math.random(),
                v14.Primary,
                true,
                nil,
                v19
            )
            v12 = if v13 == "Campfire Stick" then Utility_m:CreateSound(
                "rbxassetid://115255932685592",
                1.25,
                1,
                v14.Primary,
                true,
                nil,
                v19
            ) else Utility_m:CreateSound(
                "rbxassetid://14812827622",
                1.25,
                0.875,
                v14.Primary,
                true,
                nil,
                v19
            )
        end

        local t_3 = { Visual = v14, Sound1 = v16, Sound2 = v12, Destroyed = false }
        arg5._fire_hitboxes[arg8] = t_3

        if t_3.Visual.Name == "Hot Coals" then
            for _, val_4 in pairs(t_3.Visual.Coals:GetChildren()) do
                local v16 = val_4.Size
                val_4.Size = Vector3.new(0, 0, 0)
                local v23 = val_4.CFrame
                local Angles = CFrame.Angles
                local v24 = 6.283185307179586 * math.random()
                val_4.CFrame = v23 * Angles(
                    v24,
                    6.283185307179586 * math.random(),
                    6.283185307179586 * math.random()
                )
                task.delay(0.5 * math.random(), function() -- line: 156
                    -- upvalues:
                    --  [1] t_3 (copy)
                    --  [2] TweenService (ref)
                    --  [3] val_4 (copy)
                    --  [4] v16 (copy)

                    if t_3.Destroyed then
                        return
                    end

                    TweenService:Create(
                        val_4,
                        TweenInfo.new(
                            1 * math.random(),
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ),
                        { Size = v16 }
                    ):Play()
                end)
            end
        end
    end

    CollectionService:GetInstanceAddedSignal("FireHitbox"):Connect(fire_hitbox_added)

    for _, val_5 in pairs(CollectionService:GetTagged("FireHitbox")) do
        task.spawn(fire_hitbox_added, val_5)
    end
end

function t._Init(arg9) -- line: 174
    arg9:_Setup()
end

return t._new()
