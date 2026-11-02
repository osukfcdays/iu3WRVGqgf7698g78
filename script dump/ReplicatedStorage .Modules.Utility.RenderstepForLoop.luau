local RunService = game:GetService("RunService")

return function(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6
) -- line: 6
    -- upvalues:
    --  [1] RunService (copy)

    assert(
        if typeof(arg1) ~= "number" then false else true,
        "Argument 1 invalid, expected a number, got " .. tostring(arg1)
    )
    assert(
        if typeof(arg2) ~= "number" then false else true,
        "Argument 2 invalid, expected a number, got " .. tostring(arg2)
    )
    assert(
        if typeof(arg3) ~= "number" then if typeof(arg3) ~= "function" then false else true else true,
        "Argument 3 invalid, expected a number or function, got " .. tostring(arg3)
    )
    assert(
        if typeof(arg4) ~= "function" then false else true,
        "Argument 4 invalid, expected a function, got " .. tostring(arg4)
    )
    local v1 = not arg5 or (if typeof(arg5) ~= "boolean" then false else true)
    assert(v1, "Argument 5 invalid, expected a boolean or nil, got " .. tostring(arg5))
    v1 = not arg6 or (if typeof(arg6) ~= "number" then false else true)
    assert(v1, "Argument 6 invalid, expected a number or nil, got " .. tostring(arg6))
    local v2 = if typeof(arg3) ~= "function" then false else true
    local v3 = arg6 or 1
    local v4 = arg1

    while true do
        local v5 = v2 and arg3() or arg3

        if v5 > 0 and arg2 < v4 or v5 < 0 and arg2 > v4 then
            break
        end

        if arg4(v4) then
            return
        end

        local now = tick()

        for _ = 1, v3 do
            RunService.Heartbeat:Wait()
        end

        v4 += v5 * (tick() - now) * 60 / v3
    end

    if not arg5 then
        arg4(arg2)
    end
end
