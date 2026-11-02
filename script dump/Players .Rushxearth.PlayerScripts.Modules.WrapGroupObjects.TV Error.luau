local _ = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = {
    "rbxassetid://76762297951095",
    "rbxassetid://104650396345178",
    "rbxassetid://128067608046117"
}
local t_1 = setmetatable({}, WrapGroupObject_m)
t_1.__index = t_1

function t_1.new(...) -- line: 16
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(WrapGroupObject_m.new(...), t_1)
    t_2._static = {}
    t_2._elapsed = 0
    t_2._last_texture = 1
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, arg2) -- line: 32
    -- upvalues:
    --  [1] t (copy)

    arg1._elapsed += arg2
    local v2 = math.sin(workspace:GetServerTimeNow() * 10) / 10 + 0.1
    local v3 = t[arg1._last_texture]

    if arg1._elapsed >= 0.04 then
        arg1._elapsed = 0
        local v4 = arg1._last_texture + 1
        v4 = if not (v4 > #t) then v4 else 1
        v3 = t[v4]
        arg1._last_texture = v4
    end

    for _, val in pairs(arg1._static) do
        val.OffsetStudsU = Random.new():NextInteger(-1, 1) / 250
        val.OffsetStudsV = Random.new():NextInteger(-1, 1) / 250
        val.Texture = v3
        val.Transparency = v2
    end
end

function t_1._Setup(arg3) -- line: 62
    for _, val_1 in pairs(arg3.ExtraObjects) do
        if val_1.Name == "Static" then
            table.insert(arg3._static, val_1)
        end
    end
end

function t_1._Init(arg4) -- line: 70
    arg4:_Setup()
end

return t_1
