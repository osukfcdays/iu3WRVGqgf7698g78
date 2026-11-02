local ContentProvider = game:GetService("ContentProvider")
local t = {
    FinalResultsCamera = "rbxassetid://18110142424",
    FinalResultsPlayer1 = "rbxassetid://18110150396",
    FinalResultsPlayer2 = "rbxassetid://18110151901",
    FinalResultsPlayer3 = "rbxassetid://18110154615",
    FinalResultsPlayer4 = "rbxassetid://18110156683",
    FinalResultsPlayer5 = "rbxassetid://18110158144",
    SlidingStartForward = "rbxassetid://17702562791",
    SlidingStartRightward = "rbxassetid://18887331786",
    SlidingStartBackward = "rbxassetid://18887315202",
    SlidingStartLeftward = "rbxassetid://18887335228",
    SlidingLoopForward = "rbxassetid://17702566891",
    SlidingLoopRightward = "rbxassetid://18887328608",
    SlidingLoopBackward = "rbxassetid://18887323938",
    SlidingLoopLeftward = "rbxassetid://18887339224",
    SlidingJump = "rbxassetid://17704241464",
    SlidingJumpFall = "rbxassetid://17704252963",
    WeaponUnlockIdle = "rbxassetid://17652443406",
    WeaponUnlockPlay = "rbxassetid://17652360108",
    LobbyPortalFalling = "rbxassetid://111331261961557",
    ZombieSpawn = "rbxassetid://81895123077452"
}
local t_1 = {}
t_1.__index = t_1

function t_1._new() -- line: 33
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2._preloaded_animations_by_name = {}
    t_2._preloaded_animations_by_animation_id = {}
    t_2:_Init()

    return t_2
end

function t_1.GetPreloadedAnimationID(_, arg2) -- line: 48
    -- upvalues:
    --  [1] t (copy)

    return t[arg2]
end

function t_1.GetPreloadedAnimation(arg3, arg4) -- line: 52
    return arg3._preloaded_animations_by_name[arg4]
end

function t_1._PreloadAnimations(arg5) -- line: 60
    -- upvalues:
    --  [1] t (copy)
    --  [2] ContentProvider (copy)

    local t_3 = {}

    for key, val in pairs(t) do
        local Animation = Instance.new("Animation")
        Animation.AnimationId = val
        arg5._preloaded_animations_by_name[key] = Animation
        arg5._preloaded_animations_by_animation_id[val] = Animation
        table.insert(t_3, Animation)
    end

    while true do
        if not (#t_3 > 0) then
            break
        end

        local v2 = t_3
        t_3 = {}
        ContentProvider:PreloadAsync(v2, function(arg6, arg7) -- line: 75
            -- upvalues:
            --  [1] t_3 (ref)
            --  [2] arg5 (copy)

            if arg7 ~= Enum.AssetFetchStatus.Success then
                table.insert(t_3, arg5._preloaded_animations_by_animation_id[arg6])
            end
        end)
        wait(1)
    end
end

function t_1._Init(arg8) -- line: 85
    task.defer(arg8._PreloadAnimations, arg8)
end

return t_1._new()
