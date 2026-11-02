local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local LobbyVisuals = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LobbyVisuals")
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 22
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._BoardAdded(_, arg2) -- line: 40
    -- upvalues:
    --  [1] LobbyVisuals (copy)
    --  [2] EventLibrary_m (copy)
    --  [3] Utility_m (copy)
    --  [4] RewardSlot_m (copy)
    --  [5] MonetizationLibrary_m (copy)
    --  [6] CosmeticLibrary_m (copy)
    --  [7] ComplianceController_m (copy)
    --  [8] Pages_m (copy)
    --  [9] PlayerDataController_m (copy)
    --  [10] MonetizationController_m (copy)
    --  [11] ButtonEffect_m (copy)
    --  [12] Players (copy)

    local v2 = (LobbyVisuals:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) and LobbyVisuals[EventLibrary_m.LOBBY_VISUALS_PROFILE]:FindFirstChild(
        "LikeBoardGui"
    ) or LobbyVisuals.Default.LikeBoardGui):Clone()
    local v3 = nil

    local function update() -- line: 47
        -- upvalues:
        --  [1] v3 (ref)
        --  [2] arg2 (copy)
        --  [3] v2 (copy)
        --  [4] Utility_m (ref)
        --  [5] RewardSlot_m (ref)

        if v3 then
            v3:Destroy()
            v3 = nil
        end

        local Loaded = arg2:GetAttribute("Loaded")
        local v4 = arg2:GetAttribute("CurrentLikes") or 0
        local v5 = arg2:GetAttribute("GoalLikes") or 0
        local v6 = arg2:GetAttribute("LastGoalLikes") or 0
        local v7 = arg2:GetAttribute("CurrentMilestone") or 0
        local v8 = (v4 - v6) / (v5 - v6)
        local v9 = arg2:GetAttribute("Code") or ""
        v2.MainFrame.Progress.Current.Text = Utility_m:PrettyNumber(v4)
        v2.MainFrame.Progress.Goal.Text = Utility_m:PrettyNumber(v5)
        v2.MainFrame.Progress.Bar.Bar.Size = UDim2.new(math.clamp(v8, 0, 1), 0, 1, 0)
        v2.MainFrame.Progress.Percent.Text = math.floor(v8 * 100) .. "%"
        v2.MainFrame.Code.Text = string.upper(v9)
        local v10 = arg2:GetAttribute("KeyQuantity") or 0
        v2.MainFrame.Description.Visible = v7 > 0 and true
        v2.MainFrame.Visible = Loaded
        v2.StarterBundle.Visible = not Loaded
        v2.Waiting.Visible = false

        if v7 > 0 then
            v3 = RewardSlot_m.new({ Name = "Key", Quantity = v10 })
            v3:SetParent(v2.MainFrame.Reward)
        end
    end

    arg2:GetAttributeChangedSignal("CurrentLikes"):Connect(update)
    arg2:GetAttributeChangedSignal("GoalLikes"):Connect(update)
    arg2:GetAttributeChangedSignal("LastGoalLikes"):Connect(update)
    arg2:GetAttributeChangedSignal("CurrentMilestone"):Connect(update)
    arg2:GetAttributeChangedSignal("KeyQuantity"):Connect(update)
    arg2:GetAttributeChangedSignal("Code"):Connect(update)
    update()
    local StarterBundle = v2.StarterBundle
    local StarterBundle_1 = MonetizationLibrary_m.Bundles.starter_bundle

    for key, val in pairs(StarterBundle_1.Rewards) do
        local v12 = CosmeticLibrary_m.Rewards[val.Name]

        if
            not v12
            or v12.Type ~= "Lootbox"
            or not ComplianceController_m:ArePaidRandomItemsRestricted()
        then
            local v13 = RewardSlot_m.new(val)
            v13.Frame.LayoutOrder = key
            v13:SetParent(StarterBundle.MainFrame.Rewards)
            v13:OnClick(function() -- line: 109
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

    local function update_1() --[[ update ]] -- line: 120
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] StarterBundle_1 (copy)
        --  [3] StarterBundle (copy)

        local v15 = PlayerDataController_m:Get("GamepassBundlesClaimed")[StarterBundle_1.GamepassName]
        StarterBundle.MainFrame.Button.Visible = not v15
        StarterBundle.MainFrame.Owned.Visible = v15
    end

    PlayerDataController_m:GetDataChangedSignal("GamepassBundlesClaimed"):Connect(update_1)
    local v17 = PlayerDataController_m:Get("GamepassBundlesClaimed")[StarterBundle_1.GamepassName]
    StarterBundle.MainFrame.Button.Visible = not v17
    StarterBundle.MainFrame.Owned.Visible = v17
    StarterBundle.MainFrame.Button.MouseButton1Click:Connect(function() -- line: 130
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
    v2.Adornee = arg2
    local PlayerGui = Players.LocalPlayer.PlayerGui
    v2.Parent = PlayerGui
end

function t._Init(arg3) -- line: 146
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyLikeBoard"):Connect(function(arg4) -- line: 147
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_BoardAdded(arg4)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyLikeBoard")) do
        task.defer(arg3._BoardAdded, arg3, val_1)
    end
end

return t._new()
