local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.SettingsInfo)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local Profiles_m = require(script:WaitForChild("Profiles"))
local Inspect_m = require(script:WaitForChild("Inspect"))
local List_m = require(script:WaitForChild("List"))
local Tabs_m = require(script:WaitForChild("Tabs"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 19
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] Profiles_m (copy)
    --  [4] Inspect_m (copy)
    --  [5] Tabs_m (copy)
    --  [6] List_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.Container = t_1.PageFrame:WaitForChild("Container")
    t_1.CloseButton = t_1.Container:WaitForChild("Close")
    t_1.HidePartyDisplay = true
    t_1.CurrentPage = nil
    t_1.Profiles = Profiles_m.new(t_1)
    t_1.Inspect = Inspect_m.new(t_1)
    t_1.Tabs = Tabs_m.new(t_1)
    t_1.List = List_m.new(t_1)
    t_1._open_animation_disabled = true
    t_1:_Init()

    return t_1
end

function t.SetPage(arg1, arg2) -- line: 43
    arg1.CurrentPage = arg2
    arg1.Tabs:SetPage(arg1.CurrentPage)
    arg1.List:SetPage(arg1.CurrentPage)
    arg1.Inspect:SetPage(arg1.CurrentPage)
    arg1.Profiles:SetPage(arg1.CurrentPage)
end

function t.Open(arg3, ...) -- line: 51
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg3, ...)
    arg3.Inspect:Open()
    arg3.Profiles:Open()
end

function t.Close(arg4, ...) -- line: 57
    -- upvalues:
    --  [1] Page_m (copy)

    arg4.List:Close()
    arg4.Inspect:Close()
    Page_m.Close(arg4, ...)
end

function t._VerifyPage(arg5) -- line: 67
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local v11 = if ControlsController_m.CurrentControls ~= "Touch" then false else true

    if v11 and arg5.CurrentPage == "Hotkeys" then
        arg5:SetPage("Touch")

        return
    end

    if not v11 and arg5.CurrentPage == "Touch" then
        arg5:SetPage("Hotkeys")
    end
end

function t._UpdateSize(arg6) -- line: 77
    -- upvalues:
    --  [1] GuiService (copy)

    arg6.Container.Size = UDim2.new(1, 0, 1, -GuiService.TopbarInset.Height)
end

function t._Init(arg7) -- line: 81
    -- upvalues:
    --  [1] SettingsController_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ControlsController_m (copy)
    --  [4] GuiService (copy)
    --  [5] ButtonEffect_m (copy)

    arg7.CloseButton.MouseButton1Click:Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:CloseRequest()
    end)
    arg7.List.ResetSettings:Connect(function() -- line: 86
        -- upvalues:
        --  [1] SettingsController_m (ref)
        --  [2] arg7 (copy)

        SettingsController_m:DefaultSettings(arg7.CurrentPage)
    end)
    arg7.List.Hovered:Connect(function(arg8) -- line: 90
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.Inspect:Inspect(arg8.SettingsInfo)
    end)
    arg7.Tabs.Clicked:Connect(function(arg9) -- line: 94
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:SetPage(arg9)
    end)
    arg7.Profiles.Clicked:Connect(function(arg10) -- line: 98
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] arg7 (copy)
        --  [3] SettingsController_m (ref)

        if arg10 == PlayerDataController_m:Get("SettingsProfile") then
            return
        end

        arg7.Inspect:Inspect(nil)
        SettingsController_m:SwitchSettingsProfile(arg10)
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 107
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_VerifyPage()
    end)
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 111
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateSize()
    end)
    arg7:_UpdateSize()
    arg7:SetPage("Audio")
    ButtonEffect_m:Add(arg7.CloseButton)
end

return t._new()
