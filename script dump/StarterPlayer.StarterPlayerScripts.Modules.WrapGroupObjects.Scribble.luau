local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = { "rbxassetid://112448109089773", "rbxassetid://85215887790060" }
local t_1 = setmetatable({}, WrapGroupObject_m)
t_1.__index = t_1

function t_1.new(...) -- line: 10
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(WrapGroupObject_m.new(...), t_1)
    t_2._textures1 = {}
    t_2._textures2 = {}
    t_2._texture_index = 0
    t_2._next_tick = 0
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, _) -- line: 27
    -- upvalues:
    --  [1] t (copy)

    local serverTimestamp = workspace:GetServerTimeNow()

    if serverTimestamp < arg1._next_tick then
        return
    end

    arg1._next_tick = serverTimestamp + 0.15
    arg1._texture_index += 1
    local v2 = arg1._texture_index % 2 + 1
    local v3 = 3 - v2

    for _, val in pairs(arg1._textures1) do
        val.Texture = t[v2]
    end

    for _, val_1 in pairs(arg1._textures2) do
        val_1.Texture = t[v3]
    end
end

function t_1._Setup(arg3) -- line: 53
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "Scribbles" then
            table.insert(arg3._textures1, val_2)
        elseif val_2.Name == "Scribbles2" then
            table.insert(arg3._textures2, val_2)
        end
    end
end

function t_1._Init(arg4) -- line: 63
    arg4:_Setup()
end

return t_1
