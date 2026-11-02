local t = { _type = "Quaternion", _TO_STRING_CHAR = nil }

local _ = function(arg1) --[[ GetType ]] -- line: 288
    if arg1 == nil then
        return "nil"
    end

    local metatable = getmetatable(arg1)

    if type(metatable) == "table" and metatable._type ~= nil then
        return (tostring(metatable._type))
    end

    return (typeof(arg1))
end

local _ = function(vec1: Vector3, vec2: Vector3) --[[ _safeUnit ]] -- line: 298
    if vec1.Magnitude > 5E-07 then
        return vec1.Unit
    end

    return vec2
end

local function new(n1: number?, n2: number?, n3: number?, n4: number?) -- line: 314
    -- upvalues:
    --  [1] t (copy)

    local t_2 = setmetatable(
        { X = n1 or 0, Y = n2 or 0, Z = n3 or 0, W = n4 or 1, _cached = {} },
        t
    )
    table.freeze(t_2)

    return t_2
end

t.new = new
t.identity = new(0, 0, 0, 1)
t.zero = new(0, 0, 0, 0)

local function _Orthonormalize(vec3: Vector3, vec4: Vector3, vec5: Vector3) -- line: 334
    local v1 = if not (vec3.Magnitude > 5E-07) then Vector3.new(1, 0, 0) else vec3.Unit
    local v3 = v1:Cross(if not (vec4.Magnitude > 5E-07) then Vector3.new(0, 1, 0) else vec4.Unit)

    if v3.Magnitude > 5E-07 then
        v3 = v3.Unit
    else
        v3 = v1:Cross(Vector3.new(0, 1, 0))

        if v3.Magnitude > 5E-07 then
            v3 = v3.Unit
        else
            v3 = Vector3.new(1, 0, 0)
        end
    end

    local Unit = v3:Cross(v1).Unit

    if v3:Dot(vec5) < 0 then
        v3 = -v3
    end

    return v1, Unit, v3
end

local function _fromOrthonormalizedMatrix(vec6: Vector3, vec7: Vector3, vec8: Vector3) -- line: 358
    -- upvalues:
    --  [1] new (copy)

    local X = vec6.X
    local Y = vec6.Y
    local Z = vec6.Z
    local X_1 = vec7.X
    local Y_1 = vec7.Y
    local Z_1 = vec7.Z
    local X_2 = vec8.X
    local Y_2 = vec8.Y
    local Z_2 = vec8.Z
    local v4 = X + Y_1 + Z_2
    local v6, v7, v8, v9

    if v4 > 0 then
        local v5 = math.sqrt(v4 + 1) * 2
        v6 = (Z_1 - Y_2) / v5
        v7 = (X_2 - Z) / v5
        v8 = (Y - X_1) / v5
        v9 = v5 * 0.25
    elseif X > Y_1 and X > Z_2 then
        local v10 = math.sqrt(X + 1 - Y_1 - Z_2) * 2
        v6 = v10 * 0.25
        v7 = (X_1 + Y) / v10
        v8 = (X_2 + Z) / v10
        v9 = (Z_1 - Y_2) / v10
    elseif Y_1 > Z_2 then
        local v11 = math.sqrt(Y_1 + 1 - X - Z_2) * 2
        v6 = (X_1 + Y) / v11
        v7 = v11 * 0.25
        v8 = (Y_2 + Z_1) / v11
        v9 = (X_2 - Z) / v11
    else
        local v12 = math.sqrt(Z_2 + 1 - X - Y_1) * 2
        v6 = (X_2 + Z) / v12
        v7 = (Y_2 + Z_1) / v12
        v8 = v12 * 0.25
        v9 = (Y - X_1) / v12
    end

    return (new(v6, v7, v8, v9))
end

function t.fromAxisAngle(vec9: Vector3, n5: number) -- line: 405
    -- upvalues:
    --  [1] new (copy)

    local v13 = vec9
    vec9 = if not (v13.Magnitude > 5E-07) then Vector3.new(1, 0, 0) else v13.Unit
    local v14 = n5 / 2
    local sine = math.sin(v14)

    return (new(sine * vec9.X, sine * vec9.Y, sine * vec9.Z, (math.cos(v14))))
end

function t.fromAxisAngleFast(vec10: Vector3, n6: number) -- line: 428
    -- upvalues:
    --  [1] new (copy)

    local v21 = n6 / 2
    local v22 = vec10 * math.sin(v21)

    return (new(v22.X, v22.Y, v22.Z, (math.cos(v21))))
end

function t.fromEulerVector(vec11: Vector3) -- line: 450
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local Magnitude = vec11.Magnitude

    if Magnitude > 0 then
        local v23 = vec11 / Magnitude
        local v24 = Magnitude / 2
        local v25 = v23 * math.sin(v24)

        return (new(v25.X, v25.Y, v25.Z, (math.cos(v24))))
    end

    return t.identity
end

function t.fromCFrame(u1: CFrame) -- line: 470
    -- upvalues:
    --  [1] new (copy)

    local v26, v27 = u1:Orthonormalize():ToAxisAngle()
    local v28 = v26
    local v29 = if v28.Magnitude > 5E-07 then v28.Unit else Vector3.new(1, 0, 0)
    local v30 = v27 / 2
    local sine_1 = math.sin(v30)

    return (new(sine_1 * v29.X, sine_1 * v29.Y, sine_1 * v29.Z, (math.cos(v30))))
end

function t.fromCFrameFast(u2: CFrame) -- line: 485
    -- upvalues:
    --  [1] new (copy)

    local v37, v38 = u2:ToAxisAngle()
    local v39 = v38 / 2
    local v40 = v37 * math.sin(v39)

    return (new(v40.X, v40.Y, v40.Z, (math.cos(v39))))
end

function t.fromMatrix(vec12: Vector3, vec13: Vector3, vec14: Vector3?) -- line: 500
    -- upvalues:
    --  [1] _fromOrthonormalizedMatrix (copy)
    --  [2] _Orthonormalize (copy)

    return (_fromOrthonormalizedMatrix(
        _Orthonormalize(vec12, vec13, if vec14 then vec14 else vec12:Cross(vec13))
    ))
end

function t.fromMatrixFast(vec15: Vector3, vec16: Vector3, vec17: Vector3?) -- line: 517
    -- upvalues:
    --  [1] _fromOrthonormalizedMatrix (copy)

    local Unit_1 = vec15.Unit

    return (_fromOrthonormalizedMatrix(
        Unit_1,
        vec16.Unit,
        if vec17 then vec17 else vec15:Cross(vec16).Unit
    ))
end

function t.lookAt(vec18: Vector3, vec19: Vector3, vec20: Vector3?) -- line: 534
    -- upvalues:
    --  [1] _fromOrthonormalizedMatrix (copy)

    local v44 = vec19 - vec18
    local v45 = if not (v44.Magnitude > 5E-07) then Vector3.new(0, 0, 1) else v44.Unit
    local v46 = vec20 or Vector3.new(0, 1, 0)
    v44 = if not (v46.Magnitude > 5E-07) then Vector3.new(0, 1, 0) else v46.Unit
    local v47 = v45:Cross(v44)

    if v47.Magnitude > 5E-07 then
        v44 = v47.Unit

        return (_fromOrthonormalizedMatrix(v44, v44:Cross(v45).Unit, -v45))
    end

    local v48 = v45:Cross(Vector3.new(1, 0, 0))

    if v48.Magnitude > 5E-07 then
        local Unit_3 = v48.Unit

        return (_fromOrthonormalizedMatrix(Unit_3, Unit_3:Cross(v45).Unit, -v45))
    end

    local v49 = (Vector3.new(0, 0, 1)):Cross(v45)
    v49 *= v49:Dot(Vector3.new(0, 1, 0))

    return (_fromOrthonormalizedMatrix(v45:Cross(v49), v49, -v45))
end

local function fromEulerAnglesXYZ(n7: number, n8: number, n9: number) -- line: 568
    -- upvalues:
    --  [1] new (copy)

    local cosine = math.cos(n7 / 2)
    local sine_2 = math.sin(n7 / 2)
    local cosine_1 = math.cos(n8 / 2)
    local sine_3 = math.sin(n8 / 2)
    local cosine_2 = math.cos(n9 / 2)
    local sine_4 = math.sin(n9 / 2)
    local v51 = sine_2 * cosine_1
    local v52 = cosine * sine_3
    local v53 = cosine * cosine_1
    local v54 = sine_2 * sine_3

    return (new(
        v51 * cosine_2 + v52 * sine_4,
        v52 * cosine_2 - v51 * sine_4,
        v53 * sine_4 + v54 * cosine_2,
        v53 * cosine_2 - v54 * sine_4
    ))
end

t.fromEulerAnglesXYZ = fromEulerAnglesXYZ
t.Angles = fromEulerAnglesXYZ

local function fromEulerAnglesYXZ(n10: number, n11: number, n12: number) -- line: 606
    -- upvalues:
    --  [1] new (copy)

    local cosine_3 = math.cos(n10 / 2)
    local sine_5 = math.sin(n10 / 2)
    local cosine_4 = math.cos(n11 / 2)
    local sine_6 = math.sin(n11 / 2)
    local cosine_5 = math.cos(n12 / 2)
    local sine_7 = math.sin(n12 / 2)
    local v55 = sine_5 * cosine_4
    local v56 = cosine_3 * sine_6
    local v57 = cosine_3 * cosine_4
    local v58 = sine_5 * sine_6

    return (new(
        v55 * cosine_5 + v56 * sine_7,
        v56 * cosine_5 - v55 * sine_7,
        v57 * sine_7 - v58 * cosine_5,
        v57 * cosine_5 + v58 * sine_7
    ))
end

t.fromEulerAnglesYXZ = fromEulerAnglesYXZ
t.fromOrientation = fromEulerAnglesYXZ

function t.fromEulerAngles(n13: number, n14: number, n15: number, arg2: any) -- line: 646
    -- upvalues:
    --  [1] new (copy)

    local v59 = arg2 or Enum.RotationOrder.XYZ
    local cosine_6 = math.cos(n13 / 2)
    local cosine_7 = math.cos(n14 / 2)
    local cosine_8 = math.cos(n15 / 2)
    local sine_8 = math.sin(n13 / 2)
    local sine_9 = math.sin(n14 / 2)
    local sine_10 = math.sin(n15 / 2)
    local v60 = sine_8 * cosine_7
    local v61 = cosine_6 * sine_9
    local v62 = cosine_6 * cosine_7
    local v63 = sine_8 * sine_9
    local v64 = nil
    local v65 = nil
    local v66 = nil
    local v67 = nil
    local Name = v59.Name

    if Name == "XYZ" then
        v64 = v60 * cosine_8 + v61 * sine_10
        v65 = v61 * cosine_8 - v60 * sine_10
        v66 = v62 * sine_10 + v63 * cosine_8
        v67 = v62 * cosine_8 - v63 * sine_10
    elseif Name == "YXZ" then
        v64 = v60 * cosine_8 + v61 * sine_10
        v65 = v61 * cosine_8 - v60 * sine_10
        v66 = v62 * sine_10 - v63 * cosine_8
        v67 = v62 * cosine_8 + v63 * sine_10
    elseif Name == "ZXY" then
        v64 = v60 * cosine_8 - v61 * sine_10
        v65 = v61 * cosine_8 + v60 * sine_10
        v66 = v62 * sine_10 + v63 * cosine_8
        v67 = v62 * cosine_8 - v63 * sine_10
    elseif Name == "ZYX" then
        v64 = v60 * cosine_8 - v61 * sine_10
        v65 = v61 * cosine_8 + v60 * sine_10
        v66 = v62 * sine_10 - v63 * cosine_8
        v67 = v62 * cosine_8 + v63 * sine_10
    elseif Name == "YZX" then
        v64 = v60 * cosine_8 + v61 * sine_10
        v65 = v61 * cosine_8 + v60 * sine_10
        v66 = v62 * sine_10 - v63 * cosine_8
        v67 = v62 * cosine_8 - v63 * sine_10
    elseif Name == "XZY" then
        v64 = v60 * cosine_8 - v61 * sine_10
        v65 = v61 * cosine_8 - v60 * sine_10
        v66 = v62 * sine_10 + v63 * cosine_8
        v67 = v62 * cosine_8 + v63 * sine_10
    end

    return (new(v64, v65, v66, v67))
end

function t.fromVector(vec21: Vector3, n16: number?) -- line: 711
    -- upvalues:
    --  [1] new (copy)

    return (new(vec21.X, vec21.Y, vec21.Z, n16 or 0))
end

function t.RandomQuaternion(n17: number) -- line: 724
    -- upvalues:
    --  [1] new (copy)

    local rng = Random.new(n17 or 1)
    local math_sqrt = math.sqrt
    local math_sin = math.sin
    local math_cos = math.cos

    return function() -- line: 732
        -- upvalues:
        --  [1] rng (copy)
        --  [2] math_sqrt (copy)
        --  [3] math_sin (copy)
        --  [4] math_cos (copy)
        --  [5] new (ref)

        local v68 = rng:NextNumber(0, 1)
        local v69 = rng:NextNumber(0, 1)
        local v70 = rng:NextNumber(0, 1)
        local v71 = 1 - v68
        local v72 = math_sqrt(v68)
        local v74 = math_sqrt(v71)
        local v75 = 6.283185307179586 * v69
        local v76 = 6.283185307179586 * v70
        local v77 = v74 * math_sin(v75)
        local v78 = v74 * math_cos(v75)
        local v82 = v72 * math_sin(v76)

        return (new(v77, v78, v82, v72 * math_cos(v76)))
    end
end

local function Add(arg3, arg4) -- line: 887
    -- upvalues:
    --  [1] new (copy)

    return (new(arg3.X + arg4.X, arg3.Y + arg4.Y, arg3.Z + arg4.Z, arg3.W + arg4.W))
end

t.__add = Add
t.Add = Add

local function Sub(arg5, arg6) -- line: 894
    -- upvalues:
    --  [1] new (copy)

    return (new(arg5.X - arg6.X, arg5.Y - arg6.Y, arg5.Z - arg6.Z, arg5.W - arg6.W))
end

t.__sub = Sub
t.Sub = Sub

local function Mul(arg7, arg8) -- line: 901
    -- upvalues:
    --  [1] new (copy)

    local X_6 = arg7.X
    local Y_6 = arg7.Y
    local Z_6 = arg7.Z
    local W = arg7.W
    local X_7 = arg8.X
    local Y_7 = arg8.Y
    local Z_7 = arg8.Z
    local W_1 = arg8.W
    local v83 = new(
        W * X_7 + X_6 * W_1 + Y_6 * Z_7 - Z_6 * Y_7,
        W * Y_7 - X_6 * Z_7 + Y_6 * W_1 + Z_6 * X_7,
        W * Z_7 + X_6 * Y_7 - Y_6 * X_7 + Z_6 * W_1,
        W * W_1 - X_6 * X_7 - Y_6 * Y_7 - Z_6 * Z_7
    )

    return v83
end

t.__mul = Mul
t.Mul = Mul

function t.Scale(arg9: any, n18: number) -- line: 922
    -- upvalues:
    --  [1] new (copy)

    return (new(arg9.X * n18, arg9.Y * n18, arg9.Z * n18, arg9.W * n18))
end

function t.MulCFrameR(arg10: any, u3: CFrame) -- line: 934
    return arg10:ToCFrame() * u3
end

function t.MulCFrameL(arg11: any, u4: CFrame) -- line: 946
    return u4 * arg11:ToCFrame()
end

function t.RotateVector(arg12: any, vec22: Vector3) -- line: 958
    -- upvalues:
    --  [1] Mul (copy)
    --  [2] new (copy)

    return Mul(arg12 * new(vec22.X, vec22.Y, vec22.Z, 0), arg12:Conjugate()):Vector()
end

function t.CombineImaginary(arg13: any, vec23: Vector3) -- line: 971
    -- upvalues:
    --  [1] Mul (copy)
    --  [2] new (copy)

    return (Mul(new(vec23.X, vec23.Y, vec23.Z, 0), arg13))
end

local function Div(arg14, arg15) -- line: 978
    -- upvalues:
    --  [1] Mul (copy)

    return (Mul(arg14, arg15:Inverse()))
end

t.__div = Div
t.Div = Div

function t.ScaleInv(arg16: any, n19: number) -- line: 992
    -- upvalues:
    --  [1] new (copy)

    return (new(arg16.X / n19, arg16.Y / n19, arg16.Z / n19, arg16.W / n19))
end

local function unm(arg17) -- line: 999
    -- upvalues:
    --  [1] new (copy)

    return (new(-arg17.X, -arg17.Y, -arg17.Z, -arg17.W))
end

t.__unm = unm
t.Unm = unm
t.Negate = unm

local function Pow(arg18: any, n20: number) -- line: 1007
    -- upvalues:
    --  [1] t (copy)

    if n20 == -1 then
        return arg18:Inverse()
    end

    local W_2 = arg18.W
    local X_8 = arg18.X
    local Y_8 = arg18.Y
    local Z_8 = arg18.Z
    local v88 = X_8 * X_8 + Y_8 * Y_8 + Z_8 * Z_8
    local squareRoot = math.sqrt(W_2 * W_2 + v88)
    local squareRoot_1 = math.sqrt(v88)
    local v89 = squareRoot ^ n20

    if squareRoot_1 <= squareRoot * 5E-07 then
        return t.new(0, 0, 0, v89)
    end

    local v90 = X_8 / squareRoot_1
    local v91 = Y_8 / squareRoot_1
    local v92 = Z_8 / squareRoot_1
    local v93 = n20 * math.atan2(squareRoot_1, W_2)
    local cosine_9 = math.cos(v93)
    local v94 = v89 * math.sin(v93)

    return t.new(v94 * v90, v94 * v91, v94 * v92, v89 * cosine_9)
end

t.__pow = Pow
t.Pow = Pow

local function eq(arg19, arg20) -- line: 1041
    local v95, v96

    if arg19 == nil then
        v95 = "nil"
    else
        v96 = getmetatable(arg19)
        v95 = if type(v96) == "table" then if v96._type ~= nil then tostring(v96._type) else typeof(
            arg19
        ) else typeof(arg19)
    end

    if arg20 == nil then
        v96 = "nil"
    else
        local metatable_1 = getmetatable(arg20)
        v96 = if type(metatable_1) == "table" then if metatable_1._type ~= nil then tostring(
            metatable_1._type
        ) else typeof(arg20) else typeof(arg20)
    end

    return if v95 ~= "Quaternion" then false else if v96 ~= v95 then false else if arg19.X ~= arg20.X then false else if arg19.Y ~= arg20.Y then false else if arg19.Z ~= arg20.Z then false else arg19.W == arg20.W
end

t.__eq = eq
t.Eq = eq

local function lt(arg21, arg22) -- line: 1055
    return arg21:Length() < arg22:Length() and true
end

t.__lt = lt
t.Lt = lt

local function le(arg23, arg24) -- line: 1065
    return arg23:Length() <= arg24:Length() and true
end

t.__le = le
t.Le = le

local function Exp(arg25) -- line: 1081
    -- upvalues:
    --  [1] new (copy)

    local X_9 = arg25.X
    local Y_9 = arg25.Y
    local Z_9 = arg25.Z
    local exponential = math.exp(arg25.W)
    local v102 = X_9 * X_9 + Y_9 * Y_9 + Z_9 * Z_9

    if v102 > 0 then
        local v103 = v102 ^ 0.5
        local v104 = exponential * math.sin(v103) / v103

        return (new(X_9 * v104, Y_9 * v104, Z_9 * v104, exponential * math.cos(v103)))
    end

    return (new(0, 0, 0, exponential))
end

t.Exp = Exp

function t.ExpMap(arg26, arg27) -- line: 1104
    -- upvalues:
    --  [1] Mul (copy)
    --  [2] Exp (copy)

    return (Mul(arg26, (Exp(arg27))))
end

function t.ExpMapSym(arg28, arg29) -- line: 1117
    -- upvalues:
    --  [1] Pow (copy)
    --  [2] Mul (copy)
    --  [3] Exp (copy)

    local v110 = Pow(arg28, 0.5)

    return (Mul(Mul(v110, (Exp(arg29))), v110))
end

local function Log(arg30) -- line: 1130
    -- upvalues:
    --  [1] new (copy)

    local X_10 = arg30.X
    local Y_10 = arg30.Y
    local Z_10 = arg30.Z
    local W_3 = arg30.W
    local v113 = X_10 * X_10 + Y_10 * Y_10 + Z_10 * Z_10
    local v114 = W_3 * W_3 + v113

    if v114 > 0 then
        if v113 > 0 then
            local v115 = v114 ^ 0.5
            local v116 = math.acos(W_3 / v115) / v113 ^ 0.5

            return (new(X_10 * v116, Y_10 * v116, Z_10 * v116, (math.log(v115))))
        end

        return (new(0, 0, 0, math.log(v114) / 2))
    else
        return (new(0, 0, 0, -math.huge))
    end
end

t.Log = Log

function t.LogMap(arg31, arg32) -- line: 1156
    -- upvalues:
    --  [1] Log (copy)
    --  [2] Mul (copy)

    return (Log((Mul(arg31:Inverse(), arg32))))
end

function t.LogMapSym(arg33, arg34) -- line: 1169
    -- upvalues:
    --  [1] Pow (copy)
    --  [2] Log (copy)
    --  [3] Mul (copy)

    local v124 = Pow(arg33, -0.5)

    return (Log((Mul(Mul(v124, arg34), v124))))
end

local function Length(arg35) -- line: 1182
    local X_11 = arg35.X
    local Y_11 = arg35.Y
    local Z_11 = arg35.Z
    local W_4 = arg35.W

    return (X_11 * X_11 + Y_11 * Y_11 + Z_11 * Z_11 + W_4 * W_4) ^ 0.5
end

t.Length = Length
t.__len = Length

function t.LengthSquared(arg36) -- line: 1196
    local X_12 = arg36.X
    local Y_12 = arg36.Y
    local Z_12 = arg36.Z
    local W_5 = arg36.W

    return X_12 * X_12 + Y_12 * Y_12 + Z_12 * Z_12 + W_5 * W_5
end

function t.Hypot(arg37) -- line: 1209
    -- upvalues:
    --  [1] new (copy)

    local maximum = math.max(arg37.X, arg37.Y, arg37.Z, arg37.W)

    if maximum > 0 then
        local v127 = new(arg37.X / maximum, arg37.Y / maximum, arg37.Z / maximum, arg37.W / maximum)
        local X_13 = v127.X
        local Y_13 = v127.Y
        local Z_13 = v127.Z
        local W_6 = v127.W

        return (X_13 * X_13 + Y_13 * Y_13 + Z_13 * Z_13 + W_6 * W_6) ^ 0.5 * maximum
    end

    return 0
end

function t.Normalize(arg38) -- line: 1230
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local X_14 = arg38.X
    local Y_14 = arg38.Y
    local Z_14 = arg38.Z
    local W_7 = arg38.W
    local v128 = (X_14 * X_14 + Y_14 * Y_14 + Z_14 * Z_14 + W_7 * W_7) ^ 0.5

    if v128 > 0 then
        return (new(arg38.X / v128, arg38.Y / v128, arg38.Z / v128, arg38.W / v128))
    end

    return t.identity
end

function t.IsUnit(arg39: any, n21: number) -- line: 1248
    local X_15 = arg39.X
    local Y_15 = arg39.Y
    local Z_15 = arg39.Z
    local W_8 = arg39.W
    local v129 = (n21 or 5E-07) > math.abs(
        1 - (X_15 * X_15 + Y_15 * Y_15 + Z_15 * Z_15 + W_8 * W_8) ^ 0.5
    ) and true

    return v129
end

function t.ToCFrame(arg40: any, vec24: Vector3?) -- line: 1263
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v130 = arg40
    local X_16 = v130.X
    local Y_16 = v130.Y
    local Z_16 = v130.Z
    local W_9 = v130.W
    local v131 = (X_16 * X_16 + Y_16 * Y_16 + Z_16 * Z_16 + W_9 * W_9) ^ 0.5
    arg40 = if not (v131 > 0) then t.identity else new(
        v130.X / v131,
        v130.Y / v131,
        v130.Z / v131,
        v130.W / v131
    )
    v130 = vec24 or Vector3.new()

    return CFrame.new(
        v130.X,
        v130.Y,
        v130.Z,
        arg40.X,
        arg40.Y,
        arg40.Z,
        arg40.W
    )
end

function t.Dot(arg41, arg42) -- line: 1281
    return arg41.X * arg42.X + arg41.Y * arg42.Y + arg41.Z * arg42.Z + arg41.W * arg42.W
end

function t.Conjugate(arg43) -- line: 1294
    -- upvalues:
    --  [1] new (copy)

    return (new(-arg43.X, -arg43.Y, -arg43.Z, arg43.W))
end

function t.Inverse(arg44) -- line: 1307
    -- upvalues:
    --  [1] new (copy)

    local X_17 = arg44.X
    local Y_17 = arg44.Y
    local Z_17 = arg44.Z
    local W_10 = arg44.W
    local v132 = X_17 * X_17 + Y_17 * Y_17 + Z_17 * Z_17 + W_10 * W_10

    return (new(-arg44.X / v132, -arg44.Y / v132, -arg44.Z / v132, arg44.W / v132))
end

local function Negate(arg45) -- line: 1322
    -- upvalues:
    --  [1] new (copy)

    return (new(-arg45.X, -arg45.Y, -arg45.Z, -arg45.W))
end

t.Negate = Negate
t.__unm = Negate

function t.Difference(arg46, arg47) -- line: 1340
    -- upvalues:
    --  [1] new (copy)
    --  [2] Mul (copy)

    if arg46.X * arg47.X + arg46.Y * arg47.Y + arg46.Z * arg47.Z + arg46.W * arg47.W < 0 then
        local v133 = arg46
        arg46 = new(-v133.X, -v133.Y, -v133.Z, -v133.W)
    end

    local X_18 = arg46.X
    local Y_18 = arg46.Y
    local Z_18 = arg46.Z
    local W_11 = arg46.W
    local v134 = X_18 * X_18 + Y_18 * Y_18 + Z_18 * Z_18 + W_11 * W_11

    return (Mul(new(-arg46.X / v134, -arg46.Y / v134, -arg46.Z / v134, arg46.W / v134), arg47))
end

function t.Distance(arg48, arg49) -- line: 1356
    -- upvalues:
    --  [1] Log (copy)
    --  [2] Mul (copy)

    local v138 = Log((Mul(arg48:Inverse(), arg49)))
    local X_19 = v138.X
    local Y_19 = v138.Y
    local Z_19 = v138.Z
    local W_12 = v138.W

    return (X_19 * X_19 + Y_19 * Y_19 + Z_19 * Z_19 + W_12 * W_12) ^ 0.5 * 2
end

function t.DistanceSym(arg50, arg51) -- line: 1369
    -- upvalues:
    --  [1] Log (copy)
    --  [2] new (copy)
    --  [3] Mul (copy)

    local v139 = arg50
    v139 = if not (v139.X * arg51.X + v139.Y * arg51.Y + v139.Z * arg51.Z + v139.W * arg51.W < 0) then v139 else new(
        -v139.X,
        -v139.Y,
        -v139.Z,
        -v139.W
    )
    local X_20 = v139.X
    local Y_20 = v139.Y
    local Z_20 = v139.Z
    local W_13 = v139.W
    local v141 = X_20 * X_20 + Y_20 * Y_20 + Z_20 * Z_20 + W_13 * W_13
    local v140 = Log(
        (Mul(new(-v139.X / v141, -v139.Y / v141, -v139.Z / v141, v139.W / v141), arg51))
    )
    local X_21 = v140.X
    v139 = v140.Y
    local Z_21 = v140.Z
    local W_14 = v140.W

    return (X_21 * X_21 + v139 * v139 + Z_21 * Z_21 + W_14 * W_14) ^ 0.5 * 2
end

function t.DistanceChord(arg52, arg53) -- line: 1382
    -- upvalues:
    --  [1] Log (copy)
    --  [2] new (copy)
    --  [3] Mul (copy)

    local v143 = arg52
    v143 = if not (v143.X * arg53.X + v143.Y * arg53.Y + v143.Z * arg53.Z + v143.W * arg53.W < 0) then v143 else new(
        -v143.X,
        -v143.Y,
        -v143.Z,
        -v143.W
    )
    local X_22 = v143.X
    local Y_21 = v143.Y
    local Z_22 = v143.Z
    local W_15 = v143.W
    local v145 = X_22 * X_22 + Y_21 * Y_21 + Z_22 * Z_22 + W_15 * W_15
    local v144 = Log(
        (Mul(new(-v143.X / v145, -v143.Y / v145, -v143.Z / v145, v143.W / v145), arg53))
    )
    local X_23 = v144.X
    v143 = v144.Y
    local Z_23 = v144.Z
    local W_16 = v144.W
    local sine_11 = math.sin((X_23 * X_23 + v143 * v143 + Z_23 * Z_23 + W_16 * W_16) ^ 0.5 * 2 / 2)

    return sine_11 * 2
end

function t.DistanceAbs(arg54, arg55) -- line: 1395
    -- upvalues:
    --  [1] new (copy)

    local v147 = new(arg54.X - arg55.X, arg54.Y - arg55.Y, arg54.Z - arg55.Z, arg54.W - arg55.W)
    local v148 = new(arg54.X + arg55.X, arg54.Y + arg55.Y, arg54.Z + arg55.Z, arg54.W + arg55.W)
    local X_24 = v147.X
    local Y_22 = v147.Y
    local Z_24 = v147.Z
    local W_17 = v147.W
    local v149 = (X_24 * X_24 + Y_22 * Y_22 + Z_24 * Z_24 + W_17 * W_17) ^ 0.5
    local X_25 = v148.X
    local Y_23 = v148.Y
    local Z_25 = v148.Z
    local W_18 = v148.W
    local v150 = (X_25 * X_25 + Y_23 * Y_23 + Z_25 * Z_25 + W_18 * W_18) ^ 0.5

    if v150 > v149 then
        return v149
    end

    return v150
end

function t.Slerp(arg56: any, arg57: any, n22: number) -- line: 1417
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v151 = arg56
    local X_26 = v151.X
    local Y_24 = v151.Y
    local Z_26 = v151.Z
    local W_19 = v151.W
    local v152 = (X_26 * X_26 + Y_24 * Y_24 + Z_26 * Z_26 + W_19 * W_19) ^ 0.5
    arg56 = if not (v152 > 0) then t.identity else new(
        v151.X / v152,
        v151.Y / v152,
        v151.Z / v152,
        v151.W / v152
    )
    local v153 = arg57
    local X_27 = v153.X
    local Y_25 = v153.Y
    local Z_27 = v153.Z
    local W_20 = v153.W
    local v154 = (X_27 * X_27 + Y_25 * Y_25 + Z_27 * Z_27 + W_20 * W_20) ^ 0.5
    arg57 = if not (v154 > 0) then t.identity else new(
        v153.X / v154,
        v153.Y / v154,
        v153.Z / v154,
        v153.W / v154
    )
    v153 = arg56.X * arg57.X + arg56.Y * arg57.Y + arg56.Z * arg57.Z + arg56.W * arg57.W

    if v153 < 0 then
        local v155 = arg56
        arg56 = new(-v155.X, -v155.Y, -v155.Z, -v155.W)
        v153 = -v153
    end

    if v153 >= 1 then
        local v156 = new(arg57.X - arg56.X, arg57.Y - arg56.Y, arg57.Z - arg56.Z, arg57.W - arg56.W)
        local v157 = new(v156.X * n22, v156.Y * n22, v156.Z * n22, v156.W * n22)
        local v158 = new(arg56.X + v157.X, arg56.Y + v157.Y, arg56.Z + v157.Z, arg56.W + v157.W)
        local X_28 = v158.X
        local Y_26 = v158.Y
        local Z_28 = v158.Z
        local W_21 = v158.W
        local v159 = (X_28 * X_28 + Y_26 * Y_26 + Z_28 * Z_28 + W_21 * W_21) ^ 0.5

        if v159 > 0 then
            return (new(v158.X / v159, v158.Y / v159, v158.Z / v159, v158.W / v159))
        end

        return t.identity
    else
        local angle_1 = math.acos(v153)
        local sine_12 = math.sin(angle_1)
        local v160 = angle_1 * n22
        local sine_13 = math.sin(v160)
        local v161 = math.cos(v160) - v153 * sine_13 / sine_12
        local v162 = sine_13 / sine_12
        local v163 = new(arg56.X * v161, arg56.Y * v161, arg56.Z * v161, arg56.W * v161)
        local v164 = new(arg57.X * v162, arg57.Y * v162, arg57.Z * v162, arg57.W * v162)
        local v165 = new(v163.X + v164.X, v163.Y + v164.Y, v163.Z + v164.Z, v163.W + v164.W)
        local X_29 = v165.X
        local Y_27 = v165.Y
        local Z_29 = v165.Z
        local W_22 = v165.W
        local v166 = (X_29 * X_29 + Y_27 * Y_27 + Z_29 * Z_29 + W_22 * W_22) ^ 0.5

        if v166 > 0 then
            return (new(v165.X / v166, v165.Y / v166, v165.Z / v166, v165.W / v166))
        end

        return t.identity
    end
end

function t.IdentitySlerp(arg58: any, n23: number) -- line: 1455
    -- upvalues:
    --  [1] Pow (copy)

    if arg58.W < 0 then
        return -Pow(-arg58, n23)
    end

    return Pow(arg58, n23)
end

local function SlerpFunction(arg59, arg60) -- line: 1473
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v167 = arg59
    local X_30 = v167.X
    local Y_28 = v167.Y
    local Z_30 = v167.Z
    local W_23 = v167.W
    local v168 = (X_30 * X_30 + Y_28 * Y_28 + Z_30 * Z_30 + W_23 * W_23) ^ 0.5
    arg59 = if not (v168 > 0) then t.identity else new(
        v167.X / v168,
        v167.Y / v168,
        v167.Z / v168,
        v167.W / v168
    )
    local v169 = arg60
    local X_31 = v169.X
    local Y_29 = v169.Y
    local Z_31 = v169.Z
    local W_24 = v169.W
    local v170 = (X_31 * X_31 + Y_29 * Y_29 + Z_31 * Z_31 + W_24 * W_24) ^ 0.5
    arg60 = if not (v170 > 0) then t.identity else new(
        v169.X / v170,
        v169.Y / v170,
        v169.Z / v170,
        v169.W / v170
    )
    local v171 = arg59
    local v172 = arg60
    v169 = v171.X * v172.X + v171.Y * v172.Y + v171.Z * v172.Z + v171.W * v172.W

    if v169 < 0 then
        local v173 = arg59
        arg59 = new(-v173.X, -v173.Y, -v173.Z, -v173.W)
        v169 = -v169
    end

    if v169 >= 1 then
        local v174 = arg60
        local v175 = arg59
        local v176 = new(v174.X - v175.X, v174.Y - v175.Y, v174.Z - v175.Z, v174.W - v175.W)

        return function(n24: number) -- line: 1487
            -- upvalues:
            --  [1] arg59 (ref)
            --  [2] v176 (copy)
            --  [3] new (ref)
            --  [4] t (ref)

            local v177 = arg59
            local v178 = v176
            local v179 = new(v178.X * n24, v178.Y * n24, v178.Z * n24, v178.W * n24)
            local v180 = new(v177.X + v179.X, v177.Y + v179.Y, v177.Z + v179.Z, v177.W + v179.W)
            local X_32 = v180.X
            local Y_30 = v180.Y
            local Z_32 = v180.Z
            local W_25 = v180.W
            local v181 = (X_32 * X_32 + Y_30 * Y_30 + Z_32 * Z_32 + W_25 * W_25) ^ 0.5

            if v181 > 0 then
                return (new(v180.X / v181, v180.Y / v181, v180.Z / v181, v180.W / v181))
            end

            return t.identity
        end
    end

    local angle_2 = math.acos(v169)
    local sine_14 = math.sin(angle_2)

    return function(n25: number) -- line: 1495
        -- upvalues:
        --  [1] angle_2 (copy)
        --  [2] v169 (ref)
        --  [3] sine_14 (copy)
        --  [4] arg59 (ref)
        --  [5] new (ref)
        --  [6] arg60 (ref)
        --  [7] t (ref)

        local v182 = angle_2 * n25
        local sine_15 = math.sin(v182)
        local v183 = math.cos(v182) - v169 * sine_15 / sine_14
        local v184 = sine_15 / sine_14
        local v185 = arg59
        local v186 = new(v185.X * v183, v185.Y * v183, v185.Z * v183, v185.W * v183)
        local v187 = arg60
        local v188 = new(v187.X * v184, v187.Y * v184, v187.Z * v184, v187.W * v184)
        local v189 = new(v186.X + v188.X, v186.Y + v188.Y, v186.Z + v188.Z, v186.W + v188.W)
        local X_33 = v189.X
        local Y_31 = v189.Y
        local Z_33 = v189.Z
        local W_26 = v189.W
        local v190 = (X_33 * X_33 + Y_31 * Y_31 + Z_33 * Z_33 + W_26 * W_26) ^ 0.5

        if v190 > 0 then
            return (new(v189.X / v190, v189.Y / v190, v189.Z / v190, v189.W / v190))
        end

        return t.identity
    end
end

t.SlerpFunction = SlerpFunction

function t.Intermediates(arg61: any, arg62: any, n26: number, b1: boolean?) -- line: 1515
    -- upvalues:
    --  [1] SlerpFunction (copy)

    b1 = b1 or false
    local v191 = 1 / (n26 + 1)
    local t_3 = if not b1 then {} else { arg61 }
    local v193 = SlerpFunction(arg61, arg62)

    for index = 1, n26 do
        local v194 = v193(v191 * index)
        table.insert(t_3, v194)
    end

    if b1 then
        table.insert(t_3, arg62)
    end

    return t_3
end

function t.Derivative(arg63: any, vec25: Vector3) -- line: 1547
    -- upvalues:
    --  [1] Mul (copy)
    --  [2] new (copy)

    return (Mul(
        new(arg63.X * 0.5, arg63.Y * 0.5, arg63.Z * 0.5, arg63.W * 0.5),
        (new(vec25.X, vec25.Y, vec25.Z, 0))
    ))
end

function t.Integrate(arg64: any, vec26: Vector3, n27: number) -- line: 1562
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)
    --  [3] Mul (copy)

    local v198 = arg64
    local X_34 = v198.X
    local Y_32 = v198.Y
    local Z_34 = v198.Z
    local W_27 = v198.W
    local v199 = (X_34 * X_34 + Y_32 * Y_32 + Z_34 * Z_34 + W_27 * W_27) ^ 0.5
    arg64 = if not (v199 > 0) then t.identity else new(
        v198.X / v199,
        v198.Y / v199,
        v198.Z / v199,
        v198.W / v199
    )
    local v200 = vec26 * n27
    local Magnitude_1 = v200.Magnitude

    if Magnitude_1 > 0 then
        local v201 = v200 / Magnitude_1
        local v202 = if not (v201.Magnitude > 5E-07) then Vector3.new(1, 0, 0) else v201.Unit
        local v203 = Magnitude_1 / 2
        local sine_16 = math.sin(v203)
        local v210 = Mul(
            arg64,
            (new(sine_16 * v202.X, sine_16 * v202.Y, sine_16 * v202.Z, (math.cos(v203))))
        )
        local X_35 = v210.X
        local Y_33 = v210.Y
        local Z_35 = v210.Z
        local W_28 = v210.W
        local v211 = (X_35 * X_35 + Y_33 * Y_33 + Z_35 * Z_35 + W_28 * W_28) ^ 0.5

        if v211 > 0 then
            return (new(v210.X / v211, v210.Y / v211, v210.Z / v211, v210.W / v211))
        end

        return t.identity
    else
        return arg64
    end
end

function t.AngularVelocity(arg65: any, arg66: any, n28: number) -- line: 1587
    if n28 > 0 then
        return arg65:Difference(arg66):ToEulerVector() / n28
    end

    return (Vector3.new())
end

function t.MinimalRotation(arg67, arg68) -- line: 1606
    -- upvalues:
    --  [1] new (copy)

    local _, v213, _ = arg67:ToMatrixVectors()
    local _, v216, _ = arg68:ToMatrixVectors()
    local v218 = v213:Cross(v216)
    local Magnitude_2 = v218.Magnitude
    local v219 = v213:Dot(v216)
    local angle_3 = math.atan2(Magnitude_2, v219)
    local v220 = v218
    local v221 = if v220.Magnitude > 5E-07 then v220.Unit else Vector3.new(1, 0, 0)
    local v222 = angle_3 / 2
    local sine_17 = math.sin(v222)

    return (new(sine_17 * v221.X, sine_17 * v221.Y, sine_17 * v221.Z, (math.cos(v222))))
end

function t.ApproxEq(arg69: any, arg70: any, n29: number?) -- line: 1623
    -- upvalues:
    --  [1] Log (copy)
    --  [2] new (copy)
    --  [3] Mul (copy)

    local v229 = arg69
    v229 = if not (v229.X * arg70.X + v229.Y * arg70.Y + v229.Z * arg70.Z + v229.W * arg70.W < 0) then v229 else new(
        -v229.X,
        -v229.Y,
        -v229.Z,
        -v229.W
    )
    local X_36 = v229.X
    local Y_34 = v229.Y
    local Z_36 = v229.Z
    local W_29 = v229.W
    local v231 = X_36 * X_36 + Y_34 * Y_34 + Z_36 * Z_36 + W_29 * W_29
    local v230 = Log(
        (Mul(new(-v229.X / v231, -v229.Y / v231, -v229.Z / v231, v229.W / v231), arg70))
    )
    local X_37 = v230.X
    v229 = v230.Y
    local Z_37 = v230.Z
    local W_30 = v230.W
    local v233 = (n29 or 5E-07) > (X_37 * X_37 + v229 * v229 + Z_37 * Z_37 + W_30 * W_30) ^ 0.5 * 2 and true

    return v233
end

function t.IsNaN(arg71) -- line: 1636
    local Y_35 = arg71.Y
    local Z_38 = arg71.Z
    local W_31 = arg71.W
    local X_38 = arg71.X

    return X_38 ~= X_38 or Y_35 ~= Y_35 or Z_38 ~= Z_38 or W_31 ~= W_31
end

local function _toRotationMatrix(arg72) -- line: 1643
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v235 = arg72
    local X_39 = v235.X
    local Y_36 = v235.Y
    local Z_39 = v235.Z
    local W_32 = v235.W
    local v236 = (X_39 * X_39 + Y_36 * Y_36 + Z_39 * Z_39 + W_32 * W_32) ^ 0.5
    arg72 = if not (v236 > 0) then t.identity else new(
        v235.X / v236,
        v235.Y / v236,
        v235.Z / v236,
        v235.W / v236
    )
    local X_40 = arg72.X
    local Y_37 = arg72.Y
    local Z_40 = arg72.Z
    local W_33 = arg72.W
    local v237 = X_40 * X_40
    local v238 = Y_37 * Y_37
    local v239 = Z_40 * Z_40
    local v240 = W_33 * W_33
    local v241 = X_40 * Y_37
    local v242 = Z_40 * W_33
    local v243 = X_40 * Z_40
    local v244 = Y_37 * W_33
    local v245 = Y_37 * Z_40
    local v246 = X_40 * W_33

    return v237 - v238 - v239 + v240, 2 * (v241 - v242), 2 * (v243 + v244), 2 * (v241 + v242), -v237 + v238 - v239 + v240, 2 * (v245 - v246), 2 * (v243 - v244), 2 * (v245 + v246), -v237 - v238 + v239 + v240
end

function t.ToAxisAngle(arg73) -- line: 1681
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v247 = arg73
    local X_41 = v247.X
    local Y_38 = v247.Y
    local Z_41 = v247.Z
    local W_34 = v247.W
    local v248 = (X_41 * X_41 + Y_38 * Y_38 + Z_41 * Z_41 + W_34 * W_34) ^ 0.5
    arg73 = if not (v248 > 0) then t.identity else new(
        v247.X / v248,
        v247.Y / v248,
        v247.Z / v248,
        v247.W / v248
    )
    local X_42 = arg73.X
    local Y_39 = arg73.Y
    local Z_42 = arg73.Z
    local W_35 = arg73.W
    local v249 = math.acos(W_35) * 2
    local squareRoot_2 = math.sqrt(1 - W_35 * W_35)

    if squareRoot_2 < 5E-07 then
        return Vector3.new(X_42, Y_39, Z_42), v249
    end

    return Vector3.new(X_42 / squareRoot_2, Y_39 / squareRoot_2, Z_42 / squareRoot_2), v249
end

function t.ToEulerVector(arg74) -- line: 1704
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v250 = arg74
    local X_43 = v250.X
    local Y_40 = v250.Y
    local Z_43 = v250.Z
    local W_36 = v250.W
    local v251 = (X_43 * X_43 + Y_40 * Y_40 + Z_43 * Z_43 + W_36 * W_36) ^ 0.5
    arg74 = if not (v251 > 0) then t.identity else new(
        v250.X / v251,
        v250.Y / v251,
        v250.Z / v251,
        v250.W / v251
    )
    local X_44 = arg74.X
    local Y_41 = arg74.Y
    local Z_44 = arg74.Z
    local W_37 = arg74.W
    local v252 = math.acos(W_37) * 2
    local squareRoot_3 = math.sqrt(1 - W_37 * W_37)

    if squareRoot_3 < 5E-07 then
        return Vector3.new(X_44, Y_41, Z_44) * v252
    end

    return Vector3.new(X_44 / squareRoot_3, Y_41 / squareRoot_3, Z_44 / squareRoot_3) * v252
end

function t.ToMatrix(arg75) -- line: 1728
    -- upvalues:
    --  [1] _toRotationMatrix (copy)

    return _toRotationMatrix(arg75)
end

function t.ToMatrixVectors(arg76) -- line: 1743
    -- upvalues:
    --  [1] _toRotationMatrix (copy)

    local v253, v254, v255, v256, v257, v258, v259, v260, v261 = _toRotationMatrix(arg76)

    return Vector3.new(v253, v256, v259), Vector3.new(v254, v257, v260), (Vector3.new(
        v255,
        v258,
        v261
    ))
end

function t.Vector(arg77) -- line: 1758
    return (Vector3.new(arg77.X, arg77.Y, arg77.Z))
end

function t.Real(arg78) -- line: 1771
    -- upvalues:
    --  [1] new (copy)

    return (new(0, 0, 0, arg78.W))
end

function t.Imaginary(arg79) -- line: 1784
    -- upvalues:
    --  [1] new (copy)

    return (new(arg79.X, arg79.Y, arg79.Z, 0))
end

local function ToEulerAnglesXYZ(arg80) -- line: 1797
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v271 = arg80
    local X_45 = v271.X
    local Y_42 = v271.Y
    local Z_45 = v271.Z
    local W_38 = v271.W
    local v272 = (X_45 * X_45 + Y_42 * Y_42 + Z_45 * Z_45 + W_38 * W_38) ^ 0.5
    arg80 = if not (v272 > 0) then t.identity else new(
        v271.X / v272,
        v271.Y / v272,
        v271.Z / v272,
        v271.W / v272
    )
    local X_46 = arg80.X
    local Y_43 = arg80.Y
    local Z_46 = arg80.Z
    local W_39 = arg80.W
    local v273 = Y_43 * W_39 + X_46 * Z_46
    local v274

    if math.abs(v273) > 0.4999995 then
        v274 = if not (v273 > 0) then -1 else 1

        return v274 * 2 * math.atan2(Z_46, W_39), v274 * 3.141592653589793 / 2, 0
    end

    v274 = Y_43 * Y_43

    return math.atan2(2 * (X_46 * W_39 - Y_43 * Z_46), 1 - 2 * (X_46 * X_46 + v274)), math.asin(
        2 * v273
    ), (math.atan2(2 * (Z_46 * W_39 - X_46 * Y_43), 1 - 2 * (Z_46 * Z_46 + v274)))
end

local function ToEulerAnglesXZY(arg81) -- line: 1819
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v276 = arg81
    local X_47 = v276.X
    local Y_44 = v276.Y
    local Z_47 = v276.Z
    local W_40 = v276.W
    local v277 = (X_47 * X_47 + Y_44 * Y_44 + Z_47 * Z_47 + W_40 * W_40) ^ 0.5
    arg81 = if not (v277 > 0) then t.identity else new(
        v276.X / v277,
        v276.Y / v277,
        v276.Z / v277,
        v276.W / v277
    )
    local X_48 = arg81.X
    local Y_45 = arg81.Y
    local Z_48 = arg81.Z
    local W_41 = arg81.W
    local v278 = Z_48 * W_41 - X_48 * Y_45
    local v279

    if math.abs(v278) > 0.4999995 then
        v279 = if not (v278 >= 0) then -1 else 1

        return v279 * 2 * -math.atan2(Y_45, W_41), 0, v279 * 3.141592653589793 / 2
    end

    v279 = Z_48 * Z_48

    return math.atan2(2 * (X_48 * W_41 + Y_45 * Z_48), 1 - 2 * (X_48 * X_48 + v279)), math.atan2(
        2 * (X_48 * Z_48 + Y_45 * W_41),
        1 - 2 * (Y_45 * Y_45 + v279)
    ), (math.asin(2 * v278))
end

local function ToEulerAnglesYXZ(arg82) -- line: 1848
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v281 = arg82
    local X_49 = v281.X
    local Y_46 = v281.Y
    local Z_49 = v281.Z
    local W_42 = v281.W
    local v282 = (X_49 * X_49 + Y_46 * Y_46 + Z_49 * Z_49 + W_42 * W_42) ^ 0.5
    arg82 = if not (v282 > 0) then t.identity else new(
        v281.X / v282,
        v281.Y / v282,
        v281.Z / v282,
        v281.W / v282
    )
    local X_50 = arg82.X
    local Y_47 = arg82.Y
    local Z_50 = arg82.Z
    local W_43 = arg82.W
    local v283 = X_50 * W_43 - Y_47 * Z_50
    local v284

    if math.abs(v283) > 0.4999995 then
        v284 = if not (v283 >= 0) then -1 else 1

        return v284 * 3.141592653589793 / 2, v284 * 2 * -math.atan2(Z_50, W_43), 0
    end

    v284 = X_50 * X_50

    return math.asin(2 * v283), math.atan2(
        2 * (X_50 * Z_50 + Y_47 * W_43),
        1 - 2 * (Y_47 * Y_47 + v284)
    ), (math.atan2(2 * (X_50 * Y_47 + Z_50 * W_43), 1 - 2 * (Z_50 * Z_50 + v284)))
end

local function ToEulerAnglesYZX(arg83) -- line: 1870
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v287 = arg83
    local X_51 = v287.X
    local Y_48 = v287.Y
    local Z_51 = v287.Z
    local W_44 = v287.W
    local v288 = (X_51 * X_51 + Y_48 * Y_48 + Z_51 * Z_51 + W_44 * W_44) ^ 0.5
    arg83 = if not (v288 > 0) then t.identity else new(
        v287.X / v288,
        v287.Y / v288,
        v287.Z / v288,
        v287.W / v288
    )
    local X_52 = arg83.X
    local Y_49 = arg83.Y
    local Z_52 = arg83.Z
    local W_45 = arg83.W
    local v289 = Z_52 * W_45 + X_52 * Y_49
    local v290

    if math.abs(v289) > 0.4999995 then
        v290 = if not (v289 >= 0) then -1 else 1

        return 0, v290 * 2 * math.atan2(X_52, W_45), v290 * 3.141592653589793 / 2
    end

    v290 = Z_52 * Z_52

    return math.atan2(2 * (X_52 * W_45 - Y_49 * Z_52), 1 - 2 * (X_52 * X_52 + v290)), math.atan2(
        2 * (Y_49 * W_45 - X_52 * Z_52),
        1 - 2 * (Y_49 * Y_49 + v290)
    ), (math.asin(2 * v289))
end

local function ToEulerAnglesZXY(arg84) -- line: 1892
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v292 = arg84
    local X_53 = v292.X
    local Y_50 = v292.Y
    local Z_53 = v292.Z
    local W_46 = v292.W
    local v293 = (X_53 * X_53 + Y_50 * Y_50 + Z_53 * Z_53 + W_46 * W_46) ^ 0.5
    arg84 = if not (v293 > 0) then t.identity else new(
        v292.X / v293,
        v292.Y / v293,
        v292.Z / v293,
        v292.W / v293
    )
    local X_54 = arg84.X
    local Y_51 = arg84.Y
    local Z_54 = arg84.Z
    local W_47 = arg84.W
    local v294 = X_54 * W_47 + Y_51 * Z_54
    local v295

    if math.abs(v294) > 0.4999995 then
        v295 = if not (v294 >= 0) then -1 else 1

        return v295 * 3.141592653589793 / 2, 0, v295 * 2 * math.atan2(Y_51, W_47)
    end

    v295 = X_54 * X_54

    return math.asin(2 * v294), math.atan2(
        2 * (Y_51 * W_47 - X_54 * Z_54),
        1 - 2 * (Y_51 * Y_51 + v295)
    ), (math.atan2(2 * (Z_54 * W_47 - X_54 * Y_51), 1 - 2 * (Z_54 * Z_54 + v295)))
end

local function ToEulerAnglesZYX(arg85) -- line: 1914
    -- upvalues:
    --  [1] new (copy)
    --  [2] t (copy)

    local v298 = arg85
    local X_55 = v298.X
    local Y_52 = v298.Y
    local Z_55 = v298.Z
    local W_48 = v298.W
    local v299 = (X_55 * X_55 + Y_52 * Y_52 + Z_55 * Z_55 + W_48 * W_48) ^ 0.5
    arg85 = if not (v299 > 0) then t.identity else new(
        v298.X / v299,
        v298.Y / v299,
        v298.Z / v299,
        v298.W / v299
    )
    local X_56 = arg85.X
    local Y_53 = arg85.Y
    local Z_56 = arg85.Z
    local W_49 = arg85.W
    local v300 = Y_53 * W_49 - X_56 * Z_56
    local v301

    if math.abs(v300) > 0.4999995 then
        v301 = if not (v300 >= 0) then -1 else 1

        return 0, v301 * 3.141592653589793 / 2, v301 * 2 * -math.atan2(X_56, W_49)
    end

    v301 = Y_53 * Y_53

    return math.atan2(2 * (X_56 * W_49 + Y_53 * Z_56), 1 - 2 * (X_56 * X_56 + v301)), math.asin(
        2 * v300
    ), (math.atan2(2 * (X_56 * Y_53 + Z_56 * W_49), 1 - 2 * (Z_56 * Z_56 + v301)))
end

local t_4 = {
    XYZ = ToEulerAnglesXYZ,
    XZY = ToEulerAnglesXZY,
    YZX = ToEulerAnglesYZX,
    YXZ = ToEulerAnglesYXZ,
    ZXY = ToEulerAnglesZXY,
    ZYX = ToEulerAnglesZYX
}

function t.ToEulerAngles(arg86, arg87) -- line: 1953
    -- upvalues:
    --  [1] t_4 (copy)

    return t_4[(arg87 or Enum.RotationOrder.XYZ).Name](arg86)
end

t.ToEulerAnglesXYZ = ToEulerAnglesXYZ
t.ToEulerAnglesYXZ = ToEulerAnglesYXZ
t.ToOrientation = ToEulerAnglesYXZ

local function GetComponents(arg88) -- line: 1976
    return arg88.X, arg88.Y, arg88.Z, arg88.W
end

t.GetComponents = GetComponents
t.components = GetComponents

local _ = function(n30: number, n31: number?) --[[ round ]] -- line: 1989
    if n31 then
        n31 = math.max(0, n31)

        return (string.format(string.format("%%.%df", n31), n30))
    end

    return (tostring(n30))
end

local function ToString(arg89: any, n32: number?) -- line: 2007
    -- upvalues:
    --  [1] t (copy)

    if t._TO_STRING_CHAR then
        n32 = t._TO_STRING_CHAR
    end

    local X_57 = arg89.X
    local v307 = n32
    local v308, v311

    if v307 then
        v308 = math.max(0, v307)
        v311 = string.format(string.format("%%.%df", v308), X_57)
    else
        v311 = tostring(X_57)
    end

    local Y_54 = arg89.Y
    local v312 = n32
    local v313

    if v312 then
        v313 = math.max(0, v312)
        v308 = string.format(string.format("%%.%df", v313), Y_54)
    else
        v308 = tostring(Y_54)
    end

    local Z_57 = arg89.Z
    local v316 = n32
    local v317

    if v316 then
        v317 = math.max(0, v316)
        v313 = string.format(string.format("%%.%df", v317), Z_57)
    else
        v313 = tostring(Z_57)
    end

    local W_50 = arg89.W
    local v320 = n32
    v317 = if v320 then string.format(string.format("%%.%df", (math.max(0, v320))), W_50) else tostring(
        W_50
    )

    return v311 .. ", " .. v308 .. ", " .. v313 .. ", " .. v317
end

t.__tostring = ToString
t.ToString = ToString

function t.__index(arg90, arg91) -- line: 2022
    -- upvalues:
    --  [1] t (copy)
    --  [2] new (copy)

    local v323 = t[arg91]

    if v323 then
        return v323
    end

    local lowerText = string.lower(arg91)
    local v324 = rawget(arg90, "_cached")

    if lowerText == "unit" then
        if not v324.unit then
            local X_58 = arg90.X
            local Y_55 = arg90.Y
            local Z_58 = arg90.Z
            local W_51 = arg90.W
            local v325 = (X_58 * X_58 + Y_55 * Y_55 + Z_58 * Z_58 + W_51 * W_51) ^ 0.5
            local v326 = if not (v325 > 0) then t.identity else new(
                arg90.X / v325,
                arg90.Y / v325,
                arg90.Z / v325,
                arg90.W / v325
            )
            v324.unit = v326

            return v326
        end

        return v324.unit
    elseif lowerText == "magnitude" then
        if not v324.magnitude then
            local X_59 = arg90.X
            local Y_56 = arg90.Y
            local Z_59 = arg90.Z
            local W_52 = arg90.W
            local v327 = (X_59 * X_59 + Y_56 * Y_56 + Z_59 * Z_59 + W_52 * W_52) ^ 0.5
            v324.magnitude = v327

            return v327
        end

        return v324.magnitude
    else
        return nil
    end
end

function t.__newindex(_, arg93) -- line: 2047
    error(tostring(arg93) .. " cannot be assigned to")
end

table.freeze(t)

return t
