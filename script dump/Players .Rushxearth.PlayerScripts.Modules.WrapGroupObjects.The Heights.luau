local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = {
    "rbxassetid://2590541",
    "rbxassetid://83032711602009",
    "rbxassetid://128727548904352",
    "rbxassetid://90166684921447",
    "rbxassetid://140239100555084",
    "rbxassetid://97272253453870",
    "rbxassetid://126082024890331",
    "rbxassetid://131249583090004",
    "rbxassetid://130283158493590",
    "rbxassetid://114556019900394",
    "rbxassetid://112466666772902",
    "rbxassetid://117101826648137",
    "rbxassetid://114538468748606",
    "rbxassetid://139873735674722",
    "rbxassetid://103775503564962",
    "rbxassetid://98373420251654",
    "rbxassetid://79425698371704",
    "rbxassetid://87166826689312",
    "rbxassetid://90076189567688",
    "rbxassetid://139561695601892",
    "rbxassetid://140445824066751",
    "rbxassetid://90343553347218",
    "rbxassetid://80578694078644",
    "rbxassetid://75411897165689",
    "rbxassetid://120909749571199",
    "rbxassetid://112084468503688",
    "rbxassetid://126283045144965",
    "rbxassetid://129853781030059",
    "rbxassetid://136743858401776",
    "rbxassetid://119486130155706",
    "rbxassetid://132663054692921",
    "rbxassetid://133945106822765",
    "rbxassetid://70983245593146",
    "rbxassetid://115582632329247",
    "rbxassetid://129297227277092",
    "rbxassetid://87912065660686",
    "rbxassetid://81705944196717",
    "rbxassetid://78878769229079"
}
local v1 = #t / 2
local v2 = #t - 8
local t_1 = setmetatable({}, WrapGroupObject_m)
t_1.__index = t_1

function t_1.new(...) -- line: 56
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(WrapGroupObject_m.new(...), t_1)
    t_2._fire_ring = {}
    t_2._fire_ring_glow = {}
    t_2._last_update = 0
    t_2._last_interval = 0.04
    t_2._current_frame = 0
    t_2:_Init()

    return t_2
end

function t_1.GetPreloadedImageIDs(_) -- line: 74
    -- upvalues:
    --  [1] t (copy)

    return t
end

function t_1.Update(arg2, _) -- line: 78
    -- upvalues:
    --  [1] t (copy)
    --  [2] v2 (copy)
    --  [3] v1 (copy)

    local v4 = workspace:GetServerTimeNow()

    if v4 < arg2._last_update + arg2._last_interval then
        return
    end

    arg2._last_update = v4
    v4 = 0
    arg2._last_interval = 0.04
    arg2._current_frame -= 1

    if arg2._current_frame < 1 then
        arg2._current_frame = #t
    end

    if arg2._current_frame == #t or arg2._current_frame == 1 then
        v4 = 1
    elseif arg2._current_frame >= v2 then
        v4 = (arg2._current_frame - v2) / v2 * 10
    elseif arg2._current_frame < v1 then
        v4 += 1 - arg2._current_frame / v1
        arg2._last_interval = 0.04 / (v4 + 1)
    end

    v4 = math.clamp(v4, 0, 1)

    for _, val in pairs(arg2._fire_ring) do
        val.Texture = t[arg2._current_frame]
        val.Transparency = v4
    end

    for _, val_1 in pairs(arg2._fire_ring_glow) do
        val_1.Transparency = math.max(v4, 0.5)
    end
end

function t_1._Setup(arg4) -- line: 120
    for _, val_2 in pairs(arg4.ExtraObjects) do
        if val_2.Name == "FireRing" then
            table.insert(arg4._fire_ring, val_2)
        elseif val_2.Name == "FireRingGlow" then
            table.insert(arg4._fire_ring_glow, val_2)
        end
    end
end

function t_1._Init(arg5) -- line: 130
    arg5:_Setup()
end

return t_1
