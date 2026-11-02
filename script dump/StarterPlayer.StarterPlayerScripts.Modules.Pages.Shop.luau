local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local _ = require(ReplicatedStorage.Modules.EventLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local ShopController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShopController")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Spotlight_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Spotlight")
)
local ShopSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseShopSlot"):WaitForChild("ShopSlot")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local BundleSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BundleSlot"))
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local BottomTabs_m = require(script:WaitForChild("BottomTabs"))
local Pages_m = require(script:WaitForChild("Pages"))
local Tabs_m = require(script:WaitForChild("Tabs"))
local t = {
    "rpg_bundle",
    "energy_bundle",
    "starter_bundle",
    "medkit_bundle",
    "exogun_bundle",
    "heavyduty_bundle",
    "classic_bundle",
    "standardweapons_bundle"
}
local t_1 = {
    "Home",
    "Bundles",
    "Skins",
    "Daily",
    "Currency",
    "Ranked",
    "Rewards",
    "Gifting",
    "Weapons"
}
local t_2 = setmetatable({}, Page_m)
t_2.__index = t_2

function t_2._new() -- line: 31
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_2 (copy)
    --  [3] Signal_m (copy)
    --  [4] t (copy)
    --  [5] t_1 (copy)
    --  [6] PromptSystem_m (copy)
    --  [7] Tabs_m (copy)
    --  [8] Pages_m (copy)
    --  [9] BottomTabs_m (copy)

    local t_3 = setmetatable(Page_m.new(script.Name), t_2)
    t_3.CurrentPageChanged = Signal_m.new()
    t_3.PageContainer = t_3.PageFrame:WaitForChild("Container")
    t_3.PromptsFrame = t_3.PageContainer:WaitForChild("Prompts")
    t_3.WaitingFrame = t_3.PageContainer:WaitForChild("Waiting")
    t_3.DotsFrame = t_3.WaitingFrame:WaitForChild("Dots")
    t_3.List = t_3.PageContainer:WaitForChild("List")
    t_3.Container = t_3.List:WaitForChild("Container")
    t_3.BUNDLE_NAMES = t
    t_3.PAGE_NAMES = t_1
    t_3.HidePartyDisplay = true
    t_3.CurrentPage = nil
    t_3.PromptSystem = PromptSystem_m.new(t_3.PromptsFrame)
    t_3.Tabs = Tabs_m.new(t_3)
    t_3.Pages = Pages_m.new(t_3)
    t_3.BottomTabs = BottomTabs_m.new(t_3)
    t_3._open_animation_disabled = true
    t_3._setup_finished = false
    t_3._setup_finished_event_internal = Signal_m.new()
    t_3._bundle_slots = {}
    t_3:_Init()

    return t_3
end

function t_2.SetPage(arg1, arg2) -- line: 67
    -- upvalues:
    --  [1] Spotlight_m (copy)
    --  [2] Equipment_m (copy)

    Spotlight_m:ChangeSubject(nil)

    if arg2 == "Weapons" then
        Equipment_m:Open(true)
        arg1:CloseRequest()

        return
    end

    if arg2 == "Gifting" then
        arg1.OpenPage:Fire("Gifting")

        return
    end

    if arg2 == "Rewards" then
        arg1.OpenPage:Fire("Rewards")

        return
    end

    if arg2 == "BattlePass" then
        arg1.OpenPage:Fire("BattlePass")

        return
    end

    arg1.CurrentPage = arg2
    arg1.CurrentPageChanged:Fire(arg1.CurrentPage)
end

function t_2.InspectSkinBundle(arg3, arg4) -- line: 89
    arg3:SetPage("Skins")
    task.delay(0.5, function() -- line: 92
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] arg4 (copy)

        arg3.Pages.Components.Skins:Inspect(arg4)
    end)
end

function t_2.InspectShopEntry(arg5, arg6) -- line: 97
    if arg6 then
        arg5.PromptSystem:Open("InspectShopEntry", arg6)
    end
end

function t_2.InspectBundle(arg7, arg8, _) -- line: 103
    if not arg8 then
        return
    end

    task.defer(function() -- line: 108
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] arg8 (copy)

        if not arg7._setup_finished then
            arg7._setup_finished_event_internal:Wait()
        end

        arg7.PromptSystem:Open("InspectBundle", arg8)
    end)
end

function t_2.CreateShopSlot(
    arg10,
    arg11,
    arg12,
    arg13,
    ...
) -- line: 117
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ShopController_m (copy)
    --  [3] ShopSlot_m (copy)
    --  [4] CosmeticLibrary_m (copy)
    --  [5] ComplianceController_m (copy)

    local v17 = Utility_m:CloneTable(ShopController_m:GetShopEntry(arg13))
    local v18 = arg11 or ShopSlot_m

    if arg12 then
        arg12.BackgroundTransparency = 1
    end

    for _, val in pairs(v17.Rewards) do
        local v19 = CosmeticLibrary_m.Rewards[val.Name]

        if v19 and v19.Type == "Lootbox" and ComplianceController_m:ArePaidRandomItemsRestricted() then
        end
    end

    local v20 = v18.new(v17, ...)
    v20.Frame.Parent = arg12
    v20:OnClick(function() -- line: 136
        -- upvalues:
        --  [1] v20 (copy)
        --  [2] arg10 (copy)

        if v20.IsLocked or v20.IsOwned then
            return
        end

        arg10:InspectShopEntry(v20.ShopEntry.EntryName)
    end)

    return v20
end

function t_2.CreateBundleSlot(arg14, arg15) -- line: 147
    -- upvalues:
    --  [1] BundleSlot_m (copy)
    --  [2] ControlsController_m (copy)

    local v21 = BundleSlot_m.new(arg15)
    arg14._bundle_slots[arg15] = v21
    v21.Tapped:Connect(function() -- line: 151
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] arg14 (copy)
        --  [3] v21 (copy)

        if ControlsController_m.CurrentControls == "Touch" then
            arg14:InspectBundle(v21.Name)

            return
        end

        v21:PurchaseRequest()
    end)

    return v21
end

function t_2.Open(arg16, ...) -- line: 163
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] Utility_m (copy)

    Page_m.Open(arg16, ...)
    arg16.Tabs:Open()
    arg16.Pages:Open()
    arg16.BottomTabs:Open()
    Utility_m:CreateSound(
        "rbxassetid://18100002432",
        1.25,
        1,
        script,
        true,
        5
    )
end

function t_2.Close(arg17, ...) -- line: 171
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Close(arg17, ...)
    arg17.Tabs:Close()
    arg17.Pages:Close()
    arg17.BottomTabs:Close()
end

function t_2._CheckScrollDownToLoginRewards(arg18) -- line: 182
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] TweenService (copy)

    if arg18.CurrentPage ~= "Daily" or PlayerDataController_m:Get("ClaimedLoginRewardToday") then
        return
    end

    local Frame = arg18.Pages.Components.Daily.LoginRewards.Frame
    task.delay(0.15, function() -- line: 189
        -- upvalues:
        --  [1] TweenService (ref)
        --  [2] arg18 (copy)
        --  [3] Frame (copy)

        TweenService:Create(
            arg18.List,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {
                CanvasPosition = Vector2.new(
                    0,
                    Frame.AbsolutePosition.Y - arg18.Container.AbsolutePosition.Y
                )
            }
        ):Play()
    end)
end

function t_2._UpdatePromptContext(arg19) -- line: 194
    arg19.List.Visible = not arg19.PromptSystem.CurrentPrompt
end

function t_2._UpdateScale(arg20) -- line: 198
    local v23 = if arg20.CurrentPage ~= "Home" then 1 else 0.9
    arg20.List.Size = UDim2.new(1 / v23, 18, 1, 0)
    arg20.Container.Size = UDim2.new(v23 * 1, -8, v23 * 1, -8)
end

function t_2._UpdateCanvasSize(arg21) -- line: 205
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local v24 = arg21.Pages:GetComponentFrame(arg21.CurrentPage)
    arg21.List.Size = UDim2.new(
        1,
        18,
        0,
        (math.min(
            arg21.PageFrame.AbsoluteSize.Y,
            UILibrary_m.MainGui.AbsolutePosition.Y + UILibrary_m.MainGui.AbsoluteSize.Y - arg21.List.AbsolutePosition.Y - 20
        ))
    )
    local List_3 = arg21.List
    List_3.CanvasSize = v24 and UDim2.new(
        0,
        0,
        0,
        v24.AbsolutePosition.Y + v24.AbsoluteSize.Y - arg21.Container.AbsolutePosition.Y
    ) or UDim2.new(0, 0, 0, 0)
end

function t_2._UpdateSize(arg22) -- line: 212
    -- upvalues:
    --  [1] GuiService (copy)

    arg22.PageContainer.Size = UDim2.new(1, 0, 1, -GuiService.TopbarInset.Height)
end

function t_2._Setup(arg23) -- line: 216
    arg23.DotsFrame:AddTag("UILoadingDots")
    arg23.WaitingFrame.Visible = true
    arg23.Tabs.Frame.Visible = false
    arg23.Pages.Frame.Visible = false
    arg23.BottomTabs.Frame.Visible = false
    task.delay(0.25, function() -- line: 224
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.DotsFrame:RemoveTag("UILoadingDots")
        arg23.WaitingFrame.Visible = false
        arg23.Tabs.Frame.Visible = true
        arg23.Pages.Frame.Visible = true
        arg23.BottomTabs.Frame.Visible = true
        arg23.Tabs:Setup()
        arg23.Pages:Setup()
        arg23.BottomTabs:Setup()
        arg23:SetPage(arg23.CurrentPage or "Home")
        arg23._setup_finished = true
        arg23._setup_finished_event_internal:Fire()
    end)
end

function t_2._Init(arg24) -- line: 243
    -- upvalues:
    --  [1] Spotlight_m (copy)
    --  [2] UILibrary_m (copy)
    --  [3] GuiService (copy)

    arg24.PromptSystem.PromptAdded:Connect(function(arg25) -- line: 244
        -- upvalues:
        --  [1] arg24 (copy)

        arg24.List.CanvasPosition = Vector2.new(0, 0)
        arg24:_UpdatePromptContext()

        if arg25.InspectCurrencyPage then
            arg25.InspectCurrencyPage:Connect(function() -- line: 249
                -- upvalues:
                --  [1] arg24 (ref)

                arg24:SetPage("Currency")
            end)
        end
    end)
    arg24.PromptSystem.PromptRemoved:Connect(function() -- line: 255
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdatePromptContext()
    end)
    arg24.OpenChanged:Connect(function() -- line: 259
        -- upvalues:
        --  [1] Spotlight_m (ref)

        Spotlight_m:ChangeSubject(nil)
    end)
    arg24.CurrentPageChanged:Connect(function() -- line: 263
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_CheckScrollDownToLoginRewards()
        arg24:_UpdateCanvasSize()
        arg24:_UpdateScale()
    end)
    arg24.List:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 269
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateCanvasSize()
    end)
    arg24.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 273
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateCanvasSize()
    end)
    arg24.Container:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 277
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateCanvasSize()
    end)
    arg24.Pages.UpdateCanvasSize:Connect(function() -- line: 281
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateCanvasSize()
    end)
    UILibrary_m.MainGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 285
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateCanvasSize()
    end)
    UILibrary_m.MainGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 289
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateCanvasSize()
    end)
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 293
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateSize()
    end)
    arg24:_Setup()
    arg24:_UpdateSize()
    arg24:_UpdateScale()
    arg24:_UpdateCanvasSize()
    arg24:_UpdatePromptContext()
end

return t_2._new()
