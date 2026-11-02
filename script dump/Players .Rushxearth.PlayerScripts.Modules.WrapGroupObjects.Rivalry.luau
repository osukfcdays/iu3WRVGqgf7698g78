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
    t_1._moving_textures = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 22
    local v2 = workspace:GetServerTimeNow() / 7

    for key, val in pairs(arg1._moving_textures) do
        local v3 = arg1:_GetCameraOffset() / val
        key.OffsetStudsU = v3.Z + v2 % key.StudsPerTileU
        key.OffsetStudsV = v3.Y + v2 % key.StudsPerTileV
    end
end

function t._GetCameraOffset(arg3) -- line: 37
    return arg3.Object.Position - (workspace.CurrentCamera.CFrame * workspace.CurrentCamera.Focus).Position
end

function t._Setup(arg4) -- line: 41
    for _, val_1 in pairs(arg4.ExtraObjects) do
        if val_1:IsA("Texture") then
            local MovingTextures = arg4._moving_textures
            local v4 = if val_1.Name ~= "RibbonTexture2" then 1300 else 800
            MovingTextures[val_1] = v4
        end
    end
end

function t._Init(arg5) -- line: 51
    arg5:_Setup()
end

return t
