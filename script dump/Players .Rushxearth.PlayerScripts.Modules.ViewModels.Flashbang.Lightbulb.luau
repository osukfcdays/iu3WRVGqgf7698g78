local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Flashbang_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Flashbang)
local t = setmetatable({}, Flashbang_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Flashbang_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Flashbang_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayFlashSound(arg1, arg2) -- line: 23
    -- upvalues:
    --  [1] Flashbang_m (copy)
    --  [2] Utility_m (copy)

    Flashbang_m.PlayFlashSound(arg1, arg2)
    Utility_m:CreateSound(
        "rbxassetid://137109782386847",
        2,
        1,
        arg2,
        true,
        10
    )
end

function t._Init(arg3) -- line: 32
    -- upvalues:
    --  [1] RunService (copy)

    task.defer(function() -- line: 33
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] RunService (ref)

        table.insert(arg3._connections, arg3.ClientItem.ProjectileThrown:Connect(function(
            arg4,
            arg5
        ) -- line: 34
            -- upvalues:
            --  [1] arg3 (ref)
            --  [2] RunService (ref)

            local Neon = arg5.Neon
            local now = tick()

            while true do
                if not arg4:IsDescendantOf(workspace) then
                    break
                end

                Neon.Transparency = 1 - math.min(
                    1,
                    (tick() - now) / arg3.ClientItem.Info.DetonateDelay
                ) ^ 4
                RunService.RenderStepped:Wait()
            end
        end))
    end)
end

return t
