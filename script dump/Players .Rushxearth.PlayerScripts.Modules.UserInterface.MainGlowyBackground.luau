local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local GlowyBackground_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("GlowyBackground")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 12
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)
    --  [3] GlowyBackground_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "MainGlowyBackground")
    t_1._glowy_background = GlowyBackground_m.new("MainGui")
    t_1._current_duel_subject = nil
    t_1._current_duel_subject_connections = {}
    t_1:_Init()

    return t_1
end

function t._Update(arg1) -- line: 36
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] GuiService (copy)

    local v5 = arg1._current_duel_subject

    if v5 then
        v5 = arg1._current_duel_subject.DuelInterface

        if v5 then
            v5 = arg1._current_duel_subject.DuelInterface.Voting:IsOpen()
        end
    end

    local v6 = if not v5 then 1 else 0
    arg1._glowy_background:SetBackdropTransparency(v6)
    local GlowyBackground_1 = arg1._glowy_background
    v6 = Pages_m.PageSystem.CurrentPage and not Pages_m.PageSystem.CurrentPage.DisableGlowyBackground or GuiService.MenuIsOpen or v5
    GlowyBackground_1:SetEnabled(v6)
    arg1._glowy_background:SetBlurEnabled(not GuiService.MenuIsOpen)
end

function t._UpdateClientDuelSubject(arg2) -- line: 44
    -- upvalues:
    --  [1] SpectateController_m (copy)

    for _, val in pairs(arg2._current_duel_subject_connections) do
        val:Disconnect()
    end

    arg2._current_duel_subject_connections = {}
    arg2._current_duel_subject = nil

    if not SpectateController_m.CurrentDuelSubject then
        arg2:_Update()

        return
    end

    arg2._current_duel_subject = SpectateController_m.CurrentDuelSubject
    table.insert(arg2._current_duel_subject_connections, arg2._current_duel_subject.DuelInterface.Voting.VisibilityChanged:Connect(
        function() -- line: 59
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:_Update()
        end
    ))
    arg2:_Update()
end

function t._Setup(arg3) -- line: 66
    arg3._glowy_background:SetParent(arg3.Frame)
end

function t._Init(arg4) -- line: 70
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] GuiService (copy)
    --  [3] SpectateController_m (copy)

    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 71
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Update()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 75
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Update()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 79
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateClientDuelSubject()
    end)
    arg4:_Setup()
    task.defer(arg4._Update, arg4)
    task.defer(arg4._UpdateClientDuelSubject, arg4)
end

return t._new()
