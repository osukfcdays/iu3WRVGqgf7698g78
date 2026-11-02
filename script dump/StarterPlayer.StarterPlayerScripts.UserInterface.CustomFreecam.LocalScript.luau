local v11, v13, v2, v4, v6, v7, v9
local math_clamp = math.clamp
local math_exp = math.exp
local math_tan = math.tan
local math_abs = math.abs
local math_rad = math.rad
local math_sign = math.sign
local math_sqrt = math.sqrt
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local _ = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GameSettings = UserSettings().GameSettings
local Lighting = game:GetService("Lighting")

if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    local _ = Players.LocalPlayer
end

local CurrentCamera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 33
    -- upvalues:
    --  [1] Workspace (copy)
    --  [2] CurrentCamera (ref)

    local CurrentCamera_2 = Workspace.CurrentCamera

    if CurrentCamera_2 then
        CurrentCamera = CurrentCamera_2
    end
end)
local DepthOfFieldEffect = nil
local Success, Result = pcall(function() -- line: 44
    return UserSettings():IsUserFeatureEnabled("UserExitFreecamBreaksWithShiftlock")
end)
local g_pcall = pcall
g_pcall, v2 = g_pcall(function() -- line: 52
    return UserSettings():IsUserFeatureEnabled("UserShowGuiHideToggles")
end)
local v3 = g_pcall and v2
local g_pcall_1 = pcall
g_pcall_1, v4 = g_pcall_1(function() -- line: 60
    return UserSettings():IsUserFeatureEnabled("UserFixFreecamDeltaTimeCalculation")
end)
local v5 = g_pcall_1 and v4
local g_pcall_2 = pcall
g_pcall_2, v6 = g_pcall_2(function() -- line: 68
    return UserSettings():IsUserFeatureEnabled("UserFixFreecamGuiChangeVisibility")
end)
local g_pcall_3 = pcall
g_pcall_3, v7 = g_pcall_3(function() -- line: 76
    return UserSettings():IsUserFeatureEnabled("UserFreecamControlSpeed")
end)
local v8 = g_pcall_3 and v7
local g_pcall_4 = pcall
g_pcall_4, v9 = g_pcall_4(function() -- line: 84
    return UserSettings():IsUserFeatureEnabled("UserFreecamTiltControl")
end)
local v10 = g_pcall_4 and v9
local g_pcall_5 = pcall
g_pcall_5, v11 = g_pcall_5(function() -- line: 92
    return UserSettings():IsUserFeatureEnabled("UserFreecamSmoothnessControl")
end)
local v12 = g_pcall_5 and v11
local g_pcall_6 = pcall
g_pcall_6, v13 = g_pcall_6(function() -- line: 100
    return UserSettings():IsUserFeatureEnabled("UserFreecamGuiDestabilization")
end)
local v14 = g_pcall_6 and v13
local Success_1, Result_1 = pcall(function() -- line: 108
    return UserSettings():IsUserFeatureEnabled("UserFreecamDepthOfFieldEffect")
end)
local v15 = Success_1 and Result_1
local _ = Enum.ContextActionPriority.Low.Value
local _ = { Enum.KeyCode.LeftShift, Enum.KeyCode.P }
local t_1 = {}
local Value_1 = Enum.ContextActionPriority.High.Value
t_1[Enum.KeyCode.Z] = true
t_1[Enum.KeyCode.C] = true
local t_2 = {}
t_2[Enum.KeyCode.ButtonL1] = true
t_2[Enum.KeyCode.ButtonR1] = true
local t_3 = {}
t_3[Enum.KeyCode.BackSlash] = true
local v16 = Vector2.new(0.75, 1) * 8
local v17 = 5
local v18 = 5
local v19 = 4
local v20 = 5
local t_4 = {}
local t_5 = {}
local t_6 = {}
t_5.__index = t_5

function t_5.new(arg1, arg2) -- line: 170
    -- upvalues:
    --  [1] t_5 (copy)

    local t_7 = setmetatable({}, t_5)
    t_7.f = arg1
    t_7.p = arg2
    t_7.v = arg2 * 0

    return t_7
end

function t_5.Update(arg3, arg4, arg5) -- line: 178
    -- upvalues:
    --  [1] math_exp (copy)

    local v21 = arg3.f * 2 * 3.141592653589793
    local V = arg3.v
    local v22 = arg5 - arg3.p
    local v23 = math_exp(-v21 * arg4)
    local v24 = arg5 + (V * arg4 - v22 * (v21 * arg4 + 1)) * v23
    arg3.p, arg3.v = v24, (v21 * arg4 * (v22 * v21 - V) + V) * v23

    return v24
end

function t_5.SetFreq(arg6, arg7) -- line: 195
    arg6.f = arg7
end

function t_5.Reset(arg8, arg9) -- line: 199
    arg8.p = arg9
    arg8.v = arg9 * 0
end

local vec3 = Vector3.new()
local v25 = if v10 then Vector3.new() else Vector2.new()
local v26 = 0
local v27 = t_5.new(v17, (Vector3.new()))
local v28 = t_5.new(v18, Vector2.new())
local v29 = t_5.new(v19, 0)
local v30 = t_5.new(v20, 0)
local t_8 = {}

local _ = function(arg10) --[[ fCurve ]] -- line: 228
    -- upvalues:
    --  [1] math_exp (copy)

    return (math_exp(2 * arg10) - 1) / 6.38905609893065
end

local _ = function(arg11) --[[ fDeadzone ]] -- line: 232
    -- upvalues:
    --  [1] math_exp (copy)

    return (math_exp(2 * ((arg11 - 0.15) / 0.85)) - 1) / 6.38905609893065
end

local function thumbstickCurve(arg12) -- line: 236
    -- upvalues:
    --  [1] math_sign (copy)
    --  [2] math_abs (copy)
    --  [3] math_exp (copy)
    --  [4] math_clamp (copy)

    local v31 = math_sign(arg12)

    return v31 * math_clamp(
        (math_exp(2 * ((math_abs(arg12) - 0.15) / 0.85)) - 1) / 6.38905609893065,
        0,
        1
    )
end

local t_9 = {
    ButtonX = 0,
    ButtonY = 0,
    DPadDown = 0,
    DPadUp = 0,
    DPadLeft = 0,
    DPadRight = 0,
    ButtonL2 = 0,
    ButtonR2 = 0,
    ButtonL1 = 0,
    ButtonR1 = 0,
    Thumbstick1 = Vector2.new(),
    Thumbstick2 = Vector2.new()
}
local t_10 = {
    W = 0,
    A = 0,
    S = 0,
    D = 0,
    E = 0,
    Q = 0,
    U = 0,
    H = 0,
    J = 0,
    K = 0,
    I = 0,
    Y = 0,
    Up = 0,
    Down = 0,
    Left = 0,
    Right = 0,
    LeftShift = 0,
    RightShift = 0,
    Z = 0,
    C = 0,
    Comma = 0,
    Period = 0,
    LeftBracket = 0,
    RightBracket = 0,
    Semicolon = 0,
    Quote = 0,
    V = 0,
    B = 0,
    N = 0,
    M = 0,
    BackSlash = 0,
    Minus = 0,
    Equals = 0
}
local t_11 = { Delta = Vector2.new(), MouseWheel = 0 }
local v32 = Vector2.new(1, 1) * 0.04908738521234052
local v33 = v32 / 60
local t_12 = {
    FarIntensity = { ADJ = 0.1, MIN = 0, MAX = 1 },
    NearIntensity = { ADJ = 0.1, MIN = 0, MAX = 1 },
    FocusDistance = { ADJ = 20, MIN = 0, MAX = 200 },
    FocusRadius = { ADJ = 5, MIN = 0, MAX = 50 }
}
local v34 = 1
local v35 = 1
local v36 = 1

function t_8.Vel(arg13) -- line: 345
    -- upvalues:
    --  [1] v8 (ref)
    --  [2] v34 (ref)
    --  [3] t_10 (copy)
    --  [4] t_9 (copy)
    --  [5] math_clamp (copy)
    --  [6] thumbstickCurve (ref)
    --  [7] UserInputService (copy)

    if v8 then
        v34 = math_clamp(
            v34 + arg13 * (t_10.Up - t_10.Down + t_9.DPadUp - t_9.DPadDown) * 0.75,
            0.01,
            4
        )
    else
        v34 = math_clamp(v34 + arg13 * (t_10.Up - t_10.Down) * 0.75, 0.01, 4)
    end

    local v37 = thumbstickCurve(t_9.Thumbstick1.X)
    local v39 = thumbstickCurve(t_9.ButtonR2) - thumbstickCurve(t_9.ButtonL2)
    local v40 = Vector3.new(v37, v39, thumbstickCurve(-t_9.Thumbstick1.Y)) * Vector3.new(1, 1, 1)
    local v41 = Vector3.new(
        t_10.D - t_10.A + t_10.K - t_10.H,
        t_10.E - t_10.Q + t_10.I - t_10.Y,
        t_10.S - t_10.W + t_10.J - t_10.U
    ) * Vector3.new(1, 1, 1)
    local v44 = if not (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(
        Enum.KeyCode.RightShift
    )) then 1 else 0.25

    return (v40 + v41) * (v34 * v44)
end

local v45 = Vector2.new(1, 1) * 0.39269908169872414

function t_8.Pan(arg14) -- line: 368
    -- upvalues:
    --  [1] thumbstickCurve (ref)
    --  [2] t_9 (copy)
    --  [3] v45 (copy)
    --  [4] t_11 (copy)
    --  [5] v32 (copy)
    --  [6] v5 (ref)
    --  [7] v33 (copy)

    local v47 = Vector2.new(thumbstickCurve(t_9.Thumbstick2.Y), thumbstickCurve(-t_9.Thumbstick2.X)) * v45
    local v48 = t_11.Delta * v32

    if v5 and arg14 > 0 then
        v48 = t_11.Delta / arg14 * v33
    end

    t_11.Delta = Vector2.new()

    return v47 + v48
end

function t_8.Fov(arg15) -- line: 383
    -- upvalues:
    --  [1] v8 (ref)
    --  [2] v36 (ref)
    --  [3] t_10 (copy)
    --  [4] t_9 (copy)
    --  [5] math_clamp (copy)
    --  [6] t_11 (copy)
    --  [7] v5 (ref)

    if v8 then
        v36 = math_clamp(
            v36 + arg15 * (t_10.Right - t_10.Left + t_9.DPadRight - t_9.DPadLeft) * 0.75,
            0.01,
            4
        )
    end

    local v50 = (t_9.ButtonX - t_9.ButtonY) * 0.25
    local v51 = t_11.MouseWheel * 1
    v51 = if not v5 then v51 else if not (arg15 > 0) then v51 else t_11.MouseWheel / arg15 * 0.016666666666666666
    t_11.MouseWheel = 0

    if v8 then
        return (v50 + v51) * v36
    end

    return v50 + v51
end

function t_8.Roll(arg16) -- line: 402
    -- upvalues:
    --  [1] v35 (ref)
    --  [2] t_10 (copy)
    --  [3] math_clamp (copy)
    --  [4] t_9 (copy)

    v35 = math_clamp(v35 + arg16 * (t_10.Period - t_10.Comma) * 0.75, 0.01, 4)

    return ((t_9.ButtonR1 - t_9.ButtonL1) * 1 + (t_10.C - t_10.Z) * 1) * v35
end

function t_8.SpringControl(arg17) -- line: 411
    -- upvalues:
    --  [1] v15 (ref)
    --  [2] UserInputService (copy)
    --  [3] v17 (ref)
    --  [4] t_10 (copy)
    --  [5] math_clamp (copy)
    --  [6] v27 (copy)
    --  [7] v18 (ref)
    --  [8] v28 (copy)
    --  [9] v19 (ref)
    --  [10] v29 (copy)
    --  [11] v20 (ref)
    --  [12] v30 (copy)

    if v15 then
        if
            UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
            or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        then
            return
        end
    end

    v17 = math_clamp(v17 + arg17 * (t_10.RightBracket - t_10.LeftBracket) * 0.75, 0.01, 10)
    v27:SetFreq(v17)
    v18 = math_clamp(v18 + arg17 * (t_10.Quote - t_10.Semicolon) * 0.75, 0.01, 10)
    v28:SetFreq(v18)
    v19 = math_clamp(v19 + arg17 * (t_10.B - t_10.V) * 0.75, 0.01, 10)
    v29:SetFreq(v19)
    v20 = math_clamp(v20 + arg17 * (t_10.M - t_10.N) * 0.75, 0.01, 10)
    v30:SetFreq(v20)
end

function t_8.DoF(arg18) -- line: 434
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] DepthOfFieldEffect (ref)
    --  [3] t_10 (copy)
    --  [4] t_12 (copy)
    --  [5] math_clamp (copy)

    local v54 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(
        Enum.KeyCode.RightShift
    )
    local v55 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(
        Enum.KeyCode.RightControl
    )

    if v54 then
        DepthOfFieldEffect.FarIntensity = math_clamp(
            DepthOfFieldEffect.FarIntensity + arg18 * (t_10.RightBracket - t_10.LeftBracket) * t_12.FarIntensity.ADJ,
            t_12.FarIntensity.MIN,
            t_12.FarIntensity.MAX
        )
        DepthOfFieldEffect.InFocusRadius = math_clamp(
            DepthOfFieldEffect.InFocusRadius + arg18 * (t_10.Equals - t_10.Minus) * t_12.FocusRadius.ADJ,
            t_12.FocusRadius.MIN,
            t_12.FocusRadius.MAX
        )

        return
    end

    if v55 then
        DepthOfFieldEffect.NearIntensity = math_clamp(
            DepthOfFieldEffect.NearIntensity + arg18 * (t_10.RightBracket - t_10.LeftBracket) * t_12.NearIntensity.ADJ,
            t_12.NearIntensity.MIN,
            t_12.NearIntensity.MAX
        )

        return
    end

    DepthOfFieldEffect.FocusDistance = math_clamp(
        DepthOfFieldEffect.FocusDistance + arg18 * (t_10.Equals - t_10.Minus) * t_12.FocusDistance.ADJ,
        t_12.FocusDistance.MIN,
        t_12.FocusDistance.MAX
    )
end

local _ = function(arg19, arg20) --[[ resetKeys ]] -- line: 465
    for key, _ in pairs(arg19) do
        if arg20[key.Name] then
            arg20[key.Name] = 0
        end
    end
end

local v60 = 0

local function handleDoubleTapReset(arg21) -- line: 473
    -- upvalues:
    --  [1] t_6 (copy)
    --  [2] v60 (ref)
    --  [3] v25 (ref)
    --  [4] v30 (copy)
    --  [5] v15 (ref)
    --  [6] t_2 (copy)
    --  [7] t_9 (copy)
    --  [8] t_1 (copy)
    --  [9] t_10 (copy)

    local clockTime = os.clock()
    local v61 = t_6[arg21]

    if v61 and (v61 and clockTime - v61 or -1) <= 0.25 and clockTime - v60 >= 0.1 then
        v25 = Vector3.new(v25.x, v25.y, 0)
        v30:Reset(0)

        if v15 then
            local v63 = t_9

            for key_1, _ in pairs(t_2) do
                if v63[key_1.Name] then
                    v63[key_1.Name] = 0
                end
            end

            local v64 = t_10

            for key_2, _ in pairs(t_1) do
                if v64[key_2.Name] then
                    v64[key_2.Name] = 0
                end
            end
        else
            t_9.ButtonL1 = 0
            t_9.ButtonR1 = 0
            t_10.C = 0
            t_10.Z = 0
        end

        v60 = clockTime
    end

    t_6[arg21] = clockTime
end

local function Keypress(_, arg23, arg24) -- line: 498
    -- upvalues:
    --  [1] t_10 (copy)
    --  [2] v10 (ref)
    --  [3] t_1 (copy)
    --  [4] handleDoubleTapReset (copy)
    --  [5] v15 (ref)
    --  [6] t_3 (copy)
    --  [7] DepthOfFieldEffect (ref)
    --  [8] t_4 (ref)
    --  [9] CurrentCamera (ref)
    --  [10] Lighting (copy)

    local v65 = t_10
    local Name = arg24.KeyCode.Name
    v65[Name] = if arg23 ~= Enum.UserInputState.Begin then 0 else 1

    if v10 and t_1[arg24.KeyCode] and arg24.UserInputState == Enum.UserInputState.Begin then
        handleDoubleTapReset(arg24.KeyCode)
    end

    if v15 and t_3[arg24.KeyCode] and arg24.UserInputState == Enum.UserInputState.Begin then
        if not DepthOfFieldEffect.Enabled then
            t_4 = {}

            for _, val_3 in ipairs(CurrentCamera:GetChildren()) do
                if val_3:IsA("DepthOfFieldEffect") and val_3.Enabled then
                    t_4[#t_4 + 1] = val_3
                    val_3.Enabled = false
                end
            end

            for _, val_4 in ipairs(Lighting:GetChildren()) do
                if val_4:IsA("DepthOfFieldEffect") and val_4.Enabled then
                    t_4[#t_4 + 1] = val_4
                    val_4.Enabled = false
                end
            end

            CurrentCamera.ChildAdded:Connect(function(child: Instance) -- line: 524
                -- upvalues:
                --  [1] t_4 (ref)

                if child:IsA("DepthOfFieldEffect") and child.Enabled then
                    t_4[#t_4 + 1] = child
                    child.Enabled = false
                end
            end)
            Lighting.ChildAdded:Connect(function(child_1: Instance) -- line: 530
                -- upvalues:
                --  [1] t_4 (ref)

                if child_1:IsA("DepthOfFieldEffect") and child_1.Enabled then
                    t_4[#t_4 + 1] = child_1
                    child_1.Enabled = false
                end
            end)
        else
            local _ = Enum.UserInputState.Begin

            for _, val_5 in ipairs(t_4) do
                if val_5.Parent then
                    val_5.Enabled = true
                end
            end

            t_4 = {}
        end

        DepthOfFieldEffect.Enabled = not DepthOfFieldEffect.Enabled
        local v69 = t_10

        for key_6, _ in pairs(t_3) do
            if v69[key_6.Name] then
                v69[key_6.Name] = 0
            end
        end
    end

    return Enum.ContextActionResult.Sink
end

local function GpButton(_, arg28, arg29) -- line: 554
    -- upvalues:
    --  [1] t_9 (copy)
    --  [2] v10 (ref)
    --  [3] t_2 (copy)
    --  [4] handleDoubleTapReset (copy)

    local v70 = t_9
    local Name_1 = arg29.KeyCode.Name
    v70[Name_1] = if arg28 ~= Enum.UserInputState.Begin then 0 else 1

    if v10 and t_2[arg29.KeyCode] and arg29.UserInputState == Enum.UserInputState.Begin then
        handleDoubleTapReset(arg29.KeyCode)
    end

    return Enum.ContextActionResult.Sink
end

local function MousePan(_, _, arg32) -- line: 566
    -- upvalues:
    --  [1] t_11 (copy)

    local Delta = arg32.Delta
    t_11.Delta = Vector2.new(-Delta.y, -Delta.x)

    return Enum.ContextActionResult.Sink
end

local function Thumb(_, _, arg35) -- line: 572
    -- upvalues:
    --  [1] t_9 (copy)

    t_9[arg35.KeyCode.Name] = arg35.Position

    return Enum.ContextActionResult.Sink
end

local function Trigger(_, _, arg38) -- line: 577
    -- upvalues:
    --  [1] t_9 (copy)

    t_9[arg38.KeyCode.Name] = arg38.Position.z

    return Enum.ContextActionResult.Sink
end

local function MouseWheel(_, _, arg41) -- line: 582
    -- upvalues:
    --  [1] t_11 (copy)

    t_11[arg41.UserInputType.Name] = -arg41.Position.z

    return Enum.ContextActionResult.Sink
end

local _ = function(arg42) --[[ Zero ]] -- line: 587
    for key_7, val_7 in pairs(arg42) do
        arg42[key_7] = val_7 * 0
    end
end

function t_8.StartCapture() -- line: 593
    -- upvalues:
    --  [1] v8 (ref)
    --  [2] ContextActionService (copy)
    --  [3] Keypress (copy)
    --  [4] Value_1 (copy)
    --  [5] GpButton (copy)
    --  [6] v10 (ref)
    --  [7] v12 (ref)
    --  [8] v15 (ref)
    --  [9] MousePan (copy)
    --  [10] MouseWheel (copy)
    --  [11] Trigger (copy)
    --  [12] Thumb (copy)

    if v8 then
        ContextActionService:BindActionAtPriority(
            "FreecamKeyboard",
            Keypress,
            false,
            Value_1,
            Enum.KeyCode.W,
            Enum.KeyCode.U,
            Enum.KeyCode.A,
            Enum.KeyCode.H,
            Enum.KeyCode.S,
            Enum.KeyCode.J,
            Enum.KeyCode.D,
            Enum.KeyCode.K,
            Enum.KeyCode.E,
            Enum.KeyCode.I,
            Enum.KeyCode.Q,
            Enum.KeyCode.Y
        )
        ContextActionService:BindActionAtPriority(
            "FreecamKeyboardControlSpeed",
            Keypress,
            false,
            Value_1,
            Enum.KeyCode.Up,
            Enum.KeyCode.Down,
            Enum.KeyCode.Left,
            Enum.KeyCode.Right
        )
        ContextActionService:BindActionAtPriority(
            "FreecamGamepadControlSpeed",
            GpButton,
            false,
            Value_1,
            Enum.KeyCode.DPadUp,
            Enum.KeyCode.DPadDown,
            Enum.KeyCode.DPadLeft,
            Enum.KeyCode.DPadRight
        )
    else
        ContextActionService:BindActionAtPriority(
            "FreecamKeyboard",
            Keypress,
            false,
            Value_1,
            Enum.KeyCode.W,
            Enum.KeyCode.U,
            Enum.KeyCode.A,
            Enum.KeyCode.H,
            Enum.KeyCode.S,
            Enum.KeyCode.J,
            Enum.KeyCode.D,
            Enum.KeyCode.K,
            Enum.KeyCode.E,
            Enum.KeyCode.I,
            Enum.KeyCode.Q,
            Enum.KeyCode.Y,
            Enum.KeyCode.Up,
            Enum.KeyCode.Down
        )
    end

    if v10 then
        ContextActionService:BindActionAtPriority(
            "FreecamKeyboardTiltControl",
            Keypress,
            false,
            Value_1,
            Enum.KeyCode.Z,
            Enum.KeyCode.C
        )
        ContextActionService:BindActionAtPriority(
            "FreecamGamepadTiltControl",
            GpButton,
            false,
            Value_1,
            Enum.KeyCode.ButtonL1,
            Enum.KeyCode.ButtonR1
        )
        ContextActionService:BindActionAtPriority(
            "FreecamKeyboardTiltControlSpeed",
            Keypress,
            false,
            Value_1,
            Enum.KeyCode.Comma,
            Enum.KeyCode.Period
        )

        if v12 then
            ContextActionService:BindActionAtPriority(
                "FreecamKeyboardSmoothnessControl",
                Keypress,
                false,
                Value_1,
                Enum.KeyCode.LeftBracket,
                Enum.KeyCode.RightBracket,
                Enum.KeyCode.Semicolon,
                Enum.KeyCode.Quote,
                Enum.KeyCode.V,
                Enum.KeyCode.B,
                Enum.KeyCode.N,
                Enum.KeyCode.M
            )
        end
    end

    if v15 then
        ContextActionService:BindActionAtPriority(
            "FreecamKeyboardDoFToggle",
            Keypress,
            false,
            Value_1,
            Enum.KeyCode.BackSlash
        )
        ContextActionService:BindActionAtPriority(
            "FreecamKeyboardDoFControls",
            Keypress,
            false,
            Value_1,
            Enum.KeyCode.Minus,
            Enum.KeyCode.Equals
        )
    end

    ContextActionService:BindActionAtPriority(
        "FreecamMousePan",
        MousePan,
        false,
        Value_1,
        Enum.UserInputType.MouseMovement
    )
    ContextActionService:BindActionAtPriority(
        "FreecamMouseWheel",
        MouseWheel,
        false,
        Value_1,
        Enum.UserInputType.MouseWheel
    )
    ContextActionService:BindActionAtPriority(
        "FreecamGamepadButton",
        GpButton,
        false,
        Value_1,
        Enum.KeyCode.ButtonX,
        Enum.KeyCode.ButtonY
    )
    ContextActionService:BindActionAtPriority(
        "FreecamGamepadTrigger",
        Trigger,
        false,
        Value_1,
        Enum.KeyCode.ButtonR2,
        Enum.KeyCode.ButtonL2
    )
    ContextActionService:BindActionAtPriority(
        "FreecamGamepadThumbstick",
        Thumb,
        false,
        Value_1,
        Enum.KeyCode.Thumbstick1,
        Enum.KeyCode.Thumbstick2
    )
end

function t_8.StopCapture() -- line: 654
    -- upvalues:
    --  [1] v34 (ref)
    --  [2] v8 (ref)
    --  [3] v36 (ref)
    --  [4] v10 (ref)
    --  [5] v35 (ref)
    --  [6] t_9 (copy)
    --  [7] t_10 (copy)
    --  [8] t_11 (copy)
    --  [9] ContextActionService (copy)
    --  [10] v12 (ref)
    --  [11] v15 (ref)

    v34 = 1

    if v8 then
        v36 = 1
    end

    if v10 then
        v35 = 1
    end

    local v73 = t_9

    for key_8, val_8 in pairs(v73) do
        v73[key_8] = val_8 * 0
    end

    local v74 = t_10

    for key_9, val_9 in pairs(v74) do
        v74[key_9] = val_9 * 0
    end

    local v75 = t_11

    for key_10, val_10 in pairs(v75) do
        v75[key_10] = val_10 * 0
    end

    ContextActionService:UnbindAction("FreecamKeyboard")

    if v8 then
        ContextActionService:UnbindAction("FreecamKeyboardControlSpeed")
        ContextActionService:UnbindAction("FreecamGamepadControlSpeed")
    end

    if v10 then
        ContextActionService:UnbindAction("FreecamKeyboardTiltControl")
        ContextActionService:UnbindAction("FreecamGamepadTiltControl")
        ContextActionService:UnbindAction("FreecamKeyboardTiltControlSpeed")

        if v12 then
            ContextActionService:UnbindAction("FreecamKeyboardSmoothnessControl")
        end
    end

    if v15 then
        ContextActionService:UnbindAction("FreecamKeyboardDoFToggle")
        ContextActionService:UnbindAction("FreecamKeyboardDoFControls")
    end

    ContextActionService:UnbindAction("FreecamMousePan")
    ContextActionService:UnbindAction("FreecamMouseWheel")
    ContextActionService:UnbindAction("FreecamGamepadButton")
    ContextActionService:UnbindAction("FreecamGamepadTrigger")
    ContextActionService:UnbindAction("FreecamGamepadThumbstick")
end

local function GetFocusDistance(arg43) -- line: 692
    -- upvalues:
    --  [1] CurrentCamera (ref)
    --  [2] v26 (ref)
    --  [3] math_tan (copy)
    --  [4] Workspace (copy)

    local ViewportSize = CurrentCamera.ViewportSize
    local v76 = math_tan(v26 / 2) * 2
    local v77 = ViewportSize.x / ViewportSize.y * v76
    local RightVector = arg43.rightVector
    local UpVector = arg43.upVector
    local LookVector = arg43.lookVector
    local v78 = Vector3.new()
    local v79 = 512

    for index = 0, 1, 0.5 do
        for index_1 = 0, 1, 0.5 do
            local v80 = RightVector * ((index - 0.5) * v77) - UpVector * ((index_1 - 0.5) * v76) + LookVector
            local v81 = arg43.p + v80 * 0.1
            local _, v84 = Workspace:FindPartOnRay(Ray.new(v81, v80.unit * v79))
            local Magnitude = (v84 - v81).magnitude

            if v79 > Magnitude then
                v79 = Magnitude
                v78 = v80.unit
            end
        end
    end

    return LookVector:Dot(v78) * v79
end

local function StepFreecam(arg44) -- line: 724
    -- upvalues:
    --  [1] v12 (ref)
    --  [2] t_8 (copy)
    --  [3] v15 (ref)
    --  [4] DepthOfFieldEffect (ref)
    --  [5] v27 (copy)
    --  [6] v28 (copy)
    --  [7] v29 (copy)
    --  [8] v10 (ref)
    --  [9] v30 (copy)
    --  [10] v26 (ref)
    --  [11] math_rad (copy)
    --  [12] math_tan (copy)
    --  [13] math_sqrt (copy)
    --  [14] math_clamp (copy)
    --  [15] v16 (copy)
    --  [16] v25 (ref)
    --  [17] vec3 (ref)
    --  [18] CurrentCamera (ref)
    --  [19] GetFocusDistance (copy)

    if v12 then
        t_8.SpringControl(arg44)
    end

    if v15 and DepthOfFieldEffect and DepthOfFieldEffect.Parent then
        t_8.DoF(arg44)
    end

    local v86 = v27:Update(arg44, t_8.Vel(arg44))
    local v88 = v28:Update(arg44, t_8.Pan(arg44))
    local v90 = v29:Update(arg44, t_8.Fov(arg44))
    local v91 = if v10 then v30:Update(arg44, t_8.Roll(arg44)) else nil
    local v93 = math_rad(v26 / 2)
    local v94 = math_sqrt(0.7002075382097097 / math_tan(v93))
    v26 = math_clamp(v26 + v90 * 300 * (arg44 / v94), 1, 120)
    local v99

    if v10 then
        local v95 = v88 * v16 * (arg44 / v94)
        v25 = v25 + Vector3.new(v95.X, v95.Y, v91 * -1.5707963267948966 * (arg44 / v94))

        if v12 then
            v25 = Vector3.new(
                v25.x % 6.283185307179586,
                v25.y % 6.283185307179586,
                v25.z % 6.283185307179586
            )
        else
            v25 = Vector3.new(
                math_clamp(v25.x, -1.5707963267948966, 1.5707963267948966),
                v25.y % 6.283185307179586,
                v25.z
            )
        end

        v99 = CFrame.new(vec3) * CFrame.fromOrientation(v25.x, v25.y, v25.z) * CFrame.new(
            v86 * Vector3.new(50, 50, 50) * arg44
        )
    else
        v25 += v88 * v16 * (arg44 / v94)
        v25 = Vector2.new(
            math_clamp(v25.x, -1.5707963267948966, 1.5707963267948966),
            v25.y % 6.283185307179586
        )
        v99 = CFrame.new(vec3) * CFrame.fromOrientation(v25.x, v25.y, 0) * CFrame.new(
            v86 * Vector3.new(50, 50, 50) * arg44
        )
    end

    vec3 = v99.p
    CurrentCamera.CFrame = v99
    CurrentCamera.Focus = v99 * CFrame.new(0, 0, -GetFocusDistance(v99))
    CurrentCamera.FieldOfView = v26
end

local _ = function() --[[ CheckMouseLockAvailability ]] -- line: 771
    -- upvalues:
    --  [1] Players (copy)
    --  [2] GameSettings (copy)

    local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
    local v103 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local v104 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch

    return DevEnableMouseLock and v104 and not (GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove) and not v103
end

local t_13 = {}
local v107 = nil
local v108 = nil
local v109 = nil
local v110 = nil
local v111 = nil
local v112 = nil
local _ = {}
local _ = { Backpack = true, Chat = true, Health = true, PlayerList = true }
local _ = { BadgesNotificationsActive = true, PointsNotificationsActive = true }
local v113 = Success and Result

function t_13.Push() -- line: 803
    -- upvalues:
    --  [1] v112 (ref)
    --  [2] CurrentCamera (ref)
    --  [3] v109 (ref)
    --  [4] v111 (ref)
    --  [5] v110 (ref)
    --  [6] v108 (ref)
    --  [7] UserInputService (copy)
    --  [8] v113 (ref)
    --  [9] Players (copy)
    --  [10] GameSettings (copy)
    --  [11] v107 (ref)

    v112 = CurrentCamera.FieldOfView
    CurrentCamera.FieldOfView = 70
    v109 = CurrentCamera.CameraType
    CurrentCamera.CameraType = Enum.CameraType.Custom
    v111 = CurrentCamera.CFrame
    v110 = CurrentCamera.Focus
    v108 = UserInputService.MouseIconEnabled
    UserInputService.MouseIconEnabled = true

    if v113 then
        local DevEnableMouseLock_1 = Players.LocalPlayer.DevEnableMouseLock
        local v114 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
        local v115 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch

        if
            DevEnableMouseLock_1
            and v115
            and not (GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove)
            and not v114
        then
            v107 = Enum.MouseBehavior.Default
        else
            v107 = UserInputService.MouseBehavior
        end
    else
        v107 = UserInputService.MouseBehavior
    end

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

local v118 = g_pcall_2 and v6

function t_13.Pop() -- line: 852
    -- upvalues:
    --  [1] v118 (ref)
    --  [2] _ (ref)
    --  [3] CurrentCamera (ref)
    --  [4] v112 (ref)
    --  [5] v109 (ref)
    --  [6] v111 (ref)
    --  [7] v110 (ref)
    --  [8] UserInputService (copy)
    --  [9] v108 (ref)
    --  [10] v107 (ref)

    if v118 then
        _ = {}
    end

    CurrentCamera.FieldOfView = v112
    v112 = nil
    CurrentCamera.CameraType = v109
    v109 = nil
    CurrentCamera.CFrame = v111
    v111 = nil
    CurrentCamera.Focus = v110
    v110 = nil
    UserInputService.MouseIconEnabled = v108
    v108 = nil
    UserInputService.MouseBehavior = v107
    v107 = nil
end

local function StartFreecam() -- line: 889
    -- upvalues:
    --  [1] v14 (ref)
    --  [2] v3 (ref)
    --  [3] CurrentCamera (ref)
    --  [4] v10 (ref)
    --  [5] v25 (ref)
    --  [6] vec3 (ref)
    --  [7] v26 (ref)
    --  [8] v27 (copy)
    --  [9] v28 (copy)
    --  [10] v29 (copy)
    --  [11] v30 (copy)
    --  [12] v12 (ref)
    --  [13] v17 (ref)
    --  [14] v18 (ref)
    --  [15] v19 (ref)
    --  [16] v20 (ref)
    --  [17] t_13 (copy)
    --  [18] v15 (ref)
    --  [19] DepthOfFieldEffect (ref)
    --  [20] RunService (copy)
    --  [21] StepFreecam (copy)
    --  [22] t_8 (copy)

    if not v14 and v3 then
        script:SetAttribute("FreecamEnabled", true)
    end

    local v119 = CurrentCamera.CFrame

    if v10 then
        v25 = Vector3.new(v119:toEulerAnglesYXZ())
    else
        v25 = Vector2.new(v119:toEulerAnglesYXZ())
    end

    vec3 = v119.p
    v26 = CurrentCamera.FieldOfView
    v27:Reset((Vector3.new()))
    v28:Reset(Vector2.new())
    v29:Reset(0)

    if v10 then
        v30:Reset(0)
    end

    if v12 then
        v17 = 1.5
        v18 = 1
        v19 = 4
        v20 = 1
    end

    t_13.Push()

    if v15 and (not DepthOfFieldEffect or not DepthOfFieldEffect.Parent) then
        DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")
        DepthOfFieldEffect.Enabled = false
        DepthOfFieldEffect.Name = "FreecamDepthOfField"
        DepthOfFieldEffect.Parent = CurrentCamera
    end

    RunService:BindToRenderStep("CustomFreecam", Enum.RenderPriority.Camera.Value, StepFreecam)
    t_8.StartCapture()
end

local function StopFreecam() -- line: 935
    -- upvalues:
    --  [1] v14 (ref)
    --  [2] v3 (ref)
    --  [3] v15 (ref)
    --  [4] DepthOfFieldEffect (ref)
    --  [5] t_4 (ref)
    --  [6] t_8 (copy)
    --  [7] RunService (copy)
    --  [8] t_13 (copy)

    if not v14 and v3 then
        script:SetAttribute("FreecamEnabled", false)
    end

    if v15 and DepthOfFieldEffect and DepthOfFieldEffect.Parent then
        if DepthOfFieldEffect.Enabled then
            for _, val_11 in ipairs(t_4) do
                if val_11.Parent then
                    val_11.Enabled = true
                end
            end

            t_4 = {}
        end

        DepthOfFieldEffect.Enabled = false
    end

    t_8.StopCapture()
    RunService:UnbindFromRenderStep("CustomFreecam")
    t_13.Pop()
end

local v122 = false
script:WaitForChild("Toggle").Event:Connect(function(arguments) -- line: 967
    -- upvalues:
    --  [1] v122 (ref)
    --  [2] StartFreecam (copy)
    --  [3] StopFreecam (copy)

    if arguments and not v122 then
        StartFreecam()
    elseif not arguments and v122 then
        StopFreecam()
    end

    v122 = arguments
end)
