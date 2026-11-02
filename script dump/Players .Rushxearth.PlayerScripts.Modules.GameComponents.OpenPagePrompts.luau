local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local t = {}
t.__index = t

function t._new() -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._connections = {}
    t_1:_Init()

    return t_1
end

function t._ObjectRemoved(arg1, arg2) -- line: 30
    if arg1._connections[arg2] then
        arg1._connections[arg2]:Disconnect()
        arg1._connections[arg2] = nil
    end
end

function t._ObjectAdded(arg3, arg4) -- line: 37
    -- upvalues:
    --  [1] Pages_m (copy)

    arg3:_ObjectRemoved(arg4)
    arg3._connections[arg4] = arg4.Triggered:Connect(function() -- line: 40
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] arg4 (copy)

        wait(0.06)
        Pages_m.PageSystem:OpenPage(arg4:GetAttribute("PageName"), true)
        local ShopViewBundleName = arg4:GetAttribute("ShopViewBundleName")
        local ShopViewShopEntryName = arg4:GetAttribute("ShopViewShopEntryName")

        if ShopViewBundleName then
            local v3 = if #ShopViewBundleName >= 9 then if string.sub(ShopViewBundleName, 1, 9) ~= "keybundle" then if #ShopViewBundleName >= 19 then if string.sub(
                ShopViewBundleName,
                1,
                19
            ) ~= "eventcurrencybundle" then false else true else false else true else if #ShopViewBundleName >= 19 then if string.sub(
                ShopViewBundleName,
                1,
                19
            ) ~= "eventcurrencybundle" then false else true else false
            Pages_m.PageSystem:WaitForPage("Shop"):SetPage(if v3 then "Currency" else "Bundles")
            Pages_m.PageSystem:WaitForPage("Shop"):InspectBundle(ShopViewBundleName)
        elseif ShopViewShopEntryName then
            Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Home")
            Pages_m.PageSystem:WaitForPage("Shop"):InspectShopEntry(ShopViewShopEntryName)
        end

        local ShopViewPage = arg4:GetAttribute("ShopViewPage")

        if ShopViewPage then
            Pages_m.PageSystem:WaitForPage("Shop"):SetPage(ShopViewPage)
        end

        local DialogLobbyNPCName = arg4:GetAttribute("DialogLobbyNPCName")

        if DialogLobbyNPCName then
            Pages_m.PageSystem:WaitForPage("DialogLobby"):SetNPCName(DialogLobbyNPCName)
        end

        local MatchmakingScrollTo = arg4:GetAttribute("MatchmakingScrollTo")

        if MatchmakingScrollTo then
            Pages_m.PageSystem:WaitForPage("Matchmaking"):ScrollTo(MatchmakingScrollTo, 0.25)
        end

        local InspectUGC = arg4:GetAttribute("InspectUGC")

        if InspectUGC then
            Pages_m.PageSystem:WaitForPage("UGCShop"):Buy(InspectUGC)
        end

        local TasksScrollTo = arg4:GetAttribute("TasksScrollTo")

        if TasksScrollTo then
            Pages_m.PageSystem:WaitForPage("Tasks"):ScrollTo(TasksScrollTo, 0.25)
        end
    end)
end

function t._Init(arg5) -- line: 90
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyOpenPagePrompt"):Connect(function(arg6) -- line: 91
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectAdded(arg6)
    end)
    CollectionService:GetInstanceRemovedSignal("LobbyOpenPagePrompt"):Connect(function(arg7) -- line: 95
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectRemoved(arg7)
    end)

    for _, val in pairs(CollectionService:GetTagged("LobbyOpenPagePrompt")) do
        task.spawn(arg5._ObjectAdded, arg5, val)
    end
end

return t._new()
