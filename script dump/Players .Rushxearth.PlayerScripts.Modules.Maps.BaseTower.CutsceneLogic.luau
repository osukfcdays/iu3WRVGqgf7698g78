local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local SoundLibrary_m = require(ReplicatedStorage.Modules.SoundLibrary)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local StaticViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.BaseTower = arg1
    t_1._preloaded_sounds = {}
    t_1._preloaded_animations = {}
    t_1._cutscene_hash = 0
    t_1._cutscene_renderstep_id = nil
    t_1._cutscene_animation_tracks = {}
    t_1._cutscene_cleanup = {}
    t_1._cutscene_threads = {}
    t_1._cutscene_hidden_duelers = {}
    t_1:_Init()

    return t_1
end

function t.GetCutsceneHash(arg2) -- line: 39
    return arg2._cutscene_hash
end

function t.GetPreloadedAnimation(arg3, arg4) -- line: 43
    return arg3._preloaded_animations[arg4]
end

function t.PreloadAnimation(arg5, arg6, arg7) -- line: 47
    -- upvalues:
    --  [1] ContentProvider (copy)

    local Animation = Instance.new("Animation")
    Animation.AnimationId = arg7
    arg5._preloaded_animations[arg6] = Animation
    task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, { Animation })
end

function t.PlayAnimation(arg8, arg9, arg10, arg11) -- line: 54
    if not arg9 then
        return
    end

    local Success, Result = pcall(arg9.LoadAnimation, arg9, arg10)

    if Success then
        Result:Play(0)
        table.insert(arg8._cutscene_animation_tracks, Result)
        table.insert(arg8._cutscene_threads, task.spawn(arg11, Result))

        return
    end

    warn("Animation " .. arg10.AnimationId .. " failed to animate, error:", Result)
end

function t.StopCutscene(arg12) -- line: 70
    -- upvalues:
    --  [1] RunService (copy)

    arg12._cutscene_hash += 1

    for _, val in pairs(arg12._cutscene_animation_tracks) do
        val:Stop(0)
        val:Destroy()
    end

    for _, val_1 in pairs(arg12._cutscene_cleanup) do
        val_1:Destroy()
    end

    for _, val_2 in pairs(arg12._cutscene_threads) do
        pcall(task.cancel, val_2)
    end

    for key_3, _ in pairs(arg12._cutscene_hidden_duelers) do
        key_3:SetReplicate("IsHiddenByCutscene", nil)
    end

    arg12._cutscene_animation_tracks = {}
    arg12._cutscene_cleanup = {}
    arg12._cutscene_threads = {}
    arg12._cutscene_hidden_duelers = {}

    if arg12._cutscene_renderstep_id then
        RunService:UnbindFromRenderStep(arg12._cutscene_renderstep_id)
        arg12._cutscene_renderstep_id = nil
    end
end

function t.PlayCutscene(
    arg13,
    arg14,
    arg15,
    arg16,
    arg17,
    arg18,
    arg19,
    arg20,
    arg21,
    arg22
) -- line: 101
    -- upvalues:
    --  [1] HttpService (copy)
    --  [2] StaticViewModel_m (copy)
    --  [3] UserInputService (copy)
    --  [4] TweenService (copy)
    --  [5] RunService (copy)
    --  [6] CameraController_m (copy)

    arg13:StopCutscene()
    arg13._cutscene_renderstep_id = "ZombieTowerCutscene" .. HttpService:GenerateGUID(false)
    arg13._cutscene_hash += 1
    local CutsceneHash = arg13._cutscene_hash

    if arg15 then
        table.insert(
            arg13._cutscene_threads,
            task.spawn(
                arg15,
                CutsceneHash,
                arg13._cutscene_cleanup,
                arg13._cutscene_animation_tracks
            )
        )
    end

    local t_3 = { arg16 }
    local HumanoidRootPart = arg17.Parent.HumanoidRootPart
    local t_4 = {}
    local t_5 = {}
    local t_6 = {}

    for _, val_4 in pairs(arg13.BaseTower.ClientDuel.Duelers) do
        if val_4.ClientFighter then
            val_4.ClientFighter:SetReplicate("IsHiddenByCutscene", true)
            arg13._cutscene_hidden_duelers[val_4.ClientFighter] = true

            if val_4.ClientFighter:IsAlive() and arg20 > #t_4 then
                table.insert(t_4, val_4)
            end
        end
    end

    if #t_4 == 0 then
        return
    end

    table.sort(t_4, function(arg23, arg24) -- line: 138
        return arg23.Player.UserId < arg24.Player.UserId
    end)
    local v3, v4

    for key_5, val_5 in pairs(t_4) do
        local v2 = val_5:GetCharacterModelForCutscene()
        v2.Name = "CutscenePlayer" .. key_5
        v2:SetPrimaryPartCFrame(HumanoidRootPart.CFrame)
        v2.Parent = arg17.Parent.Parent
        table.insert(t_5, v2)
        table.insert(arg13._cutscene_cleanup, v2)

        if arg22 then
            v3 = val_5.ClientFighter.EquippedItem

            if v3 then
                v3 = val_5.ClientFighter.EquippedItem:GetViewModelDetails()
            end

            v4 = v3

            if v4 then
                v4 = StaticViewModel_m.new(v3.ViewModelName)
            end

            if v4 then
                if v4:HasGripAttachment() then
                    v4:DeleteAnimationContextSubModels()
                    v4:SetWrap(v3.Wrap)
                    v4:SetCharm(v3.Charm)
                    v4:ScaleTo(if key_5 == 1 then 1.5 else 1.25)
                    v4:InitializeGrip()
                    v4:SetParent(v2)
                    table.insert(arg13._cutscene_cleanup, v4)
                    t_6[v4] = v2
                else
                    task.defer(v4.Destroy, v4)
                end
            end
        end

        v3, v4 = pcall(function() -- line: 170
            -- upvalues:
            --  [1] v2 (copy)
            --  [2] arg13 (copy)
            --  [3] arg21 (copy)
            --  [4] key_5 (copy)

            local animationTrack = v2.Humanoid:LoadAnimation(
                arg13:GetPreloadedAnimation(arg21 .. key_5)
            )
            animationTrack:Play(0)
            table.insert(arg13._cutscene_animation_tracks, animationTrack)
        end)

        if not v3 then
            warn("Player " .. key_5 .. " failed to animate, error:", v4)
            v2.Parent = nil
        end
    end

    table.insert(t_3, function(_) -- line: 182
        -- upvalues:
        --  [1] t_5 (copy)
        --  [2] HumanoidRootPart (copy)
        --  [3] t_6 (copy)

        for _, val_6 in pairs(t_5) do
            val_6:SetPrimaryPartCFrame(HumanoidRootPart.CFrame)
        end

        for key_7, val_7 in pairs(t_6) do
            key_7:GripPivotTo(val_7)
        end
    end)
    local Cam = arg17.Parent:FindFirstChild("Cam")

    if not Cam then
        return
    end

    arg13:PlayAnimation(arg17, arg18, function(_) -- line: 201
        -- upvalues:
        --  [1] arg19 (copy)
        --  [2] t_3 (copy)
        --  [3] UserInputService (ref)
        --  [4] Cam (copy)
        --  [5] TweenService (ref)
        --  [6] RunService (ref)
        --  [7] CutsceneHash (copy)
        --  [8] arg13 (copy)

        local v8 = arg19[1][2]
        table.insert(t_3, function(_) -- line: 204
            -- upvalues:
            --  [1] UserInputService (ref)
            --  [2] v8 (ref)
            --  [3] Cam (ref)

            UserInputService.MouseIconEnabled = true
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            workspace.CurrentCamera.FieldOfView = v8
            workspace.CurrentCamera.CFrame = Cam.CFrame
        end)
        local v9 = 0

        for key_8, val_8 in pairs(arg19) do
            local v11 = arg19[math.max(1, key_8 - 1)][2]
            local _ = math.max(1, key_8 - 1)
            local _, v13, v14, v15, v16 = table.unpack(val_8)
            local v17 = val_8[1] - v9

            if v14 then
                v9 += wait(v17)
                v8 = v13
            else
                local now = tick()

                while true do
                    if not (tick() < now + v17) then
                        break
                    end

                    if v17 == 0 then
                        v8 = v13
                    else
                        local v18 = v13 - v11
                        local v19 = TweenService
                        local v20 = (tick() - now) / v17
                        v8 = v11 + v18 * v19:GetValue(
                            v20,
                            v15 or Enum.EasingStyle.Quad,
                            v16 or Enum.EasingDirection.InOut
                        )
                    end

                    v9 += RunService.RenderStepped:Wait()

                    if CutsceneHash == arg13._cutscene_hash then
                        continue
                    end

                    return
                end
            end
        end
    end)
    RunService:BindToRenderStep(arg13._cutscene_renderstep_id, CameraController_m:GetRenderstepPriority() + 1, function(
        arg28
    ) -- line: 239
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] t_3 (copy)

        if not arg13.BaseTower.ClientDuel:Get("IsSpectating") then
            return
        end

        for _, val_9 in pairs(t_3) do
            val_9(arg28)
        end
    end)
    wait(arg14)

    if CutsceneHash ~= arg13._cutscene_hash then
        return
    end

    arg13:StopCutscene()
end

function t.PreloadCutsceneSoundIDs(arg29, arg30) -- line: 259
    -- upvalues:
    --  [1] SoundLibrary_m (copy)

    for _, val_10 in pairs(SoundLibrary_m:PreloadSounds(arg30)) do
        table.insert(arg29._preloaded_sounds, val_10)
    end
end

function t.Destroy(arg31) -- line: 265
    for _, val_11 in pairs(arg31._preloaded_sounds) do
        val_11:Destroy()
    end

    for _, val_12 in pairs(arg31._preloaded_animations) do
        val_12:Destroy()
    end

    arg31:StopCutscene()
end

function t._Init(_) -- line: 281
end

return t
