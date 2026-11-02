local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._overlays = {}
    t_1._overlays2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 23
    local serverTimestamp = workspace:GetServerTimeNow()

    for _, val in pairs(arg1._overlays) do
        local v2 = serverTimestamp / 15
        val.OffsetStudsU, val.OffsetStudsV = v2 % val.StudsPerTileU, v2 % val.StudsPerTileV
        val.Transparency = math.sin(serverTimestamp * 1.25) / 7 + 0.25
    end

    for _, val_1 in pairs(arg1._overlays2) do
        local v3 = (math.sin(serverTimestamp / 2.5) / 1.2 + 2) / 6 + 2
        val_1.StudsPerTileU = v3
        val_1.StudsPerTileV = v3
    end
end

function t._Setup(arg3) -- line: 51
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "WeirdPaintOverlay" then
            table.insert(arg3._overlays, val_2)
        elseif val_2.Name == "WeirdPaintOverlay2" then
            table.insert(arg3._overlays2, val_2)
        end
    end
end

function t._Init(arg4) -- line: 61
    arg4:_Setup()
end

return t
