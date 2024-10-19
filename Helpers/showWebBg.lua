local tux = require ("Libraries.tux")
local slices = require ("Helpers.slices")
local urlBar = love.graphics.newImage ("Graphics/urlBar.png")

local function showWebBg (x, y, w, h)
    -- URL bar
    tux.show.label ({
        image = urlBar,
        iscale = 0.5,
        valign = "bottom",
        colors = {0, 0, 0, 0},
        padding = {padTop = 5}
    }, x, y, w, h)

    -- Background
    tux.show.label ({
        slices = slices.webLbl
    }, x, y, w, h)
end

return showWebBg