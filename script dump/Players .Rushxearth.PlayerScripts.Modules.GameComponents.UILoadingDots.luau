local CollectionService = game:GetService("CollectionService")
local t = {}
t.__index = t

function t._new() -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t.Update(_, _) -- line: 20
    -- upvalues:
    --  [1] CollectionService (copy)

    for _, val in pairs(CollectionService:GetTagged("UILoadingDots")) do
        for index = 1, 3 do
            local absoluteValue = math.abs(
                (math.sin(
                    (tick() * -4 + index / 3 * 3.141592653589793 * 2 * 0.15) % 6.283185307179586
                ))
            )
            local v2 = math.max(0.5, absoluteValue) * 0.3333333333333333
            val[index].Size = UDim2.new(v2, 0, v2, 0)
        end
    end
end

function t._Init(_) -- line: 36
end

return t._new()
