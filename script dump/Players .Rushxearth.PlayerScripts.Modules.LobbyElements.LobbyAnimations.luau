local CollectionService = game:GetService("CollectionService")
local LobbyElement_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.LobbyElement
)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 9
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._ObjectAdded(_, arg2) -- line: 27
    while true do
        local Animation = Instance.new("Animation")
        Animation.AnimationId = arg2:GetAttribute("IdleAnimation")
        local Success, Result = pcall(arg2.LoadAnimation, arg2, Animation)

        if Success and pcall(Result.Play, Result) then
            break
        end

        wait(1)
    end
end

function t._Init(arg3) -- line: 46
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyAnimation"):Connect(function(arg4) -- line: 47
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_ObjectAdded(arg4)
    end)

    for _, val in pairs(CollectionService:GetTagged("LobbyAnimation")) do
        task.defer(arg3._ObjectAdded, arg3, val)
    end
end

return t._new()
