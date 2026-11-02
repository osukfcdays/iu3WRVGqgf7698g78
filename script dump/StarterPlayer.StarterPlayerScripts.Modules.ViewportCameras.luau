local RunService = game:GetService("RunService")
local t = { ZOOM_OUT_FACTOR = 3, Charm = Instance.new("Camera") }
t.Charm.FieldOfView = 25
t.CharmZoomedOut = Instance.new("Camera")
t.CharmZoomedOut.FieldOfView = 25
t.Skin = Instance.new("Camera")
t.Skin.FieldOfView = 25
t.SkinZoomedOut = Instance.new("Camera")
t.SkinZoomedOut.FieldOfView = 25
t.Wrap = Instance.new("Camera")
t.Wrap.FieldOfView = 25
t.Wrap.CFrame = CFrame.Angles(0, 3.490658503988659, 0) * CFrame.Angles(-0.2617993877991494, 0, 0) * CFrame.new(
    0,
    0,
    1
)
t.WrapZoomedOut = Instance.new("Camera")
t.WrapZoomedOut.FieldOfView = 25
t.WrapZoomedOut.CFrame = CFrame.Angles(0, 3.490658503988659, 0) * CFrame.Angles(
    -0.2617993877991494,
    0,
    0
) * CFrame.new(0, 0, 1 * t.ZOOM_OUT_FACTOR)
t.Emote = Instance.new("Camera")
t.Emote.FieldOfView = 10
t.EmoteZoomedOut = Instance.new("Camera")
t.EmoteZoomedOut.FieldOfView = 10
RunService.RenderStepped:Connect(function(_) -- line: 29
    -- upvalues:
    --  [1] t (copy)

    t.Charm.CFrame = CFrame.Angles(0, tick() * 0.5 % 6.283185307179586, 0) * CFrame.Angles(
        -0.2617993877991494,
        0,
        0
    ) * CFrame.new(0, 0, 0.3)
    t.CharmZoomedOut.CFrame = CFrame.Angles(0, tick() * 0.5 % 6.283185307179586, 0) * CFrame.Angles(
        -0.2617993877991494,
        0,
        0
    ) * CFrame.new(0, 0, 0.3 * t.ZOOM_OUT_FACTOR)
    t.Skin.CFrame = CFrame.Angles(0, tick() * 0.5 % 6.283185307179586, 0) * CFrame.Angles(
        -0.2617993877991494,
        0,
        0
    ) * CFrame.new(0, 0, 5)
    t.SkinZoomedOut.CFrame = CFrame.Angles(0, tick() * 0.5 % 6.283185307179586, 0) * CFrame.Angles(
        -0.2617993877991494,
        0,
        0
    ) * CFrame.new(0, 0, 5 * t.ZOOM_OUT_FACTOR)
    local Emote = t.Emote
    local v12 = CFrame.Angles(
        0,
        3.141592653589793 + math.sin(tick() * 0.25 % 6.283185307179586) * 0.2617993877991494,
        0
    ) * CFrame.Angles(-0.4363323129985824, 0, 0)
    Emote.CFrame = v12 * CFrame.new(0, 0, 40)
    local EmoteZoomedOut = t.EmoteZoomedOut
    local v14 = CFrame.Angles(
        0,
        3.141592653589793 + math.sin(tick() * 0.25 % 6.283185307179586) * 0.2617993877991494,
        0
    ) * CFrame.Angles(-0.4363323129985824, 0, 0)
    EmoteZoomedOut.CFrame = v14 * CFrame.new(0, 0, 40 * t.ZOOM_OUT_FACTOR)
end)

return t
