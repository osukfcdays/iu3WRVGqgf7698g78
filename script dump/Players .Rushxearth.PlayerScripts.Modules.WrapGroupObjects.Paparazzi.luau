local TweenService = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo_1 = TweenInfo.new(0, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local range = NumberRange.new(0.3, 0.5)
local range_1 = NumberRange.new(0.25, 0.3)
local range_2 = NumberRange.new(1, 3)
local range_3 = NumberRange.new(0, 5)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 18
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._flashes1 = {}
    t_1._flashes2 = {}
    t_1._flashes3 = {}
    t_1._flashes4 = {}
    t_1._flashes_large = {}
    t_1._started = 0
    t_1._next_flash = 0
    t_1._last_index = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 39
    -- upvalues:
    --  [1] range (copy)
    --  [2] range_1 (copy)
    --  [3] range_3 (copy)
    --  [4] range_2 (copy)
    --  [5] TweenService (copy)
    --  [6] tweenInfo (copy)
    --  [7] tweenInfo_1 (copy)

    arg1._started += arg2

    if arg1._started < arg1._next_flash then
        return
    end

    arg1._next_flash = arg1._started + Random.new():NextNumber(range.Min, range.Max)
    local t_2 = {}

    if arg1._last_index ~= 1 then
        table.insert(t_2, 1)
    end

    if arg1._last_index ~= 2 then
        table.insert(t_2, 2)
    end

    if arg1._last_index ~= 3 then
        table.insert(t_2, 3)
    end

    if arg1._last_index ~= 4 then
        table.insert(t_2, 4)
    end

    local rng_1 = Random.new()
    arg1._last_index = t_2[rng_1:NextInteger(1, #t_2)]
    local New = Random.new():NextNumber(range_1.Min, range_1.Max)
    local rng_2 = Random.new():NextNumber(range_3.Min, range_3.Max)
    local rng_3 = Random.new():NextNumber(range_3.Min, range_3.Max)
    local v4 = Random.new():NextInteger(range_2.Min, range_2.Max)

    for _, val in pairs(arg1[`_flashes{arg1._last_index}`]) do
        val.OffsetStudsU = rng_2
        val.OffsetStudsV = rng_3
        task.spawn(function() -- line: 58
            -- upvalues:
            --  [1] v4 (copy)
            --  [2] TweenService (ref)
            --  [3] val (copy)
            --  [4] tweenInfo (ref)
            --  [5] arg1 (copy)
            --  [6] New (copy)
            --  [7] tweenInfo_1 (ref)

            for _ = 1, v4 do
                local v6 = TweenService:Create(val, tweenInfo, { Transparency = 0.1 })
                v6:Play()
                table.insert(arg1._tweens, v6)
                task.wait(tweenInfo.Time)
                local v9 = TweenService:Create(
                    val,
                    TweenInfo.new(New, tweenInfo_1.EasingStyle, tweenInfo_1.EasingDirection),
                    { Transparency = 1 }
                )
                v9:Play()
                table.insert(arg1._tweens, v9)
                task.wait(New / 1.5)
            end
        end)
    end

    for _, val_1 in pairs(arg1._flashes_large) do
        val_1.Transparency = 0.85
        local v11 = TweenService:Create(
            val_1,
            TweenInfo.new(New + 0.5, tweenInfo_1.EasingStyle, tweenInfo_1.EasingDirection),
            { Transparency = 1 }
        )
        v11:Play()
        table.insert(arg1._tweens, v11)
    end
end

function t._Setup(arg3) -- line: 100
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "FlashesBackground" then
            table.insert(arg3._flashes_large, val_2)
        else
            for index_1 = 1, 4 do
                if val_2.Name == `Flashes{index_1}` then
                    table.insert(arg3[`_flashes{index_1}`], val_2)
                    val_2.Transparency = 1
                end
            end
        end
    end

    arg3._started = workspace:GetServerTimeNow()
end

function t._Init(arg4) -- line: 131
    arg4:_Setup()
end

return t
