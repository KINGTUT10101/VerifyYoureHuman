local function cursorInArea (mx, my, x, y, w, h)
    local result = false
    
    if x <= mx and mx <= x + w and y <= my and my <= y + h then
        result = true
    end

    return result
end

return cursorInArea