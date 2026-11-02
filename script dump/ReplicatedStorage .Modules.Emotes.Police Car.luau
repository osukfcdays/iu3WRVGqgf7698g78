local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local _ = Color3.fromRGB(20, 82, 214)
local _ = Color3.fromRGB(202, 42, 42)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 18
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 30
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local v2 = arg1:_SetupMultipleProps(script.CarProp)
    arg1:_PlayAnimation("rbxassetid://131715664984592", "rbxassetid://121062198562083", 3.15)
    arg1:CreateSound(
        "rbxassetid://139395743852964",
        1,
        1,
        nil,
        true
    ).Looped = true
    arg1:CreateSound(
        "rbxassetid://77259408745181",
        0.75,
        1,
        nil,
        true
    ).Looped = true
    local _ = v2.Base.Frame.vfx
    local _ = v2.Base.RedLights
    local _ = v2.Base.BlueLights
    local _ = tick() + 4

    for index = 1, math.huge do
        if arg1._destroyed then
            return
        end

        if index % 2 ~= 1 then
        end

        wait(0.5)
    end
end

function t._Init(_) -- line: 68
end

return t
