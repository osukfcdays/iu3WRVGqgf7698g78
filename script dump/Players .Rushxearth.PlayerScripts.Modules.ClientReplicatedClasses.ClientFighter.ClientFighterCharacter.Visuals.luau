local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local t = {}
local BlindedGui = Players.LocalPlayer.PlayerScripts.UserInterface.BlindedGui
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._destroyed = false
    t_1._red_figure_highlight = nil
    t_1:_Init()

    return t_1
end

function t.SetRedFigureMode(arg2, arg3, arg4) -- line: 30
    if arg3 and not arg2._red_figure_highlight then
        arg2._red_figure_highlight = Instance.new("Highlight")
        arg2._red_figure_highlight.FillColor = Color3.fromRGB(255, 0, 0)
        arg2._red_figure_highlight.FillTransparency = 0.25
        arg2._red_figure_highlight.OutlineColor = Color3.fromRGB(255, 112, 112)
        arg2._red_figure_highlight.OutlineTransparency = 0
        local RedFigureHighlight_2 = arg2._red_figure_highlight
        RedFigureHighlight_2.DepthMode = if not arg4 then Enum.HighlightDepthMode.Occluded else Enum.HighlightDepthMode.AlwaysOnTop
        arg2._red_figure_highlight.Adornee = arg2.ClientFighterCharacter.Model
        arg2._red_figure_highlight.Parent = arg2.ClientFighterCharacter.Model

        return
    end

    if not arg3 and arg2._red_figure_highlight then
        arg2._red_figure_highlight:Destroy()
        arg2._red_figure_highlight = nil
    end
end

function t.BlindedEffect(arg5, arg6) -- line: 46
    -- upvalues:
    --  [1] BlindedGui (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] RunService (copy)

    local now = tick()
    local v2 = BlindedGui:Clone()
    v2.Parent = arg5.ClientFighterCharacter.Model:FindFirstChild("Head") or arg5.ClientFighterCharacter.RootPart
    BetterDebris_m:AddItem(v2, arg6)
    local ImageLabel = v2.ImageLabel

    while true do
        if arg5._destroyed then
            break
        end

        if not (tick() < now + arg6) then
            break
        end

        ImageLabel.ImageTransparency = math.min(1, (tick() - now) / arg6) ^ 5
        RunService.RenderStepped:Wait()
    end

    v2:Destroy()
end

function t.HurtEffect(arg7, ...) -- line: 63
    -- upvalues:
    --  [1] CameraController_m (copy)

    local v4 = (...)[utf8.char(0)] / arg7.ClientFighterCharacter.Humanoid.MaxHealth

    if arg7.ClientFighterCharacter.ClientFighter.FighterInterface then
        task.spawn(
            arg7.ClientFighterCharacter.ClientFighter.FighterInterface.HurtEffect,
            arg7.ClientFighterCharacter.ClientFighter.FighterInterface,
            ...
        )
    end

    for key, _ in pairs(arg7.ClientFighterCharacter.ClientFighter:GetEquippedItems()) do
        local ViewModel = key.ViewModel
        local v6 = math.random() - 0.5
        ViewModel:ApplyRecoil(Vector3.new(v6, math.random() - 0.5, math.random() - 0.5) * 1.5 * v4)
    end

    if arg7.ClientFighterCharacter.ClientFighter:Get("IsSpectating") then
        CameraController_m:ShakeOnce(
            60 * v4,
            10,
            0,
            0.4,
            Vector3.new(0.25, 0.25, 0),
            Vector3.new(0, 0, 0)
        )
    end
end

function t.Update(_, _, _) -- line: 81
end

function t.Destroy(arg11) -- line: 85
    arg11._destroyed = true
end

function t._Init(arg12) -- line: 93
    arg12.ClientFighterCharacter.HealthChanged:Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:SetRedFigureMode(false)
    end)
end

return t
