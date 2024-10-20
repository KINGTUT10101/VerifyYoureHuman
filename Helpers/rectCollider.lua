local function rectCollider(rect1, rect2)
    -- Extract the coordinates and dimensions of both rectangles
    local r1_x, r1_y, r1_w, r1_h = rect1.x, rect1.y, rect1.w, rect1.h
    local r2_x, r2_y, r2_w, r2_h = rect2.x, rect2.y, rect2.w, rect2.h

    -- Check for no collision by testing if one rectangle is to the left, right, above, or below the other
    if r1_x + r1_w < r2_x or -- rect1 is to the left of rect2
       r1_x > r2_x + r2_w or -- rect1 is to the right of rect2
       r1_y + r1_h < r2_y or -- rect1 is above rect2
       r1_y > r2_y + r2_h    -- rect1 is below rect2
    then
        return false -- No collision
    else
        return true -- Collision
    end
end

return rectCollider