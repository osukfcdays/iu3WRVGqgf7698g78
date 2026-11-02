local Players = game:GetService("Players")
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local PartyDisplay_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PartyDisplay")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)
    --  [3] PartyDisplay_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.IsVisible = false
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Pages", "SideParty")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.LocalFighter = nil
    t_1.SidePartyDisplay = PartyDisplay_m.new(t_1.Container, true)
    t_1:_Init()

    return t_1
end

function t._UpdateVisibility(arg1) -- line: 36
    -- upvalues:
    --  [1] Pages_m (copy)

    local v5 = Pages_m.PageSystem.CurrentPage

    if v5 then
        v5 = not Pages_m.PageSystem.CurrentPage.HidePartyDisplay

        if v5 then
            v5 = arg1.LocalFighter

            if v5 then
                v5 = not arg1.LocalFighter:Get("IsInDuel")

                if v5 then
                    v5 = not arg1.LocalFighter:Get("IsInShootingRange")
                end
            end
        end
    end

    arg1.IsVisible = v5
    v5 = arg1.Container
    v5:TweenPosition(
        arg1.IsVisible and UDim2.new(0.05, 0, 0.95, 0) or UDim2.new(-0.15, 0, 0.95, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t._HookLocalFighter(arg2) -- line: 43
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg2.LocalFighter = FighterController_m:WaitForLocalFighter()
    arg2.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 46
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    arg2.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 50
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    arg2:_UpdateVisibility()
end

function t._Init(arg3) -- line: 57
    -- upvalues:
    --  [1] Pages_m (copy)

    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateVisibility()
    end)
    arg3:_UpdateVisibility()
    task.spawn(arg3._HookLocalFighter, arg3)
end

return t._new()
