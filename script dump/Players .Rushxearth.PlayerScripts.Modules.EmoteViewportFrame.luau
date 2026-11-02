local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ViewportCameras_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewportCameras)
local EmoteViewportFrame = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EmoteViewportFrame"
)
local EmoteDummy = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("EmoteDummy")
local t = {}
local Emotes = ReplicatedStorage.Modules.Emotes
t.__index = t

function t.new(arg1, arg2) -- line: 15
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] t (copy)
    --  [3] EmoteViewportFrame (copy)

    assert(CosmeticLibrary_m.Cosmetics[arg1].Type == "Emote")
    local t_1 = setmetatable({}, t)
    t_1.Name = arg1
    t_1.Frame = EmoteViewportFrame:Clone()
    t_1.EmoteGlow = t_1.Frame.EmoteGlow
    t_1._destroyed = false
    t_1._world_model = t_1.Frame.WorldModel
    t_1._playing_emotes_hash = 0
    t_1._dummy = nil
    t_1._last_emote = nil
    t_1._fade_speed = if t_1.Name == "MISSING_EMOTE" then math.huge else arg2 or 1
    t_1._is_locked = false
    t_1:_Init()

    return t_1
end

function t.SetParent(arg3, arg4) -- line: 41
    arg3.Frame.Parent = arg4
    arg3.EmoteGlow.Parent = arg4
end

function t.SetLocked(arg5, arg6) -- line: 46
    arg5._is_locked = arg6
    local Frame = arg5.Frame
    Frame.ImageColor3 = arg5._is_locked and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    arg5.Frame.ImageTransparency = arg5:_GetImageTransparency()
end

function t.HideShadow(arg7) -- line: 52
    arg7.EmoteGlow.Visible = false
end

function t.ZoomOut(arg8) -- line: 56
    -- upvalues:
    --  [1] ViewportCameras_m (copy)

    local Size = arg8.Frame.Size
    arg8.Frame.Size = UDim2.new(
        arg8.Frame.Size.X.Scale * ViewportCameras_m.ZOOM_OUT_FACTOR,
        arg8.Frame.Size.X.Offset * ViewportCameras_m.ZOOM_OUT_FACTOR,
        arg8.Frame.Size.Y.Scale * ViewportCameras_m.ZOOM_OUT_FACTOR,
        arg8.Frame.Size.Y.Offset * ViewportCameras_m.ZOOM_OUT_FACTOR
    )
    local Frame_3 = arg8.Frame
    Frame_3.Position = UDim2.new(
        arg8.Frame.Position.X.Scale,
        arg8.Frame.Position.X.Offset,
        arg8.Frame.Position.Y.Scale - Size.Y.Scale * 0.5 + arg8.Frame.Size.Y.Scale * 0.5,
        arg8.Frame.Position.Y.Offset - Size.Y.Offset * 0.5 + arg8.Frame.Size.Y.Offset * 0.5
    )
    arg8.Frame.CurrentCamera = ViewportCameras_m.EmoteZoomedOut
end

function t.Destroy(arg9) -- line: 63
    arg9._destroyed = true
    arg9._playing_emotes_hash += 1
    arg9.Frame:Destroy()
    arg9:_Clear()
end

function t._GetImageTransparency(arg10) -- line: 74
    if arg10._is_locked then
        return 0.5
    end

    return 0
end

function t._IsActuallyVisible(arg11) -- line: 78
    -- upvalues:
    --  [1] Players (copy)

    if
        not arg11.Frame:IsDescendantOf(workspace)
        and (not Players.LocalPlayer:FindFirstChild("PlayerGui") or not arg11.Frame:IsDescendantOf(
            Players.LocalPlayer.PlayerGui
        ))
    then
        return false
    end

    local v4 = arg11.Frame

    while v4 do
        if v4:IsA("LayerCollector") then
            break
        end

        v4 = v4.Parent
    end

    if not v4 or not v4.Enabled then
        return false
    end

    local v5 = arg11.Frame

    repeat
        if not v5.Visible then
            return false
        end

        v5 = v5.Parent
    until v5 == v4

    return true
end

function t._Clear(arg12) -- line: 110
    if arg12._dummy then
        arg12._dummy:Destroy()
        arg12._dummy = nil
    end

    if arg12._last_emote then
        arg12._last_emote:Destroy()
        arg12._last_emote = nil
    end
end

function t._PlayEmote(arg13) -- line: 122
    -- upvalues:
    --  [1] EmoteDummy (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] Utility_m (copy)
    --  [4] Emotes (copy)

    if arg13._destroyed then
        return
    end

    arg13._playing_emotes_hash += 1
    local PlayingEmotesHash = arg13._playing_emotes_hash
    arg13:_Clear()

    while true do
        if arg13:_IsActuallyVisible() then
            break
        end

        wait(1)

        if arg13._playing_emotes_hash == PlayingEmotesHash then
            continue
        end

        return
    end

    while true do
        local now = tick()
        arg13._dummy = EmoteDummy:Clone()
        arg13._dummy:PivotTo(CosmeticLibrary_m.Cosmetics[arg13.Name].ViewportCFrameOffset)
        arg13._dummy.Parent = arg13._world_model
        Utility_m:RenderstepForLoop(0, 100, 4 * arg13._fade_speed, function(arg14) -- line: 147
            -- upvalues:
            --  [1] arg13 (copy)
            --  [2] PlayingEmotesHash (copy)

            if arg13._playing_emotes_hash ~= PlayingEmotesHash then
                return true
            end

            local v7 = (arg14 / 100) ^ 3
            arg13.Frame.ImageTransparency = 1 + (arg13:_GetImageTransparency() - 1) * v7
            arg13.EmoteGlow.ImageTransparency = 1 + -0.5 * v7
        end)

        if arg13._playing_emotes_hash ~= PlayingEmotesHash then
            return
        end

        if arg13._dummy:FindFirstChild("Humanoid") then
            arg13._last_emote = require(Emotes[arg13.Name]).new(arg13._dummy.Humanoid)
            task.defer(arg13._last_emote.Simulate, arg13._last_emote)
            arg13._last_emote.Destroying:Wait()
        end

        Utility_m:RenderstepForLoop(0, 100, 4 * arg13._fade_speed, function(arg15) -- line: 168
            -- upvalues:
            --  [1] arg13 (copy)
            --  [2] PlayingEmotesHash (copy)

            if arg13._playing_emotes_hash ~= PlayingEmotesHash then
                return true
            end

            local v9 = 1 - (1 - arg15 / 100) ^ 3
            arg13.Frame.ImageTransparency = arg13:_GetImageTransparency() + (1 - arg13:_GetImageTransparency()) * v9
            arg13.EmoteGlow.ImageTransparency = 0.5 + 0.5 * v9
        end)

        if arg13._playing_emotes_hash ~= PlayingEmotesHash then
            return
        end

        arg13:_Clear()
        wait(1 - (tick() - now))

        if arg13._playing_emotes_hash == PlayingEmotesHash then
            continue
        end

        return
    end
end

function t._Setup(arg16) -- line: 193
    -- upvalues:
    --  [1] ViewportCameras_m (copy)

    arg16.Frame.CurrentCamera = ViewportCameras_m.Emote
end

function t._Init(arg17) -- line: 197
    arg17.Frame.AncestryChanged:Connect(function() -- line: 198
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_PlayEmote()
    end)
    arg17:_Setup()
    task.spawn(arg17._PlayEmote, arg17)
end

return t
