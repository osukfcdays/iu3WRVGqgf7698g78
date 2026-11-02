local CollectionService = game:GetService("CollectionService")
local PortalModel_m = require(script:WaitForChild("PortalModel"))
local t = {}
t.__index = t

function t._new() -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._portal_models = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 22
    for _, val in pairs(arg1._portal_models) do
        val:Update(arg2)
    end
end

function t._ObjectRemoved(arg3, arg4) -- line: 32
    if arg3._portal_models[arg4] then
        arg3._portal_models[arg4]:Destroy()
        arg3._portal_models[arg4] = nil
    end
end

function t._ObjectAdded(arg5, arg6) -- line: 39
    -- upvalues:
    --  [1] PortalModel_m (copy)

    arg5:_ObjectRemoved(arg6)
    arg5._portal_models[arg6] = PortalModel_m.new(arg6)
end

function t._Init(arg7) -- line: 46
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceRemovedSignal("PortalModel"):Connect(function(arg8) -- line: 47
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectRemoved(arg8)
    end)
    CollectionService:GetInstanceAddedSignal("PortalModel"):Connect(function(arg9) -- line: 51
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectAdded(arg9)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("PortalModel")) do
        task.spawn(arg7._ObjectAdded, arg7, val_1)
    end
end

return t._new()
