local t = {}
t.__index = t

function t.new(arg1) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.Vignette = t_1.FighterInterface.Frame:WaitForChild("FrozenVignette")
    t_1.VignetteTexture = t_1.Vignette:WaitForChild("Texture")
    t_1:_Init()

    return t_1
end

function t.Refresh(arg2) -- line: 20
    local v1 = arg2.FighterInterface.ClientFighter

    if v1 then
        v1 = arg2.FighterInterface.ClientFighter.Entity

        if v1 then
            v1 = arg2.FighterInterface.ClientFighter:IsAlive()

            if v1 then
                v1 = arg2.FighterInterface.ClientFighter.Entity:Get("IsFrozen")
            end
        end
    end

    local v2 = typeof(v1) == "table" and v1 or {}
    arg2.Vignette.ImageColor3 = v2.IsDisableOnly and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(
        35,
        149,
        255
    )
    arg2.Vignette.ImageTransparency = if not v1 then 1 else 0
    arg2.VignetteTexture.ImageTransparency = arg2.Vignette.ImageTransparency
end

function t.Destroy(_) -- line: 30
end

function t._Init(_) -- line: 38
end

return t
