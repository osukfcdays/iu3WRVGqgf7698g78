local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 12
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._PartAdded(_, arg2) -- line: 30
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] Players (copy)
    --  [3] Utility_m (copy)

    local PageName = arg2:GetAttribute("PageName")
    local v2 = false
    arg2.Touched:Connect(function(otherPart: BasePart) -- line: 34
        -- upvalues:
        --  [1] v2 (ref)
        --  [2] Pages_m (ref)
        --  [3] Players (ref)
        --  [4] PageName (copy)
        --  [5] Utility_m (ref)
        --  [6] arg2 (copy)

        if
            v2
            or Pages_m.PageSystem.CurrentPage
            or not otherPart.AssemblyRootPart
            or not otherPart.AssemblyRootPart.Parent
            or Players:GetPlayerFromCharacter(otherPart.AssemblyRootPart.Parent) ~= Players.LocalPlayer
        then
            return
        end

        v2 = true
        Pages_m.PageSystem:OpenPage(PageName, true)

        while true do
            if not otherPart:IsDescendantOf(workspace) then
                break
            end

            if not Utility_m:IsWithinPart(
                arg2,
                otherPart.Position,
                Vector3.new(1, 1, 1) * math.max(
                    otherPart.Size.X,
                    otherPart.Size.Y,
                    otherPart.Size.Z
                ) * 5
            ) then
                break
            end

            wait(0.1)
        end

        v2 = false

        if Pages_m.PageSystem.CurrentPage and Pages_m.PageSystem.CurrentPage.Name == PageName then
            Pages_m.PageSystem:CloseCurrentPage()
        end
    end)
end

function t._Init(arg4) -- line: 54
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("ProximityPageOpener"):Connect(function(arg5) -- line: 55
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_PartAdded(arg5)
    end)

    for _, val in pairs(CollectionService:GetTagged("ProximityPageOpener")) do
        task.defer(arg4._PartAdded, arg4, val)
    end
end

return t._new()
