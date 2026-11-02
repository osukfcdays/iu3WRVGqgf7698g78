local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local SubspaceTripmine_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"]
)
local DevintheBoxExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "DevintheBoxExplosionEffect"
)
local DevInTheBox = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("Dev-in-the-Box")
local t = setmetatable({}, SubspaceTripmine_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] SubspaceTripmine_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SubspaceTripmine_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(arg1, arg2) -- line: 27
    -- upvalues:
    --  [1] DevInTheBox (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] WrapController_m (copy)
    --  [4] Utility_m (copy)
    --  [5] DevintheBoxExplosionEffect (copy)

    local v2 = arg2:FuzzyEq(workspace.CurrentCamera.CFrame.Position) and CFrame.new(arg2) or CFrame.new(
        arg2,
        (Vector3.new(workspace.CurrentCamera.CFrame.X, arg2.Y, workspace.CurrentCamera.CFrame.Z))
    )
    local v3 = math.random() < 0.5 and true
    local v4 = DevInTheBox:Clone()
    v4.Dev.SenseiWarrior.Transparency = if v3 then 0 else 1
    v4.Dev.Nosniy.Transparency = if not v3 then 0 else 1
    v4:PivotTo(v2 + Vector3.new(0, 0.5, 0))
    v4.Parent = workspace
    BetterDebris_m:AddItem(v4, 4)
    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(v4),
        arg1.ClientItem:GetWrap(),
        true
    )
    Utility_m:CreateSound(
        "rbxassetid://86639533276627",
        0.875,
        1 + 0.1 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://121003602924254",
        1.25,
        1 + 0.1 * math.random(),
        arg2,
        true,
        10
    )
    v3 = DevintheBoxExplosionEffect:Clone()
    v3.CFrame = CFrame.new(arg2)
    v3.Parent = workspace
    BetterDebris_m:AddItem(v3, 5)
    Utility_m:PlayParticles(v3)
    pcall(function() -- line: 48
        -- upvalues:
        --  [1] v4 (copy)

        task.delay(3, function() -- line: 49
            -- upvalues:
            --  [1] v4 (ref)

            v4.Primary.Anchored = false
        end)
        v4.AnimationController:LoadAnimation(v4.Animation):Play()
        wait(0.1)
        v4.top.Lid.Delete:Destroy()
        v4.top.Lid.Velocity = (Random.new():NextUnitVector() * Vector3.new(1, 0, 1) + Vector3.new(0, 4, 0)) * (15 + 25 * math.random())
        local Lid_1 = v4.top.Lid
        local LookVector = CFrame.Angles(
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2
        ).LookVector
        Lid_1.RotVelocity = LookVector * (10 + 10 * math.random())
    end)
end

function t._Init(_) -- line: 67
end

return t
