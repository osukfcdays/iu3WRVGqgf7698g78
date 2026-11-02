local TweenService = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = {
    "rbxassetid://101762638470251",
    "rbxassetid://126383304317897",
    "rbxassetid://74045498632198",
    "rbxassetid://126383304317897"
}
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t_1 = setmetatable({}, WrapGroupObject_m)
t_1.__index = t_1

function t_1.new(...) -- line: 18
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(WrapGroupObject_m.new(...), t_1)
    t_2._started = 0
    t_2._flashes = {}
    t_2._bats = {}
    t_2._last_strike = 0
    t_2._next_strike = 0
    t_2._current_frame = 0
    t_2._last_update = 0
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, arg2) -- line: 38
    -- upvalues:
    --  [1] t (copy)
    --  [2] TweenService (copy)
    --  [3] tweenInfo (copy)

    arg1._started += arg2
    local Started = arg1._started

    for _, val in arg1._bats do
        val.OffsetStudsU = Started % val.StudsPerTileU
        val.OffsetStudsV = Started * 2 % val.StudsPerTileV
    end

    if Started >= arg1._last_update + 0.05 then
        arg1._last_update = Started
        arg1._current_frame += 1

        if arg1._current_frame > #t then
            arg1._current_frame = 1
        end

        for _, val_1 in arg1._bats do
            val_1.Texture = t[arg1._current_frame]
        end
    end

    if Started < arg1._next_strike then
        return
    end

    arg1._next_strike = Started + Random.new(arg1._started):NextNumber(1.1, 2.1)
    arg1._last_strike = Started

    for _, val_2 in arg1._bats do
        local v3 = Random.new():NextNumber(-val_2.StudsPerTileU, val_2.StudsPerTileU)
        local rng_1 = Random.new():NextNumber(-val_2.StudsPerTileV, val_2.StudsPerTileV)
        val_2.OffsetStudsU = v3
        val_2.OffsetStudsV = rng_1
    end

    for _, val_3 in arg1._flashes do
        val_3.Transparency = 0
        local v5 = TweenService:Create(val_3, tweenInfo, { Transparency = 1 })
        v5:Play()
        table.insert(arg1._tweens, v5)
    end
end

function t_1._Setup(arg3) -- line: 87
    -- upvalues:
    --  [1] t (copy)

    for _, val_4 in pairs(arg3.ExtraObjects) do
        if val_4:IsA("Texture") and val_4.Name == "Flash" then
            table.insert(arg3._flashes, val_4)
        elseif val_4:IsA("Texture") and val_4.Name == "Bats" then
            table.insert(arg3._bats, val_4)
        end
    end

    if arg3.Object:IsA("BasePart") then
        for _, val_5 in pairs(t) do
            local PreloadedTextureBatFlock_Texture = Instance.new("Texture")
            PreloadedTextureBatFlock_Texture.Texture = val_5
            PreloadedTextureBatFlock_Texture.Transparency = 1
            PreloadedTextureBatFlock_Texture.Face = Enum.NormalId.Front
            PreloadedTextureBatFlock_Texture.Name = "PreloadedTextureBatFlock"
            PreloadedTextureBatFlock_Texture.Parent = arg3.Object
        end
    end
end

function t_1._Init(arg4) -- line: 108
    arg4:_Setup()
end

return t_1
