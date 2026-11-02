local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CurrencyLibrary_m = require(ReplicatedStorage.Modules.CurrencyLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("Header")
    t_1.SeasonFrame = t_1.Frame:WaitForChild("Season")
    t_1.SeasonText = t_1.SeasonFrame:WaitForChild("Title")
    t_1.DescriptionFrame = t_1.Frame:WaitForChild("Description")
    t_1.DescriptionButton = t_1.DescriptionFrame:WaitForChild("Info")
    t_1.DescriptionTitle = t_1.DescriptionFrame:WaitForChild("Title")
    t_1.GloryFrame = t_1.Frame:WaitForChild("Glory")
    t_1.GloryButton = t_1.GloryFrame:WaitForChild("Button")
    t_1.GloryIcon = t_1.GloryButton:WaitForChild("Icon")
    t_1.GloryTitle = t_1.GloryButton:WaitForChild("Title")
    t_1._update_description_thread = nil
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 45
    arg2:_UpdateGlory()
    arg2:_UpdateDescription()
end

function t.Close(arg3) -- line: 50
    arg3:_CancelDescriptionThread()
end

function t._CancelDescriptionThread(arg4) -- line: 58
    if arg4._update_description_thread then
        task.cancel(arg4._update_description_thread)
        arg4._update_description_thread = nil
    end
end

function t._UpdateDescription(arg5) -- line: 65
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Utility_m (copy)

    local v1 = SeasonLibrary_m.CurrentSeason.Name
    local v2 = SeasonLibrary_m.Seasons[v1]
    local UNIVERSALELONAME = SeasonLibrary_m.UNIVERSAL_ELO_NAME
    local v3 = PlayerDataController_m:Get("Seasons")[v1]
    v1 = v3

    if v1 then
        v1 = v3.RankedPerformances[UNIVERSALELONAME]
    end

    v3 = not v1.LastDuelPlayedTime or not v1.CurrentELO or v1.CurrentELO <= v2.ELODecayThreshold

    if v3 then
        arg5.DescriptionTitle.Text = "Standard duel gameplay  \226\128\162  Restricted handicaps  \226\128\162  Ban maps & weapons"

        return
    end

    arg5:_CancelDescriptionThread()
    arg5._update_description_thread = task.spawn(function() -- line: 81
        -- upvalues:
        --  [1] v1 (copy)
        --  [2] v2 (copy)
        --  [3] arg5 (copy)
        --  [4] Utility_m (ref)

        while true do
            local v4 = (math.ceil(v1.LastDuelPlayedTime / 60 / 60 / 24) + v2.ELODecayInactivePeriodDays) * 24 * 60 * 60
            local v5 = v4 - os.time()

            if v5 <= 0 then
                arg5.DescriptionTitle.Text = "Your ELO has begun decaying, play Ranked now to stop it"
            else
                arg5.DescriptionTitle.Text = string.format(
                    "Your ELO will start decaying in %s if you don't play Ranked",
                    Utility_m:TimeFormat2(v5)
                )
            end

            wait(1)
        end
    end)
end

function t._UpdateGlory(arg6) -- line: 97
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] PlayerDataController_m (copy)

    arg6.GloryTitle.Text = string.format(
        "%s <font transparency=\"0.25\" weight=\"500\" size=\"8\">Glory</font>",
        Utility_m:PrettyNumber(PlayerDataController_m:Get("Glory"))
    )
end

function t._Setup(arg7) -- line: 101
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] CurrencyLibrary_m (copy)

    arg7.SeasonText.Text = "Season " .. SeasonLibrary_m.CurrentSeason.Version
    arg7.GloryIcon.Image = CurrencyLibrary_m.Info.Glory.Image
end

function t._Init(arg8) -- line: 106
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg8.DescriptionButton.MouseButton1Click:Connect(function() -- line: 107
        -- upvalues:
        --  [1] arg8 (copy)

        arg8.Page.PromptSystem:Open("ViewRankedDetails")
    end)
    arg8.GloryButton.MouseButton1Click:Connect(function() -- line: 111
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] Pages_m (ref)

        arg8.Page.OpenPage:Fire("Shop")
        Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Ranked")
        Pages_m.PageSystem:WaitForPage("Shop"):RedirectTo("Ranked")
    end)
    arg8:_Setup()
    ButtonEffect_m:Add(arg8.DescriptionButton)
    ButtonEffect_m:Add(arg8.GloryButton, nil, { ReleaseRatio = 1.05, HoverRatio = 1.05 })
end

return t
