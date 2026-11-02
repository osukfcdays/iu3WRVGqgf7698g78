local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local VideoAdRewards_m = require(Players.LocalPlayer.PlayerScripts.Modules.VideoAdRewards)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local StarterBundleGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "StarterBundleGui"
)
local _ = Color3.fromRGB(114, 140, 255)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 23
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1._boards = {}
    t_1:_Init()

    return t_1
end

function t._BoardAdded(arg1, arg2) -- line: 43
    -- upvalues:
    --  [1] StarterBundleGui (copy)
    --  [2] VideoAdRewards_m (copy)
    --  [3] MonetizationLibrary_m (copy)
    --  [4] CosmeticLibrary_m (copy)
    --  [5] ComplianceController_m (copy)
    --  [6] RewardSlot_m (copy)
    --  [7] Pages_m (copy)
    --  [8] PlayerDataController_m (copy)
    --  [9] MonetizationController_m (copy)
    --  [10] ButtonEffect_m (copy)
    --  [11] Players (copy)

    local t_2 = {
        Gui = StarterBundleGui:Clone(),
        VideoAdRewards = VideoAdRewards_m.new(),
        Connections = {}
    }
    local StarterBundle = t_2.Gui.StarterBundle
    local StarterBundle_1 = MonetizationLibrary_m.Bundles.starter_bundle

    for key, val in pairs(StarterBundle_1.Rewards) do
        local v2 = CosmeticLibrary_m.Rewards[val.Name]

        if not v2 or v2.Type ~= "Lootbox" or not ComplianceController_m:ArePaidRandomItemsRestricted() then
            local v3 = RewardSlot_m.new(val)
            v3.Frame.LayoutOrder = key
            v3:SetParent(StarterBundle.MainFrame.Rewards)
            v3:OnClick(function() -- line: 65
                -- upvalues:
                --  [1] Pages_m (ref)

                if Pages_m.PageSystem.CurrentPage then
                    return
                end

                Pages_m.PageSystem:OpenPage("Shop")
                Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Bundles")
                Pages_m.PageSystem:WaitForPage("Shop"):InspectBundle("starter_bundle")
            end)
        end
    end

    local function update() -- line: 76
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] StarterBundle_1 (copy)
        --  [3] StarterBundle (copy)

        local v5 = PlayerDataController_m:Get("GamepassBundlesClaimed")[StarterBundle_1.GamepassName]
        StarterBundle.MainFrame.Button.Visible = not v5
        StarterBundle.MainFrame.Owned.Visible = v5
    end

    table.insert(
        t_2.Connections,
        PlayerDataController_m:GetDataChangedSignal("GamepassBundlesClaimed"):Connect(update)
    )
    local v7 = PlayerDataController_m:Get("GamepassBundlesClaimed")[StarterBundle_1.GamepassName]
    StarterBundle.MainFrame.Button.Visible = not v7
    StarterBundle.MainFrame.Owned.Visible = v7
    StarterBundle.MainFrame.Button.MouseButton1Click:Connect(function() -- line: 86
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] MonetizationController_m (ref)
        --  [3] MonetizationLibrary_m (ref)
        --  [4] StarterBundle_1 (copy)

        if Pages_m.PageSystem.CurrentPage then
            return
        end

        MonetizationController_m:PromptGamePassPurchase(
            MonetizationLibrary_m.Gamepasses[StarterBundle_1.GamepassName].GamepassID
        )
    end)
    MonetizationController_m:SetRobuxText(
        StarterBundle.MainFrame.Button.Title,
        MonetizationLibrary_m.Gamepasses[StarterBundle_1.GamepassName].GamepassID,
        Enum.InfoType.GamePass
    )
    ButtonEffect_m:Add(StarterBundle.MainFrame.Button)
    local VideoAdRewards = t_2.Gui.VideoAdRewards
    StarterBundle.Visible = true
    VideoAdRewards.Visible = false
    t_2.Gui.Adornee = arg2
    t_2.Gui.Parent = Players.LocalPlayer.PlayerGui
    arg1._boards[arg2] = t_2
end

function t._BoardRemoved(arg3, arg4) -- line: 130
    local v8 = arg3._boards[arg4]

    if not v8 then
        return
    end

    for _, val_1 in pairs(v8.Connections) do
        val_1:Disconnect()
    end

    v8.Gui:Destroy()
    v8.VideoAdRewards:Destroy()
    arg3._boards[arg4] = nil
end

function t._Init(arg5) -- line: 146
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyStarterBundleBoard"):Connect(function(arg6) -- line: 147
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_BoardAdded(arg6)
    end)
    CollectionService:GetInstanceRemovedSignal("LobbyStarterBundleBoard"):Connect(function(arg7) -- line: 151
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_BoardRemoved(arg7)
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("LobbyStarterBundleBoard")) do
        task.defer(arg5._BoardAdded, arg5, val_2)
    end
end

return t._new()
