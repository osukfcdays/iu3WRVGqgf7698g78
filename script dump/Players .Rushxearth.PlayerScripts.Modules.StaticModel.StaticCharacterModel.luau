local Players = game:GetService("Players")
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local StaticModel_m = require(Players.LocalPlayer.PlayerScripts.Modules.StaticModel)
local t = setmetatable({}, StaticModel_m)
t.__index = t

function t.new(arg1) -- line: 9
    -- upvalues:
    --  [1] StaticModel_m (copy)
    --  [2] FighterController_m (copy)
    --  [3] t (copy)

    local t_1 = setmetatable(
        StaticModel_m.new(FighterController_m:GenerateCharacterModel(arg1).Template:Clone()),
        t
    )
    t_1.UserID = arg1
    t_1:_Init()

    return t_1
end

function t._SetupCharacterModel(arg2) -- line: 29
    -- upvalues:
    --  [1] FighterController_m (copy)

    local v2 = FighterController_m:GenerateCharacterModel(arg2.UserID, true)

    if arg2._destroyed or not v2 then
        return
    end

    local v3 = v2.Template:Clone()
    v3.HumanoidRootPart.Anchored = true
    v3.PrimaryPart = nil
    v3.WorldPivot = v3.HumanoidRootPart.CFrame * CFrame.new(0, 1.5, 0)
    v3:PivotTo(arg2.Model:GetPivot())
    local v5 = v3:GetScale() * arg2.Model:GetScale() / arg2._original_scale
    v3:ScaleTo(v5)
    v3.Parent = arg2.Model.Parent
    task.defer(pcall, function() -- line: 44
        -- upvalues:
        --  [1] v3 (copy)

        if v3:FindFirstChild("Animate") then
            v3.Animate:Destroy()
        end

        for _, val in pairs(v3.Humanoid:GetPlayingAnimationTracks()) do
            val:Stop()
        end

        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://507766388"
        v3.Humanoid:LoadAnimation(Animation):Play()
    end)
    arg2.Model:Destroy()
    arg2.Model = v3
    arg2._original_scale = v3:GetScale()
end

function t._Setup(arg3) -- line: 63
    arg3.Model.PrimaryPart = arg3.Model:FindFirstChild("HumanoidRootPart")
end

function t._Init(arg4) -- line: 67
    arg4:_Setup()
    task.spawn(arg4._SetupCharacterModel, arg4)
end

return t
