local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = {
    "rbxassetid://138393431257124",
    "rbxassetid://107051054528784",
    "rbxassetid://125054446055112",
    "rbxassetid://110582063087757",
    "rbxassetid://119507229017142",
    "rbxassetid://97696327350095",
    "rbxassetid://108305398626234",
    "rbxassetid://107586098443052",
    "rbxassetid://102752148910886",
    "rbxassetid://96190250840477",
    "rbxassetid://83191963862467",
    "rbxassetid://101078325262094"
}
local t_1 = setmetatable({}, WrapGroupObject_m)
t_1.__index = t_1

function t_1.new(...) -- line: 24
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(WrapGroupObject_m.new(...), t_1)
    t_2._arrows1 = {}
    t_2._arrows2 = {}
    t_2._snowflakes = {}
    t_2._frame = 0
    t_2._next_update = 0
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, _) -- line: 42
    -- upvalues:
    --  [1] t (copy)

    local serverTimestamp = workspace:GetServerTimeNow()

    for _, val in pairs(arg1._arrows1) do
        val.OffsetStudsU = -(serverTimestamp * 2 % val.StudsPerTileU)
    end

    for _, val_1 in pairs(arg1._arrows2) do
        val_1.OffsetStudsU = serverTimestamp * 2 % val_1.StudsPerTileU
    end

    if tick() < arg1._next_update then
        return
    end

    arg1._next_update = tick() + 0.03
    arg1._frame = arg1._frame % #t + 1

    for _, val_2 in pairs(arg1._snowflakes) do
        val_2.Texture = t[arg1._frame]
    end
end

function t_1._Setup(arg3) -- line: 69
    for _, val_3 in pairs(arg3.ExtraObjects) do
        if val_3.Name == "TopArrows" then
            table.insert(arg3._arrows1, val_3)
        elseif val_3.Name == "BottomArrows" then
            table.insert(arg3._arrows2, val_3)
        elseif val_3.Name == "Snowflake" then
            table.insert(arg3._snowflakes, val_3)
        end
    end
end

function t_1._Init(arg4) -- line: 81
    arg4:_Setup()
end

return t_1
