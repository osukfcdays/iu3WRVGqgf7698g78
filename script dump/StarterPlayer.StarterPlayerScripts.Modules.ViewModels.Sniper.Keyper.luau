local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local Sniper_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels:WaitForChild("Sniper")
)
local t = setmetatable({}, Sniper_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Sniper_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Sniper_m.new(...), t)
    t_1.BulletTrail = t_1.ItemModel:WaitForChild("Bullet"):WaitForChild("MeshPart"):WaitForChild(
        "TrailA0"
    ):WaitForChild("Trail")
    t_1:_Init()

    return t_1
end

function t.CustomTracers(arg1, arg2, _) -- line: 28
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] WrapController_m (copy)
    --  [3] Utility_m (copy)

    local v3 = arg1:GetWrap()

    local function play() -- line: 31
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] arg2 (copy)
        --  [3] BetterDebris_m (ref)
        --  [4] WrapController_m (ref)
        --  [5] v3 (copy)
        --  [6] Utility_m (ref)

        local v4 = arg1:GetMuzzlePosition()

        if not v4 then
            return
        end

        v4 += workspace.CurrentCamera.CFrame.RightVector * 0.1

        for _, val in pairs(arg2.RaycastResults) do
            local v5 = val.StartPosition or v4
            local Magnitude = (v5 - val.Position).Magnitude
            local Part = Instance.new("Part")
            Part.CastShadow = false
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.Anchored = true
            Part.Color = Color3.fromRGB(255, 176, 112)
            Part:SetAttribute("IgnoreTransparency", true)
            Part:AddTag("Wrappable")
            Part:SetAttribute("WrapGroup", 3)
            Part.Parent = workspace
            BetterDebris_m:AddItem(Part, 10)
            WrapController_m:ApplyWrap(WrapController_m:RecordOriginalWrapProperties(Part), v3)
            Part.Material = Enum.Material.Neon
            Part.MaterialVariant = ""
            task.spawn(function() -- line: 61
                -- upvalues:
                --  [1] Utility_m (ref)
                --  [2] Part (copy)
                --  [3] Magnitude (copy)
                --  [4] val (copy)
                --  [5] v5 (copy)

                Utility_m:RenderstepForLoop(0, 100, 2, function(arg4) -- line: 62
                    -- upvalues:
                    --  [1] Part (ref)
                    --  [2] Magnitude (ref)
                    --  [3] val (ref)
                    --  [4] v5 (ref)

                    local v10 = arg4 / 100
                    local v11 = (1 - v10) ^ 4
                    Part.Size = Vector3.new(
                        0.01 + 1 * v11,
                        0.01 + 1 * v11,
                        Magnitude * (1 - v10 ^ 4) - 5
                    )
                    Part.CFrame = CFrame.new(val.Position, v5) * CFrame.new(0, 0, -Part.Size.Z / 2)
                end)
                Part:Destroy()
            end)
        end
    end

    if arg1.ClientItem:Get("IsAiming") then
        arg1.ClientItem:GetDataChangedSignal("IsAiming"):ConnectOnce(function() -- line: 77
            -- upvalues:
            --  [1] play (copy)

            task.delay(0.06, task.defer, play)
        end)

        return
    end

    play()
end

function t._UpdateBulletTrail(arg5) -- line: 89
    local BulletTrail = arg5.BulletTrail
    BulletTrail.Enabled = arg5:IsAnimationPlaying("Shoot1") or arg5:IsAnimationPlaying(
        "EmptyReload"
    )
end

function t._Init(arg6) -- line: 93
    arg6.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 94
        -- upvalues:
        --  [1] arg6 (copy)

        if animationTrack == "Shoot1" or animationTrack == "EmptyReload" then
            arg6:_UpdateBulletTrail()
        end
    end)
    arg6.AnimationStopped:Connect(function(arg8) -- line: 100
        -- upvalues:
        --  [1] arg6 (copy)

        if arg8 == "Shoot1" or arg8 == "EmptyReload" then
            arg6:_UpdateBulletTrail()
        end
    end)
    arg6:_UpdateBulletTrail()
end

return t
