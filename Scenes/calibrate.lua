local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local showWebBg = require ("Helpers.showWebBg")

local pinny = love.graphics.newImage ("Graphics/pinny.png")

local textIndex = 1
local pinnyText = {
    "HI!!!!!! I'm Pinny, you're every so he"
}

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Pinny
    

    -- Text


    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene