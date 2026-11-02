local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local t = {}
local Emotes = ReplicatedStorage.Modules.Emotes
t.__index = t

function t.new(arg1) -- line: 12
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Scene = arg1
    t_1._playing_hash = 0
    t_1._last_rig = nil
    t_1._last_emote = nil
    t_1:_Init()

    return t_1
end

function t.OnCustomizingStateChanged(arg2) -- line: 30
    task.defer(arg2._StartPlaying, arg2)
end

function t.OnStateChanged(arg3) -- line: 34
    task.defer(arg3._StartPlaying, arg3)
end

function t._StartPlaying(arg4) -- line: 42
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] FighterController_m (copy)
    --  [3] Players (copy)
    --  [4] Emotes (copy)

    arg4._playing_hash += 1
    local PlayingHash = arg4._playing_hash

    if arg4._last_rig then
        arg4._last_rig:Destroy()
        arg4._last_rig = nil
    end

    if arg4._last_emote then
        arg4._last_emote:Destroy()
        arg4._last_emote = nil
    end

    local v1 = arg4.Scene.Equipment:GetSelectedCosmetic()
    local v2 = arg4.Scene.Equipment:GetCustomizingType()
    local v3 = CosmeticLibrary_m.Cosmetics[v1]

    if v2 ~= "Emote" or not v3 then
        return
    end

    while true do
        arg4._last_rig = FighterController_m:GenerateCharacterModel(Players.LocalPlayer.UserId).Template:Clone()
        arg4._last_rig:PivotTo(arg4.Scene:GetHumanoidCFrame() * v3.ViewportCFrameOffset)
        arg4._last_rig.HumanoidRootPart.Anchored = true
        arg4._last_rig.Humanoid:SetAttribute("SimulateMoving", true)
        arg4._last_rig.Parent = arg4.Scene.Model
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://507766388"
        local Success, Result = pcall(
            arg4._last_rig.Humanoid.LoadAnimation,
            arg4._last_rig.Humanoid,
            Animation
        )

        if Success then
            Result:Play(0)
        end

        arg4._last_emote = require(Emotes[v1]).new(arg4._last_rig.Humanoid)
        task.defer(arg4._last_emote.Simulate, arg4._last_emote)
        arg4._last_emote.Destroying:Wait()

        if arg4._playing_hash ~= PlayingHash then
            return
        end

        if arg4._last_rig then
            arg4._last_rig:Destroy()
            arg4._last_rig = nil
        end

        if not arg4._last_emote then
            continue
        end

        arg4._last_emote:Destroy()
        arg4._last_emote = nil
    end
end

function t._Init(_) -- line: 100
end

return t
