local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "PaintGrenadeExplosionEffect"
):WaitForChild("Attachment")
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._last_splat_sound = 0
    t_1:_Init()

    return t_1
end

function t.GetPaintballColor(_) -- line: 27
    return Color3.fromHSV(math.random(), 0.75, 1)
end

function t.PlaySplatSound(arg2, arg3) -- line: 31
    -- upvalues:
    --  [1] Utility_m (copy)

    local v3 = tick() - arg2._last_splat_sound < 0.001 and true
    arg2._last_splat_sound = tick()

    local function play_sound() -- line: 35
        -- upvalues:
        --  [1] Utility_m (ref)
        --  [2] v3 (copy)
        --  [3] arg3 (copy)

        Utility_m:CreateSound(
            "rbxassetid://16835701807",
            0.5 * (if not v3 then 1 else 0.5),
            1 + 0.4 * math.random(),
            arg3,
            true,
            1
        )
    end

    if v3 then
        task.delay(0.25 * math.random(), play_sound)

        return
    end

    Utility_m:CreateSound(
        "rbxassetid://16835701807",
        0.5 * (if not v3 then 1 else 0.5),
        1 + 0.4 * math.random(),
        arg3,
        true,
        1
    )
end

function t.CustomImpactMarker(_, _) -- line: 46
end

function t.ExplosionEffect(arg6, arg7, arg8) -- line: 50
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Attachment (copy)

    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg7)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    Utility_m:CreateSound(
        "rbxassetid://13455969017",
        0.25,
        1.4 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://102872919640755",
        1.5,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v16 = Attachment:Clone()

    for _, child in pairs(v16:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg8 / 18)
        end
    end

    v16.Parent = Part
    Utility_m:PlayParticles(v16)
    local v19 = arg7 + workspace.CurrentCamera.CFrame.LookVector * -3
    local v20 = arg6.ClientItem.ClientFighter:GetRaycastWhitelist()
    local t_2 = { IsFromPaintGrenade = true }

    for index = 1, 4 do
        for index_1 = 1, 4 do
            local cframe = CFrame.Angles(
                0,
                6.283185307179586 * (index / 4 + 0.2617993877991494 * math.random()),
                0
            )
            local v22 = index_1 / 4
            local Angles_1 = CFrame.Angles
            local cframe = Utility_m:Raycast(
                v19,
                v19 + (cframe * Angles_1(
                    6.283185307179586 * (v22 + 0.2617993877991494 * math.random()),
                    0,
                    0
                )).LookVector * arg8,
                arg8,
                v20,
                Enum.RaycastFilterType.Include
            )

            for _ = 1, 2 do
                task.delay(0.25 * math.random(), function() -- line: 85
                    -- upvalues:
                    --  [1] arg6 (copy)
                    --  [2] cframe (copy)
                    --  [3] t_2 (copy)

                    if arg6._destroyed then
                        return
                    end

                    arg6.ClientItem:_ImpactMarkers({ cframe }, t_2)
                end)
            end
        end
    end
end

function t._Init(_) -- line: 102
end

return t
