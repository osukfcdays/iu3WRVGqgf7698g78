local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
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

function t._ModelAdded(_, arg2) -- line: 27
    -- upvalues:
    --  [1] Players (copy)

    local From = arg2:WaitForChild("From")
    local To = arg2:WaitForChild("To")
    local v2 = 0
    From.Touched:Connect(function(otherPart: BasePart) -- line: 32
        -- upvalues:
        --  [1] v2 (ref)
        --  [2] Players (ref)
        --  [3] To (copy)

        if
            tick() > v2
            and otherPart
            and otherPart.AssemblyRootPart
            and otherPart.AssemblyRootPart.Parent
            and Players:GetPlayerFromCharacter(otherPart.AssemblyRootPart.Parent) == Players.LocalPlayer
        then
            v2 = tick() + 1
            otherPart.AssemblyRootPart.Parent.HumanoidRootPart.CFrame = CFrame.new(To.Position) * otherPart.AssemblyRootPart.Parent.HumanoidRootPart.CFrame.Rotation
        end
    end)
end

function t._Init(arg4) -- line: 40
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyTeleporter"):Connect(function(arg5) -- line: 41
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_ModelAdded(arg5)
    end)

    for _, val in pairs(CollectionService:GetTagged("LobbyTeleporter")) do
        task.defer(arg4._ModelAdded, arg4, val)
    end
end

return t._new()
