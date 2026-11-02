local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Spring)
local Throwable_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local t = setmetatable({}, Throwable_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Throwable_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Throwable_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 30
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)

    arg1.ProjectileThrown:Connect(function(arg2, arg3) -- line: 31
        -- upvalues:
        --  [1] BetterDebris_m (ref)
        --  [2] arg1 (copy)
        --  [3] RunService (ref)

        local Highlight = Instance.new("Highlight")
        Highlight.FillColor = Color3.fromRGB(255, 0, 0)
        Highlight.OutlineTransparency = 1
        Highlight.FillTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.Adornee = arg3
        Highlight.Parent = arg3
        BetterDebris_m:AddItem(Highlight, 10)
        local rng = Random.new()
        local now = tick()

        while true do
            if not arg2:IsDescendantOf(workspace) then
                break
            end

            local minimum = math.min(1, (tick() - now) / arg1.Info.DetonateDelay)
            arg3.WorldPivot = arg3:GetPivot() + rng:NextUnitVector() * 0.25 * minimum ^ 4
            Highlight.FillTransparency = 1 - minimum ^ 4 / 2
            RunService.RenderStepped:Wait()
        end

        Highlight:Destroy()
    end)
end

return t
