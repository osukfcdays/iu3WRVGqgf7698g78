local CollectionService = game:GetService("CollectionService")
local _ = game:GetService("RunService")
local t = {}
t.__index = t

function t._new() -- line: 7
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._is_playing = false
    t_1._next_flicker = {}
    t_1:_Init()

    return t_1
end

function t._Play(arg1) -- line: 28
    -- upvalues:
    --  [1] CollectionService (copy)

    if arg1._is_playing then
        return
    end

    arg1._is_playing = true

    while true do
        local taggedInstances = CollectionService:GetTagged("FlickeringLight")

        if #taggedInstances == 0 then
            break
        end

        for _, val in pairs(taggedInstances) do
            if not (tick() < (arg1._next_flicker[val] or 0)) then
                arg1._next_flicker[val] = tick() + 1 + 4 * math.random()
                task.spawn(function() -- line: 49
                    -- upvalues:
                    --  [1] val (copy)

                    for _ = 1, math.random(1, 3) do
                        local SurfaceLight = val:FindFirstChildOfClass("SurfaceLight")
                        val.Material = Enum.Material.Neon

                        if SurfaceLight then
                            SurfaceLight.Enabled = true
                        end

                        wait(0.1)
                        val.Material = Enum.Material.SmoothPlastic

                        if SurfaceLight then
                            SurfaceLight.Enabled = false
                        end

                        wait(0.1)
                    end
                end)
            end
        end

        wait(0.1)
    end

    arg1._is_playing = false
end

function t._Init(arg2) -- line: 78
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("FlickeringLight"):Connect(function(arg3) -- line: 79
        -- upvalues:
        --  [1] arg2 (copy)

        arg2._next_flicker[arg3] = tick() + 1
        arg2:_Play()
    end)
    CollectionService:GetInstanceRemovedSignal("FlickeringLight"):Connect(function(arg4) -- line: 84
        -- upvalues:
        --  [1] arg2 (copy)

        arg2._next_flicker[arg4] = nil
    end)
    task.spawn(arg2._Play, arg2)
end

return t._new()
