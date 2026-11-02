local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local _ = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {}
t[Enum.TextXAlignment.Left] = 0
t[Enum.TextXAlignment.Right] = 1
t[Enum.TextYAlignment.Top] = 0
t[Enum.TextYAlignment.Bottom] = 1
local color = Color3.fromRGB(0, 0, 0)
local t_1 = {}
local Color = ItemLibrary_m.Statuses.Contraband.Color
t_1.__index = t_1

function t_1._new() -- line: 27
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2._objects = {}
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, arg2) -- line: 41
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] t (copy)
    --  [3] Color (copy)
    --  [4] color (copy)

    for key, val in pairs(arg1._objects) do
        if Utility_m:IsUIElementVisible(key) then
            if val.IsTextLabel then
                local v3 = Vector2.new(
                    math.min(5, key.AbsoluteSize.X),
                    (math.min(5, key.AbsoluteSize.Y))
                ) * Vector2.new(math.random() - 0.5, math.random() - 0.5)
                local absoluteValue = math.abs(v3.X)
                local minimum_1 = math.min(absoluteValue, (math.abs(v3.Y)))
                local OriginalPosition = val.OriginalPosition
                local New_2 = UDim2.new
                local v4 = math.min(math.abs(v3.X), minimum_1) * math.sign(v3.X)
                key.Position = OriginalPosition + New_2(
                    0,
                    v4,
                    0,
                    math.min(math.abs(v3.Y), minimum_1) * math.sign(v3.Y)
                )
            end

            if tick() > val.Cooldown then
                val.Cooldown = tick() + 0.1
                local v5 = val.IsTextLabel and key.TextBounds.X or key.AbsoluteSize.X
                local v6 = val.IsTextLabel and key.TextBounds.Y or key.AbsoluteSize.Y
                local v7 = val.IsTextLabel and t[key.TextXAlignment] or 0.5
                local v8 = val.IsTextLabel and t[key.TextYAlignment] or 0.5
                local v9 = (0.375 + 0.25 * math.random()) * 0.375
                local v10 = (0.375 + 0.25 * math.random()) * 0.375

                if v5 > 0 then
                    local Frame = Instance.new("Frame")
                    Frame.BorderSizePixel = 0
                    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
                    Frame.BackgroundColor3 = Color:Lerp(color, math.random())
                    Frame.Size = UDim2.new(v9, 0, v10, 0)
                    Frame.Position = UDim2.new(
                        v7,
                        (math.random() - v7) * v5,
                        v8,
                        (math.random() - v8) * v6
                    )
                    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
                    UIAspectRatioConstraint.AspectRatio = 1 + 2 * math.random()
                    UIAspectRatioConstraint.Parent = Frame
                    Frame.Parent = key
                    local t_3 = {
                        Particle = Frame,
                        Age = 0,
                        OriginalPosition = Frame.Position,
                        Direction = math.sign(math.random() - 0.5)
                    }
                    table.insert(val.Particles, t_3)
                end
            end

            for index = #val.Particles, 1, -1 do
                local v16 = val.Particles[index]
                v16.Age += arg2

                if v16.Age >= 0.5 then
                    v16.Particle:Destroy()
                    table.remove(val.Particles, index)
                else
                    v16.Particle.Position = v16.OriginalPosition + UDim2.new(
                        0,
                        v16.Age * 10 * v16.Direction,
                        0,
                        0
                    )

                    if not val.IsTextLabel then
                        local v18 = v16.Particle.AbsoluteSize * Vector2.new(
                            math.random() - 0.5,
                            math.random() - 0.5
                        ) * 0.25
                        local Particle_1 = v16.Particle
                        Particle_1.Position = Particle_1.Position + UDim2.new(0, v18.X, 0, v18.Y)
                    end
                end
            end
        end
    end
end

function t_1._ObjectRemoved(arg3, arg4) -- line: 109
    if not arg3._objects[arg4] then
        return
    end

    for _, val_1 in pairs(arg3._objects[arg4].Particles) do
        val_1.Particle:Destroy()
    end

    arg3._objects[arg4] = nil
end

function t_1._ObjectAdded(arg5, arg6) -- line: 121
    arg5:_ObjectRemoved(arg6)
    arg5._objects[arg6] = {
        IsTextLabel = arg6:IsA("TextLabel"),
        OriginalPosition = arg6.Position,
        Cooldown = 0,
        Particles = {}
    }
end

function t_1._Init(arg7) -- line: 132
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceRemovedSignal("UIGlitchEffect"):Connect(function(arg8) -- line: 133
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectRemoved(arg8)
    end)
    CollectionService:GetInstanceAddedSignal("UIGlitchEffect"):Connect(function(arg9) -- line: 137
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectAdded(arg9)
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("UIGlitchEffect")) do
        task.spawn(arg7._ObjectAdded, arg7, val_2)
    end
end

return t_1._new()
