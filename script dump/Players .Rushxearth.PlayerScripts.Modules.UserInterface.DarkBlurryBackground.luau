local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local MobileInputs_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.MobileInputs)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local color = Color3.fromRGB(255, 255, 255)
local color_1 = Color3.fromRGB(220, 220, 220)
local t = {}
t.__index = t

function t._new() -- line: 21
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._blur = Instance.new("BlurEffect")
    t_1._colorcorrection = Instance.new("ColorCorrectionEffect")
    t_1._last_blur_enabled = nil
    t_1._last_cc_enabled = nil
    t_1._tween_hash = 0
    t_1._current_duel = nil
    t_1._current_duel_connections = {}
    t_1:_Init()

    return t_1
end

function t._Tween(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5
) -- line: 47
    -- upvalues:
    --  [1] color (copy)
    --  [2] color_1 (copy)
    --  [3] Utility_m (copy)

    local v1 = arg2 or false
    local v2 = arg2 or false

    if v1 == arg1._last_blur_enabled and v2 == arg1._last_cc_enabled then
        return
    end

    arg1._last_blur_enabled = v1
    arg1._last_cc_enabled = v2
    arg1._tween_last = arg2
    arg1._tween_hash += 1
    local TweenHash = arg1._tween_hash
    local Size = arg1._blur.Size
    local Brightness = arg1._colorcorrection.Brightness
    local TintColor = arg1._colorcorrection.TintColor
    local v3 = if not v1 then 0 else if not arg3 then 24 or 0 else 60 or 0
    v1 = if not v2 then 0 else if not arg4 then -0.1 or 0 else 0 or 0
    local v4 = if not v2 then color else if not arg4 then color_1 or color else color or color
    local v6 = if not arg5 then 4 else 100
    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        v6,
        function(arg6) -- line: 69
            -- upvalues:
            --  [1] TweenHash (copy)
            --  [2] arg1 (copy)
            --  [3] Size (copy)
            --  [4] v3 (copy)
            --  [5] Brightness (copy)
            --  [6] v1 (copy)
            --  [7] TintColor (copy)
            --  [8] v4 (copy)

            if TweenHash ~= arg1._tween_hash then
                return true
            end

            local v7 = 1 - (1 - arg6 / 100) ^ 3
            arg1._blur.Size = Size + (v3 - Size) * v7
            arg1._colorcorrection.Brightness = Brightness + (v1 - Brightness) * v7
            arg1._colorcorrection.TintColor = TintColor:Lerp(v4, v7)
        end
    )
end

function t._Update(arg7) -- line: 82
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] MobileInputs_m (copy)

    local v8 = Pages_m.PageSystem.CurrentPage and Pages_m.PageSystem.CurrentPage.UseDarkBlurryBackground
    local v9 = arg7._current_duel

    if v9 then
        v9 = arg7._current_duel.DuelInterface.Scoreboard:IsOpen() or (if arg7._current_duel.DuelInterface.FinalResults.CurrentPage ~= "Summary" then arg7._current_duel.DuelInterface.Voting:IsOpen() else true)
    end

    arg7:_Tween(
        v8 or v9 or MobileInputs_m.EditorEnabled,
        MobileInputs_m.EditorEnabled,
        MobileInputs_m.EditorEnabled
    )
end

function t._VerifyClientDuel(arg8) -- line: 98
    -- upvalues:
    --  [1] SpectateController_m (copy)

    for _, val in pairs(arg8._current_duel_connections) do
        val:Disconnect()
    end

    arg8._current_duel_connections = {}
    arg8._current_duel = SpectateController_m.CurrentDuelSubject
    arg8:_Update()

    if not arg8._current_duel then
        return
    end

    table.insert(arg8._current_duel_connections, arg8._current_duel.DuelInterface.Frame:GetPropertyChangedSignal(
        "Visible"
    ):Connect(function() -- line: 111
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Update()
    end))
    table.insert(arg8._current_duel_connections, arg8._current_duel.DuelInterface.Scoreboard.VisibilityChanged:Connect(
        function() -- line: 115
            -- upvalues:
            --  [1] arg8 (copy)

            arg8:_Update()
        end
    ))
    table.insert(arg8._current_duel_connections, arg8._current_duel.DuelInterface.FinalResults.PageChanged:Connect(
        function() -- line: 119
            -- upvalues:
            --  [1] arg8 (copy)

            arg8:_Update()
        end
    ))
    table.insert(arg8._current_duel_connections, arg8._current_duel.DuelInterface.Voting.VisibilityChanged:Connect(
        function() -- line: 123
            -- upvalues:
            --  [1] arg8 (copy)

            arg8:_Update()
        end
    ))
end

function t._Setup(arg9) -- line: 128
    -- upvalues:
    --  [1] Lighting (copy)

    arg9._blur.Name = "DarkBlurryBackground"
    arg9._blur.Parent = Lighting
    arg9._colorcorrection.Name = "DarkBlurryBackground"
    arg9._colorcorrection.Parent = Lighting
end

function t._Init(arg10) -- line: 136
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] Pages_m (copy)
    --  [3] MobileInputs_m (copy)

    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 137
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_VerifyClientDuel()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 141
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 145
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end)
    arg10:_Setup()
    task.defer(
        arg10._Tween,
        arg10,
        false,
        nil,
        nil,
        true
    )
    task.defer(arg10._Update, arg10)
    task.defer(arg10._VerifyClientDuel, arg10)
end

return t._new()
