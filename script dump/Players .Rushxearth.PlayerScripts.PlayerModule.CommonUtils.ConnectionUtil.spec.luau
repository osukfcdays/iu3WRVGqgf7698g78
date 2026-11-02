local CorePackages = game:GetService("CorePackages")
local JestGlobals_m = require(CorePackages.Packages.Dev.JestGlobals)
local Describe = JestGlobals_m.describe
local Expect = JestGlobals_m.expect
local It = JestGlobals_m.it
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local ConnectionUtil_m = require(script.Parent.ConnectionUtil)
Describe("ConnectionUtil", function() -- line: 13
    -- upvalues:
    --  [1] It (copy)
    --  [2] ConnectionUtil_m (copy)
    --  [3] Expect (copy)
    --  [4] Signal (copy)

    It("should instantiate", function() -- line: 14
        -- upvalues:
        --  [1] ConnectionUtil_m (ref)
        --  [2] Expect (ref)

        Expect((ConnectionUtil_m.new())).never.toBeNil()
    end)
    It("should track a connection", function() -- line: 20
        -- upvalues:
        --  [1] ConnectionUtil_m (ref)
        --  [2] Signal (ref)
        --  [3] Expect (ref)

        local v1 = ConnectionUtil_m.new()
        local v2 = Signal.new()
        local v3 = ""
        v1:trackConnection("Signal", v2:Connect(function(arg1) -- line: 27
            -- upvalues:
            --  [1] v3 (ref)

            v3 = arg1
        end))
        v2:fire("Testing")
        Expect(v3).toBe("Testing")
    end)
    It("should disconnect from signal", function() -- line: 36
        -- upvalues:
        --  [1] ConnectionUtil_m (ref)
        --  [2] Signal (ref)
        --  [3] Expect (ref)

        local v4 = ConnectionUtil_m.new()
        local v5 = Signal.new()
        local v6 = ""
        v4:trackConnection("Signal", v5:Connect(function(arg2) -- line: 43
            -- upvalues:
            --  [1] v6 (ref)

            v6 = arg2
        end))
        v4:disconnect("Signal")
        v5:fire("Testing")
        Expect(v6).toBe("")
    end)
    It("should disconnect from all", function() -- line: 53
        -- upvalues:
        --  [1] ConnectionUtil_m (ref)
        --  [2] Signal (ref)
        --  [3] Expect (ref)

        local v7 = ConnectionUtil_m.new()
        local v8 = Signal.new()
        local v9 = Signal.new()
        local v10 = Signal.new()
        local v11 = ""
        local v12 = ""
        local v13 = ""
        v7:trackConnection("Signal", v8:Connect(function(arg3) -- line: 65
            -- upvalues:
            --  [1] v11 (ref)

            v11 = arg3
        end))
        v7:trackConnection("Signal1", v9:Connect(function(arg4) -- line: 71
            -- upvalues:
            --  [1] v12 (ref)

            v12 = arg4
        end))
        v7:trackConnection("Signal2", v10:Connect(function(arg5) -- line: 77
            -- upvalues:
            --  [1] v13 (ref)

            v13 = arg5
        end))
        v7:disconnectAll()
        v8:fire("TestingPrimary")
        v8:fire("TestingSecondary")
        v8:fire("TestingTertiary")
        Expect(v11).toBe("")
        Expect(v12).toBe("")
        Expect(v13).toBe("")
    end)
    It("should call manual disconnect", function() -- line: 92
        -- upvalues:
        --  [1] ConnectionUtil_m (ref)
        --  [2] Expect (ref)

        local v14 = ConnectionUtil_m.new()
        local v15 = ""
        v14:trackBoundFunction("Manual", function() -- line: 96
            -- upvalues:
            --  [1] v15 (ref)

            v15 = "Disconnected"
        end)
        v14:disconnect("Manual")
        Expect(v15).toBe("Disconnected")
    end)
end)
