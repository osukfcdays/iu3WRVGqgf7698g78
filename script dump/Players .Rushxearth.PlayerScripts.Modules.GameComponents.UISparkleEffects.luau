local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PrimeSparkle = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PrimeSparkle")
local t = {}
t[Enum.TextXAlignment.Left] = 0
t[Enum.TextXAlignment.Right] = 1
t[Enum.TextYAlignment.Top] = 0
t[Enum.TextYAlignment.Bottom] = 1
local color = Color3.fromRGB(255, 255, 255)
local t_1 = {}
t_1.__index = t_1

function t_1._new() -- line: 23
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2._objects = {}
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, arg2) -- line: 37
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] t (copy)
    --  [3] PrimeSparkle (copy)
    --  [4] color (copy)
    --  [5] Players (copy)

    for key, val in pairs(arg1._objects) do
        if Utility_m:IsUIElementVisible(key) then
            if tick() > val.Cooldown then
                val.Cooldown = tick() + 0.5
                local v1 = val.IsTextLabel and key.TextBounds.X or key.AbsoluteSize.X
                local v2 = val.IsTextLabel and key.TextBounds.Y or key.AbsoluteSize.Y
                local v3 = val.IsTextLabel and t[key.TextXAlignment] or 0.5
                local v4 = val.IsTextLabel and t[key.TextYAlignment] or 0.5
                local v5 = (0.375 + 0.25 * math.random()) * 1

                if v1 > 0 then
                    local v6 = PrimeSparkle:Clone()
                    local v7 = val.IsTextLabel and key.TextTransparency or val.IsImageLabel and key.ImageTransparency or 0
                    v6.ImageTransparency = v7
                    v6.ImageColor3 = color
                    v6.Size = UDim2.new(v5, 0, v5, 0)
                    v6.Position = UDim2.new(
                        v3,
                        (math.random() - v3) * v1,
                        v4,
                        (math.random() - v4) * v2
                    )
                    v6.Rotation = math.random() * 360
                    v6.Parent = key

                    if v6:IsDescendantOf(Players) then
                        v6:TweenSize(
                            UDim2.new(),
                            "In",
                            "Back",
                            2,
                            true
                        )
                    end

                    table.insert(val.Particles, { Particle = v6, Age = 0 })
                end
            end

            for index = #val.Particles, 1, -1 do
                local v9 = val.Particles[index]
                v9.Age += arg2

                if v9.Age >= 2 then
                    v9.Particle:Destroy()
                    table.remove(val.Particles, index)
                else
                    v9.Particle.Rotation = v9.Age * 180 * 1
                end
            end
        end
    end
end

function t_1._ObjectRemoved(arg3, arg4) -- line: 89
    if not arg3._objects[arg4] then
        return
    end

    for _, val_1 in pairs(arg3._objects[arg4].Particles) do
        val_1.Particle:Destroy()
    end

    arg3._objects[arg4] = nil
end

function t_1._ObjectAdded(arg5, arg6) -- line: 101
    arg5:_ObjectRemoved(arg6)
    arg5._objects[arg6] = {
        IsTextLabel = arg6:IsA("TextLabel"),
        IsImageLabel = arg6:IsA("ImageLabel"),
        Cooldown = 0,
        Particles = {}
    }
end

function t_1._Init(arg7) -- line: 112
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceRemovedSignal("UISparkleEffect"):Connect(function(arg8) -- line: 113
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectRemoved(arg8)
    end)
    CollectionService:GetInstanceAddedSignal("UISparkleEffect"):Connect(function(arg9) -- line: 117
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectAdded(arg9)
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("UISparkleEffect")) do
        task.spawn(arg7._ObjectAdded, arg7, val_2)
    end
end

return t_1._new()
