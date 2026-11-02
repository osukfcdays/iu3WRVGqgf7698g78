local t = { JUMP_STUDS = 4, SETTLED_STUDS = 1, DEBOUNCE_SECONDS = 0.25 }

function t.shouldRecenter(n1: number?, n2: number, n3: number?, n4: number) -- line: 29
    -- upvalues:
    --  [1] t (copy)

    return if not (n2 <= t.JUMP_STUDS) then if n1 == nil then n3 == nil or not (n4 - n3 < t.DEBOUNCE_SECONDS) else if not (n1 >= t.SETTLED_STUDS) then n3 == nil or not (n4 - n3 < t.DEBOUNCE_SECONDS) else false else false
end

return t
