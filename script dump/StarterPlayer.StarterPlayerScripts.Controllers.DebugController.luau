local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local PermissionsLibrary_m = require(ReplicatedStorage.Modules.PermissionsLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MechanicsController"))
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController"))
local DuelController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController")
)
local OutOfBoundsParts_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("GameComponents"):WaitForChild(
        "OutOfBoundsParts"
    )
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local TableViewer_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("TableViewer"))
local DebugState_m = require(script:WaitForChild("DebugState"))
local t = {}
t.__index = t

function t._new() -- line: 24
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1._are_hitboxes_visible = false
    t_1._are_map_barriers_visible = false
    t_1._are_map_barriers_visible_changed_internal = Signal_m.new()
    t_1:_Init()

    return t_1
end

function t.Command(arg1, arg2, arg3) -- line: 40
    if arg1[arg2] then
        arg1[arg2](arg1, arg3)

        return
    end

    arg1:_Command(arg2, arg3)
end

function t.SetHandicapsEnabled(_, arg5) -- line: 48
    -- upvalues:
    --  [1] DebugState_m (copy)

    DebugState_m:SetReplicate("AreHandicapsEnabled", arg5)
end

function t.DisableTransparentHats(_, arg7) -- line: 52
    -- upvalues:
    --  [1] DebugState_m (copy)

    DebugState_m:SetReplicate("DisableTransparentHats", arg7)
end

function t.SpectateNilDuel(_) -- line: 56
    -- upvalues:
    --  [1] SpectateController_m (copy)

    SpectateController_m:SpectateDuelRequest(nil)
end

function t.ShowClientEnvironment(_) -- line: 60
    -- upvalues:
    --  [1] TableViewer_m (copy)
    --  [2] Players (copy)

    TableViewer_m.new(require(Players.LocalPlayer.PlayerScripts.Client)).ScreenGui.Parent = Players.LocalPlayer.PlayerGui
end

function t.GetMatchmakingData(arg10) -- line: 65
    arg10:_JSONDump(arg10:_Command("GetMatchmakingData", true))
end

function t.SetMapBarriersVisible(arg11, arg12) -- line: 69
    arg11._are_map_barriers_visible = arg12
    arg11._are_map_barriers_visible_changed_internal:Fire()
    arg11:_SetupMapBarriersLogic()
end

function t.SetOOBVisible(_, arg14) -- line: 75
    -- upvalues:
    --  [1] OutOfBoundsParts_m (copy)

    OutOfBoundsParts_m:SetVisible(arg14)
end

function t.DisableDeviceAutoSwitch(_, arg16) -- line: 79
    -- upvalues:
    --  [1] ControlsController_m (copy)

    ControlsController_m:DisableVerification(arg16)
end

function t.SetHitboxesVisible(arg17, arg18) -- line: 83
    arg17._are_hitboxes_visible = arg18
    arg17:_UpdateAllClientFighterCharacterHitboxes()
end

function t.InternalViewRewardSlot(_) -- line: 88
    -- upvalues:
    --  [1] Pages_m (copy)

    Pages_m.PageSystem:OpenPage("Debug", true)
    Pages_m.PageSystem:WaitForPage("Debug").PromptSystem:Open("InternalViewRewardSlot")
end

function t.SendOfflineGiftRewards(_) -- line: 93
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Pages_m (copy)

    if not PermissionsLibrary_m:IsAdministrator(PlayerDataController_m:Get("PermissionsRoles")) then
        return
    end

    Pages_m.PageSystem:OpenPage("Debug", true)
    Pages_m.PageSystem:WaitForPage("Debug").PromptSystem:Open("SendOfflineGiftRewards")
end

function t.SendBugRewards(_) -- line: 103
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Pages_m (copy)

    if not PermissionsLibrary_m:HasPermission(
        "permission_testing_publiccommands_bugrewards",
        PlayerDataController_m:Get("PermissionsRoles")
    ) then
        return
    end

    Pages_m.PageSystem:OpenPage("Debug", true)
    Pages_m.PageSystem:WaitForPage("Debug").PromptSystem:Open("SendBugRewards")
end

function t._SetupMapBarriersLogic(arg22) -- line: 117
    -- upvalues:
    --  [1] DuelController_m (copy)

    if arg22._map_barrier_logic_setup then
        return
    end

    arg22._map_barrier_logic_setup = true
    DuelController_m.ObjectAdded:Connect(function(arg23) --[[ duel_added ]] -- line: 124
        -- upvalues:
        --  [1] arg22 (copy)

        local function update_map() -- line: 125
            -- upvalues:
            --  [1] arg23 (copy)
            --  [2] arg22 (ref)

            if not arg23.Map then
                return
            end

            for _, val in pairs(arg23.Map.Model.Barriers:GetDescendants()) do
                if val:IsA("BasePart") and not val:HasTag("OutOfBoundsPart") then
                    local v15 = if not arg22._are_map_barriers_visible then 1 else 0.5
                    val.Transparency = v15
                    val.Material = Enum.Material.SmoothPlastic
                    local v16 = val:HasTag("KillBrick") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(
                        127,
                        127,
                        127
                    )
                    val.Color = v16
                    val.CastShadow = false
                end
            end
        end

        arg22._are_map_barriers_visible_changed_internal:Connect(update_map)
        arg23.MapAdded:Connect(update_map)
        update_map()
    end)

    for _, val_1 in pairs(DuelController_m.Objects) do
        local function update_map_1() --[[ update_map ]] -- line: 125
            -- upvalues:
            --  [1] val_1 (copy)
            --  [2] arg22 (copy)

            if not val_1.Map then
                return
            end

            for _, val_2 in pairs(val_1.Map.Model.Barriers:GetDescendants()) do
                if val_2:IsA("BasePart") and not val_2:HasTag("OutOfBoundsPart") then
                    local v18 = if not arg22._are_map_barriers_visible then 1 else 0.5
                    val_2.Transparency = v18
                    val_2.Material = Enum.Material.SmoothPlastic
                    local v19 = val_2:HasTag("KillBrick") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(
                        127,
                        127,
                        127
                    )
                    val_2.Color = v19
                    val_2.CastShadow = false
                end
            end
        end

        arg22._are_map_barriers_visible_changed_internal:Connect(update_map_1)
        val_1.MapAdded:Connect(update_map_1)
        update_map_1()
    end
end

function t._JSONDump(_, ...) -- line: 152
    -- upvalues:
    --  [1] Players (copy)
    --  [2] BetterDebris_m (copy)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    BetterDebris_m:AddItem(ScreenGui, 60)
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Parent = ScreenGui
    local t_2 = { ... }

    for key_3, val_3 in pairs(t_2) do
        for index = 1, math.ceil(#val_3 / 199999) do
            local v20 = (index - 1) * 199999
            local substring = string.sub(val_3, v20 + 1, v20 + 199999)
            local TextBox = Instance.new("TextBox")
            TextBox.BackgroundColor3 = Color3.fromHSV(key_3 / #t_2, 0.75, 1)
            TextBox.Size = UDim2.new(0, 200, 0, 200)
            TextBox.ClearTextOnFocus = false
            TextBox.TextEditable = false
            TextBox.Text = substring
            TextBox.TextWrapped = true
            TextBox.Parent = ScreenGui
        end
    end
end

function t._Encode(_, arg26) -- line: 184
    -- upvalues:
    --  [1] HttpService (copy)

    local t_3 = {}

    local function clone(arg27) -- line: 187
        -- upvalues:
        --  [1] t_3 (copy)
        --  [2] clone (copy)

        local t_4 = {}

        for key_4, val_4 in pairs(arg27) do
            if t_3[val_4] then
                t_4[key_4] = "*** cyclic table detected ***"
            elseif typeof(val_4) == "table" then
                t_3[val_4] = true
                t_4[key_4] = clone(val_4)
            else
                t_4[key_4] = val_4
            end
        end

        return t_4
    end

    return HttpService:JSONEncode((clone(arg26)))
end

function t._Command(_, ...) -- line: 207
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return ReplicatedStorage.Remotes.Debug.Command:InvokeServer(...)
end

function t._UpdateClientFighterCharacterHitboxes(arg29, arg30) -- line: 211
    arg30:SetHitboxesVisible(arg29._are_hitboxes_visible)
end

function t._UpdateAllClientFighterCharacterHitboxes(arg31) -- line: 215
    -- upvalues:
    --  [1] FighterController_m (copy)

    for _, val_5 in pairs(FighterController_m.Objects) do
        if val_5.Entity then
            arg31:_UpdateClientFighterCharacterHitboxes(val_5.Entity)
        end
    end
end

function t._SetupHitboxesVisualizer(arg32) -- line: 223
    -- upvalues:
    --  [1] FighterController_m (copy)

    local function client_fighter_added(arg33) -- line: 224
        -- upvalues:
        --  [1] arg32 (copy)

        arg33.EntityAdded:Connect(function(arg34) -- line: 225
            -- upvalues:
            --  [1] arg32 (ref)

            arg32:_UpdateClientFighterCharacterHitboxes(arg34)
        end)

        if arg33.Entity then
            arg32:_UpdateClientFighterCharacterHitboxes(arg33.Entity)
        end
    end

    FighterController_m.ObjectAdded:Connect(client_fighter_added)

    for _, val_6 in pairs(FighterController_m.Objects) do
        task.defer(client_fighter_added, val_6)
    end
end

function t._Init(arg35) -- line: 241
    task.defer(arg35._SetupHitboxesVisualizer, arg35)
end

return t._new()
