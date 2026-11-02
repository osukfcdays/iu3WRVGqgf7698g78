local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local LobbyController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.LobbyController)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = {
    "starter_bundle",
    "medkit_bundle",
    "exogun_bundle",
    "heavyduty_bundle",
    "classic_bundle",
    "standardweapons_bundle",
    "energy_bundle",
    "rpg_bundle"
}
local PhysicalBundles = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("PhysicalBundles")
local t_1 = setmetatable({}, LobbyElement_m)
t_1.__index = t_1

function t_1._new(...) -- line: 17
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(LobbyElement_m.new(...), t_1)
    t_2._bundles_pool = {}
    t_2._current_index = 1
    t_2._bundle_display_model = nil
    t_2._bundle_display_pivot = nil
    t_2:_Init()

    return t_2
end

function t_1.SetIndex(arg1, arg2) -- line: 34
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] PhysicalBundles (copy)

    arg1._current_index = if #arg1._bundles_pool == 0 then 1 else (arg2 - 1) % #arg1._bundles_pool + 1
    local v2 = arg1._bundle_display_pivot

    if not v2 then
        v2 = CollectionService:GetTagged("LobbyBundleDisplay")[1] and CollectionService:GetTagged(
            "LobbyBundleDisplay"
        )[1].CFrame or nil
    end

    arg1._bundle_display_pivot = v2

    if arg1._bundle_display_model then
        arg1._bundle_display_model:Destroy()
        arg1._bundle_display_model = nil
    end

    local v3 = arg1._bundles_pool[arg1._current_index] or "keybundle_3"
    arg1._bundle_display_model = PhysicalBundles:WaitForChild(v3):Clone()
    arg1._bundle_display_model.PrimaryPart = arg1._bundle_display_model.Prompt
    local Prompt = arg1._bundle_display_model.Prompt
    Prompt.CFrame += Vector3.new(0, 2, 0)

    for _, descendant in pairs(arg1._bundle_display_model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
        end
    end

    arg1._bundle_display_model.Parent = workspace

    for _, descendant_1 in pairs(arg1._bundle_display_model:GetDescendants()) do
        if descendant_1:IsA("BasePart") then
            descendant_1.CanCollide = false
            descendant_1.CanTouch = false
            descendant_1.CanQuery = false
            descendant_1.Anchored = true
        end
    end

    local ProximityPrompt = Instance.new("ProximityPrompt")
    ProximityPrompt.ActionText = "View"
    ProximityPrompt.ClickablePrompt = true
    ProximityPrompt.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
    ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.MaxActivationDistance = 16
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.Q
    ProximityPrompt.ObjectText = "Special Offer"
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
    ProximityPrompt:AddTag("LobbyOpenPagePrompt")
    ProximityPrompt:SetAttribute("PageName", "Shop")
    ProximityPrompt:SetAttribute("ShopViewBundleName", v3)
    ProximityPrompt.Parent = arg1._bundle_display_model.Prompt
end

function t_1.Update(arg3, _) -- line: 89
    if not arg3._bundle_display_model then
        return
    end

    local v6 = math.sin(tick() * 0.25) ^ 30 * 1
    local v7 = tick() * 0.1 % 6.283185307179586
    local v10 = CFrame.new(0, v6, 0) * CFrame.Angles(0, v7, 0)
    local v9 = arg3._bundle_display_pivot
    local BundleDisplayModel = arg3._bundle_display_model

    if not v9 then
        v9 = CFrame.identity
    end

    BundleDisplayModel:PivotTo(v9 * v10)
end

function t_1._UpdatePool(arg5) -- line: 105
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] MonetizationLibrary_m (copy)

    for key_2, _ in pairs(PlayerDataController_m:Get("GamepassBundlesClaimed")) do
        local v13 = MonetizationLibrary_m.Gamepasses[key_2]

        if v13 and v13.BundleName then
            local index = table.find(arg5._bundles_pool, v13.BundleName)

            if index then
                table.remove(arg5._bundles_pool, index)
            end
        end
    end

    arg5:SetIndex(1)
end

function t_1._Setup(arg6) -- line: 123
    -- upvalues:
    --  [1] t (copy)

    for _, val_1 in pairs(t) do
        table.insert(arg6._bundles_pool, math.random(1, #arg6._bundles_pool + 1), val_1)
    end
end

function t_1._Init(arg7) -- line: 129
    -- upvalues:
    --  [1] LobbyController_m (copy)
    --  [2] PlayerDataController_m (copy)

    LobbyController_m.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 130
        -- upvalues:
        --  [1] LobbyController_m (ref)
        --  [2] arg7 (copy)

        if not LobbyController_m.LocalFighter:Get("IsInDuel") then
            arg7:SetIndex(arg7._current_index + 1)
        end
    end)
    PlayerDataController_m:GetDataChangedSignal("GamepassBundlesClaimed"):Connect(function() -- line: 136
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdatePool()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 140
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdatePool()
    end)
    arg7:_Setup()
    arg7:_UpdatePool()
    arg7:SetIndex(1)
end

return t_1._new()
