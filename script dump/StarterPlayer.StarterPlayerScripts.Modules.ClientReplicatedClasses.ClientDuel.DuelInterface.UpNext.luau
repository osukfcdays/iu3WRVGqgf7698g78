local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local EliminatedEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect
)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("UpNext")
    t_1.Container = t_1.Frame:WaitForChild("Container"):WaitForChild("SpectateBuffer"):WaitForChild(
        "Container"
    )
    t_1.Background = t_1.Container:WaitForChild("Background")
    t_1.Title = t_1.Container:WaitForChild("Title")
    t_1:_Init()

    return t_1
end

function t.Update(arg2) -- line: 29
    -- upvalues:
    --  [1] EliminatedEffect_m (copy)
    --  [2] Pages_m (copy)
    --  [3] DuelLibrary_m (copy)

    local v1 = not arg2.DuelInterface.Scoreboard:IsOpen()

    if v1 then
        v1 = not arg2.DuelInterface.Voting:IsOpen()

        if v1 then
            v1 = not EliminatedEffect_m:IsVisible()

            if v1 then
                v1 = not Pages_m.PageSystem.CurrentPage

                if v1 then
                    v1 = if arg2.DuelInterface.ClientDuel:Get("Status") ~= "RoundStarted" then false else true
                end
            end
        end
    end

    local v2 = arg2.DuelInterface.ClientDuel.LocalDueler

    if v2 then
        v2 = arg2.DuelInterface.ClientDuel.LocalDueler:GetStaggeredSpawnsTurn()
    end

    local v3 = v2 and v2 <= 1
    v2 = arg2.DuelInterface.ClientDuel:Get("PlaySourceName")
    local v4 = v2

    if v4 then
        v4 = false

        if DuelLibrary_m.PlaySources[v2].DuelLogic == "Zombie Tower" then
            v4 = arg2.DuelInterface.ClientDuel.LocalDueler

            if v4 then
                v4 = arg2.DuelInterface.ClientDuel.LocalDueler.ClientFighter

                if v4 then
                    v4 = not arg2.DuelInterface.ClientDuel.LocalDueler.ClientFighter:IsAlive()
                end
            end
        end
    end

    arg2.Frame.Visible = v1 and (v3 or v4)
    arg2.Title.Text = if not v3 then if not v4 then "" else "Waiting to be revived by a Revive Drop" else "You're up next!"
end

function t.Destroy(_) -- line: 45
end

function t._UpdateBackground(arg4) -- line: 53
    arg4.Background.Size = UDim2.new(
        0,
        arg4.Title.TextBounds.X + arg4.Container.AbsoluteSize.Y * 0.6,
        1,
        0
    )
end

function t._Init(arg5) -- line: 57
    arg5.DuelInterface.Scoreboard.VisibilityChanged:Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:Update()
    end)
    arg5.DuelInterface.Voting.VisibilityChanged:Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:Update()
    end)
    arg5.Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 66
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateBackground()
    end)
    arg5.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateBackground()
    end)
    arg5:_UpdateBackground()
end

return t
