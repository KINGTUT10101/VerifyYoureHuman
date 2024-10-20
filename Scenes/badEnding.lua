local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")

local maxTimer = 5
local timer = maxTimer

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Update timer
    if timer > 0 then
        timer = timer - dt

    else
        if tux.show.button ({
            text = "Retry",
            fsize = 20,
            slices = slices.webBtn
        }, 367, 468, 104, 45) == "end" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 2.5, "finalBattle")
        end
    end

    tux.show.label ({
        text = "Error\n\nSystem32 deleted\n\n\nTraceback\n\nAHAHAHAHAHAHAHAHAHAHAHAH",
        align = "left",
        valign = "top",
        fsize = 14,
        colors = {0, 0, 0, 0}
    }, 50, 75, 500, 500)
end

function thisScene:earlyDraw ()
    love.graphics.setColor (89/255, 157/255, 220/255, 1)
    love.graphics.rectangle ("fill", 0, 0, 800, 600)
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene