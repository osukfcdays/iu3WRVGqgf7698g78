local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Snowballs = Players.LocalPlayer.PlayerScripts.Assets.Misc.Snowballs
local t = {}
local SnowballParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.SnowballParticles
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._grab_snowball_hash = 0
    t_1._grab_snowball_visual = nil
    t_1._grab_snowball_animation_start = Instance.new("Animation")
    t_1._grab_snowball_animation_idle = Instance.new("Animation")
    t_1._grab_snowball_animation_throw = Instance.new("Animation")
    t_1._grab_snowball_animation_track_start = nil
    t_1._grab_snowball_animation_track_idle = nil
    t_1:_Init()

    return t_1
end

function t.ThrowSnowball(arg2, arg3) -- line: 38
    local v1 = arg2.ClientFighterCharacter:Get("IsGrabbingSnowball")
    arg2.ClientFighterCharacter:SetReplicate("IsGrabbingSnowball", nil)
    arg2:_ThrowSnowball(arg3, v1)
end

function t.Update(_, _, _) -- line: 45
end

function t.Destroy(arg7) -- line: 49
    arg7._grab_snowball_animation_start:Destroy()
    arg7._grab_snowball_animation_idle:Destroy()
    arg7._grab_snowball_animation_throw:Destroy()
    arg7:_ThrowSnowball(nil)
end

function t._GrabSnowball(arg8, arg9) -- line: 60
    -- upvalues:
    --  [1] Snowballs (copy)

    arg8:_ThrowSnowball(nil)
    local RightHand = arg8.ClientFighterCharacter.Model:FindFirstChild("RightHand")

    if not RightHand then
        return
    end

    arg8._grab_snowball_hash += 1
    local GrabSnowballHash = arg8._grab_snowball_hash
    local Success, Result = pcall(
        arg8.ClientFighterCharacter.Humanoid.LoadAnimation,
        arg8.ClientFighterCharacter.Humanoid,
        arg8._grab_snowball_animation_start
    )

    if Success then
        arg8._grab_snowball_animation_track_start = Result
        arg8._grab_snowball_animation_track_start:Play(0)
        arg8._grab_snowball_animation_track_start:AdjustSpeed(3)
        task.delay(0.5, function() -- line: 81
            -- upvalues:
            --  [1] GrabSnowballHash (copy)
            --  [2] arg8 (copy)

            if GrabSnowballHash ~= arg8._grab_snowball_hash then
                return
            end

            local Success_1, Result_1 = pcall(
                arg8.ClientFighterCharacter.Humanoid.LoadAnimation,
                arg8.ClientFighterCharacter.Humanoid,
                arg8._grab_snowball_animation_idle
            )

            if Success_1 then
                arg8._grab_snowball_animation_track_idle = Result_1
                arg8._grab_snowball_animation_track_idle:Play()
            end
        end)
    end

    if not arg9 then
        return
    end

    arg8._grab_snowball_visual = Snowballs[arg9]:Clone()
    arg8._grab_snowball_visual.PrimaryPart = arg8._grab_snowball_visual.Primary
    arg8._grab_snowball_visual:PivotTo(RightHand.CFrame)
    arg8._grab_snowball_visual.Parent = RightHand
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = RightHand
    WeldConstraint.Part1 = arg8._grab_snowball_visual.PrimaryPart
    WeldConstraint.Parent = arg8._grab_snowball_visual
end

function t._ThrowSnowball(arg10, arg11, arg12) -- line: 110
    -- upvalues:
    --  [1] Snowballs (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] SnowballParticles (copy)

    arg10._grab_snowball_hash += 1

    if arg10._grab_snowball_visual then
        arg10._grab_snowball_visual:Destroy()
        arg10._grab_snowball_visual = nil
    end

    if arg10._grab_snowball_animation_track_start then
        arg10._grab_snowball_animation_track_start:Stop(0)
        arg10._grab_snowball_animation_track_start:Destroy()
        arg10._grab_snowball_animation_track_start = nil
    end

    if arg10._grab_snowball_animation_track_idle then
        arg10._grab_snowball_animation_track_idle:Stop(0)
        arg10._grab_snowball_animation_track_idle:Destroy()
        arg10._grab_snowball_animation_track_idle = nil
    end

    if not arg11 or not arg12 then
        return
    end

    local RightHand_1 = arg10.ClientFighterCharacter.Model:FindFirstChild("RightHand")

    if not RightHand_1 then
        return
    end

    task.spawn(function() -- line: 140
        -- upvalues:
        --  [1] RightHand_1 (copy)
        --  [2] arg11 (copy)
        --  [3] Snowballs (ref)
        --  [4] arg12 (copy)
        --  [5] arg10 (copy)
        --  [6] BetterDebris_m (ref)
        --  [7] Utility_m (ref)
        --  [8] SnowballParticles (ref)

        local Position = RightHand_1.Position
        local Magnitude = (Position - arg11).Magnitude
        local v3 = Snowballs[arg12]:Clone()
        v3.PrimaryPart = v3.Primary
        v3:PivotTo(RightHand_1.CFrame)
        v3.Parent = workspace
        local WeldConstraint_1 = Instance.new("WeldConstraint")
        WeldConstraint_1.Part0 = RightHand_1
        WeldConstraint_1.Part1 = v3.PrimaryPart
        WeldConstraint_1.Parent = v3
        local Success_2, Result_2 = pcall(
            arg10.ClientFighterCharacter.Humanoid.LoadAnimation,
            arg10.ClientFighterCharacter.Humanoid,
            arg10._grab_snowball_animation_throw
        )

        if Success_2 then
            Result_2:Play()
            Result_2:AdjustSpeed(1.25)
            BetterDebris_m:AddItem(Result_2, 2)
            wait(0.32)
        end

        v3.PrimaryPart.Anchored = true
        WeldConstraint_1.Part0 = nil
        local cframe_1 = CFrame.Angles(
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2
        )
        Utility_m:RenderstepForLoop(0, 100, 225 / Magnitude, function(arg13) -- line: 171
            -- upvalues:
            --  [1] Position (copy)
            --  [2] arg11 (ref)
            --  [3] v3 (copy)
            --  [4] cframe_1 (copy)

            local v8 = arg13 / 100
            local cframe = CFrame.new(Position:Lerp(arg11, v8))
            local v11 = Position.Y + (arg11.Y - Position.Y) * (math.sin(1.8849555921538759 * v8) / 0.9510565162951536)
            local v12 = math.sin(3.141592653589793 * v8) * 3
            local v13 = v3
            local New_1 = CFrame.new
            local X = cframe.X
            local Y_1 = cframe.Y
            local absoluteValue = math.abs(cframe.Y - v11)
            v13:PivotTo(New_1(X, Y_1 + math.max(v12, absoluteValue), cframe.Z) * cframe_1)
        end)

        for _, descendant in pairs(v3:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 1
            end
        end

        BetterDebris_m:AddItem(v3, 4)
        local v17 = SnowballParticles[arg12].Attachment:Clone()
        v17.Parent = v3.PrimaryPart
        Utility_m:PlayParticles(v17)

        if arg12 == "WaterBalloon" then
            Utility_m:CreateSound(
                "rbxassetid://122599219317279",
                0.4,
                0.9 + 0.2 * math.random(),
                v3.PrimaryPart,
                true,
                5
            )

            return
        end

        Utility_m:CreateSound(
            "rbxassetid://11800684590",
            0.4,
            0.9 + 0.2 * math.random(),
            v3.PrimaryPart,
            true,
            5
        )
    end)
end

function t._Setup(arg14) -- line: 201
    arg14._grab_snowball_animation_start.AnimationId = "rbxassetid://127148856297189"
    arg14._grab_snowball_animation_idle.AnimationId = "rbxassetid://120318438418071"
    arg14._grab_snowball_animation_throw.AnimationId = "rbxassetid://107298949913168"
end

function t._Init(arg15) -- line: 207
    arg15.ClientFighterCharacter:GetDataChangedSignal("IsGrabbingSnowball"):Connect(function() -- line: 208
        -- upvalues:
        --  [1] arg15 (copy)

        local v22 = arg15.ClientFighterCharacter:Get("IsGrabbingSnowball")

        if not v22 then
            return
        end

        arg15:_GrabSnowball(v22)
    end)
    arg15:_Setup()
end

return t
