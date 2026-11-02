local v1 = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local Ragdoll_m = require(v1.Modules.Finishers.Ragdoll)
local Utility_m = require(v1.Modules.Utility)
v1 = CONSTANTS_m.IS_CLIENT

if v1 then
    v1 = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
end

local v2 = CONSTANTS_m.IS_CLIENT and require(
    Players.LocalPlayer.PlayerScripts.Controllers.CameraController
)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)
    --  [3] HttpService (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1._fov_offset_key = HttpService:GenerateGUID(false)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, arg2) -- line: 29
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] v1 (copy)
    --  [3] Lighting (copy)
    --  [4] Utility_m (copy)
    --  [5] v2 (copy)

    Ragdoll_m.PlayClient(arg1, arg2)

    if not arg2 then
        local v4 = v1:GetFighter(arg1._eliminator)

        if not v4 or not v4:Get("IsSpectating") then
            return
        end
    end

    local v5 = 0.95 + 0.1 * math.random()
    arg1:CreateSound(
        "rbxassetid://74603473314180",
        1.25,
        v5,
        script,
        true,
        10
    )
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Parent = Lighting
    table.insert(arg1._destroy_these, ColorCorrectionEffect)
    Utility_m:RenderstepForLoop(0, 100, 2, function(arg3) -- line: 46
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] ColorCorrectionEffect (copy)
        --  [3] v2 (ref)

        if arg1._destroyed then
            return true
        end

        local v6 = arg3 / 100
        local v8 = 1 - (if not (v6 < 0.5) then 1 - (-2 * v6 + 2) ^ 5 / 2 else 16 * v6 ^ 5)
        ColorCorrectionEffect.Brightness = 0.25 * v8
        ColorCorrectionEffect.Contrast = 0.5 * v8
        ColorCorrectionEffect.Saturation = 1 * v8
        v2:SetExternalFOVOffset(arg1._fov_offset_key, 10 * v8)
    end)
    ColorCorrectionEffect:Destroy()
    v2:SetExternalFOVOffset(arg1._fov_offset_key, 0)
end

function t.Destroy(arg4) -- line: 65
    -- upvalues:
    --  [1] v2 (copy)
    --  [2] Ragdoll_m (copy)

    if v2 then
        v2:SetExternalFOVOffset(arg4._fov_offset_key, 0)
    end

    Ragdoll_m.Destroy(arg4)
end

function t._Init(_) -- line: 77
end

return t
